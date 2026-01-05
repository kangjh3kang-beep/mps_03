package main

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/joho/godotenv"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

// ===== Models =====

type User struct {
	ID        uint      `gorm:"primaryKey" json:"id"`
	Email     string    `gorm:"uniqueIndex" json:"email"`
	Password  string    `json:"-"`
	Name      string    `json:"name"`
	Role      string    `gorm:"default:'user'" json:"role"`
	Active    bool      `gorm:"default:true" json:"active"`
	Verified  bool      `gorm:"default:false" json:"verified"`
	Provider  string    `gorm:"size:50" json:"provider"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
}

type SignupRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required,min=6"`
	Name     string `json:"name" binding:"required,min=2"`
}

type AuthResponse struct {
	Success      bool   `json:"success"`
	User         User   `json:"user,omitempty"`
	Token        string `json:"token,omitempty"`
	RefreshToken string `json:"refresh_token,omitempty"`
	ExpiresIn    int    `json:"expires_in,omitempty"`
	Message      string `json:"message,omitempty"`
	Error        string `json:"error,omitempty"`
}

// ===== JWT Claims =====

type Claims struct {
	UserID string `json:"user_id"`
	Email  string `json:"email"`
	Role   string `json:"role"`
	jwt.RegisteredClaims
}

// ===== Environment Variables =====

var (
	DATABASE_URL = getEnv("DATABASE_URL", "postgres://user:password@localhost:5432/manpasik")
	JWT_SECRET   = getEnv("JWT_SECRET", "your-secret-key-change-in-production")
	PORT         = getEnv("PORT", "8001")
)

func getEnv(key string, defaultVal string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return defaultVal
}

// ===== Database =====

var db *gorm.DB

func initDB() error {
	var err error
	db, err = gorm.Open(postgres.Open(DATABASE_URL), &gorm.Config{})
	if err != nil {
		return err
	}

	// Auto migrate all models including OAuth, 2FA, RBAC tables
	return db.AutoMigrate(
		&User{},
		&OAuthToken{},
		&TwoFactorAuth{},
		&SMSVerification{},
		&Role{},
		&Permission{},
		&UserRole{},
	)
}

// generateToken generates a JWT token for a user (helper for OAuth/2FA)
func generateToken(userID uint) (string, error) {
	claims := Claims{
		UserID: fmt.Sprintf("%d", userID),
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(JWT_SECRET))
}

// checkPasswordHash compares a password with a hash
func checkPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}

// AuthMiddleware validates JWT tokens
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" || len(authHeader) < 8 {
			c.JSON(401, gin.H{"error": "Missing authorization header"})
			c.Abort()
			return
		}

		tokenString := authHeader[7:] // Remove "Bearer "
		claims := &Claims{}

		token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
			return []byte(JWT_SECRET), nil
		})

		if err != nil || !token.Valid {
			c.JSON(401, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}

		// 🔐 토큰 블랙리스트 체크
		tokenID := tokenString[:32] // 토큰의 처음 32자를 ID로 사용
		if IsBlacklisted(tokenID) {
			reason := GetBlacklistReason(tokenID)
			c.JSON(401, gin.H{
				"error":  "Token has been revoked",
				"reason": reason,
			})
			c.Abort()
			return
		}

		// Parse userID to uint
		var userID uint
		fmt.Sscanf(claims.UserID, "%d", &userID)
		c.Set("userID", userID)
		c.Set("email", claims.Email)
		c.Set("role", claims.Role)
		c.Set("tokenID", tokenID) // 로그아웃 시 사용
		c.Next()
	}
}

// ===== Handlers =====

// Health check
func healthHandler(c *gin.Context) {
	c.JSON(200, gin.H{
		"status":    "ok",
		"service":   "auth-service",
		"timestamp": time.Now().UTC().Format(time.RFC3339),
	})
}

// Login handler
func loginHandler(c *gin.Context) {
	var req LoginRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(400, AuthResponse{
			Success: false,
			Error:   err.Error(),
		})
		return
	}

	var user User
	result := db.Where("email = ?", req.Email).First(&user)

	if result.Error != nil {
		c.JSON(401, AuthResponse{
			Success: false,
			Error:   "Invalid email or password",
		})
		return
	}

	// Check password
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password)); err != nil {
		c.JSON(401, AuthResponse{
			Success: false,
			Error:   "Invalid email or password",
		})
		return
	}

	// Generate JWT
	token, refreshToken, expiresIn, err := generateTokens(user)
	if err != nil {
		c.JSON(500, AuthResponse{
			Success: false,
			Error:   "Failed to generate token",
		})
		return
	}

	// Remove password from response
	user.Password = ""

	c.JSON(200, AuthResponse{
		Success:      true,
		User:         user,
		Token:        token,
		RefreshToken: refreshToken,
		ExpiresIn:    expiresIn,
	})
}

// Signup handler
func signupHandler(c *gin.Context) {
	var req SignupRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(400, AuthResponse{
			Success: false,
			Error:   err.Error(),
		})
		return
	}

	// Check if user exists
	var existingUser User
	if err := db.Where("email = ?", req.Email).First(&existingUser).Error; err == nil {
		c.JSON(409, AuthResponse{
			Success: false,
			Error:   "User already exists",
		})
		return
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(500, AuthResponse{
			Success: false,
			Error:   "Failed to hash password",
		})
		return
	}

	// Create user
	user := User{
		ID:       uuid.New().String(),
		Email:    req.Email,
		Password: string(hashedPassword),
		Name:     req.Name,
		Role:     "user",
	}

	if err := db.Create(&user).Error; err != nil {
		c.JSON(500, AuthResponse{
			Success: false,
			Error:   "Failed to create user",
		})
		return
	}

	// Generate JWT
	token, refreshToken, expiresIn, err := generateTokens(user)
	if err != nil {
		c.JSON(500, AuthResponse{
			Success: false,
			Error:   "Failed to generate token",
		})
		return
	}

	// Remove password from response
	user.Password = ""

	c.JSON(201, AuthResponse{
		Success:      true,
		User:         user,
		Token:        token,
		RefreshToken: refreshToken,
		ExpiresIn:    expiresIn,
		Message:      "Signup successful",
	})
}

// Logout handler
func logoutHandler(c *gin.Context) {
	// 🔐 토큰을 블랙리스트에 등록
	authHeader := c.GetHeader("Authorization")
	if authHeader != "" && len(authHeader) > 7 {
		tokenString := authHeader[7:]
		tokenID := tokenString[:32] // 토큰의 처음 32자를 ID로 사용
		
		// 토큰 만료 시간까지 블랙리스트에 유지 (기본 1시간)
		BlacklistToken(tokenID, time.Hour, "logout")
	}

	c.JSON(200, AuthResponse{
		Success: true,
		Message: "Logout successful",
	})
}

// Verify token handler
func verifyTokenHandler(c *gin.Context) {
	authHeader := c.GetHeader("Authorization")
	if authHeader == "" {
		c.JSON(401, AuthResponse{
			Success: false,
			Error:   "Missing authorization header",
		})
		return
	}

	tokenString := authHeader[7:] // Remove "Bearer "
	claims := &Claims{}

	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		return []byte(JWT_SECRET), nil
	})

	if err != nil || !token.Valid {
		c.JSON(401, AuthResponse{
			Success: false,
			Error:   "Invalid token",
		})
		return
	}

	c.JSON(200, gin.H{
		"success": true,
		"claims":  claims,
	})
}

// Get user profile
func getUserProfileHandler(c *gin.Context) {
	userID := c.Param("userId")

	var user User
	if err := db.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(404, AuthResponse{
			Success: false,
			Error:   "User not found",
		})
		return
	}

	user.Password = ""

	c.JSON(200, gin.H{
		"success": true,
		"data":    user,
	})
}

// Update user profile
func updateUserProfileHandler(c *gin.Context) {
	userID := c.Param("userId")

	var updateData struct {
		Name string `json:"name"`
	}

	if err := c.ShouldBindJSON(&updateData); err != nil {
		c.JSON(400, AuthResponse{
			Success: false,
			Error:   err.Error(),
		})
		return
	}

	if err := db.Model(&User{}).Where("id = ?", userID).Update("name", updateData.Name).Error; err != nil {
		c.JSON(500, AuthResponse{
			Success: false,
			Error:   "Failed to update user",
		})
		return
	}

	var user User
	db.Where("id = ?", userID).First(&user)
	user.Password = ""

	c.JSON(200, gin.H{
		"success": true,
		"data":    user,
		"message": "User updated successfully",
	})
}

// ===== JWT Helper Functions =====

func generateTokens(user User) (string, string, int, error) {
	// Access token (1 hour)
	accessTokenClaims := Claims{
		UserID: user.ID,
		Email:  user.Email,
		Role:   user.Role,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	accessToken := jwt.NewWithClaims(jwt.SigningMethodHS256, accessTokenClaims)
	accessTokenString, err := accessToken.SignedString([]byte(JWT_SECRET))
	if err != nil {
		return "", "", 0, err
	}

	// Refresh token (7 days)
	refreshTokenClaims := Claims{
		UserID: user.ID,
		Email:  user.Email,
		Role:   user.Role,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(7 * 24 * time.Hour)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, refreshTokenClaims)
	refreshTokenString, err := refreshToken.SignedString([]byte(JWT_SECRET))
	if err != nil {
		return "", "", 0, err
	}

	return accessTokenString, refreshTokenString, 3600, nil
}

// ===== Main =====

func main() {
	// Load environment variables
	godotenv.Load()

	// Initialize database
	if err := initDB(); err != nil {
		log.Fatalf("Failed to initialize database: %v", err)
	}

	// Create router
	router := gin.Default()

	// Middleware
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	// CORS
	router.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	// Initialize OAuth
	InitOAuth()
	
	// Initialize RBAC
	InitRBAC()

	// ===== Public Routes =====
	router.GET("/health", healthHandler)
	router.POST("/api/auth/login", loginHandler)
	router.POST("/api/auth/signup", signupHandler)
	router.POST("/api/auth/logout", logoutHandler)
	router.POST("/api/auth/verify", verifyTokenHandler)

	// OAuth Routes
	router.GET("/api/auth/oauth/google", HandleGoogleLogin)
	router.GET("/api/auth/callback/google", HandleGoogleCallback)
	router.GET("/api/auth/oauth/kakao", HandleKakaoLogin)
	router.GET("/api/auth/oauth/naver", HandleNaverLogin)

	// 2FA Public Route (for login verification)
	router.POST("/api/auth/2fa/validate", Validate2FACode)

	// ===== Protected Routes =====
	protected := router.Group("/api")
	protected.Use(AuthMiddleware())
	{
		// User Profile
		protected.GET("/users/:userId", getUserProfileHandler)
		protected.PUT("/users/:userId", updateUserProfileHandler)

		// 2FA Routes
		protected.POST("/auth/2fa/setup", Setup2FA)
		protected.POST("/auth/2fa/verify", Verify2FA)
		protected.POST("/auth/2fa/disable", Disable2FA)
		protected.GET("/auth/2fa/status", Check2FAStatus)
		protected.POST("/auth/2fa/backup-codes", RegenerateBackupCodes)
		protected.POST("/auth/2fa/sms/send", SendSMSCode)
		protected.POST("/auth/2fa/sms/verify", VerifySMSCode)

		// OAuth Account Linking
		protected.POST("/auth/oauth/link", LinkOAuthAccount)
		protected.DELETE("/auth/oauth/unlink/:provider", UnlinkOAuthAccount)
		protected.GET("/auth/oauth/accounts", GetLinkedAccounts)

		// User Permissions
		protected.GET("/auth/permissions", GetUserPermissions)
	}

	// ===== Admin Routes =====
	admin := router.Group("/api/admin")
	admin.Use(AuthMiddleware())
	admin.Use(RequireRole("admin"))
	{
		// Role Management
		admin.GET("/roles", ListRoles)
		admin.POST("/roles", CreateRole)
		admin.PUT("/roles/:name", UpdateRole)
		admin.POST("/roles/assign", AssignRole)
		admin.POST("/roles/revoke", RevokeRole)

		// Permission Management
		admin.GET("/permissions", ListPermissions)
	}

	// Start server
	fmt.Printf(`
╔════════════════════════════════════════════════════╗
║  🚀 Auth Service 시작                              ║
║                                                    ║
║  📍 주소: http://localhost:%s               ║
║  🏥 상태: 정상 작동 중                             ║
║  💾 데이터베이스: PostgreSQL                       ║
║  🔐 인증: JWT (1시간)                              ║
║                                                    ║
║  Endpoints:                                       ║
║  - POST /api/auth/login                          ║
║  - POST /api/auth/signup                         ║
║  - GET  /api/auth/oauth/google (OAuth2)          ║
║  - POST /api/auth/2fa/setup (2FA)                ║
║  - GET  /api/admin/roles (RBAC)                  ║
║                                                    ║
╚════════════════════════════════════════════════════╝
`, PORT)

	if err := router.Run(":" + PORT); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

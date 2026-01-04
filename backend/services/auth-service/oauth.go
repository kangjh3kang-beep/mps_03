package main

import (
	"context"
	"crypto/rand"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

// OAuth2 Configuration
var (
	googleOAuthConfig *oauth2.Config
	oauthStateString  = "random" // Production에서는 랜덤 문자열 사용
)

// OAuthProvider represents supported OAuth providers
type OAuthProvider string

const (
	ProviderGoogle OAuthProvider = "google"
	ProviderApple  OAuthProvider = "apple"
	ProviderKakao  OAuthProvider = "kakao"
	ProviderNaver  OAuthProvider = "naver"
)

// OAuthUserInfo represents user info from OAuth provider
type OAuthUserInfo struct {
	ID            string `json:"id"`
	Email         string `json:"email"`
	Name          string `json:"name"`
	Picture       string `json:"picture"`
	Provider      string `json:"provider"`
	VerifiedEmail bool   `json:"verified_email"`
}

// OAuthToken represents OAuth tokens stored in database
type OAuthToken struct {
	ID           uint      `gorm:"primarykey"`
	UserID       uint      `gorm:"not null"`
	Provider     string    `gorm:"size:50;not null"`
	ProviderID   string    `gorm:"size:255;not null"`
	AccessToken  string    `gorm:"type:text"`
	RefreshToken string    `gorm:"type:text"`
	ExpiresAt    time.Time
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

// InitOAuth initializes OAuth configurations
func InitOAuth() {
	googleOAuthConfig = &oauth2.Config{
		ClientID:     getEnv("GOOGLE_CLIENT_ID", ""),
		ClientSecret: getEnv("GOOGLE_CLIENT_SECRET", ""),
		RedirectURL:  getEnv("GOOGLE_REDIRECT_URL", "http://localhost:8001/auth/callback/google"),
		Scopes: []string{
			"https://www.googleapis.com/auth/userinfo.email",
			"https://www.googleapis.com/auth/userinfo.profile",
		},
		Endpoint: google.Endpoint,
	}
}

// generateStateOauthCookie generates random state for OAuth
func generateStateOauthCookie() string {
	b := make([]byte, 16)
	rand.Read(b)
	return base64.URLEncoding.EncodeToString(b)
}

// HandleGoogleLogin initiates Google OAuth flow
func HandleGoogleLogin(c *gin.Context) {
	oauthState := generateStateOauthCookie()
	
	// Store state in session/cookie for verification
	c.SetCookie("oauthstate", oauthState, 3600, "/", "", false, true)
	
	url := googleOAuthConfig.AuthCodeURL(oauthState)
	c.Redirect(http.StatusTemporaryRedirect, url)
}

// HandleGoogleCallback handles Google OAuth callback
func HandleGoogleCallback(c *gin.Context) {
	// Verify state
	oauthState, _ := c.Cookie("oauthstate")
	if c.Query("state") != oauthState {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid OAuth state"})
		return
	}

	code := c.Query("code")
	token, err := googleOAuthConfig.Exchange(context.Background(), code)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to exchange token"})
		return
	}

	// Get user info from Google
	userInfo, err := getGoogleUserInfo(token.AccessToken)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get user info"})
		return
	}

	// Find or create user
	user, jwtToken, err := findOrCreateOAuthUser(userInfo, token)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to process user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "OAuth login successful",
		"user":    user,
		"token":   jwtToken,
	})
}

// getGoogleUserInfo fetches user info from Google API
func getGoogleUserInfo(accessToken string) (*OAuthUserInfo, error) {
	resp, err := http.Get("https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var userInfo OAuthUserInfo
	if err := json.Unmarshal(data, &userInfo); err != nil {
		return nil, err
	}
	userInfo.Provider = string(ProviderGoogle)

	return &userInfo, nil
}

// findOrCreateOAuthUser finds existing user or creates new one from OAuth
func findOrCreateOAuthUser(info *OAuthUserInfo, token *oauth2.Token) (*User, string, error) {
	var user User
	
	// Check if user exists with this OAuth provider
	var oauthToken OAuthToken
	result := db.Where("provider = ? AND provider_id = ?", info.Provider, info.ID).First(&oauthToken)
	
	if result.Error == nil {
		// User exists, update tokens
		db.First(&user, oauthToken.UserID)
		oauthToken.AccessToken = token.AccessToken
		oauthToken.RefreshToken = token.RefreshToken
		oauthToken.ExpiresAt = token.Expiry
		db.Save(&oauthToken)
	} else {
		// Check if user exists with same email
		result = db.Where("email = ?", info.Email).First(&user)
		
		if result.Error != nil {
			// Create new user
			user = User{
				Email:     info.Email,
				Name:      info.Name,
				Password:  "", // OAuth users don't have password
				Role:      "user",
				Active:    true,
				Verified:  info.VerifiedEmail,
				Provider:  info.Provider,
			}
			db.Create(&user)
		}
		
		// Create OAuth token record
		oauthToken = OAuthToken{
			UserID:       user.ID,
			Provider:     info.Provider,
			ProviderID:   info.ID,
			AccessToken:  token.AccessToken,
			RefreshToken: token.RefreshToken,
			ExpiresAt:    token.Expiry,
		}
		db.Create(&oauthToken)
	}

	// Generate JWT token
	jwtToken, _ := generateToken(user.ID)

	return &user, jwtToken, nil
}

// HandleKakaoLogin initiates Kakao OAuth flow
func HandleKakaoLogin(c *gin.Context) {
	kakaoConfig := &oauth2.Config{
		ClientID:     getEnv("KAKAO_CLIENT_ID", ""),
		ClientSecret: getEnv("KAKAO_CLIENT_SECRET", ""),
		RedirectURL:  getEnv("KAKAO_REDIRECT_URL", "http://localhost:8001/auth/callback/kakao"),
		Scopes:       []string{"profile_nickname", "profile_image", "account_email"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://kauth.kakao.com/oauth/authorize",
			TokenURL: "https://kauth.kakao.com/oauth/token",
		},
	}

	oauthState := generateStateOauthCookie()
	c.SetCookie("oauthstate", oauthState, 3600, "/", "", false, true)
	
	url := kakaoConfig.AuthCodeURL(oauthState)
	c.Redirect(http.StatusTemporaryRedirect, url)
}

// HandleNaverLogin initiates Naver OAuth flow
func HandleNaverLogin(c *gin.Context) {
	naverConfig := &oauth2.Config{
		ClientID:     getEnv("NAVER_CLIENT_ID", ""),
		ClientSecret: getEnv("NAVER_CLIENT_SECRET", ""),
		RedirectURL:  getEnv("NAVER_REDIRECT_URL", "http://localhost:8001/auth/callback/naver"),
		Scopes:       []string{"profile"},
		Endpoint: oauth2.Endpoint{
			AuthURL:  "https://nid.naver.com/oauth2.0/authorize",
			TokenURL: "https://nid.naver.com/oauth2.0/token",
		},
	}

	oauthState := generateStateOauthCookie()
	c.SetCookie("oauthstate", oauthState, 3600, "/", "", false, true)
	
	url := naverConfig.AuthCodeURL(oauthState)
	c.Redirect(http.StatusTemporaryRedirect, url)
}

// LinkOAuthAccount links OAuth account to existing user
func LinkOAuthAccount(c *gin.Context) {
	userID := c.GetUint("userID")
	var request struct {
		Provider     string `json:"provider" binding:"required"`
		ProviderID   string `json:"provider_id" binding:"required"`
		AccessToken  string `json:"access_token"`
		RefreshToken string `json:"refresh_token"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Check if this OAuth account is already linked
	var existing OAuthToken
	if err := db.Where("provider = ? AND provider_id = ?", request.Provider, request.ProviderID).First(&existing).Error; err == nil {
		c.JSON(http.StatusConflict, gin.H{"error": "This OAuth account is already linked to another user"})
		return
	}

	oauthToken := OAuthToken{
		UserID:       userID,
		Provider:     request.Provider,
		ProviderID:   request.ProviderID,
		AccessToken:  request.AccessToken,
		RefreshToken: request.RefreshToken,
	}

	if err := db.Create(&oauthToken).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to link OAuth account"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "OAuth account linked successfully"})
}

// UnlinkOAuthAccount unlinks OAuth account from user
func UnlinkOAuthAccount(c *gin.Context) {
	userID := c.GetUint("userID")
	provider := c.Param("provider")

	result := db.Where("user_id = ? AND provider = ?", userID, provider).Delete(&OAuthToken{})
	if result.RowsAffected == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "OAuth account not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "OAuth account unlinked successfully"})
}

// GetLinkedAccounts returns all linked OAuth accounts for a user
func GetLinkedAccounts(c *gin.Context) {
	userID := c.GetUint("userID")

	var tokens []OAuthToken
	db.Where("user_id = ?", userID).Find(&tokens)

	accounts := make([]map[string]interface{}, len(tokens))
	for i, t := range tokens {
		accounts[i] = map[string]interface{}{
			"provider":   t.Provider,
			"linked_at":  t.CreatedAt,
		}
	}

	c.JSON(http.StatusOK, gin.H{"linked_accounts": accounts})
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}


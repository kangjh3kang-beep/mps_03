package main

import (
	"crypto/rand"
	"encoding/base32"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/pquerna/otp"
	"github.com/pquerna/otp/totp"
)

// TwoFactorAuth represents 2FA settings for a user
type TwoFactorAuth struct {
	ID            uint      `gorm:"primarykey"`
	UserID        uint      `gorm:"uniqueIndex;not null"`
	Secret        string    `gorm:"size:255;not null"`
	Enabled       bool      `gorm:"default:false"`
	BackupCodes   string    `gorm:"type:text"` // JSON array of backup codes
	LastUsed      time.Time
	CreatedAt     time.Time
	UpdatedAt     time.Time
}

// SMSVerification represents SMS verification codes
type SMSVerification struct {
	ID        uint      `gorm:"primarykey"`
	UserID    uint      `gorm:"not null"`
	Phone     string    `gorm:"size:20;not null"`
	Code      string    `gorm:"size:6;not null"`
	ExpiresAt time.Time
	Used      bool      `gorm:"default:false"`
	CreatedAt time.Time
}

// TwoFactorSetupResponse response for 2FA setup
type TwoFactorSetupResponse struct {
	Secret      string   `json:"secret"`
	QRCodeURL   string   `json:"qr_code_url"`
	BackupCodes []string `json:"backup_codes"`
}

// Setup2FA initiates 2FA setup for user
func Setup2FA(c *gin.Context) {
	userID := c.GetUint("userID")

	// Get user email
	var user User
	if err := db.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// Check if 2FA is already set up
	var existing TwoFactorAuth
	if err := db.Where("user_id = ?", userID).First(&existing).Error; err == nil && existing.Enabled {
		c.JSON(http.StatusConflict, gin.H{"error": "2FA is already enabled"})
		return
	}

	// Generate TOTP key
	key, err := totp.Generate(totp.GenerateOpts{
		Issuer:      "Manpasik Health",
		AccountName: user.Email,
		SecretSize:  32,
		Algorithm:   otp.AlgorithmSHA1,
		Digits:      otp.DigitsSix,
		Period:      30,
	})
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate 2FA secret"})
		return
	}

	// Generate backup codes
	backupCodes := generateBackupCodes(10)

	// Store 2FA settings (not enabled yet)
	twoFA := TwoFactorAuth{
		UserID:      userID,
		Secret:      key.Secret(),
		Enabled:     false,
		BackupCodes: encodeBackupCodes(backupCodes),
	}

	if existing.ID != 0 {
		twoFA.ID = existing.ID
		db.Save(&twoFA)
	} else {
		db.Create(&twoFA)
	}

	c.JSON(http.StatusOK, TwoFactorSetupResponse{
		Secret:      key.Secret(),
		QRCodeURL:   key.URL(),
		BackupCodes: backupCodes,
	})
}

// Verify2FA verifies the 2FA code and enables 2FA
func Verify2FA(c *gin.Context) {
	userID := c.GetUint("userID")
	
	var request struct {
		Code string `json:"code" binding:"required,len=6"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var twoFA TwoFactorAuth
	if err := db.Where("user_id = ?", userID).First(&twoFA).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "2FA not set up"})
		return
	}

	// Verify TOTP code
	valid := totp.Validate(request.Code, twoFA.Secret)
	if !valid {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid 2FA code"})
		return
	}

	// Enable 2FA
	twoFA.Enabled = true
	twoFA.LastUsed = time.Now()
	db.Save(&twoFA)

	c.JSON(http.StatusOK, gin.H{"message": "2FA enabled successfully"})
}

// Disable2FA disables 2FA for user
func Disable2FA(c *gin.Context) {
	userID := c.GetUint("userID")
	
	var request struct {
		Code     string `json:"code" binding:"required"`
		Password string `json:"password" binding:"required"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Verify password
	var user User
	if err := db.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	if !checkPasswordHash(request.Password, user.Password) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid password"})
		return
	}

	// Verify 2FA code
	var twoFA TwoFactorAuth
	if err := db.Where("user_id = ?", userID).First(&twoFA).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "2FA not enabled"})
		return
	}

	valid := totp.Validate(request.Code, twoFA.Secret)
	if !valid && !verifyBackupCode(request.Code, twoFA.BackupCodes) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid 2FA code"})
		return
	}

	// Delete 2FA settings
	db.Delete(&twoFA)

	c.JSON(http.StatusOK, gin.H{"message": "2FA disabled successfully"})
}

// Validate2FACode validates 2FA code during login
func Validate2FACode(c *gin.Context) {
	var request struct {
		UserID uint   `json:"user_id" binding:"required"`
		Code   string `json:"code" binding:"required"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var twoFA TwoFactorAuth
	if err := db.Where("user_id = ? AND enabled = ?", request.UserID, true).First(&twoFA).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "2FA not enabled"})
		return
	}

	// Try TOTP first
	valid := totp.Validate(request.Code, twoFA.Secret)
	
	// If TOTP fails, try backup code
	if !valid {
		if verifyBackupCode(request.Code, twoFA.BackupCodes) {
			// Invalidate used backup code
			twoFA.BackupCodes = removeBackupCode(request.Code, twoFA.BackupCodes)
			db.Save(&twoFA)
			valid = true
		}
	}

	if !valid {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid 2FA code"})
		return
	}

	twoFA.LastUsed = time.Now()
	db.Save(&twoFA)

	// Generate final JWT token
	token, _ := generateToken(request.UserID)

	c.JSON(http.StatusOK, gin.H{
		"message": "2FA verified",
		"token":   token,
	})
}

// Check2FAStatus checks if user has 2FA enabled
func Check2FAStatus(c *gin.Context) {
	userID := c.GetUint("userID")

	var twoFA TwoFactorAuth
	if err := db.Where("user_id = ?", userID).First(&twoFA).Error; err != nil {
		c.JSON(http.StatusOK, gin.H{
			"enabled":   false,
			"setup":     false,
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"enabled":   twoFA.Enabled,
		"setup":     true,
		"last_used": twoFA.LastUsed,
	})
}

// RegenerateBackupCodes regenerates backup codes
func RegenerateBackupCodes(c *gin.Context) {
	userID := c.GetUint("userID")
	
	var request struct {
		Code string `json:"code" binding:"required"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var twoFA TwoFactorAuth
	if err := db.Where("user_id = ? AND enabled = ?", userID, true).First(&twoFA).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "2FA not enabled"})
		return
	}

	// Verify TOTP code
	if !totp.Validate(request.Code, twoFA.Secret) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid 2FA code"})
		return
	}

	// Generate new backup codes
	backupCodes := generateBackupCodes(10)
	twoFA.BackupCodes = encodeBackupCodes(backupCodes)
	db.Save(&twoFA)

	c.JSON(http.StatusOK, gin.H{
		"message":      "Backup codes regenerated",
		"backup_codes": backupCodes,
	})
}

// SendSMSCode sends SMS verification code
func SendSMSCode(c *gin.Context) {
	userID := c.GetUint("userID")
	
	var request struct {
		Phone string `json:"phone" binding:"required"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Generate 6-digit code
	code := generateSMSCode()

	// Store verification record
	verification := SMSVerification{
		UserID:    userID,
		Phone:     request.Phone,
		Code:      code,
		ExpiresAt: time.Now().Add(5 * time.Minute),
	}
	db.Create(&verification)

	// TODO: Integrate with actual SMS provider (Twilio, AWS SNS, etc.)
	// For now, just return success
	fmt.Printf("SMS Code for %s: %s\n", request.Phone, code)

	c.JSON(http.StatusOK, gin.H{
		"message":    "SMS code sent",
		"expires_in": 300, // 5 minutes
	})
}

// VerifySMSCode verifies SMS code
func VerifySMSCode(c *gin.Context) {
	userID := c.GetUint("userID")
	
	var request struct {
		Phone string `json:"phone" binding:"required"`
		Code  string `json:"code" binding:"required,len=6"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var verification SMSVerification
	if err := db.Where(
		"user_id = ? AND phone = ? AND code = ? AND expires_at > ? AND used = ?",
		userID, request.Phone, request.Code, time.Now(), false,
	).First(&verification).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired code"})
		return
	}

	// Mark as used
	verification.Used = true
	db.Save(&verification)

	c.JSON(http.StatusOK, gin.H{"message": "SMS code verified"})
}

// Helper functions

func generateBackupCodes(count int) []string {
	codes := make([]string, count)
	for i := 0; i < count; i++ {
		codes[i] = generateRandomCode(8)
	}
	return codes
}

func generateRandomCode(length int) string {
	bytes := make([]byte, length)
	rand.Read(bytes)
	return base32.StdEncoding.EncodeToString(bytes)[:length]
}

func generateSMSCode() string {
	bytes := make([]byte, 3)
	rand.Read(bytes)
	code := int(bytes[0])<<16 | int(bytes[1])<<8 | int(bytes[2])
	return fmt.Sprintf("%06d", code%1000000)
}

func encodeBackupCodes(codes []string) string {
	// Simple comma-separated encoding
	result := ""
	for i, code := range codes {
		if i > 0 {
			result += ","
		}
		result += code
	}
	return result
}

func verifyBackupCode(code string, storedCodes string) bool {
	codes := decodeBackupCodes(storedCodes)
	for _, c := range codes {
		if c == code {
			return true
		}
	}
	return false
}

func decodeBackupCodes(encoded string) []string {
	if encoded == "" {
		return []string{}
	}
	codes := []string{}
	current := ""
	for _, char := range encoded {
		if char == ',' {
			if current != "" {
				codes = append(codes, current)
			}
			current = ""
		} else {
			current += string(char)
		}
	}
	if current != "" {
		codes = append(codes, current)
	}
	return codes
}

func removeBackupCode(code string, storedCodes string) string {
	codes := decodeBackupCodes(storedCodes)
	newCodes := []string{}
	for _, c := range codes {
		if c != code {
			newCodes = append(newCodes, c)
		}
	}
	return encodeBackupCodes(newCodes)
}


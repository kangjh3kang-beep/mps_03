package main

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// Role represents a user role
type Role struct {
	ID          uint      `gorm:"primarykey"`
	Name        string    `gorm:"uniqueIndex;size:50;not null"`
	Description string    `gorm:"size:255"`
	Permissions string    `gorm:"type:text"` // JSON array of permission IDs
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

// Permission represents a permission
type Permission struct {
	ID          uint      `gorm:"primarykey"`
	Name        string    `gorm:"uniqueIndex;size:100;not null"`
	Resource    string    `gorm:"size:100;not null"` // e.g., "users", "measurements"
	Action      string    `gorm:"size:50;not null"`  // e.g., "create", "read", "update", "delete"
	Description string    `gorm:"size:255"`
	CreatedAt   time.Time
}

// UserRole represents user-role mapping
type UserRole struct {
	ID        uint      `gorm:"primarykey"`
	UserID    uint      `gorm:"not null"`
	RoleID    uint      `gorm:"not null"`
	CreatedAt time.Time
}

// Default roles and permissions
var defaultRoles = []Role{
	{Name: "admin", Description: "시스템 관리자 - 전체 접근 권한"},
	{Name: "doctor", Description: "의료진 - 환자 데이터 조회 및 처방 권한"},
	{Name: "user", Description: "일반 사용자 - 자신의 데이터만 접근"},
	{Name: "family_member", Description: "가족 구성원 - 공유된 데이터 조회"},
	{Name: "guest", Description: "게스트 - 제한된 접근"},
}

var defaultPermissions = []Permission{
	// User permissions
	{Name: "users:create", Resource: "users", Action: "create", Description: "사용자 생성"},
	{Name: "users:read", Resource: "users", Action: "read", Description: "사용자 조회"},
	{Name: "users:update", Resource: "users", Action: "update", Description: "사용자 수정"},
	{Name: "users:delete", Resource: "users", Action: "delete", Description: "사용자 삭제"},
	
	// Measurement permissions
	{Name: "measurements:create", Resource: "measurements", Action: "create", Description: "측정 데이터 생성"},
	{Name: "measurements:read", Resource: "measurements", Action: "read", Description: "측정 데이터 조회"},
	{Name: "measurements:update", Resource: "measurements", Action: "update", Description: "측정 데이터 수정"},
	{Name: "measurements:delete", Resource: "measurements", Action: "delete", Description: "측정 데이터 삭제"},
	
	// Analysis permissions
	{Name: "analysis:read", Resource: "analysis", Action: "read", Description: "분석 데이터 조회"},
	{Name: "analysis:export", Resource: "analysis", Action: "export", Description: "분석 데이터 내보내기"},
	
	// Coaching permissions
	{Name: "coaching:read", Resource: "coaching", Action: "read", Description: "코칭 조회"},
	{Name: "coaching:manage", Resource: "coaching", Action: "manage", Description: "코칭 관리"},
	
	// Family permissions
	{Name: "family:invite", Resource: "family", Action: "invite", Description: "가족 초대"},
	{Name: "family:read", Resource: "family", Action: "read", Description: "가족 데이터 조회"},
	
	// Admin permissions
	{Name: "admin:access", Resource: "admin", Action: "access", Description: "관리자 패널 접근"},
	{Name: "admin:manage_users", Resource: "admin", Action: "manage_users", Description: "사용자 관리"},
	{Name: "admin:manage_roles", Resource: "admin", Action: "manage_roles", Description: "역할 관리"},
	{Name: "admin:view_logs", Resource: "admin", Action: "view_logs", Description: "로그 조회"},
}

// Role to permissions mapping
var rolePermissions = map[string][]string{
	"admin": {
		"users:create", "users:read", "users:update", "users:delete",
		"measurements:create", "measurements:read", "measurements:update", "measurements:delete",
		"analysis:read", "analysis:export",
		"coaching:read", "coaching:manage",
		"family:invite", "family:read",
		"admin:access", "admin:manage_users", "admin:manage_roles", "admin:view_logs",
	},
	"doctor": {
		"users:read",
		"measurements:read",
		"analysis:read", "analysis:export",
		"coaching:read", "coaching:manage",
	},
	"user": {
		"measurements:create", "measurements:read", "measurements:update", "measurements:delete",
		"analysis:read", "analysis:export",
		"coaching:read",
		"family:invite", "family:read",
	},
	"family_member": {
		"measurements:read",
		"analysis:read",
		"family:read",
	},
	"guest": {
		"analysis:read",
	},
}

// InitRBAC initializes default roles and permissions
func InitRBAC() {
	// Create default permissions
	for _, perm := range defaultPermissions {
		db.FirstOrCreate(&perm, Permission{Name: perm.Name})
	}

	// Create default roles
	for _, role := range defaultRoles {
		db.FirstOrCreate(&role, Role{Name: role.Name})
	}
}

// RequirePermission middleware checks if user has required permission
func RequirePermission(permission string) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID := c.GetUint("userID")

		if !HasPermission(userID, permission) {
			c.JSON(http.StatusForbidden, gin.H{"error": "Permission denied"})
			c.Abort()
			return
		}

		c.Next()
	}
}

// RequireRole middleware checks if user has required role
func RequireRole(roles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		userID := c.GetUint("userID")

		userRoles := GetUserRoles(userID)
		for _, required := range roles {
			for _, userRole := range userRoles {
				if userRole == required {
					c.Next()
					return
				}
			}
		}

		c.JSON(http.StatusForbidden, gin.H{"error": "Role not authorized"})
		c.Abort()
	}
}

// HasPermission checks if user has specific permission
func HasPermission(userID uint, permission string) bool {
	roles := GetUserRoles(userID)
	
	for _, role := range roles {
		if permissions, ok := rolePermissions[role]; ok {
			for _, perm := range permissions {
				if perm == permission {
					return true
				}
			}
		}
	}
	
	return false
}

// GetUserRoles returns all roles for a user
func GetUserRoles(userID uint) []string {
	var userRoles []UserRole
	db.Where("user_id = ?", userID).Find(&userRoles)

	roles := make([]string, 0, len(userRoles))
	for _, ur := range userRoles {
		var role Role
		if db.First(&role, ur.RoleID).Error == nil {
			roles = append(roles, role.Name)
		}
	}

	// If user has no roles, assign default "user" role
	if len(roles) == 0 {
		roles = append(roles, "user")
	}

	return roles
}

// AssignRole assigns a role to a user
func AssignRole(c *gin.Context) {
	var request struct {
		UserID   uint   `json:"user_id" binding:"required"`
		RoleName string `json:"role_name" binding:"required"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Find role
	var role Role
	if err := db.Where("name = ?", request.RoleName).First(&role).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Role not found"})
		return
	}

	// Check if user already has this role
	var existing UserRole
	if err := db.Where("user_id = ? AND role_id = ?", request.UserID, role.ID).First(&existing).Error; err == nil {
		c.JSON(http.StatusConflict, gin.H{"error": "User already has this role"})
		return
	}

	// Assign role
	userRole := UserRole{
		UserID: request.UserID,
		RoleID: role.ID,
	}
	db.Create(&userRole)

	c.JSON(http.StatusOK, gin.H{"message": "Role assigned successfully"})
}

// RevokeRole removes a role from a user
func RevokeRole(c *gin.Context) {
	var request struct {
		UserID   uint   `json:"user_id" binding:"required"`
		RoleName string `json:"role_name" binding:"required"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var role Role
	if err := db.Where("name = ?", request.RoleName).First(&role).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Role not found"})
		return
	}

	result := db.Where("user_id = ? AND role_id = ?", request.UserID, role.ID).Delete(&UserRole{})
	if result.RowsAffected == 0 {
		c.JSON(http.StatusNotFound, gin.H{"error": "User does not have this role"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Role revoked successfully"})
}

// ListRoles returns all available roles
func ListRoles(c *gin.Context) {
	var roles []Role
	db.Find(&roles)

	c.JSON(http.StatusOK, gin.H{"roles": roles})
}

// ListPermissions returns all available permissions
func ListPermissions(c *gin.Context) {
	var permissions []Permission
	db.Find(&permissions)

	c.JSON(http.StatusOK, gin.H{"permissions": permissions})
}

// GetUserPermissions returns all permissions for a user
func GetUserPermissions(c *gin.Context) {
	userID := c.GetUint("userID")
	roles := GetUserRoles(userID)

	allPermissions := make(map[string]bool)
	for _, role := range roles {
		if permissions, ok := rolePermissions[role]; ok {
			for _, perm := range permissions {
				allPermissions[perm] = true
			}
		}
	}

	permissions := make([]string, 0, len(allPermissions))
	for perm := range allPermissions {
		permissions = append(permissions, perm)
	}

	c.JSON(http.StatusOK, gin.H{
		"roles":       roles,
		"permissions": permissions,
	})
}

// CreateRole creates a new role (admin only)
func CreateRole(c *gin.Context) {
	var request struct {
		Name        string   `json:"name" binding:"required"`
		Description string   `json:"description"`
		Permissions []string `json:"permissions"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Check if role already exists
	var existing Role
	if err := db.Where("name = ?", request.Name).First(&existing).Error; err == nil {
		c.JSON(http.StatusConflict, gin.H{"error": "Role already exists"})
		return
	}

	role := Role{
		Name:        request.Name,
		Description: request.Description,
		Permissions: encodeBackupCodes(request.Permissions), // Reuse helper
	}
	db.Create(&role)

	// Update rolePermissions map
	rolePermissions[request.Name] = request.Permissions

	c.JSON(http.StatusCreated, gin.H{
		"message": "Role created successfully",
		"role":    role,
	})
}

// UpdateRole updates an existing role (admin only)
func UpdateRole(c *gin.Context) {
	roleName := c.Param("name")

	var request struct {
		Description string   `json:"description"`
		Permissions []string `json:"permissions"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var role Role
	if err := db.Where("name = ?", roleName).First(&role).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Role not found"})
		return
	}

	role.Description = request.Description
	role.Permissions = encodeBackupCodes(request.Permissions)
	db.Save(&role)

	// Update rolePermissions map
	rolePermissions[roleName] = request.Permissions

	c.JSON(http.StatusOK, gin.H{
		"message": "Role updated successfully",
		"role":    role,
	})
}


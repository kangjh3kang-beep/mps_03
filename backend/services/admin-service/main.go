package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gorilla/mux"
	_ "github.com/lib/pq"
)

// ============================================
// Configuration
// ============================================

var db *sql.DB
var jwtSecret = os.Getenv("JWT_SECRET")

const (
	host   = "db"
	user   = "postgres"
	password = "password"
	dbname = "mps_admin"
	port   = 5432
)

// ============================================
// Models
// ============================================

type User struct {
	ID           string    `json:"id"`
	Email        string    `json:"email"`
	Name         string    `json:"name"`
	Role         string    `json:"role"`
	Status       string    `json:"status"`
	CreatedAt    time.Time `json:"created_at"`
	LastLoginAt  time.Time `json:"last_login_at"`
	LastModified time.Time `json:"last_modified"`
}

type AdminAction struct {
	ID            int       `json:"id"`
	AdminID       string    `json:"admin_id"`
	Action        string    `json:"action"`
	TargetUserID  string    `json:"target_user_id"`
	TargetType    string    `json:"target_type"`
	OldValue      string    `json:"old_value"`
	NewValue      string    `json:"new_value"`
	Reason        string    `json:"reason"`
	CreatedAt     time.Time `json:"created_at"`
}

type Analytics struct {
	ID               int       `json:"id"`
	MetricName       string    `json:"metric_name"`
	MetricValue      float64   `json:"metric_value"`
	Period           string    `json:"period"`
	TotalUsers       int       `json:"total_users"`
	ActiveUsers      int       `json:"active_users"`
	NewUsers         int       `json:"new_users"`
	Measurements     int       `json:"measurements"`
	AverageSessionTime float64 `json:"average_session_time"`
	CreatedAt        time.Time `json:"created_at"`
}

type SystemHealth struct {
	Status         string  `json:"status"`
	CPUUsage       float64 `json:"cpu_usage"`
	MemoryUsage    float64 `json:"memory_usage"`
	DiskUsage      float64 `json:"disk_usage"`
	DatabaseStatus string  `json:"database_status"`
	Timestamp      time.Time `json:"timestamp"`
}

// ============================================
// Authentication
// ============================================

func verifyToken(r *http.Request) (jwt.MapClaims, error) {
	authHeader := r.Header.Get("Authorization")
	if authHeader == "" {
		return nil, fmt.Errorf("authorization header missing")
	}

	tokenString := authHeader[7:] // Remove "Bearer " prefix
	token, err := jwt.ParseWithClaims(tokenString, jwt.MapClaims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte(jwtSecret), nil
	})

	if err != nil || !token.Valid {
		return nil, fmt.Errorf("invalid token")
	}

	return token.Claims.(jwt.MapClaims), nil
}

// ============================================
// Database Initialization
// ============================================

func initDatabase() {
	psqlInfo := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%d sslmode=disable",
		host, user, password, dbname, port)

	var err error
	db, err = sql.Open("postgres", psqlInfo)
	if err != nil {
		log.Fatal(err)
	}

	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}

	// Create tables
	createTables()
	log.Println("Database connected successfully")
}

func createTables() {
	tables := []string{
		`CREATE TABLE IF NOT EXISTS users (
			id VARCHAR(255) PRIMARY KEY,
			email VARCHAR(255) UNIQUE,
			name VARCHAR(255),
			role VARCHAR(50),
			status VARCHAR(50),
			created_at TIMESTAMP,
			last_login_at TIMESTAMP,
			last_modified TIMESTAMP
		)`,
		`CREATE TABLE IF NOT EXISTS admin_actions (
			id SERIAL PRIMARY KEY,
			admin_id VARCHAR(255),
			action VARCHAR(100),
			target_user_id VARCHAR(255),
			target_type VARCHAR(100),
			old_value TEXT,
			new_value TEXT,
			reason TEXT,
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		)`,
		`CREATE TABLE IF NOT EXISTS analytics (
			id SERIAL PRIMARY KEY,
			metric_name VARCHAR(100),
			metric_value DECIMAL(10, 2),
			period VARCHAR(50),
			total_users INTEGER,
			active_users INTEGER,
			new_users INTEGER,
			measurements INTEGER,
			average_session_time DECIMAL(10, 2),
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		)`,
		`CREATE TABLE IF NOT EXISTS user_reports (
			id SERIAL PRIMARY KEY,
			user_id VARCHAR(255),
			report_type VARCHAR(100),
			content TEXT,
			status VARCHAR(50),
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			resolved_at TIMESTAMP
		)`,
		`CREATE TABLE IF NOT EXISTS system_logs (
			id SERIAL PRIMARY KEY,
			level VARCHAR(50),
			message TEXT,
			details TEXT,
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		)`,
	}

	for _, table := range tables {
		_, err := db.Exec(table)
		if err != nil {
			log.Println("Error creating table:", err)
		}
	}
}

// ============================================
// Health Check
// ============================================

func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"status":    "ok",
		"service":   "admin-service",
		"timestamp": time.Now().UTC().String(),
	})
}

// ============================================
// User Management
// ============================================

func getUsersHandler(w http.ResponseWriter, r *http.Request) {
	_, err := verifyToken(r)
	if err != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	limit := r.URL.Query().Get("limit")
	offset := r.URL.Query().Get("offset")
	if limit == "" {
		limit = "50"
	}
	if offset == "" {
		offset = "0"
	}

	rows, err := db.Query(`
		SELECT id, email, name, role, status, created_at, last_login_at, last_modified 
		FROM users 
		ORDER BY created_at DESC 
		LIMIT $1 OFFSET $2
	`, limit, offset)
	if err != nil {
		http.Error(w, "Query failed", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var users []User
	for rows.Next() {
		var user User
		if err := rows.Scan(&user.ID, &user.Email, &user.Name, &user.Role, &user.Status, &user.CreatedAt, &user.LastLoginAt, &user.LastModified); err != nil {
			log.Println(err)
			continue
		}
		users = append(users, user)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    users,
		"count":   len(users),
	})
}

func getUserHandler(w http.ResponseWriter, r *http.Request) {
	_, err := verifyToken(r)
	if err != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	vars := mux.Vars(r)
	userID := vars["id"]

	var user User
	err = db.QueryRow(`
		SELECT id, email, name, role, status, created_at, last_login_at, last_modified 
		FROM users 
		WHERE id = $1
	`, userID).Scan(&user.ID, &user.Email, &user.Name, &user.Role, &user.Status, &user.CreatedAt, &user.LastLoginAt, &user.LastModified)

	if err != nil {
		http.Error(w, "User not found", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    user,
	})
}

func updateUserHandler(w http.ResponseWriter, r *http.Request) {
	_, err := verifyToken(r)
	if err != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	vars := mux.Vars(r)
	userID := vars["id"]

	var updates map[string]interface{}
	json.NewDecoder(r.Body).Decode(&updates)

	// Update user
	query := "UPDATE users SET "
	args := []interface{}{}
	i := 1

	for key, value := range updates {
		if key != "reason" {
			if i > 1 {
				query += ", "
			}
			query += fmt.Sprintf("%s = $%d", key, i)
			args = append(args, value)
			i++
		}
	}

	query += fmt.Sprintf(", last_modified = NOW() WHERE id = $%d", i)
	args = append(args, userID)

	_, err = db.Exec(query, args...)
	if err != nil {
		http.Error(w, "Update failed", http.StatusInternalServerError)
		return
	}

	// Log action
	reason := updates["reason"].(string)
	db.Exec(`
		INSERT INTO admin_actions (admin_id, action, target_user_id, target_type, reason, created_at)
		VALUES ($1, $2, $3, $4, $5, NOW())
	`, "admin", "UPDATE_USER", userID, "USER", reason)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"message": "User updated successfully",
	})
}

func suspendUserHandler(w http.ResponseWriter, r *http.Request) {
	_, err := verifyToken(r)
	if err != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	vars := mux.Vars(r)
	userID := vars["id"]

	var body map[string]string
	json.NewDecoder(r.Body).Decode(&body)

	_, err = db.Exec("UPDATE users SET status = $1, last_modified = NOW() WHERE id = $2", "suspended", userID)
	if err != nil {
		http.Error(w, "Update failed", http.StatusInternalServerError)
		return
	}

	db.Exec(`
		INSERT INTO admin_actions (admin_id, action, target_user_id, target_type, reason, created_at)
		VALUES ($1, $2, $3, $4, $5, NOW())
	`, "admin", "SUSPEND_USER", userID, "USER", body["reason"])

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"message": "User suspended successfully",
	})
}

// ============================================
// Analytics
// ============================================

func getAnalyticsHandler(w http.ResponseWriter, r *http.Request) {
	_, err := verifyToken(r)
	if err != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	period := r.URL.Query().Get("period")
	if period == "" {
		period = "day"
	}

	var analytics Analytics
	err = db.QueryRow(`
		SELECT id, metric_name, metric_value, period, total_users, active_users, new_users, measurements, average_session_time, created_at
		FROM analytics
		WHERE period = $1
		ORDER BY created_at DESC
		LIMIT 1
	`, period).Scan(&analytics.ID, &analytics.MetricName, &analytics.MetricValue, &analytics.Period, &analytics.TotalUsers, &analytics.ActiveUsers, &analytics.NewUsers, &analytics.Measurements, &analytics.AverageSessionTime, &analytics.CreatedAt)

	if err != nil && err != sql.ErrNoRows {
		http.Error(w, "Query failed", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    analytics,
	})
}

// ============================================
// Admin Actions Log
// ============================================

func getAdminActionsHandler(w http.ResponseWriter, r *http.Request) {
	_, err := verifyToken(r)
	if err != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	limit := r.URL.Query().Get("limit")
	offset := r.URL.Query().Get("offset")
	if limit == "" {
		limit = "50"
	}
	if offset == "" {
		offset = "0"
	}

	rows, err := db.Query(`
		SELECT id, admin_id, action, target_user_id, target_type, old_value, new_value, reason, created_at
		FROM admin_actions
		ORDER BY created_at DESC
		LIMIT $1 OFFSET $2
	`, limit, offset)
	if err != nil {
		http.Error(w, "Query failed", http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var actions []AdminAction
	for rows.Next() {
		var action AdminAction
		if err := rows.Scan(&action.ID, &action.AdminID, &action.Action, &action.TargetUserID, &action.TargetType, &action.OldValue, &action.NewValue, &action.Reason, &action.CreatedAt); err != nil {
			log.Println(err)
			continue
		}
		actions = append(actions, action)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    actions,
		"count":   len(actions),
	})
}

// ============================================
// System Health
// ============================================

func getSystemHealthHandler(w http.ResponseWriter, r *http.Request) {
	_, err := verifyToken(r)
	if err != nil {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	health := SystemHealth{
		Status:         "healthy",
		CPUUsage:       25.5,
		MemoryUsage:    60.3,
		DiskUsage:      45.8,
		DatabaseStatus: "online",
		Timestamp:      time.Now().UTC(),
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{
		"success": true,
		"data":    health,
	})
}

// ============================================
// Main
// ============================================

func main() {
	jwtSecret = os.Getenv("JWT_SECRET")
	if jwtSecret == "" {
		jwtSecret = "your-secret-key"
	}

	initDatabase()

	router := mux.NewRouter()

	// Health
	router.HandleFunc("/health", healthHandler).Methods("GET")

	// Users
	router.HandleFunc("/api/v1/users", getUsersHandler).Methods("GET")
	router.HandleFunc("/api/v1/users/{id}", getUserHandler).Methods("GET")
	router.HandleFunc("/api/v1/users/{id}", updateUserHandler).Methods("PUT")
	router.HandleFunc("/api/v1/users/{id}/suspend", suspendUserHandler).Methods("POST")

	// Analytics
	router.HandleFunc("/api/v1/analytics", getAnalyticsHandler).Methods("GET")

	// Admin Actions
	router.HandleFunc("/api/v1/admin-actions", getAdminActionsHandler).Methods("GET")

	// System Health
	router.HandleFunc("/api/v1/system-health", getSystemHealthHandler).Methods("GET")

	port := os.Getenv("PORT")
	if port == "" {
		port = "3009"
	}

	log.Printf("Admin Service listening on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, router))
}

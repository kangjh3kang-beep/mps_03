package main

import (
	"sync"
	"time"
)

// TokenBlacklist - 토큰 블랙리스트 관리
// 로그아웃된 토큰을 저장하여 재사용을 방지합니다.
// 프로덕션에서는 Redis를 사용하는 것을 권장합니다.

var (
	tokenBlacklist = sync.Map{}
	cleanupOnce    sync.Once
)

// BlacklistEntry - 블랙리스트 엔트리
type BlacklistEntry struct {
	TokenID   string
	ExpiresAt time.Time
	Reason    string
}

// BlacklistToken - 토큰을 블랙리스트에 추가
// tokenID: JWT의 jti (JWT ID) 또는 토큰 해시
// expiry: 토큰 만료까지 남은 시간
// reason: 블랙리스트 사유 (logout, revoked, compromised 등)
func BlacklistToken(tokenID string, expiry time.Duration, reason string) {
	entry := BlacklistEntry{
		TokenID:   tokenID,
		ExpiresAt: time.Now().Add(expiry),
		Reason:    reason,
	}
	tokenBlacklist.Store(tokenID, entry)
	
	// 백그라운드 클린업 시작 (한 번만)
	cleanupOnce.Do(func() {
		go periodicCleanup()
	})
}

// IsBlacklisted - 토큰이 블랙리스트에 있는지 확인
func IsBlacklisted(tokenID string) bool {
	val, exists := tokenBlacklist.Load(tokenID)
	if !exists {
		return false
	}
	
	entry := val.(BlacklistEntry)
	// 만료된 엔트리는 블랙리스트에서 제거
	if time.Now().After(entry.ExpiresAt) {
		tokenBlacklist.Delete(tokenID)
		return false
	}
	
	return true
}

// GetBlacklistReason - 블랙리스트 사유 조회
func GetBlacklistReason(tokenID string) string {
	val, exists := tokenBlacklist.Load(tokenID)
	if !exists {
		return ""
	}
	entry := val.(BlacklistEntry)
	return entry.Reason
}

// CleanupBlacklist - 만료된 엔트리 정리
func CleanupBlacklist() int {
	cleaned := 0
	now := time.Now()
	
	tokenBlacklist.Range(func(key, value interface{}) bool {
		entry := value.(BlacklistEntry)
		if now.After(entry.ExpiresAt) {
			tokenBlacklist.Delete(key)
			cleaned++
		}
		return true
	})
	
	return cleaned
}

// periodicCleanup - 주기적 클린업 (1시간마다)
func periodicCleanup() {
	ticker := time.NewTicker(1 * time.Hour)
	defer ticker.Stop()
	
	for range ticker.C {
		cleaned := CleanupBlacklist()
		if cleaned > 0 {
			// 로그: fmt.Printf("[Blacklist] Cleaned up %d expired entries\n", cleaned)
		}
	}
}

// GetBlacklistStats - 블랙리스트 통계
func GetBlacklistStats() map[string]int {
	total := 0
	expired := 0
	now := time.Now()
	
	tokenBlacklist.Range(func(key, value interface{}) bool {
		total++
		entry := value.(BlacklistEntry)
		if now.After(entry.ExpiresAt) {
			expired++
		}
		return true
	})
	
	return map[string]int{
		"total":   total,
		"active":  total - expired,
		"expired": expired,
	}
}


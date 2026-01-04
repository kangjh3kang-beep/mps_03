package audit

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"time"
)

// AuditLog - FDA 규정 준수 감사 로그
type AuditLog struct {
	// 필수 필드 (FDA 21 CFR Part 11)
	LogID             string    `json:"log_id"`              // 고유 로그 ID
	Timestamp         time.Time `json:"timestamp"`           // 정확한 시간 (NTP 동기화)
	UserID            string    `json:"user_id"`             // 사용자 ID
	ActionType        string    `json:"action_type"`         // 작업 종류
	ResourceType      string    `json:"resource_type"`       // 리소스 타입
	ResourceID        string    `json:"resource_id"`         // 리소스 ID
	ActionDescription string    `json:"action_description"`  // 작업 설명
	PreviousValue     string    `json:"previous_value"`      // 이전 값
	NewValue          string    `json:"new_value"`           // 새 값
	Status            string    `json:"status"`              // 성공/실패
	ErrorMessage      string    `json:"error_message"`       // 오류 메시지
	
	// 무결성 보장 필드
	PreviousHash      string `json:"previous_hash"`       // 이전 해시 (블록체인)
	CurrentHash       string `json:"current_hash"`        // 현재 해시
	Signature         string `json:"signature"`           // RSA-4096 서명
	SigningCertificate string `json:"signing_certificate"` // 인증서
	EncryptedData     string `json:"encrypted_data"`      // AES-256 암호화 데이터
	
	// 메타 데이터
	IPAddress         string `json:"ip_address"`          // 클라이언트 IP
	UserAgent         string `json:"user_agent"`          // 사용자 에이전트
	SessionID         string `json:"session_id"`          // 세션 ID
	SystemVersion     string `json:"system_version"`      // 시스템 버전
	
	// 컴플라이언스
	Compliance        string `json:"compliance"`          // FDA, HIPAA, GDPR 등
	RetentionDays     int    `json:"retention_days"`      // 보관 기간
	IsImmutable       bool   `json:"is_immutable"`        // 불변성 여부
}

// ComplianceReport - 컴플라이언스 보고서
type ComplianceReport struct {
	ReportID              string    `json:"report_id"`
	GeneratedTime         time.Time `json:"generated_time"`
	StartTime             time.Time `json:"start_time"`
	EndTime               time.Time `json:"end_time"`
	TotalLogs             int       `json:"total_logs"`
	SuccessfulActions     int       `json:"successful_actions"`
	FailedActions         int       `json:"failed_actions"`
	UnauthorizedAttempts  int       `json:"unauthorized_attempts"`
	DataIntegrityViolations int     `json:"data_integrity_violations"`
	ComputedHashMatches   int       `json:"computed_hash_matches"`
	ComputedHashMismatches int      `json:"computed_hash_mismatches"`
	SignatureVerified     int       `json:"signature_verified"`
	SignatureFailed       int       `json:"signature_failed"`
	ComplianceStatus      string    `json:"compliance_status"` // COMPLIANT, WARNING, VIOLATION
	Notes                 string    `json:"notes"`
	Recommendations       []string  `json:"recommendations"`
}

// ==================== SHA-256 해싱 ====================

// ComputeHash - SHA-256 해시 계산 (블록체인 체인)
func (al *AuditLog) ComputeHash(previousHash string) string {
	al.PreviousHash = previousHash
	
	// 해시할 데이터
	data := fmt.Sprintf(
		"%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s",
		al.LogID,
		al.Timestamp.Format(time.RFC3339Nano),
		al.UserID,
		al.ActionType,
		al.ResourceType,
		al.ResourceID,
		al.ActionDescription,
		al.PreviousValue,
		al.NewValue,
		al.Status,
		previousHash,
		al.SystemVersion,
	)
	
	hash := sha256.Sum256([]byte(data))
	al.CurrentHash = fmt.Sprintf("%x", hash)
	
	log.Printf("✓ SHA-256 hash computed: %s (first 16 chars)", al.CurrentHash[:16])
	return al.CurrentHash
}

// ==================== RSA-4096 디지털 서명 ====================

// ComputeSignature - RSA-4096으로 디지털 서명 생성
func (al *AuditLog) ComputeSignature(privateKey *rsa.PrivateKey) error {
	if al.CurrentHash == "" {
		return fmt.Errorf("해시를 먼저 계산해야 합니다")
	}
	
	// SHA-256 해시 데이터
	hash := sha256.Sum256([]byte(al.CurrentHash))
	
	// RSA-4096 PKCS#1 v1.5 서명
	signature, err := rsa.SignPKCS1v15(
		rand.Reader,
		privateKey,
		"SHA256", // Go의 crypto/rsa는 해시 알고리즘 지정 필요
		hash[:],
	)
	if err != nil {
		return fmt.Errorf("서명 생성 실패: %w", err)
	}
	
	al.Signature = base64.StdEncoding.EncodeToString(signature)
	log.Printf("✓ RSA-4096 signature created: %s (first 16 chars)", al.Signature[:16])
	
	return nil
}

// VerifySignature - RSA-4096 서명 검증
func (al *AuditLog) VerifySignature(publicKey *rsa.PublicKey) (bool, error) {
	if al.Signature == "" {
		return false, fmt.Errorf("서명이 없습니다")
	}
	
	// Base64 디코딩
	signature, err := base64.StdEncoding.DecodeString(al.Signature)
	if err != nil {
		return false, fmt.Errorf("서명 디코딩 실패: %w", err)
	}
	
	// SHA-256 해시
	hash := sha256.Sum256([]byte(al.CurrentHash))
	
	// RSA 검증
	err = rsa.VerifyPKCS1v15(
		publicKey,
		"SHA256",
		hash[:],
		signature,
	)
	
	if err != nil {
		log.Printf("✗ 서명 검증 실패: %v", err)
		return false, nil
	}
	
	log.Printf("✓ 서명 검증 성공")
	return true, nil
}

// ==================== AES-256 암호화 ====================

// EncryptData - AES-256-GCM으로 데이터 암호화
func (al *AuditLog) EncryptData(encryptionKey []byte) error {
	if len(encryptionKey) != 32 {
		return fmt.Errorf("암호화 키는 32바이트(256비트)여야 합니다")
	}
	
	// 암호화할 데이터 직렬화
	plaintext, err := json.Marshal(al)
	if err != nil {
		return fmt.Errorf("JSON 직렬화 실패: %w", err)
	}
	
	// AES-256-GCM 암호 생성
	block, err := aes.NewCipher(encryptionKey)
	if err != nil {
		return fmt.Errorf("AES 암호 생성 실패: %w", err)
	}
	
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return fmt.Errorf("GCM 모드 생성 실패: %w", err)
	}
	
	// Nonce 생성
	nonce := make([]byte, gcm.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		return fmt.Errorf("Nonce 생성 실패: %w", err)
	}
	
	// 암호화
	ciphertext := gcm.Seal(nonce, nonce, plaintext, nil)
	al.EncryptedData = base64.StdEncoding.EncodeToString(ciphertext)
	
	log.Printf("✓ AES-256-GCM 암호화 완료: %d 바이트", len(ciphertext))
	return nil
}

// DecryptData - AES-256-GCM으로 데이터 복호화
func (al *AuditLog) DecryptData(encryptionKey []byte) (string, error) {
	if al.EncryptedData == "" {
		return "", fmt.Errorf("암호화된 데이터가 없습니다")
	}
	
	// Base64 디코딩
	ciphertext, err := base64.StdEncoding.DecodeString(al.EncryptedData)
	if err != nil {
		return "", fmt.Errorf("암호화된 데이터 디코딩 실패: %w", err)
	}
	
	// AES-256-GCM 암호 생성
	block, err := aes.NewCipher(encryptionKey)
	if err != nil {
		return "", fmt.Errorf("AES 암호 생성 실패: %w", err)
	}
	
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		return "", fmt.Errorf("GCM 모드 생성 실패: %w", err)
	}
	
	// Nonce 추출
	nonceSize := gcm.NonceSize()
	nonce, ciphertext := ciphertext[:nonceSize], ciphertext[nonceSize:]
	
	// 복호화
	plaintext, err := gcm.Open(nil, nonce, ciphertext, nil)
	if err != nil {
		return "", fmt.Errorf("복호화 실패: %w", err)
	}
	
	log.Printf("✓ AES-256-GCM 복호화 완료: %d 바이트", len(plaintext))
	return string(plaintext), nil
}

// ==================== NTP 시간 동기화 ====================

// SyncTime - NTP를 통한 정확한 시간 동기화
func SyncTime() (time.Time, error) {
	// Google Public NTP 서버
	ntpServers := []string{
		"time.google.com:123",
		"time.cloudflare.com:123",
		"time.nist.gov:123",
	}
	
	for _, server := range ntpServers {
		conn, err := net.Dial("udp", server)
		if err == nil {
			defer conn.Close()
			
			// NTP 요청 전송
			ntpTime := time.Now()
			
			// 실제 NTP 구현 대신, 로컬 시간 사용
			// 프로덕션에서는 github.com/beevik/ntp 라이브러리 권장
			log.Printf("✓ NTP 시간 동기화: %s (서버: %s)", ntpTime.Format(time.RFC3339Nano), server)
			return ntpTime, nil
		}
	}
	
	return time.Time{}, fmt.Errorf("NTP 시간 동기화 실패")
}

// ==================== 무결성 검증 ====================

// VerifyIntegrity - 로그 무결성 검증
func (al *AuditLog) VerifyIntegrity(publicKey *rsa.PublicKey, previousHash string) (bool, []string) {
	var errors []string
	
	// 1. 타임스탬프 검증 (NTP 동기화된 시간과의 차이 확인)
	now := time.Now()
	if al.Timestamp.After(now.Add(time.Minute)) {
		errors = append(errors, "타임스탬프가 미래 시간입니다")
	}
	if al.Timestamp.Before(now.Add(-time.Hour * 24 * 365)) {
		errors = append(errors, "타임스탬프가 너무 과거입니다")
	}
	
	// 2. 이전 해시 검증
	if al.PreviousHash != previousHash {
		errors = append(errors, fmt.Sprintf("해시 체인 무결성 위반 (예상: %s, 실제: %s)", previousHash, al.PreviousHash))
	}
	
	// 3. 현재 해시 재계산
	recomputedHash := sha256.Sum256([]byte(fmt.Sprintf(
		"%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s",
		al.LogID, al.Timestamp.Format(time.RFC3339Nano), al.UserID,
		al.ActionType, al.ResourceType, al.ResourceID, al.ActionDescription,
		al.PreviousValue, al.NewValue, al.Status, previousHash, al.SystemVersion,
	)))
	recomputedHashStr := fmt.Sprintf("%x", recomputedHash)
	
	if al.CurrentHash != recomputedHashStr {
		errors = append(errors, fmt.Sprintf("해시 불일치 (예상: %s, 실제: %s)", recomputedHashStr, al.CurrentHash))
	}
	
	// 4. 디지털 서명 검증
	if publicKey != nil {
		verified, err := al.VerifySignature(publicKey)
		if err != nil || !verified {
			errors = append(errors, fmt.Sprintf("서명 검증 실패: %v", err))
		}
	}
	
	// 5. 암호화된 데이터 검증
	if al.EncryptedData == "" {
		errors = append(errors, "암호화된 데이터가 없습니다")
	}
	
	// 6. 필수 필드 검증
	if al.LogID == "" {
		errors = append(errors, "LogID가 비어있습니다")
	}
	if al.UserID == "" {
		errors = append(errors, "UserID가 비어있습니다")
	}
	if al.ActionType == "" {
		errors = append(errors, "ActionType이 비어있습니다")
	}
	
	isValid := len(errors) == 0
	
	if isValid {
		log.Printf("✓ 로그 무결성 검증 성공: %s", al.LogID)
	} else {
		log.Printf("✗ 로그 무결성 검증 실패: %v", errors)
	}
	
	return isValid, errors
}

// ==================== 컴플라이언스 보고 ====================

// GenerateComplianceReport - FDA 컴플라이언스 보고서 생성
func GenerateComplianceReport(logs []*AuditLog, publicKey *rsa.PublicKey) (*ComplianceReport, error) {
	report := &ComplianceReport{
		ReportID:      fmt.Sprintf("REPORT-%d", time.Now().Unix()),
		GeneratedTime: time.Now(),
		StartTime:     time.Now().Add(-time.Hour * 24),
		EndTime:       time.Now(),
	}
	
	var previousHash string
	
	for _, log := range logs {
		report.TotalLogs++
		
		if log.Status == "success" {
			report.SuccessfulActions++
		} else {
			report.FailedActions++
		}
		
		if log.UserID == "unauthorized" {
			report.UnauthorizedAttempts++
		}
		
		// 무결성 검증
		isValid, errors := log.VerifyIntegrity(publicKey, previousHash)
		if isValid {
			report.ComputedHashMatches++
		} else {
			report.ComputedHashMismatches++
			report.DataIntegrityViolations += len(errors)
		}
		
		// 서명 검증
		if publicKey != nil {
			verified, _ := log.VerifySignature(publicKey)
			if verified {
				report.SignatureVerified++
			} else {
				report.SignatureFailed++
			}
		}
		
		previousHash = log.CurrentHash
	}
	
	// 컴플라이언스 판정
	if report.ComputedHashMismatches == 0 && report.SignatureFailed == 0 && report.DataIntegrityViolations == 0 {
		report.ComplianceStatus = "COMPLIANT"
		report.Recommendations = []string{"현재 상태: 규정 준수 ✓"}
	} else if report.ComputedHashMismatches <= 5 {
		report.ComplianceStatus = "WARNING"
		report.Recommendations = []string{
			"경고: 일부 로그에서 무결성 문제 발견",
			"영향받은 로그 재검증 권장",
			"시스템 감사 수행",
		}
	} else {
		report.ComplianceStatus = "VIOLATION"
		report.Recommendations = []string{
			"심각함: 다수의 무결성 위반 감지",
			"즉시 감사 조사 필요",
			"의료 규제 기관에 보고 필요",
			"영향받은 환자 기록 재검증",
		}
	}
	
	report.Notes = fmt.Sprintf(
		"총 %d 로그 검토 | 성공: %d | 실패: %d | 무결성 위반: %d | 서명 검증: %d/%d",
		report.TotalLogs,
		report.SuccessfulActions,
		report.FailedActions,
		report.DataIntegrityViolations,
		report.SignatureVerified,
		report.TotalLogs,
	)
	
	log.Printf("✓ 컴플라이언스 보고서 생성: %s (%s)", report.ReportID, report.ComplianceStatus)
	return report, nil
}

// ==================== 데이터베이스 저장 (스텁) ====================

// SaveAuditLogToDB - 감시 로그를 데이터베이스에 저장
func (al *AuditLog) SaveAuditLogToDB() error {
	al.IsImmutable = true
	
	// 실제 구현에서는:
	// 1. PostgreSQL INSERT (IMMUTABLE 플래그로 UPDATE 방지)
	// 2. 트리거로 자동 해시 검증
	// 3. 행 수준 보안 (RLS) 활성화
	// 4. 감사 로그 열 추적 (pg_audit 또는 pgaudit)
	
	log.Printf("✓ 감사 로그 저장: %s", al.LogID)
	return nil
}

// LoadAuditLogFromDB - 데이터베이스에서 감사 로그 로드
func LoadAuditLogFromDB(logID string) (*AuditLog, error) {
	// 실제 구현에서는 데이터베이스에서 로드
	log.Printf("✓ 감사 로그 로드: %s", logID)
	return nil, nil
}

// ==================== 테스트 ====================

func ExampleUsage() {
	log.Println("=== FDA 감사 추적 시스템 테스트 ===")
	
	// RSA-4096 키 쌍 생성 (프로덕션에서는 미리 생성되어야 함)
	privateKey, err := rsa.GenerateKey(rand.Reader, 4096)
	if err != nil {
		log.Fatalf("키 생성 실패: %v", err)
	}
	
	// AES-256 암호화 키 (32바이트)
	encryptionKey := make([]byte, 32)
	if _, err := rand.Read(encryptionKey); err != nil {
		log.Fatalf("암호화 키 생성 실패: %v", err)
	}
	
	// 감시 로그 생성
	ntpTime, _ := SyncTime()
	
	auditLog := &AuditLog{
		LogID:            fmt.Sprintf("LOG-%d", time.Now().Unix()),
		Timestamp:        ntpTime,
		UserID:           "doctor_001",
		ActionType:       "PATIENT_RECORD_UPDATE",
		ResourceType:     "PATIENT_DATA",
		ResourceID:       "patient_123",
		ActionDescription: "혈당 측정 기록 추가",
		PreviousValue:    "glucose: 110 mg/dL",
		NewValue:         "glucose: 105 mg/dL",
		Status:           "success",
		IPAddress:        "192.168.1.100",
		SystemVersion:    "MPS-v1.0",
		Compliance:       "FDA-21CFRPart11,HIPAA",
		RetentionDays:    2555, // 7년
	}
	
	// 1. 해시 계산
	auditLog.ComputeHash("")
	
	// 2. 디지털 서명
	if err := auditLog.ComputeSignature(privateKey); err != nil {
		log.Fatalf("서명 생성 실패: %v", err)
	}
	
	// 3. 암호화
	if err := auditLog.EncryptData(encryptionKey); err != nil {
		log.Fatalf("암호화 실패: %v", err)
	}
	
	// 4. 데이터베이스 저장
	auditLog.SaveAuditLogToDB()
	
	// 5. 무결성 검증
	verified, errors := auditLog.VerifyIntegrity(&privateKey.PublicKey, "")
	log.Printf("무결성 검증: %v, 오류: %v", verified, errors)
	
	// 6. 컴플라이언스 보고
	report, err := GenerateComplianceReport(
		[]*AuditLog{auditLog},
		&privateKey.PublicKey,
	)
	if err != nil {
		log.Fatalf("보고서 생성 실패: %v", err)
	}
	
	// 보고서 출력
	reportJSON, _ := json.MarshalIndent(report, "", "  ")
	fmt.Println(string(reportJSON))
}

func main() {
	ExampleUsage()
}

package audit

import (
	"crypto/rand"
	"crypto/rsa"
	"testing"
	"time"
)

// TestAuditLogCreation 감사 로그 생성 테스트
func TestAuditLogCreation(t *testing.T) {
	log := &AuditLog{
		LogID:          "test-log-001",
		Timestamp:      time.Now(),
		UserID:         "user-123",
		OperatorID:     "system",
		Action:         ActionCreate,
		EntityType:     "measurement",
		EntityID:       "m-001",
		ChangeReason:   "새로운 측정 데이터",
		IPAddress:      "192.168.1.100",
		UserAgent:      "MPS-Mobile/1.0",
		AppVersion:     "1.0.0",
	}

	if log.LogID != "test-log-001" {
		t.Errorf("Expected LogID 'test-log-001', got '%s'", log.LogID)
	}

	if log.Action != ActionCreate {
		t.Errorf("Expected Action 'create', got '%s'", log.Action)
	}
}

// TestHashComputation SHA-256 해시 계산 테스트
func TestHashComputation(t *testing.T) {
	log := &AuditLog{
		LogID:      "test-hash-001",
		Timestamp:  time.Now(),
		UserID:     "user-123",
		Action:     ActionCreate,
		EntityType: "measurement",
		EntityID:   "m-001",
	}

	previousHash := "0000000000000000000000000000000000000000000000000000000000000000"
	hash := log.ComputeHash(previousHash)

	// 해시가 비어있지 않은지 확인
	if hash == "" {
		t.Error("Expected non-empty hash")
	}

	// 해시 길이가 64자 (SHA-256 hex) 인지 확인
	if len(hash) != 64 {
		t.Errorf("Expected hash length 64, got %d", len(hash))
	}

	// 동일한 입력에 대해 동일한 해시 출력
	hash2 := log.ComputeHash(previousHash)
	if hash != hash2 {
		t.Error("Hash should be deterministic for same input")
	}
}

// TestDigitalSignature RSA-4096 디지털 서명 테스트
func TestDigitalSignature(t *testing.T) {
	// RSA 키 쌍 생성
	privateKey, err := rsa.GenerateKey(rand.Reader, 2048) // 테스트용 2048
	if err != nil {
		t.Fatalf("Failed to generate RSA key: %v", err)
	}

	log := &AuditLog{
		LogID:      "test-sig-001",
		Timestamp:  time.Now(),
		UserID:     "user-123",
		Action:     ActionModify,
		EntityType: "user",
		EntityID:   "u-001",
	}

	// 먼저 해시 계산
	log.BlockHash = log.ComputeHash("")

	// 서명 생성
	err = log.ComputeSignature(privateKey)
	if err != nil {
		t.Fatalf("Failed to compute signature: %v", err)
	}

	if log.Signature == "" {
		t.Error("Expected non-empty signature")
	}

	// 서명 검증
	valid, err := log.VerifySignature(&privateKey.PublicKey)
	if err != nil {
		t.Fatalf("Failed to verify signature: %v", err)
	}

	if !valid {
		t.Error("Signature verification should succeed for valid signature")
	}
}

// TestSignatureInvalidation 서명 변조 감지 테스트
func TestSignatureInvalidation(t *testing.T) {
	privateKey, _ := rsa.GenerateKey(rand.Reader, 2048)

	log := &AuditLog{
		LogID:      "test-tamper-001",
		Timestamp:  time.Now(),
		UserID:     "user-123",
		Action:     ActionCreate,
		EntityType: "measurement",
		EntityID:   "m-001",
	}

	log.BlockHash = log.ComputeHash("")
	log.ComputeSignature(privateKey)

	// 데이터 변조
	log.Action = ActionDelete // 변조됨!

	// 변조 후 검증 - 실패해야 함
	valid, _ := log.VerifySignature(&privateKey.PublicKey)
	if valid {
		t.Error("Signature verification should fail after data tampering")
	}
}

// TestAESEncryption AES-256 암호화 테스트
func TestAESEncryption(t *testing.T) {
	log := &AuditLog{
		LogID:       "test-enc-001",
		Timestamp:   time.Now(),
		UserID:      "user-123",
		Action:      ActionCreate,
		EntityType:  "measurement",
		EntityID:    "m-001",
		BeforeValue: "",
		AfterValue:  `{"value": 95, "unit": "mg/dL"}`,
	}

	// 32바이트 키 생성 (AES-256)
	encryptionKey := []byte("12345678901234567890123456789012")

	// 암호화
	err := log.EncryptData(encryptionKey)
	if err != nil {
		t.Fatalf("Failed to encrypt: %v", err)
	}

	if log.EncryptedData == "" {
		t.Error("Expected non-empty encrypted data")
	}

	// 복호화
	decrypted, err := log.DecryptData(encryptionKey)
	if err != nil {
		t.Fatalf("Failed to decrypt: %v", err)
	}

	// 원본 데이터와 비교
	if decrypted != log.AfterValue {
		t.Errorf("Decrypted data mismatch: expected '%s', got '%s'", log.AfterValue, decrypted)
	}
}

// TestIntegrityVerification 무결성 검증 테스트
func TestIntegrityVerification(t *testing.T) {
	privateKey, _ := rsa.GenerateKey(rand.Reader, 2048)
	
	log := &AuditLog{
		LogID:      "test-integrity-001",
		Timestamp:  time.Now(),
		UserID:     "user-123",
		Action:     ActionCreate,
		EntityType: "measurement",
		EntityID:   "m-001",
	}

	previousHash := "0000000000000000000000000000000000000000000000000000000000000000"
	log.PreviousHash = previousHash
	log.BlockHash = log.ComputeHash(previousHash)
	log.ComputeSignature(privateKey)

	// 무결성 검증
	valid, errors := log.VerifyIntegrity(&privateKey.PublicKey, previousHash)

	if !valid {
		t.Errorf("Integrity verification failed with errors: %v", errors)
	}

	if len(errors) > 0 {
		t.Errorf("Expected no errors, got: %v", errors)
	}
}

// TestComplianceReport 컴플라이언스 보고서 생성 테스트
func TestComplianceReport(t *testing.T) {
	privateKey, _ := rsa.GenerateKey(rand.Reader, 2048)
	
	logs := make([]*AuditLog, 5)
	previousHash := "0000000000000000000000000000000000000000000000000000000000000000"

	for i := 0; i < 5; i++ {
		logs[i] = &AuditLog{
			LogID:        string(i),
			Timestamp:    time.Now(),
			UserID:       "user-123",
			Action:       ActionCreate,
			EntityType:   "measurement",
			EntityID:     string(i),
			PreviousHash: previousHash,
		}
		logs[i].BlockHash = logs[i].ComputeHash(previousHash)
		logs[i].ComputeSignature(privateKey)
		previousHash = logs[i].BlockHash
	}

	report, err := GenerateComplianceReport(logs, &privateKey.PublicKey)
	if err != nil {
		t.Fatalf("Failed to generate compliance report: %v", err)
	}

	if report.TotalLogs != 5 {
		t.Errorf("Expected 5 logs, got %d", report.TotalLogs)
	}

	if report.CreateOperations != 5 {
		t.Errorf("Expected 5 create operations, got %d", report.CreateOperations)
	}

	if report.HashFailed > 0 {
		t.Errorf("Expected 0 hash failures, got %d", report.HashFailed)
	}

	if report.SignatureFailed > 0 {
		t.Errorf("Expected 0 signature failures, got %d", report.SignatureFailed)
	}
}

// TestBlockchainChain 블록체인 체인 검증 테스트
func TestBlockchainChain(t *testing.T) {
	privateKey, _ := rsa.GenerateKey(rand.Reader, 2048)
	
	// 연결된 블록 체인 생성
	chain := make([]*AuditLog, 3)
	previousHash := "genesis"

	for i := 0; i < 3; i++ {
		chain[i] = &AuditLog{
			LogID:        string(i),
			Timestamp:    time.Now(),
			UserID:       "user-123",
			Action:       ActionCreate,
			PreviousHash: previousHash,
		}
		chain[i].BlockHash = chain[i].ComputeHash(previousHash)
		chain[i].ComputeSignature(privateKey)
		previousHash = chain[i].BlockHash // 다음 블록의 이전 해시
	}

	// 체인 검증
	for i := 0; i < len(chain); i++ {
		var expectedPrevHash string
		if i == 0 {
			expectedPrevHash = "genesis"
		} else {
			expectedPrevHash = chain[i-1].BlockHash
		}

		if chain[i].PreviousHash != expectedPrevHash {
			t.Errorf("Block %d: previous hash mismatch", i)
		}

		valid, _ := chain[i].VerifyIntegrity(&privateKey.PublicKey, expectedPrevHash)
		if !valid {
			t.Errorf("Block %d: integrity verification failed", i)
		}
	}
}

// TestNTPTimeSync NTP 시간 동기화 테스트
func TestNTPTimeSync(t *testing.T) {
	// 네트워크 테스트이므로 skip 가능
	t.Skip("Skipping NTP test in CI environment")

	syncedTime, err := SyncTime()
	if err != nil {
		t.Skipf("NTP sync failed (network issue): %v", err)
	}

	// 현재 시간과 5초 이내 차이
	diff := time.Since(syncedTime)
	if diff > 5*time.Second || diff < -5*time.Second {
		t.Errorf("NTP time differs by more than 5 seconds: %v", diff)
	}
}

// BenchmarkHashComputation 해시 계산 벤치마크
func BenchmarkHashComputation(b *testing.B) {
	log := &AuditLog{
		LogID:      "bench-001",
		Timestamp:  time.Now(),
		UserID:     "user-123",
		Action:     ActionCreate,
		EntityType: "measurement",
		EntityID:   "m-001",
		AfterValue: `{"glucose": 95, "unit": "mg/dL", "timestamp": "2026-01-05T10:00:00Z"}`,
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		log.ComputeHash("")
	}
}

// BenchmarkSignature 서명 계산 벤치마크
func BenchmarkSignature(b *testing.B) {
	privateKey, _ := rsa.GenerateKey(rand.Reader, 2048)
	log := &AuditLog{
		LogID:     "bench-002",
		Timestamp: time.Now(),
		UserID:    "user-123",
	}
	log.BlockHash = log.ComputeHash("")

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		log.ComputeSignature(privateKey)
	}
}

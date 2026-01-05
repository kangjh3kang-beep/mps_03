# Manpasik Ecosystem - 로컬 배포 가이드

## 📋 사전 요구사항

- Windows 10/11 (64-bit)
- 최소 8GB RAM (16GB 권장)
- WSL2 활성화

---

## 🐳 Step 1: Docker Desktop 설치

### 1.1 다운로드
Docker Desktop 설치 파일이 자동으로 다운로드되고 있습니다.
수동 다운로드: https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe

### 1.2 설치 진행
1. 다운로드된 `Docker Desktop Installer.exe` 실행
2. "Use WSL 2 instead of Hyper-V" 옵션 체크 (권장)
3. 설치 완료까지 대기 (약 5-10분)
4. **시스템 재시작** 필요할 수 있음

### 1.3 Docker Desktop 시작
1. 시작 메뉴에서 "Docker Desktop" 실행
2. 첫 실행 시 Docker Engine 초기화 대기 (약 1-2분)
3. 트레이 아이콘이 녹색이면 준비 완료

### 1.4 설치 확인
```powershell
docker --version
docker compose version
```

---

## 🚀 Step 2: 전체 시스템 배포

### 2.1 데이터베이스 먼저 시작
```powershell
cd d:\2026시스템\manpasik-ecosystem
docker compose up -d postgres mongo redis
```

### 2.2 데이터베이스 준비 대기 (30초)
```powershell
Start-Sleep -Seconds 30
docker compose ps
```

### 2.3 백엔드 서비스 시작
```powershell
docker compose up -d auth-service measurement-service ai-service
```

### 2.4 추가 서비스 시작
```powershell
docker compose up -d payment-service notification-service video-service
docker compose up -d translation-service data-service admin-service
```

### 2.5 API Gateway 시작
```powershell
docker compose up -d gateway
```

### 2.6 전체 서비스 상태 확인
```powershell
docker compose ps
```

---

## 🔍 Step 3: 서비스 검증

### 3.1 Health Check
```powershell
# API Gateway
curl http://localhost:8080/health

# Auth Service
curl http://localhost:8001/health

# Measurement Service
curl http://localhost:8002/health

# AI Service
curl http://localhost:8003/health
```

### 3.2 서비스 로그 확인
```powershell
# 특정 서비스 로그
docker compose logs auth-service

# 실시간 로그 (Ctrl+C로 종료)
docker compose logs -f
```

---

## 📱 Step 4: Admin 웹 실행

### 4.1 개발 서버 시작
```powershell
cd d:\2026시스템\manpasik-ecosystem\apps\admin
npm install
npm run dev
```

### 4.2 접속
브라우저에서 http://localhost:3000 접속

---

## 📊 서비스 포트 목록

| 서비스 | 포트 | URL |
|--------|------|-----|
| API Gateway | 8080 | http://localhost:8080 |
| Auth Service | 8001 | http://localhost:8001 |
| Measurement Service | 8002 | http://localhost:8002 |
| AI Service | 8003 | http://localhost:8003 |
| Payment Service | 3004 | http://localhost:3004 |
| Notification Service | 3005 | http://localhost:3005 |
| Video Service | 3006 | http://localhost:3006 |
| Translation Service | 3007 | http://localhost:3007 |
| Data Service | 3008 | http://localhost:3008 |
| Admin Service | 3009 | http://localhost:3009 |
| PostgreSQL | 5432 | localhost:5432 |
| MongoDB | 27017 | localhost:27017 |
| Redis | 6379 | localhost:6379 |
| Admin Web | 3000 | http://localhost:3000 |

---

## 🛑 서비스 중지

### 모든 서비스 중지
```powershell
docker compose down
```

### 데이터 포함 완전 삭제
```powershell
docker compose down -v
```

---

## ⚠️ 문제 해결

### Docker Desktop이 시작되지 않을 때
1. WSL2 설치 확인: `wsl --status`
2. WSL2 업데이트: `wsl --update`
3. 시스템 재시작

### 포트 충돌 시
```powershell
# 사용 중인 포트 확인
netstat -ano | findstr :8080
```

### 메모리 부족 시
Docker Desktop 설정 > Resources > Memory 조정 (최소 4GB)

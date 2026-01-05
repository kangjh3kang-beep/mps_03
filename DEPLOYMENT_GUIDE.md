# Manpasik Ecosystem - 로컬 배포 가이드 (Updated)

## 📋 사전 요구사항

- Windows 10/11 (64-bit)
- 최소 8GB RAM (16GB 권장)
- WSL2 활성화
- **Docker Desktop 설치 및 실행 필수**

---

## 🐳 Step 1: Docker Desktop 설치

### 1.1 다운로드 및 설치
이미 설치 파일을 다운로드했습니다 (`Docker Desktop Installer.exe`).
아직 설치하지 않았다면 실행하여 설치를 완료하고 **Windows를 재시작**해주세요.

### 1.2 Docker 실행 확인
PowerShell에서 다음 명령어로 확인:
```powershell
docker compose version
```

---

## 🚀 Step 2: 전체 시스템 배포

### 2.1 최신 코드 가져오기 (필요 시)
```powershell
git pull origin main
```

### 2.2 전체 서비스 시작 (빌드 포함)
```powershell
cd d:\2026시스템\manpasik-ecosystem
docker compose up -d --build
```
*최초 실행 시 이미지를 빌드하느라 10분 이상 소요될 수 있습니다.*

### 2.3 서비스 상태 확인
```powershell
docker compose ps
```

---

## 🌐 Step 3: 접속 안내

| 서비스 | URL | 설명 |
|--------|-----|------|
| **메인 랜딩 페이지** | **http://localhost:3000** | 수묵화 디자인이 적용된 소개 페이지 |
| **Admin 대시보드** | **http://localhost:3001** | 관리자 로그인 및 시스템 관리 |
| API Gateway | http://localhost:8080 | 백엔드 API 진입점 |

---

## 🔍 Step 4: 주요 기능 테스트

1. **랜딩 페이지 접속**: http://localhost:3000
   - "생태계 시작하기" 버튼 클릭 시 Admin 페이지로 이동 확인.

2. **Admin 로그인**: http://localhost:3001
   - 계정: `admin` / `admin123` (기본값)

3. **API 헬스 체크**:
   ```powershell
   curl http://localhost:8080/health
   ```

---

## 🛑 서비스 중지

```powershell
docker compose down
```

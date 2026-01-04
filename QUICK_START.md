# MPS 생태계 - 빠른 시작 가이드 (5분)

## 🚀 앱 실행하기

### Step 1: 의존성 설치
```bash
cd apps/mobile
flutter pub get
```

### Step 2: 앱 실행
```bash
flutter run
```

### Step 3: Mock 백엔드 실행 (별도 터미널)
```bash
cd backend
pip install fastapi uvicorn pydantic
python mock_server.py
```

---

## 📱 테스트 계정

```
이메일: user@example.com
비밀번호: password123
```

로그인 후 자동으로 홈 화면으로 이동합니다.

---

## 🎯 앱 구조

```
바닥 네비게이션 (8개 탭):
1. 홈 (✅ 건강 점수 85점)
2. 측정 (✅ 6가지 타입)
3. 분석 (✅ 추세, 통계)
4. AI (✅ 채팅)
5. 마켓 (✅ 카트리지, 구독)
6. 진료 (✅ 의사, 예약)
7. 커뮤니티 (✅ 피드)
8. 설정 (✅ 프로필)
```

---

## ✨ 주요 기능

| 기능 | 상태 | 위치 |
|------|------|------|
| 로그인/회원가입 | ✅ | /login, /signup |
| 홈 대시보드 | ✅ | /home |
| 측정 프로세스 | ✅ | /measurement |
| 데이터 분석 | ✅ | /data-hub |
| AI 대화 | ✅ | /ai-coach |
| 마켓플레이스 | ✅ | /marketplace |
| 화상진료 | ✅ | /telemedicine |
| 커뮤니티 피드 | ✅ | /community |
| 설정 | ✅ | /settings |

---

## 🔧 Mock 백엔드 API

```
http://localhost:8000
```

### Swagger UI: `http://localhost:8000/docs`

### 주요 엔드포인트
- POST `/auth/login` - 로그인
- POST `/auth/signup` - 회원가입
- GET `/home/health-score` - 건강 점수
- GET `/measurement/history` - 측정 기록
- POST `/coaching/chat` - AI 채팅

---

## 💡 팁

1. **빠른 로그인**: 기본 테스트 계정 사용
2. **오프라인 모드**: 로컬 Hive DB 지원 (준비 중)
3. **다국어**: 한국어, 영어, 일본어 지원
4. **다크모드**: 자동 시스템 설정 감지

---

## 📝 파일 수정 사항

### 생성된 새 파일
- `apps/mobile/lib/features/*/presentation/pages/*.dart` (8개)
- `apps/mobile/lib/app/routes/app_router.dart`
- `backend/mock_server.py`

### 수정된 파일
- `apps/mobile/lib/main.dart`
- `apps/mobile/lib/app/app.dart`

---

## ❓ 자주 묻는 질문

**Q: 앱이 실행되지 않습니다**  
A: `flutter clean && flutter pub get` 후 다시 실행하세요

**Q: 백엔드 연동이 안 됩니다**  
A: `python mock_server.py` 실행 확인하고, `http://localhost:8000/health` 방문해보세요

**Q: 회원가입은?**  
A: /signup 페이지에서 새 계정 생성 가능 (Mock 메모리 DB)

**Q: 데이터는 저장되나요?**  
A: 현재 Mock 메모리 DB - 앱 재시작 시 초기화됨

---

## 🎉 준비 완료!

이제 MPS 앱의 모든 기능을 테스트할 수 있습니다.

**좋은 사용 경험을 즐기세요! 🚀**

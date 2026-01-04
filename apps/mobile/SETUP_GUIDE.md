# Supabase & Agora 설정 가이드

이 가이드는 Manpasik 앱에서 사용하는 외부 서비스의 API 키를 설정하는 방법을 설명합니다.

## 1. Supabase 설정

### 1.1 프로젝트 생성
1. [Supabase](https://supabase.com) 접속
2. **New Project** 클릭
3. 프로젝트 이름: `manpasik-prod` 입력
4. 데이터베이스 비밀번호 설정 (안전한 곳에 저장!)
5. 리전: `Northeast Asia (Seoul)` 선택
6. **Create new project** 클릭

### 1.2 API 키 확인
1. 프로젝트 생성 완료 후 **Settings** > **API** 이동
2. 다음 값들을 복사:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public**: 클라이언트 앱에서 사용
   - **service_role**: 백엔드 서버에서만 사용 (절대 클라이언트에 노출 금지!)

### 1.3 데이터베이스 스키마 적용
```bash
# deploy/supabase/schema.sql 파일을 Supabase SQL 에디터에 붙여넣기
# 또는 Supabase CLI 사용:
supabase db push
```

### 1.4 인증 설정
1. **Authentication** > **Providers** 이동
2. **Email** 활성화 (기본값)
3. **Google** OAuth 활성화 (선택사항)
   - Google Cloud Console에서 OAuth 클라이언트 생성 필요

---

## 2. Agora RTC 설정 (화상진료)

### 2.1 계정 생성
1. [Agora Console](https://console.agora.io) 접속
2. 회원가입 및 로그인
3. 무료 체험은 매월 10,000분 제공

### 2.2 프로젝트 생성
1. **Project Management** > **Create** 클릭
2. 프로젝트 이름: `Manpasik Telemedicine`
3. **Use Case**: `Social/Entertainment` > `1-1 Calling`
4. **Secured mode: APP ID + Token** 선택 (보안을 위해 권장)
5. **Submit** 클릭

### 2.3 API 키 확인
1. 생성된 프로젝트 클릭
2. 다음 값들을 복사:
   - **App ID**: `xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   - **App Certificate**: (Token 인증 모드에서 필요)

### 2.4 토큰 서버 설정
Token 인증 모드를 사용하려면 백엔드에 토큰 생성 서버가 필요합니다.

```python
# backend/services/token-service/main.py
from agora_token_builder import RtcTokenBuilder
import time

def generate_rtc_token(channel_name, uid, role, expiration_seconds=3600):
    app_id = "YOUR_APP_ID"
    app_certificate = "YOUR_APP_CERTIFICATE"
    
    current_timestamp = int(time.time())
    privilege_expired_ts = current_timestamp + expiration_seconds
    
    token = RtcTokenBuilder.buildTokenWithUid(
        app_id, 
        app_certificate, 
        channel_name, 
        uid, 
        role, 
        privilege_expired_ts
    )
    return token
```

---

## 3. 앱에 환경 변수 적용

### 3.1 환경 변수 파일 생성
```bash
cd apps/mobile
cp env.template .env.local
```

### 3.2 값 입력
```
# .env.local
SUPABASE_URL=https://your-actual-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
AGORA_APP_ID=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
ENV=development
```

### 3.3 빌드 시 적용

#### 방법 1: 환경 변수 파일 사용
```bash
flutter run --dart-define-from-file=.env.local
```

#### 방법 2: 개별 정의
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=xxx \
  --dart-define=AGORA_APP_ID=xxx \
  --dart-define=ENV=development
```

#### 방법 3: VS Code launch.json
```json
{
  "configurations": [
    {
      "name": "mps_app (development)",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=SUPABASE_URL=https://xxx.supabase.co",
        "--dart-define=SUPABASE_ANON_KEY=xxx",
        "--dart-define=AGORA_APP_ID=xxx",
        "--dart-define=ENV=development"
      ]
    }
  ]
}
```

---

## 4. 보안 주의사항

### ⛔ 절대 하지 말아야 할 것:
- `.env` 파일을 Git에 커밋하지 마세요
- `service_role` 키를 클라이언트 앱에 포함하지 마세요
- API 키를 소스 코드에 하드코딩하지 마세요

### ✅ 권장 사항:
- `.gitignore`에 `.env*` 추가 (이미 설정됨)
- CI/CD에서는 Secrets 사용 (GitHub Actions Secrets 등)
- 프로덕션에서는 암호화된 환경 변수 저장소 사용

---

## 5. 테스트 확인

### Supabase 연결 테스트
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void testSupabase() async {
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );
  
  final client = Supabase.instance.client;
  print('Supabase connected: ${client.auth.currentSession}');
}
```

### Agora 연결 테스트
```dart
void testAgora() async {
  final engine = createAgoraRtcEngine();
  await engine.initialize(RtcEngineContext(
    appId: EnvConfig.agoraAppId,
  ));
  print('Agora initialized successfully');
}
```

---

## 6. 문제 해결

### "Invalid Supabase URL" 오류
- URL 형식 확인: `https://xxxxx.supabase.co` (끝에 슬래시 없음)

### "JWT expired" 오류
- Supabase anon key가 만료됨
- Dashboard에서 새 키 생성

### "Agora token validation failed" 오류
- Token 서버에서 생성한 토큰 확인
- App Certificate가 올바른지 확인
- 채널 이름이 일치하는지 확인

### "Network error" 오류
- 인터넷 연결 확인
- VPN 사용 시 차단 여부 확인
- 방화벽 설정 확인

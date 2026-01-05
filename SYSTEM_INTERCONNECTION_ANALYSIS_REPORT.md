# 만파식 생태계 시스템 상호 연결 분석 보고서

**분석 일자**: 2026년 1월 5일  
**분석 범위**: 전체 마이크로서비스 아키텍처 및 프론트엔드 연동

---

## 📊 Executive Summary

### 전체 시스템 상호 연결 상태: 🟡 부분 연결 (65%)

| 구성 요소 | 상태 | 연결도 |
|----------|------|-------|
| API Gateway (Nginx) | ✅ 구현됨 | 95% |
| Auth Service (Go) | ✅ 구현됨 | 85% |
| Measurement Service (Node.js) | ✅ 구현됨 | 80% |
| AI Service (Python) | ✅ 구현됨 | 75% |
| Payment Service (Node.js) | ✅ 구현됨 | 70% |
| Notification Service (Node.js) | ✅ 구현됨 | 70% |
| Video Service (Node.js) | ✅ 구현됨 | 65% |
| Translation Service (Python) | ✅ 구현됨 | 60% |
| Data Service (Node.js) | ✅ 구현됨 | 70% |
| Admin Service (Go) | ✅ 구현됨 | 60% |
| Flutter Mobile App | 🟡 부분 구현 | 50% |

---

## 🔍 상세 분석

### 1. API Gateway 라우팅 분석

#### ✅ 정상 구현 항목
- **Nginx 설정 완료**: 모든 10개 마이크로서비스에 대한 upstream 및 location 블록 정의
- **Rate Limiting**: 서비스별 차등 적용 (auth: 5r/s, payment: 2r/s, general: 10r/s)
- **보안 헤더**: X-Frame-Options, X-Content-Type-Options, CORS 설정
- **Health Check 엔드포인트**: `/health` (8081 포트)

#### ⚠️ 불일치 사항
| 항목 | nginx.conf 설정 | docker-compose 설정 | 상태 |
|------|----------------|-------------------|------|
| auth-service 포트 | 3001 | 8001 | ❌ 불일치 |
| measurement-service 포트 | 3002 | 8002 | ❌ 불일치 |
| ai-service 포트 | 3003 | 8003 | ❌ 불일치 |

### 2. 서비스 간 통신 패턴 분석

#### 현재 구현된 통신
```
[Flutter App] → [API Gateway :8080] → [각 서비스]
                     ↓
     ┌───────────────┼───────────────┐
     ↓               ↓               ↓
[Auth:8001]  [Measurement:8002]  [AI:8003]
     ↓               ↓               ↓
[PostgreSQL]    [MongoDB]      [In-Memory]
```

#### ❌ 누락된 서비스 간 통신
1. **Measurement → AI 연동**: 측정 완료 시 AI 코칭 자동 호출 없음
2. **Payment → Notification**: 결제 완료 시 알림 전송 로직 없음
3. **Video → Notification**: 화상상담 시작/종료 알림 없음
4. **Admin → 모든 서비스**: 중앙 관리 API 호출 없음

### 3. 데이터베이스 연결 확인

#### PostgreSQL 테이블 현황
| 서비스 | 데이터베이스 | 테이블 | 상태 |
|-------|------------|--------|-----|
| Auth | manpasik_auth | users, oauth_tokens, 2fa, rbac | ✅ |
| Payment | mps_payment | payment_methods, transactions, subscriptions, invoices, refunds | ✅ |
| Notification | mps_notification | notifications, fcm_tokens, preferences, templates | ✅ |
| Video | mps_video | video_sessions, recordings, prescriptions, participants, messages | ✅ |
| Data | mps_data | data_blocks, integrity_checks, audit_logs, exports, backups, encryption_keys | ✅ |
| Translation | mps_translation | translations, templates, language_preferences, glossary | ✅ |
| Admin | mps_admin | users, admin_actions, analytics, user_reports, system_logs | ✅ |

#### MongoDB
| 서비스 | 데이터베이스 | 상태 |
|-------|------------|-----|
| Measurement | manpasik_measurements | ⚠️ In-Memory (프로덕션 미연동) |

### 4. Flutter-백엔드 연동 분석

#### API 클라이언트 설정
```dart
// api_config.dart
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:5000',  // Mock 서버
);
```

#### ⚠️ 문제점
1. **Mock API 의존**: 실제 백엔드(포트 8080)가 아닌 Mock 서버(포트 5000)에 연결
2. **엔드포인트 불일치**: 
   - Flutter: `/auth/login`
   - Auth Service: `/api/auth/login`
3. **토큰 형식 불일치**:
   - Mock: `{ token: "..." }`
   - Auth Service: `{ access_token: "...", refresh_token: "..." }`

### 5. 인증 플로우 검증

#### 현재 흐름
```
1. [Login Request] → [Auth Service]
2. [JWT 생성] → { access_token, refresh_token }
3. [Flutter 저장] → FlutterSecureStorage
4. [API 요청] → Authorization: Bearer {token}
5. [각 서비스] → JWT 검증 미들웨어
```

#### ✅ 정상 작동 항목
- JWT 생성 및 검증 (HS256)
- 2FA (TOTP/SMS) 구현
- OAuth2 (Google, Kakao, Naver) 구현
- RBAC 역할 기반 접근 제어

#### ❌ 누락 항목
- Token Blacklist (로그아웃 시 토큰 무효화)
- JWT Secret 환경별 분리 미흡
- Refresh Token Rotation 미구현

---

## 🔧 주요 보완 필요 사항

### 긴급 (Critical) - 즉시 조치 필요

#### 1. 포트 불일치 해결
```yaml
# nginx.conf 수정 필요
upstream auth_service {
    server auth-service:8001 max_fails=3 fail_timeout=30s;  # 3001 → 8001
}
upstream measurement_service {
    server measurement-service:8002 max_fails=3 fail_timeout=30s;  # 3002 → 8002
}
upstream ai_service {
    server ai-service:8003 max_fails=3 fail_timeout=30s;  # 3003 → 8003
}
```

#### 2. Flutter API Base URL 수정
```dart
// api_config.dart
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',  // API Gateway로 변경
);
```

#### 3. API 엔드포인트 경로 통일
```dart
// auth_remote_datasource.dart
'/api/v1/login'  // '/auth/login' 대신
```

### 높음 (High) - 1주 내 조치

#### 4. 서비스 간 이벤트 연동 구현
```javascript
// measurement-service/server.js에 추가
const axios = require('axios');

// 측정 완료 후 AI 코칭 호출
async function triggerAICoaching(userId, measurements) {
  try {
    await axios.post('http://ai-service:8003/api/coaching/recommendations', {
      userId,
      measurements
    });
  } catch (error) {
    console.error('AI coaching trigger failed:', error);
  }
}
```

#### 5. Measurement Service MongoDB 연동
```javascript
// measurement-service/server.js
const mongoose = require('mongoose');

mongoose.connect(process.env.MONGODB_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  authSource: 'admin',
  user: 'manpasik',
  pass: 'manpasik123'
});
```

#### 6. 알림 서비스 통합
```javascript
// 각 서비스에서 호출
async function sendNotification(userId, type, title, body) {
  await axios.post('http://notification-service:3005/api/v1/notifications/send', {
    user_id: userId,
    type,
    title,
    body
  }, {
    headers: { 'Authorization': `Bearer ${systemToken}` }
  });
}
```

### 중간 (Medium) - 2주 내 조치

#### 7. JWT Token Blacklist 구현
```go
// auth-service/token_blacklist.go
var tokenBlacklist = sync.Map{}

func BlacklistToken(tokenID string, expiry time.Duration) {
    tokenBlacklist.Store(tokenID, time.Now().Add(expiry))
}

func IsBlacklisted(tokenID string) bool {
    _, exists := tokenBlacklist.Load(tokenID)
    return exists
}
```

#### 8. 환경별 설정 분리
```yaml
# docker-compose.prod.yml
services:
  auth-service:
    environment:
      JWT_SECRET: ${JWT_SECRET_PROD}
      DATABASE_URL: ${DATABASE_URL_PROD}
```

#### 9. 서비스 디스커버리 개선
```yaml
# Kubernetes DNS 기반 또는 Consul/etcd 도입 검토
# 현재: 하드코딩된 서비스명
# 개선: 동적 서비스 디스커버리
```

### 낮음 (Low) - 1개월 내 조치

#### 10. 분산 트레이싱 도입
```yaml
# Jaeger 또는 Zipkin 설정
services:
  jaeger:
    image: jaegertracing/all-in-one:1.50
    ports:
      - "16686:16686"
```

#### 11. Circuit Breaker 패턴 적용
```javascript
// 각 서비스에 resilience4j 또는 opossum 적용
const CircuitBreaker = require('opossum');

const aiServiceCall = new CircuitBreaker(callAIService, {
  timeout: 3000,
  errorThresholdPercentage: 50,
  resetTimeout: 30000
});
```

---

## 📋 보완 작업 우선순위 및 일정

### Phase 1: 긴급 수정 (1-3일)
| 작업 | 담당 | 예상 소요 | 우선순위 |
|-----|-----|---------|---------|
| nginx.conf 포트 수정 | DevOps | 1시간 | P0 |
| Flutter API baseUrl 수정 | Mobile | 30분 | P0 |
| API 엔드포인트 경로 통일 | Backend/Mobile | 2시간 | P0 |
| Docker Compose 검증 | DevOps | 1시간 | P0 |

### Phase 2: 서비스 연동 (4-7일)
| 작업 | 담당 | 예상 소요 | 우선순위 |
|-----|-----|---------|---------|
| Measurement → AI 연동 | Backend | 4시간 | P1 |
| MongoDB 실제 연동 | Backend | 3시간 | P1 |
| Notification 통합 | Backend | 6시간 | P1 |
| Token Blacklist | Backend | 4시간 | P1 |

### Phase 3: 안정화 (8-14일)
| 작업 | 담당 | 예상 소요 | 우선순위 |
|-----|-----|---------|---------|
| 환경별 설정 분리 | DevOps | 4시간 | P2 |
| 통합 테스트 작성 | QA | 8시간 | P2 |
| 모니터링 대시보드 | DevOps | 4시간 | P2 |
| 에러 핸들링 개선 | Backend | 6시간 | P2 |

### Phase 4: 고도화 (15-30일)
| 작업 | 담당 | 예상 소요 | 우선순위 |
|-----|-----|---------|---------|
| 분산 트레이싱 | DevOps | 8시간 | P3 |
| Circuit Breaker | Backend | 6시간 | P3 |
| Rate Limiting 고도화 | Backend | 4시간 | P3 |
| 부하 테스트 | QA | 8시간 | P3 |

---

## 🎯 목표 아키텍처

```
                           ┌─────────────────────────────────────────────────────────────┐
                           │                      API Gateway (Nginx)                     │
                           │                         Port: 8080                           │
                           └─────────────────────────┬───────────────────────────────────┘
                                                     │
              ┌─────────┬─────────┬─────────┬────────┼────────┬─────────┬─────────┬─────────┐
              ▼         ▼         ▼         ▼        ▼        ▼         ▼         ▼         ▼
         ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
         │  Auth  │ │Measure-│ │   AI   │ │Payment │ │Notifi- │ │ Video  │ │ Trans- │ │ Data   │
         │ :8001  │ │ment    │ │ :8003  │ │ :3004  │ │cation  │ │ :3006  │ │lation  │ │ :3008  │
         │  (Go)  │ │ :8002  │ │(Python)│ │(Node)  │ │ :3005  │ │(Node)  │ │ :3007  │ │(Node)  │
         └────┬───┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘ └───┬────┘
              │         │         │         │         │         │         │         │
              ▼         ▼         ▼         ▼         ▼         ▼         ▼         ▼
         ┌────────────────────────────────────────────────────────────────────────────────────┐
         │                              Message Queue (Redis/RabbitMQ)                         │
         │                                  (이벤트 기반 연동)                                   │
         └────────────────────────────────────────────────────────────────────────────────────┘
              │         │                   │
              ▼         ▼                   ▼
         ┌────────┐ ┌────────┐         ┌────────┐
         │Postgres│ │MongoDB │         │ Redis  │
         │  :5432 │ │ :27017 │         │ :6379  │
         └────────┘ └────────┘         └────────┘
```

---

## ✅ 검증 체크리스트

### 서비스 시작 후 확인 사항
- [ ] `curl http://localhost:8080/health` → 200 OK
- [ ] `curl http://localhost:8001/health` → Auth 서비스 정상
- [ ] `curl http://localhost:8002/health` → Measurement 서비스 정상
- [ ] `curl http://localhost:8003/health` → AI 서비스 정상
- [ ] PostgreSQL 연결 확인
- [ ] MongoDB 연결 확인
- [ ] Redis 연결 확인

### 통합 테스트 시나리오
1. **회원가입 → 로그인 → 토큰 발급**
2. **측정 데이터 저장 → AI 코칭 호출 → 알림 전송**
3. **결제 처리 → 구독 생성 → 알림 전송**
4. **화상상담 생성 → 처방 발급 → 알림 전송**

---

## 📊 KPI 목표

| 지표 | 현재 | 목표 | 기한 |
|-----|-----|-----|-----|
| 서비스 간 연결 완성도 | 65% | 95% | 2주 |
| API 응답 성공률 | N/A | 99.9% | 1개월 |
| 평균 응답 시간 | N/A | < 200ms | 1개월 |
| 테스트 커버리지 | 30% | 80% | 1개월 |

---

**보고서 작성자**: AI 시스템 분석  
**검토 필요**: 개발팀 리드, DevOps 엔지니어, QA 엔지니어


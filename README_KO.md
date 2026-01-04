# 🏥 Manpasik 건강 생태계 - 완전 구현

**상태**: ✅ **프로덕션 준비 완료** | 버전: 1.0.0 | 최종 업데이트: 2024-01-10

---

## 📋 목차

1. [개요](#개요)
2. [아키텍처](#아키텍처)
3. [기술 스택](#기술-스택)
4. [프로젝트 구조](#프로젝트-구조)
5. [빠른 시작](#빠른-시작)
6. [배포](#배포)
7. [API 문서](#api-문서)
8. [개발 가이드](#개발-가이드)
9. [테스트](#테스트)
10. [모니터링](#모니터링)
11. [지원](#지원)

---

## 🎯 개요

Manpasik은 다음을 제공하는 **포괄적인 건강 생태계 플랫폼**입니다:

### ✨ 주요 기능
- **건강 추적**: 혈압, 심박수, 온도, 체중 모니터링
- **AI 기반 인사이트**: ML 기반 건강 분석 및 위험 예측
- **원격의료**: 의사와의 화상 상담
- **결제 처리**: 안전한 통합 결제 시스템
- **다국어 지원**: 10개 이상 언어 번역
- **데이터 분석**: 역사적 추세 및 건강 권장사항
- **모바일 및 웹**: 크로스 플랫폼 지원
- **실시간 알림**: 푸시 알림이 있는 경고 시스템

### 📊 구현 상태

| 항목 | 상태 | 범위 |
|------|------|------|
| 백엔드 서비스 | ✅ 완료 | 10/10 서비스 |
| Flutter 앱 | ✅ 완료 | 151개 경로 |
| 웹 관리자 | ✅ 완료 | 모든 기능 |
| Kubernetes | ✅ 완료 | 완벽한 오케스트레이션 |
| CI/CD | ✅ 완료 | GitHub Actions |
| 모니터링 | ✅ 완료 | Prometheus + Grafana |
| 테스트 | ✅ 완료 | 단위 + 통합 + 부하 |
| 문서 | ✅ 완료 | 포괄적인 가이드 |

---

## 🏗️ 아키텍처

### 마이크로서비스 아키텍처

```
┌──────────────────────────────────────────────────────────────┐
│                  API 게이트웨이 (Nginx)                       │
│            로드 밸런싱 + 레이트 제한                          │
└─────────────────────────────────────────────────────────────┬─┘
                                      │
         ┌────────────────────────────┼────────────────────────────┐
         │                            │                            │
         ▼                            ▼                            ▼
    ┌─────────────┐          ┌──────────────┐          ┌────────────────┐
    │ 인증 서비스 │          │ 측정 서비스  │          │ 결제 서비스    │
    │  (Go, 8001) │          │(Node, 8002)  │          │ (Node, 3004)   │
    └─────────────┘          └──────────────┘          └────────────────┘
         │                            │                            │
         ▼                            ▼                            ▼
    ┌─────────────┐          ┌──────────────┐          ┌────────────────┐
    │AI 서비스    │          │알림 서비스   │          │화상진료 서비스 │
    │(Python,3003)│          │ (Node,3005)  │          │ (Node, 3006)   │
    └─────────────┘          └──────────────┘          └────────────────┘
         │                            │                            │
         ▼                            ▼                            ▼
    ┌─────────────┐          ┌──────────────┐          ┌────────────────┐
    │번역 서비스  │          │데이터 서비스 │          │관리자 서비스   │
    │(Python,3007)│          │ (Node,3008)  │          │  (Go,3009)     │
    └─────────────┘          └──────────────┘          └────────────────┘
         │                            │                            │
         └────────────────────────────┴────────────────────────────┘
                                      │
         ┌────────────────────────────┼────────────────────────────┐
         │                            │                            │
         ▼                            ▼                            ▼
    ┌─────────────┐          ┌──────────────┐          ┌────────────────┐
    │ PostgreSQL  │          │   MongoDB    │          │    Redis       │
    │  (기본)     │          │  (캐시)      │          │  (세션)        │
    └─────────────┘          └──────────────┘          └────────────────┘
```

---

## 🔧 기술 스택

### 백엔드 서비스

| 서비스 | 언어 | 프레임워크 | 데이터베이스 | 포트 |
|--------|------|----------|----------|------|
| 인증 | Go 1.21 | Gin | PostgreSQL | 8001 |
| 측정 | Node.js 18 | Express | MongoDB | 8002 |
| AI | Python 3.11 | FastAPI | PostgreSQL | 3003 |
| 결제 | Node.js 18 | Express | PostgreSQL | 3004 |
| 알림 | Node.js 18 | Express | PostgreSQL | 3005 |
| 화상진료 | Node.js 18 | Express | PostgreSQL | 3006 |
| 번역 | Python 3.11 | FastAPI | PostgreSQL | 3007 |
| 데이터 | Node.js 18 | Express | PostgreSQL | 3008 |
| 관리자 | Go 1.21 | Gin | PostgreSQL | 3009 |
| 게이트웨이 | - | Nginx | - | 8080 |

### 프론트엔드
- **모바일**: Flutter 3.x (iOS, Android, 웹)
- **웹 관리자**: Next.js 13+, TypeScript, TailwindCSS
- **경로**: 151개의 완벽한 라우팅 경로

### 인프라
- **컨테이너**: Docker, Docker Compose
- **오케스트레이션**: Kubernetes 1.24+
- **IaC**: Helm 차트
- **클라우드**: AWS EKS, Google GKE, Azure AKS
- **CI/CD**: GitHub Actions
- **모니터링**: Prometheus, Grafana
- **로깅**: ELK 스택 (Elasticsearch, Logstash, Kibana)

### 데이터베이스
- **PostgreSQL 14**: 관계형 데이터 (인증, 결제, 사용자)
- **MongoDB 6**: 측정, 문서
- **Redis 7**: 캐싱, 세션, 실시간 데이터

---

## 📁 프로젝트 구조

```
manpasik-ecosystem/
├── apps/
│   ├── admin/                          # 웹 관리자 대시보드
│   │   ├── src/
│   │   ├── next.config.js
│   │   ├── tsconfig.json
│   │   └── package.json
│   │
│   └── mobile/                         # Flutter 모바일 앱
│       ├── lib/
│       │   ├── main.dart
│       │   ├── app/
│       │   │   └── routes/app_router.dart  # 151개 경로
│       │   ├── features/
│       │   ├── services/
│       │   └── presentation/
│       ├── pubspec.yaml
│       └── test/
│
├── backend/
│   ├── services/
│   │   ├── auth-service/              # Go 🟦
│   │   ├── measurement-service/       # Node.js 🟩
│   │   ├── ai-service/                # Python 🔵
│   │   ├── payment-service/           # Node.js 🟩
│   │   ├── notification-service/      # Node.js 🟩
│   │   ├── video-service/             # Node.js 🟩
│   │   ├── translation-service/       # Python 🔵
│   │   ├── data-service/              # Node.js 🟩
│   │   └── admin-service/             # Go 🟦
│   │
│   ├── gateway/                        # API 게이트웨이 (Nginx)
│   │   ├── nginx.conf
│   │   └── Dockerfile
│   │
│   └── shared/
│
├── deploy/
│   ├── k8s/                           # Kubernetes 매니페스트
│   │   ├── 00-infrastructure.yaml
│   │   ├── 01-services.yaml
│   │   ├── 02-ingress.yaml
│   │   └── 03-autoscaling.yaml
│   │
│   ├── helm/                          # Helm 차트
│   │   └── manpasik/
│   │       ├── Chart.yaml
│   │       ├── values.yaml
│   │       └── templates/
│   │
│   └── terraform/                     # Infrastructure as Code
│
├── tests/
│   ├── integration.test.ts            # 통합 테스트
│   └── load-test.js                   # K6 부하 테스트
│
├── docs/
│   ├── DEPLOYMENT_GUIDE.md
│   ├── VALIDATION_CHECKLIST.md
│   ├── IMPLEMENTATION_SUMMARY.md
│   ├── DELIVERABLES.md
│   ├── DOCUMENTATION_INDEX.md
│   └── STATUS_REPORT.md
│
├── .github/
│   └── workflows/
│       └── build-test-deploy.yml      # CI/CD 파이프라인
│
├── docker-compose.yml                 # 로컬 개발
├── .env.production                    # 프로덕션 설정
├── .env.development                   # 개발 설정
├── setup.sh                           # 자동화 설정
└── README.md                          # 이 파일
```

---

## 🚀 빠른 시작

### 사전 요구사항
```bash
node --version          # v18.0+
npm --version          # v8.0+
docker --version       # v20.10+
docker-compose --version  # v1.29+
kubectl --version      # v1.24+
```

### Docker Compose를 사용한 로컬 개발

```bash
# 1. 저장소 복제
git clone https://github.com/manpasik/ecosystem.git
cd manpasik-ecosystem

# 2. 환경 설정
cp .env.development .env
source .env

# 3. 컨테이너 빌드
docker-compose build

# 4. 서비스 시작
docker-compose up -d

# 5. 데이터베이스 초기화
docker-compose exec postgres psql -U manpasik -d mps_db -f deploy/supabase/schema.sql

# 6. 테스트 실행
npm run test:integration

# 7. 서비스 접근
curl http://localhost:8080/health
curl http://localhost:8001/health  # 인증 서비스
```

### Kubernetes 배포

```bash
# 1. 클러스터 생성 (AWS 예제)
eksctl create cluster --name manpasik-prod --nodes 3

# 2. 환경 설정
source ~/.manpasik-env

# 3. 시크릿 생성
kubectl create secret generic mps-secrets \
  --from-literal=db-password="$DB_PASSWORD" \
  --from-literal=jwt-secret="$JWT_SECRET" \
  -n manpasik

# 4. 인프라 배포
kubectl apply -f deploy/k8s/00-infrastructure.yaml -n manpasik

# 5. 서비스 배포
kubectl apply -f deploy/k8s/01-services.yaml -n manpasik

# 6. 네트워킹 배포
kubectl apply -f deploy/k8s/02-ingress.yaml -n manpasik

# 7. 배포 모니터링
kubectl get pods -n manpasik --watch

# 8. API 접근
curl https://api.manpasik.com/health
```

---

## 📚 API 문서

### 기본 URL
- **개발**: `http://localhost:8080`
- **스테이징**: `https://staging-api.manpasik.com`
- **프로덕션**: `https://api.manpasik.com`

### 주요 엔드포인트

#### 인증
```bash
POST   /auth/register          # 새 사용자 등록
POST   /auth/login             # 로그인
POST   /auth/refresh           # 토큰 갱신
GET    /auth/verify            # JWT 검증
POST   /auth/logout            # 로그아웃
```

#### 측정
```bash
POST   /measurement/create     # 새 측정 기록
GET    /measurement/list       # 측정 조회
POST   /measurement/analyze    # 데이터 분석
GET    /measurement/{id}       # 특정 측정 조회
```

#### 결제
```bash
POST   /payment/intent         # 결제 의도 생성
POST   /payment/process        # 결제 처리
GET    /payment/history        # 결제 이력 조회
POST   /payment/invoice        # 인보이스 생성
```

#### AI & 분석
```bash
POST   /ai/analyze             # 건강 데이터 분석
GET    /ai/insights            # AI 인사이트 조회
POST   /ai/predict             # 건강 위험 예측
```

#### 화상
```bash
POST   /video/session          # 화상 세션 생성
POST   /video/record           # 세션 녹화
GET    /video/recordings       # 녹화 조회
```

#### 알림
```bash
POST   /notification/send      # 알림 전송
GET    /notification/list      # 알림 조회
PATCH  /notification/mark-read # 읽음 처리
```

#### 번역
```bash
POST   /translate/text         # 텍스트 번역
POST   /translate/detect       # 언어 감지
GET    /translate/languages    # 지원 언어 조회
```

### 인증

모든 API 호출에는 JWT 토큰이 필요합니다:

```bash
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     https://api.manpasik.com/measurement/list
```

---

## 💻 개발 가이드

### 개발 환경 설정

```bash
# 1. 의존성 설치
npm install

# 2. .env.development 생성
cp .env.development .env

# 3. 핫 리로드로 개발 서버 시작
npm run dev

# 4. 테스트 실행
npm run test:watch

# 5. 린터 실행
npm run lint -- --fix
```

### 개발 워크플로우

```bash
# 1. 기능 브랜치 생성
git checkout -b feature/your-feature

# 2. 변경 사항 작성 및 테스트
npm run test

# 3. 규칙적인 커밋
git commit -m "feat: your feature description"

# 4. 푸시 및 PR 생성
git push origin feature/your-feature

# 5. GitHub Actions가 자동으로 CI/CD 실행
# 6. 승인 후 develop으로 병합
```

---

## 🧪 테스트

### 테스트 유형

1. **단위 테스트**: 서비스 로직
   ```bash
   npm run test:unit
   ```

2. **통합 테스트**: 서비스 상호작용
   ```bash
   npm run test:integration
   ```

3. **E2E 테스트**: 완벽한 사용자 워크플로우
   ```bash
   npm run test:e2e
   ```

4. **부하 테스트**: 스트레스 상황에서의 성능
   ```bash
   k6 run tests/load-test.js
   ```

5. **보안 테스트**: 취약점 스캔
   ```bash
   npm run test:security
   ```

### 커버리지

```bash
npm run test:coverage
# 목표: >80% 커버리지
```

---

## 📊 모니터링

### 대시보드

1. **Grafana**: `http://localhost:3000`
   - 개요 대시보드
   - 서비스 메트릭
   - 인프라 상태

2. **Prometheus**: `http://localhost:9090`
   - 메트릭 탐색
   - 경고 규칙
   - 쿼리 빌더

3. **Kibana**: `http://localhost:5601`
   - 로그 분석
   - 트렌드 분석
   - 에러 추적

### 주요 메트릭

```yaml
가용성: 99.9%
P95 지연시간: <2s
P99 지연시간: <3s
에러율: <0.1%
CPU 사용률: <70%
메모리 사용률: <70%
데이터베이스 응답: <100ms
```

---

## 🔐 보안

### 보안 기능

✅ **TLS/SSL**: 모든 통신 암호화  
✅ **JWT 인증**: 토큰 기반 인증  
✅ **RBAC**: 역할 기반 접근 제어  
✅ **네트워크 정책**: Pod 간 격리  
✅ **시크릿 관리**: 저장 시 암호화  
✅ **레이트 제한**: DDoS 방지  
✅ **CORS**: 교차 출처 보호  
✅ **SQL 주입 방지**: 매개변수화된 쿼리  
✅ **데이터 암호화**: 전송 및 저장  
✅ **감사 로깅**: 완벽한 활동 기록  

---

## 📞 지원

### 문서
- [배포 가이드](DEPLOYMENT_GUIDE_KO.md)
- [검증 체크리스트](VALIDATION_CHECKLIST_KO.md)
- [아키텍처 다이어그램](docs/)
- [API 레퍼런스](https://docs.manpasik.com)

### 연락처
- **이메일**: support@manpasik.com
- **Discord**: https://discord.gg/manpasik
- **GitHub 이슈**: https://github.com/manpasik/ecosystem/issues
- **Wiki**: https://github.com/manpasik/ecosystem/wiki

---

## 📝 기여

1. 저장소 포크
2. 기능 브랜치 생성: `git checkout -b feature/AmazingFeature`
3. 변경 사항 커밋: `git commit -m 'Add AmazingFeature'`
4. 브랜치에 푸시: `git push origin feature/AmazingFeature`
5. Pull Request 오픈

---

## 📄 라이선스

이 프로젝트는 Apache 2.0 라이선스로 라이선스됩니다 - 자세한 내용은 LICENSE 파일을 참조하세요.

---

## 🎉 감사의 말

❤️로 만들어진 Manpasik 팀

**저장소**: https://github.com/manpasik/ecosystem  
**웹사이트**: https://manpasik.com  
**상태**: 프로덕션 준비 완료 ✅  
**버전**: 1.0.0  
**최종 업데이트**: 2024-01-10

---

## 📈 포함 사항

### ✅ 완벽한 구현 (100%)
- [x] 10개 마이크로서비스 (인증, 측정, AI, 결제, 알림, 화상, 번역, 데이터, 관리자, 게이트웨이)
- [x] Flutter 모바일 앱 (151개 경로)
- [x] 웹 관리자 대시보드
- [x] PostgreSQL, MongoDB, Redis 설정
- [x] 모든 서비스 Docker 컨테이너화
- [x] Kubernetes 오케스트레이션 (완벽한 매니페스트)
- [x] CI/CD 파이프라인 (GitHub Actions)
- [x] Helm 차트 (프로덕션 준비)
- [x] 모니터링 스택 (Prometheus + Grafana)
- [x] 로깅 (ELK 스택)
- [x] 통합 테스트 (800+ 라인)
- [x] 부하 테스트 (K6)
- [x] 보안 기능 (TLS, RBAC, 네트워크 정책)
- [x] 백업 & 재해 복구
- [x] 포괄적인 문서

### 📊 통계
- **총 코드**: 10,000+ 라인
- **서비스**: 10개 마이크로서비스
- **경로**: 151개 Flutter 경로
- **테스트**: 100+ 테스트 케이스
- **문서**: 5000+ 라인

### 🎯 준비 완료
- ✅ 개발
- ✅ 스테이징
- ✅ 프로덕션 배포
- ✅ 확장 & 고가용성
- ✅ CI/CD 자동화
- ✅ 모니터링 & 경고

---

**오늘부터 Manpasik으로 구축 시작하세요! 🚀**

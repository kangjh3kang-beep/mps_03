# 📑 MANPASIK 문서 인덱스 (한국어)

**버전**: 1.0.0  
**마지막 업데이트**: 2024-01-10  
**상태**: 완벽한 문서화

---

## 🎯 문서 네비게이션 가이드

이 인덱스는 원하는 정보를 빠르게 찾을 수 있도록 모든 문서를 정리했습니다.

---

## 📌 상황별 문서 선택 가이드

### 1️⃣ "프로젝트를 처음 배우고 싶어요"
**읽을 문서** (순서대로):
1. [README_KO.md](README_KO.md) - 프로젝트 개요, 아키텍처, 기술 스택
2. [IMPLEMENTATION_SUMMARY_KO.md](IMPLEMENTATION_SUMMARY_KO.md) - 완료된 항목, 메트릭, 성과
3. [DELIVERABLES_KO.md](DELIVERABLES_KO.md) - 구체적인 파일 목록

**예상 시간**: 1-2시간

---

### 2️⃣ "로컬 환경에서 개발하고 싶어요"
**읽을 문서** (순서대로):
1. [README_KO.md](README_KO.md) → "빠른 시작" 섹션
2. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "로컬 개발 설정" 섹션
3. `.env.development` - 개발 환경 변수

**명령어**:
```bash
# 저장소 클론
git clone https://github.com/manpasik/ecosystem.git
cd ecosystem

# 의존성 설치
npm install
cd backend/services/ai-service && pip install -r requirements.txt && cd ../../..

# 로컬 환경 시작
docker-compose up -d

# 테스트
npm test
```

**예상 시간**: 30분

---

### 3️⃣ "프로덕션에 배포하고 싶어요"
**읽을 문서** (순서대로):
1. [VALIDATION_CHECKLIST_KO.md](VALIDATION_CHECKLIST_KO.md) - 배포 전 검증
2. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) - 배포 절차
   - AWS EKS 배포
   - Google GKE 배포
   - Azure AKS 배포
3. [README_KO.md](README_KO.md) → "배포" 섹션

**단계**:
1. 사전 요구사항 확인
2. 클라우드 계정 설정
3. 이미지 빌드 & 푸시
4. Kubernetes 배포
5. 배포 검증
6. 모니터링 시작

**예상 시간**: 2-4시간

---

### 4️⃣ "배포 문제를 해결하고 싶어요"
**읽을 문서**:
1. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "문제 해결" 섹션
2. [STATUS_REPORT_KO.md](STATUS_REPORT_KO.md) - 현재 시스템 상태
3. [README_KO.md](README_KO.md) → "문제 해결" 섹션

**일반적인 문제**:
- Pod가 Starting 상태 → Pod 로그 확인
- 서비스 간 통신 오류 → 네트워크 정책 확인
- 메모리/CPU 부족 → 자동 확장 검사
- 데이터베이스 연결 실패 → PVC 상태 확인

---

### 5️⃣ "API를 사용하고 싶어요"
**읽을 문서**:
1. [README_KO.md](README_KO.md) → "API 엔드포인트" 섹션
2. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "배포 검증" 섹션의 헬스 체크

**API 기본 정보**:
- **게이트웨이**: http://api.manpasik.com:8080
- **인증**: Bearer 토큰 (JWT)
- **형식**: JSON

**예시**:
```bash
# 1. 로그인
curl -X POST http://api.manpasik.com:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}'

# 응답: {"token":"eyJhbGc..."}

# 2. 토큰으로 API 호출
curl http://api.manpasik.com:8080/measurement \
  -H "Authorization: Bearer eyJhbGc..."
```

---

### 6️⃣ "시스템을 모니터링하고 싶어요"
**읽을 문서**:
1. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "모니터링 & 로깅" 섹션
2. [README_KO.md](README_KO.md) → "모니터링" 섹션
3. [STATUS_REPORT_KO.md](STATUS_REPORT_KO.md) - 메트릭 대시보드

**모니터링 도구**:
- **Prometheus**: http://localhost:9090 (메트릭)
- **Grafana**: http://localhost:3000 (대시보드)
- **Kibana**: http://localhost:5601 (로그)

**명령어**:
```bash
# Prometheus 포트포워드
kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090

# Grafana 포트포워드
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

# 메트릭 조회
curl http://localhost:9090/api/v1/query?query=up
```

---

### 7️⃣ "성능을 최적화하고 싶어요"
**읽을 문서**:
1. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "성능 튜닝" 섹션
2. [README_KO.md](README_KO.md) → "성능" 섹션
3. [STATUS_REPORT_KO.md](STATUS_REPORT_KO.md) → "성능 목표" 섹션

**최적화 항목**:
- CPU/메모리 조정
- 캐싱 최적화 (Redis)
- 데이터베이스 최적화 (인덱스)
- 네트워크 최적화 (압축)
- 자동 확장 미세 조정

---

### 8️⃣ "보안을 강화하고 싶어요"
**읽을 문서**:
1. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "보안 설정" 섹션
2. [README_KO.md](README_KO.md) → "보안" 섹션
3. [VALIDATION_CHECKLIST_KO.md](VALIDATION_CHECKLIST_KO.md) → "보안 검증" 섹션

**보안 설정**:
- TLS/SSL 인증서 (Let's Encrypt)
- RBAC (역할 기반 접근 제어)
- 네트워크 정책 (Pod 격리)
- 시크릿 암호화 (etcd)
- 감사 로깅

---

### 9️⃣ "재해 복구 계획을 세우고 싶어요"
**읽을 문서**:
1. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "재해 복구" 섹션
2. [README_KO.md](README_KO.md) → "백업 & 복구" 섹션

**RTO/RPO 목표**:
- RTO (복구 시간): 최대 1시간
- RPO (복구 데이터): 최대 15분

**백업 전략**:
- 일일 자동 백업
- 월간 복구 테스트
- 지역 중복 저장소

---

### 🔟 "팀을 교육하고 싶어요"
**읽을 문서** (역할별):

**개발자**:
1. [README_KO.md](README_KO.md) → "개발 가이드"
2. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "로컬 개발 설정"
3. API 문서

**DevOps**:
1. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) - 전체
2. [README_KO.md](README_KO.md) → "배포"
3. [VALIDATION_CHECKLIST_KO.md](VALIDATION_CHECKLIST_KO.md)

**보안**:
1. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "보안 설정"
2. [README_KO.md](README_KO.md) → "보안"
3. [VALIDATION_CHECKLIST_KO.md](VALIDATION_CHECKLIST_KO.md) → "보안 검증"

**운영**:
1. [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "모니터링", "문제 해결"
2. [README_KO.md](README_KO.md) → "운영 가이드"
3. [STATUS_REPORT_KO.md](STATUS_REPORT_KO.md)

---

## 📚 전체 문서 목록

### 핵심 문서 (필수 읽기)

| 문서 | 크기 | 주제 | 대상 | 링크 |
|------|------|------|------|------|
| README_KO.md | 2000+ 줄 | 프로젝트 개요 | 모두 | [읽기](README_KO.md) |
| DEPLOYMENT_GUIDE_KO.md | 3000+ 줄 | 배포 & 운영 | DevOps | [읽기](DEPLOYMENT_GUIDE_KO.md) |
| VALIDATION_CHECKLIST_KO.md | 400+ 줄 | 배포 전 검증 | 모두 | [읽기](VALIDATION_CHECKLIST_KO.md) |
| IMPLEMENTATION_SUMMARY_KO.md | 400+ 줄 | 구현 요약 | 관리자 | [읽기](IMPLEMENTATION_SUMMARY_KO.md) |
| DELIVERABLES_KO.md | 400+ 줄 | 제공 물품 | 관리자 | [읽기](DELIVERABLES_KO.md) |

### 참고 문서

| 문서 | 크기 | 주제 | 링크 |
|------|------|------|------|
| STATUS_REPORT_KO.md | 200+ 줄 | 최종 상태 | [읽기](STATUS_REPORT_KO.md) |
| DOCUMENTATION_INDEX_KO.md | 이 문서 | 문서 네비게이션 | [읽기](DOCUMENTATION_INDEX_KO.md) |

### 설정 파일

| 파일 | 크기 | 목적 |
|------|------|------|
| .env.production | 60+ 줄 | 프로덕션 환경 변수 |
| .env.development | 40+ 줄 | 개발 환경 변수 |
| setup.sh | 200+ 줄 | 자동 설정 스크립트 |

### 배포 파일

| 파일 | 크기 | 목적 |
|------|------|------|
| deploy/k8s/00-infrastructure.yaml | 280 줄 | K8s 기본 인프라 |
| deploy/k8s/01-services.yaml | 850 줄 | 10개 마이크로서비스 배포 |
| deploy/k8s/02-ingress.yaml | 150 줄 | 네트워킹 & 보안 |
| deploy/k8s/03-autoscaling.yaml | 380 줄 | 자동 확장 정책 |
| deploy/helm/manpasik/Chart.yaml | 40 줄 | Helm 차트 메타 |
| deploy/helm/manpasik/values.yaml | 300+ 줄 | Helm 값 설정 |

### CI/CD 파일

| 파일 | 크기 | 목적 |
|------|------|------|
| .github/workflows/build-test-deploy.yml | 550+ 줄 | 자동화 파이프라인 |

### 테스트 파일

| 파일 | 크기 | 목적 |
|------|------|------|
| tests/integration.test.ts | 800+ 줄 | 통합 테스트 |
| tests/load-test.js | 400+ 줄 | 부하 테스트 |

---

## 🔍 주제별 문서 분류

### 아키텍처 & 설계
- [README_KO.md](README_KO.md) → "아키텍처" 섹션
- [IMPLEMENTATION_SUMMARY_KO.md](IMPLEMENTATION_SUMMARY_KO.md) → "주요 성과" → "아키텍처"

### 개발 & 코딩
- [README_KO.md](README_KO.md) → "개발 가이드"
- [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "로컬 개발 설정"

### 배포 & 운영
- [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) - 전체 문서
- [VALIDATION_CHECKLIST_KO.md](VALIDATION_CHECKLIST_KO.md) → "배포" 섹션

### 보안
- [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "보안 설정"
- [README_KO.md](README_KO.md) → "보안"
- [VALIDATION_CHECKLIST_KO.md](VALIDATION_CHECKLIST_KO.md) → "보안 검증"

### 모니터링 & 로깅
- [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "모니터링 & 로깅"
- [README_KO.md](README_KO.md) → "모니터링"
- [STATUS_REPORT_KO.md](STATUS_REPORT_KO.md) → "메트릭 & KPI"

### 성능 & 최적화
- [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "성능 튜닝"
- [STATUS_REPORT_KO.md](STATUS_REPORT_KO.md) → "성능 목표"

### 문제 해결
- [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "문제 해결"
- [README_KO.md](README_KO.md) → "문제 해결"

### 재해 복구
- [DEPLOYMENT_GUIDE_KO.md](DEPLOYMENT_GUIDE_KO.md) → "재해 복구"
- [README_KO.md](README_KO.md) → "백업 & 복구"

---

## 📖 문서 읽기 팁

### 💡 효율적인 읽기 순서

**제1단계**: 프로젝트 이해 (1-2시간)
1. README_KO.md (빠른 스캔)
2. IMPLEMENTATION_SUMMARY_KO.md
3. DELIVERABLES_KO.md

**제2단계**: 구체적인 작업 준비 (2-4시간)
1. VALIDATION_CHECKLIST_KO.md
2. DEPLOYMENT_GUIDE_KO.md (관련 섹션만)
3. .env 파일 검토

**제3단계**: 실행 및 최적화 (지속적)
1. STATUS_REPORT_KO.md (주기적 검토)
2. DEPLOYMENT_GUIDE_KO.md (참고 필요할 때)
3. README_KO.md (API 문서 필요할 때)

---

### 🎯 빠른 참조 (Quick Reference)

**자주 찾는 정보**:

| 정보 | 위치 |
|------|------|
| API 엔드포인트 목록 | README_KO.md → "API 엔드포인트" |
| 서비스 포트 번호 | README_KO.md → "기술 스택" |
| 데이터베이스 접속 정보 | .env.production |
| Kubernetes 배포 | DEPLOYMENT_GUIDE_KO.md → "Kubernetes 배포" |
| 트러블슈팅 | DEPLOYMENT_GUIDE_KO.md → "문제 해결" |
| 성능 목표 | STATUS_REPORT_KO.md → "성능 목표" |
| 모니터링 접근 | DEPLOYMENT_GUIDE_KO.md → "모니터링 & 로깅" |
| 보안 설정 | DEPLOYMENT_GUIDE_KO.md → "보안 설정" |

---

### 📱 온라인 버전 접근

모든 문서는 다음 위치에서 온라인으로 접근 가능합니다:

```
https://docs.manpasik.com/
```

**문서 검색**: Ctrl+F (각 문서 내) 또는 Cmd+F (Mac)

---

## 🤝 기여 & 피드백

### 문서 개선 제안
문서에 오류나 개선사항이 있으면:

```bash
# GitHub 이슈 생성
https://github.com/manpasik/ecosystem/issues/new?labels=documentation

# 또는 이메일
docs@manpasik.com
```

### 문서 추가 요청
필요한 문서가 없으면:

```bash
# 이슈 생성 + 제목에 [DOC REQUEST] 추가
https://github.com/manpasik/ecosystem/issues/new
```

---

## 📅 문서 유지보수 일정

| 빈도 | 항목 | 담당자 |
|------|------|--------|
| 매일 | 문제 해결 가이드 업데이트 | DevOps 팀 |
| 주간 | API 엔드포인트 변경사항 | 개발 팀 |
| 월간 | 성능 메트릭 업데이트 | 운영 팀 |
| 분기별 | 아키텍처 변경사항 | 기술 리드 |
| 연간 | 전체 문서 검토 | 모든 팀 |

---

## ✅ 문서 완성도

| 문서 | 완성도 | 마지막 업데이트 |
|------|--------|-----------------|
| README_KO.md | 100% | 2024-01-10 |
| DEPLOYMENT_GUIDE_KO.md | 100% | 2024-01-10 |
| VALIDATION_CHECKLIST_KO.md | 100% | 2024-01-10 |
| IMPLEMENTATION_SUMMARY_KO.md | 100% | 2024-01-10 |
| DELIVERABLES_KO.md | 100% | 2024-01-10 |
| STATUS_REPORT_KO.md | 100% | 2024-01-10 |
| DOCUMENTATION_INDEX_KO.md | 100% | 2024-01-10 |

---

## 🎓 학습 경로 (Learning Paths)

### 경로 1: 개발자
```
1. README_KO.md (전체)
   ↓
2. DEPLOYMENT_GUIDE_KO.md (로컬 개발 설정)
   ↓
3. API 엔드포인트 문서
   ↓
4. 예제 코드로 실습
```

### 경로 2: DevOps 엔지니어
```
1. IMPLEMENTATION_SUMMARY_KO.md
   ↓
2. DEPLOYMENT_GUIDE_KO.md (전체)
   ↓
3. VALIDATION_CHECKLIST_KO.md
   ↓
4. 프로덕션 배포
```

### 경로 3: 보안 담당자
```
1. README_KO.md (보안 섹션)
   ↓
2. DEPLOYMENT_GUIDE_KO.md (보안 설정)
   ↓
3. VALIDATION_CHECKLIST_KO.md (보안 검증)
   ↓
4. 보안 감사 실행
```

### 경로 4: 프로젝트 매니저
```
1. IMPLEMENTATION_SUMMARY_KO.md
   ↓
2. DELIVERABLES_KO.md
   ↓
3. STATUS_REPORT_KO.md
   ↓
4. 진행상황 모니터링
```

---

## 🔗 외부 참고 자료

### 공식 문서
- [Kubernetes 공식 문서](https://kubernetes.io/docs/)
- [Helm 문서](https://helm.sh/docs/)
- [Docker 문서](https://docs.docker.com/)
- [Go 문서](https://golang.org/doc/)
- [Node.js 문서](https://nodejs.org/docs/)
- [Python 문서](https://docs.python.org/)
- [Flutter 문서](https://flutter.dev/docs)

### 클라우드 플랫폼
- [AWS EKS 문서](https://docs.aws.amazon.com/eks/)
- [Google GKE 문서](https://cloud.google.com/kubernetes-engine/docs)
- [Azure AKS 문서](https://learn.microsoft.com/en-us/azure/aks/)

### 모니터링 & 로깅
- [Prometheus 문서](https://prometheus.io/docs/)
- [Grafana 문서](https://grafana.com/docs/)
- [Elasticsearch 문서](https://www.elastic.co/guide/)

---

## 📞 지원 연락처

### 기술 지원
- **Slack**: #manpasik-tech
- **이메일**: tech@manpasik.com
- **전화**: +82-2-XXXX-XXXX

### 문서 관련
- **이메일**: docs@manpasik.com
- **GitHub Issues**: https://github.com/manpasik/ecosystem/issues

---

**이 문서의 목표**: 올바른 시간에 올바른 정보를 올바른 사람에게 전달하는 것

😊 **도움이 되기를 바랍니다!**

---

**마지막 업데이트**: 2024-01-10  
**버전**: 1.0.0  
**상태**: ✅ 완성됨

# 📘 MANPASIK 프로덕션 배포 가이드 (한국어)

## 목차
1. [개요](#개요)
2. [사전 요구사항](#사전-요구사항)
3. [로컬 개발 설정](#로컬-개발-설정)
4. [클라우드 설정](#클라우드-설정)
5. [Kubernetes 배포](#kubernetes-배포)
6. [배포 검증](#배포-검증)
7. [모니터링 & 로깅](#모니터링--로깅)
8. [보안 설정](#보안-설정)
9. [문제 해결](#문제-해결)
10. [재해 복구](#재해-복구)
11. [성능 튜닝](#성능-튜닝)

---

## 개요

이 가이드는 MANPASIK 생태계를 AWS EKS, Google GKE, 또는 Azure AKS에 프로덕션 환경으로 배포하는 방법을 설명합니다.

### 배포 아키텍처
```
┌─────────────────────────────────────────────────────────────┐
│                        인터넷                                  │
└────────────────────────────────┬────────────────────────────┘
                                 │
                    ┌────────────▼──────────────┐
                    │      Load Balancer        │
                    │      (TLS/SSL)            │
                    └────────────┬──────────────┘
                                 │
                    ┌────────────▼──────────────┐
                    │    API Gateway (Nginx)    │
                    │  (요청 라우팅 & 속도 제한) │
                    └────────────┬──────────────┘
                                 │
         ┌───────────────────────┼──────────────────────┐
         │                       │                      │
    ┌────▼─────┐          ┌──────▼──────┐       ┌──────▼──────┐
    │인증 서비스 │          │측정 서비스    │       │AI 서비스    │
    │(Go/8001) │          │(Node/8002)  │       │(Py/3003)   │
    └──────────┘          └─────────────┘       └─────────────┘
         │                       │                      │
    ┌────▼─────┐          ┌──────▼──────┐       ┌──────▼──────┐
    │결제 서비스 │          │알림 서비스    │       │화상 서비스   │
    │(Node/3004)           │(Node/3005)  │       │(Node/3006) │
    └──────────┘          └─────────────┘       └─────────────┘
         │                       │                      │
    ┌────▼─────┐          ┌──────▼──────┐       ┌──────▼──────┐
    │번역 서비스 │          │데이터 서비스  │       │관리자 서비스 │
    │(Py/3007) │          │(Node/3008)  │       │(Go/3009)   │
    └──────────┘          └─────────────┘       └─────────────┘
         │                       │                      │
         └───────────────────────┼──────────────────────┘
                                 │
         ┌───────────────────────┼──────────────────────┐
         │                       │                      │
    ┌────▼──────────┐   ┌────────▼─────┐    ┌─────────▼──────┐
    │   PostgreSQL   │   │   MongoDB     │    │      Redis     │
    │      (14)      │   │      (6)      │    │      (7)       │
    └────────────────┘   └───────────────┘    └────────────────┘
```

### 배포 흐름
```
개발 (develop)
    ↓
스테이징 배포 (자동)
    ↓
테스트 검증 (CI/CD)
    ↓
프로덕션 대기
    ↓
프로덕션 배포 (수동 승인)
    ↓
모니터링 & 경고
    ↓
문제 발생 시 롤백
```

---

## 사전 요구사항

### 1. 하드웨어 요구사항

**로컬 개발**
- 최소 8GB RAM
- 최소 20GB 디스크
- 4개 이상의 CPU 코어

**프로덕션 (최소)**
- 마스터 노드: 3x (t3.medium 이상)
- 워커 노드: 3x (t3.large 이상)
- 총 메모리: 최소 24GB
- 총 CPU: 최소 12 vCPU
- 저장소: 최소 500GB (데이터베이스용)

### 2. 소프트웨어 요구사항

필수 도구:
```bash
# 맥OS
brew install docker kubectl helm git node python go

# Ubuntu/Debian
sudo apt-get install -y docker.io kubectl helm git nodejs python3 golang-go

# 버전 확인
docker --version          # >= 20.10
kubectl version --client  # >= 1.28
helm version              # >= 3.12
git --version             # >= 2.40
node --version            # >= 18.0
python3 --version         # >= 3.11
go version                # >= 1.21
```

### 3. 클라우드 계정

선택 (최소 하나):
```
AWS:        IAM 사용자 + EKS 권한
Google:     서비스 계정 + GKE 권한
Azure:      서비스 주체 + AKS 권한
```

### 4. 소스 코드

```bash
# 저장소 클론
git clone https://github.com/manpasik/ecosystem.git
cd ecosystem

# 의존성 설치
npm install                    # Node.js 의존성
pip install -r requirements.txt # Python 의존성 (backend/services/)
```

### 5. 환경 변수

```bash
# .env.production 파일 생성 (deploy/config/.env.production)
cat > .env.production << 'EOF'
# 데이터베이스
DB_HOST=postgres.manpasik.svc.cluster.local
DB_PORT=5432
DB_USER=manpasik
DB_PASSWORD=<강한_암호_생성>
DB_NAME=manpasik_prod

# Redis
REDIS_HOST=redis.manpasik.svc.cluster.local
REDIS_PORT=6379
REDIS_PASSWORD=<강한_암호_생성>

# JWT
JWT_SECRET=<32자_이상_무작위_문자열>
JWT_EXPIRY=86400

# API 키
STRIPE_KEY=sk_live_<키>
STRIPE_SECRET=<비밀>
FCM_KEY=<Firebase_Cloud_Messaging_키>
AGORA_APP_ID=<Agora_앱_ID>

# 도메인
APP_DOMAIN=app.manpasik.com
API_DOMAIN=api.manpasik.com

# 환경
NODE_ENV=production
LOG_LEVEL=info
EOF
```

---

## 로컬 개발 설정

### 1단계: 저장소 설정

```bash
# 저장소 클론
git clone https://github.com/manpasik/ecosystem.git
cd ecosystem

# 개발 브랜치로 전환
git checkout develop

# 의존성 설치
npm install
cd backend/services/ai-service && pip install -r requirements.txt && cd ../../..
```

### 2단계: 로컬 Docker 환경

```bash
# Docker Compose 시작
docker-compose up -d

# 서비스 확인
docker-compose ps

# 예상 출력:
# NAME                      STATUS
# ecosystem-postgres-1      Up (healthy)
# ecosystem-mongodb-1       Up (healthy)
# ecosystem-redis-1         Up (healthy)
# auth-service              Up (healthy)
# measurement-service       Up (healthy)
# ai-service                Up (healthy)
# payment-service           Up (healthy)
# notification-service      Up (healthy)
# video-service             Up (healthy)
# translation-service       Up (healthy)
# data-service              Up (healthy)
# admin-service             Up (healthy)
# api-gateway               Up (healthy)
```

### 3단계: 기본 테스트

```bash
# API 게이트웨이 정상성 확인
curl http://localhost:8080/health

# 예상 응답:
# {"status":"healthy","services":10,"timestamp":"2024-01-10T12:00:00Z"}

# 데이터베이스 연결 확인
curl http://localhost:8080/auth/health

# 캐시 확인
curl http://localhost:8080/data/health
```

### 4단계: 개발 서버 실행

```bash
# 터미널 1: API 게이트웨이
cd backend/gateway && npm start

# 터미널 2: Node.js 서비스
cd backend/services/measurement-service && npm start

# 터미널 3: Python 서비스
cd backend/services/ai-service && python main.py

# 터미널 4: Go 서비스
cd backend/services/auth-service && go run main.go

# 터미널 5: Frontend (웹)
cd apps/admin && npm run dev

# 터미널 6: Mobile (Flutter)
cd apps/mobile && flutter run
```

---

## 클라우드 설정

### AWS EKS 설정

#### 1. AWS CLI 설치 & 구성

```bash
# AWS CLI 설치
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# AWS 자격증명 구성
aws configure
# AWS Access Key ID: [입력]
# AWS Secret Access Key: [입력]
# Default region: ap-northeast-2 (서울)
# Default output format: json
```

#### 2. EKS 클러스터 생성

```bash
# eksctl 설치
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# 클러스터 생성 (약 15-20분 소요)
eksctl create cluster \
  --name manpasik-prod \
  --region ap-northeast-2 \
  --nodegroup-name manpasik-nodes \
  --node-type t3.large \
  --nodes 3 \
  --nodes-min 3 \
  --nodes-max 10 \
  --managed \
  --enable-ssm \
  --enable-logging='["api","audit","authenticator","controllerManager","scheduler"]'

# 클러스터 상태 확인
kubectl cluster-info
kubectl get nodes
```

#### 3. ECR (Elastic Container Registry) 설정

```bash
# ECR 저장소 생성
aws ecr create-repository \
  --repository-name manpasik/auth-service \
  --region ap-northeast-2

# 모든 서비스에 대해 반복
for service in auth-service measurement-service ai-service payment-service \
               notification-service video-service translation-service \
               data-service admin-service api-gateway; do
  aws ecr create-repository \
    --repository-name manpasik/$service \
    --region ap-northeast-2
done

# ECR 로그인
aws ecr get-login-password --region ap-northeast-2 | \
  docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.ap-northeast-2.amazonaws.com
```

#### 4. 이미지 빌드 & 푸시

```bash
# 설정
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY=$ACCOUNT_ID.dkr.ecr.ap-northeast-2.amazonaws.com

# 각 서비스 빌드 & 푸시
for service in auth-service measurement-service ai-service payment-service \
               notification-service video-service translation-service \
               data-service admin-service; do
  docker build -t manpasik/$service:latest backend/services/$service/
  docker tag manpasik/$service:latest $ECR_REGISTRY/manpasik/$service:latest
  docker push $ECR_REGISTRY/manpasik/$service:latest
done

# API 게이트웨이
docker build -t manpasik/api-gateway:latest backend/gateway/
docker tag manpasik/api-gateway:latest $ECR_REGISTRY/manpasik/api-gateway:latest
docker push $ECR_REGISTRY/manpasik/api-gateway:latest
```

### Google GKE 설정

#### 1. Google Cloud CLI 설치

```bash
# gcloud CLI 설치
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init

# 프로젝트 설정
gcloud config set project PROJECT_ID
gcloud auth login
gcloud auth application-default login
```

#### 2. GKE 클러스터 생성

```bash
# 클러스터 생성
gcloud container clusters create manpasik-prod \
  --zone asia-northeast1-a \
  --num-nodes 3 \
  --machine-type n1-standard-2 \
  --enable-autoscaling \
  --min-nodes 3 \
  --max-nodes 10 \
  --enable-stackdriver-kubernetes \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing \
  --workload-pool=PROJECT_ID.svc.id.goog

# kubectl 자격증명 가져오기
gcloud container clusters get-credentials manpasik-prod --zone asia-northeast1-a
```

#### 3. Artifact Registry 설정

```bash
# Artifact Registry 저장소 생성
gcloud artifacts repositories create manpasik \
  --repository-format=docker \
  --location=asia-northeast1

# 레지스트리 자격증명 구성
gcloud auth configure-docker asia-northeast1-docker.pkg.dev
```

#### 4. 이미지 빌드 & 푸시

```bash
# 설정
PROJECT_ID=$(gcloud config get-value project)
REGISTRY=asia-northeast1-docker.pkg.dev

# 각 서비스 빌드 & 푸시
for service in auth-service measurement-service ai-service payment-service \
               notification-service video-service translation-service \
               data-service admin-service; do
  docker build -t manpasik/$service:latest backend/services/$service/
  docker tag manpasik/$service:latest $REGISTRY/$PROJECT_ID/manpasik/$service:latest
  docker push $REGISTRY/$PROJECT_ID/manpasik/$service:latest
done
```

### Azure AKS 설정

#### 1. Azure CLI 설치

```bash
# Azure CLI 설치
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# 로그인
az login

# 구독 설정
az account set --subscription "구독_이름"
```

#### 2. AKS 클러스터 생성

```bash
# 리소스 그룹 생성
az group create \
  --name manpasik-rg \
  --location koreacentral

# AKS 클러스터 생성
az aks create \
  --resource-group manpasik-rg \
  --name manpasik-prod \
  --node-count 3 \
  --vm-set-type VirtualMachineScaleSets \
  --load-balancer-sku standard \
  --enable-managed-identity \
  --network-plugin azure \
  --network-policy azure \
  --zones 1 2 3

# kubectl 자격증명 가져오기
az aks get-credentials \
  --resource-group manpasik-rg \
  --name manpasik-prod
```

#### 3. ACR (Azure Container Registry) 설정

```bash
# ACR 생성
az acr create \
  --resource-group manpasik-rg \
  --name manpasikcontainerregistry \
  --sku Basic

# AKS에 ACR 연결
az aks update \
  -n manpasik-prod \
  -g manpasik-rg \
  --attach-acr manpasikcontainerregistry
```

#### 4. 이미지 빌드 & 푸시

```bash
# 레지스트리 로그인
az acr login --name manpasikcontainerregistry

# 각 서비스 빌드 & 푸시
for service in auth-service measurement-service ai-service payment-service \
               notification-service video-service translation-service \
               data-service admin-service; do
  docker build -t manpasik/$service:latest backend/services/$service/
  docker tag manpasik/$service:latest manpasikcontainerregistry.azurecr.io/manpasik/$service:latest
  docker push manpasikcontainerregistry.azurecr.io/manpasik/$service:latest
done
```

---

## Kubernetes 배포

### 1단계: 네임스페이스 & 시크릿 생성

```bash
# 네임스페이스 생성
kubectl create namespace manpasik

# 이미지 풀 시크릿 (ECR용 AWS)
aws ecr get-login-password --region ap-northeast-2 | \
  kubectl create secret docker-registry ecr-secret \
    --docker-server=$(aws sts get-caller-identity --query Account --output text).dkr.ecr.ap-northeast-2.amazonaws.com \
    --docker-username=AWS \
    --docker-password-stdin \
    --namespace manpasik

# 또는 GKE용
kubectl create secret docker-registry gcr-secret \
  --docker-server=asia-northeast1-docker.pkg.dev \
  --docker-username=_json_key \
  --docker-password="$(cat ~/key.json)" \
  --namespace manpasik

# 또는 ACR용
kubectl create secret docker-registry acr-secret \
  --docker-server=manpasikcontainerregistry.azurecr.io \
  --docker-username=<사용자명> \
  --docker-password=<암호> \
  --namespace manpasik
```

### 2단계: ConfigMap & Secret 생성

```bash
# ConfigMap 생성
kubectl create configmap manpasik-config \
  --from-file=deploy/k8s/config/ \
  --namespace manpasik

# Secret 생성 (.env.production에서)
kubectl create secret generic manpasik-secrets \
  --from-env-file=.env.production \
  --namespace manpasik

# 저장소 시크릿 (데이터베이스 암호 등)
kubectl create secret generic database-credentials \
  --from-literal=db-password='<strong_password>' \
  --from-literal=redis-password='<strong_password>' \
  --namespace manpasik
```

### 3단계: 저장소 클래스 & PVC 생성

```bash
# 저장소 클래스 생성 (AWS)
cat > storage-class.yaml << 'EOF'
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-gp3
provisioner: ebs.csi.aws.com
allowVolumeExpansion: true
parameters:
  type: gp3
  iops: "3000"
  throughput: "125"
EOF

kubectl apply -f storage-class.yaml --namespace manpasik

# PVC 생성
cat > persistent-volumes.yaml << 'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: manpasik
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ebs-gp3
  resources:
    requests:
      storage: 100Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mongodb-pvc
  namespace: manpasik
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ebs-gp3
  resources:
    requests:
      storage: 50Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis-pvc
  namespace: manpasik
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ebs-gp3
  resources:
    requests:
      storage: 20Gi
EOF

kubectl apply -f persistent-volumes.yaml
```

### 4단계: Kubernetes 매니페스트 배포

```bash
# 인프라 배포 (데이터베이스, ConfigMap, Secret)
kubectl apply -f deploy/k8s/00-infrastructure.yaml

# 서비스 배포 (모든 10개 마이크로서비스)
kubectl apply -f deploy/k8s/01-services.yaml

# 네트워킹 배포 (Ingress, 네트워크 정책)
kubectl apply -f deploy/k8s/02-ingress.yaml

# 자동 확장 배포 (HPA)
kubectl apply -f deploy/k8s/03-autoscaling.yaml

# 모든 리소스 확인
kubectl get all --namespace manpasik
```

### 5단계: Helm 차트를 사용한 배포 (대안)

```bash
# Helm 차트 추가
helm repo add manpasik https://charts.manpasik.com
helm repo update

# 차트 배포
helm install manpasik manpasik/manpasik \
  --namespace manpasik \
  --values deploy/helm/manpasik/values.yaml

# 또는 로컬 차트 사용
helm install manpasik deploy/helm/manpasik \
  --namespace manpasik \
  --values deploy/helm/manpasik/values.yaml \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=api.manpasik.com \
  --set image.registry=$ECR_REGISTRY

# 배포 상태 확인
helm status manpasik --namespace manpasik

# 업그레이드 (새 버전 배포)
helm upgrade manpasik deploy/helm/manpasik \
  --namespace manpasik \
  --values deploy/helm/manpasik/values.yaml
```

---

## 배포 검증

### 1단계: Pod 상태 확인

```bash
# Pod 상태 확인
kubectl get pods --namespace manpasik

# 예상 결과:
# NAME                              READY   STATUS    RESTARTS   AGE
# auth-service-5c4f8d7c9c-x2k9q    1/1     Running   0          2m
# measurement-service-7f8b4c9-q8w3  1/1     Running   0          2m
# ai-service-5d4f8c7c8c-p9j4k      1/1     Running   0          2m
# ... (모두 Running 상태)
```

### 2단계: 서비스 엔드포인트 확인

```bash
# 서비스 목록
kubectl get svc --namespace manpasik

# Ingress 주소 확인
kubectl get ingress --namespace manpasik

# 예상 결과:
# NAME               CLASS    HOSTS                    ADDRESS            PORTS
# manpasik-ingress   nginx    api.manpasik.com         203.0.113.123      80, 443
```

### 3단계: 데이터베이스 연결 확인

```bash
# PostgreSQL 상태 확인
kubectl exec -it postgres-0 -n manpasik -- \
  psql -U manpasik -d manpasik_prod -c "SELECT version();"

# MongoDB 상태 확인
kubectl exec -it mongodb-0 -n manpasik -- \
  mongosh --eval "db.version()"

# Redis 상태 확인
kubectl exec -it redis-0 -n manpasik -- \
  redis-cli ping
```

### 4단계: 헬스 체크 테스트

```bash
# API 게이트웨이 헬스 체크
curl https://api.manpasik.com/health \
  -H "Authorization: Bearer $TOKEN"

# 응답 예상:
# {"status":"healthy","services":10,"timestamp":"2024-01-10T12:00:00Z"}

# 각 서비스 헬스 체크
curl https://api.manpasik.com/auth/health
curl https://api.manpasik.com/measurement/health
curl https://api.manpasik.com/ai/health
# ... (모든 서비스)
```

### 5단계: 통합 테스트 실행

```bash
# 통합 테스트 실행
npm test --workspace=tests

# 예상 결과:
# ✓ Auth Service: Login endpoint (150ms)
# ✓ Measurement Service: Create measurement (200ms)
# ✓ Payment Service: Create payment (250ms)
# ... (100+ 테스트)
# 
# 테스트 완료: 100개 통과, 0개 실패
```

### 6단계: 부하 테스트 실행

```bash
# K6 부하 테스트 실행
k6 run tests/load-test.js

# 예상 결과:
# execution: local
#   scenario: default
#     iterations completed: 1000
#     duration: 26m30s
#     avg response time: 450ms
#     p95 response time: 1800ms
#     error rate: 0.08%
# 
# 성능 목표 달성: ✓
```

---

## 모니터링 & 로깅

### 1단계: Prometheus 설정

```bash
# Prometheus 차트 추가
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Prometheus 설치
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set prometheus.prometheusSpec.retention=30d \
  --set grafana.enabled=true

# Prometheus 접근
kubectl port-forward -n monitoring svc/prometheus-operated 9090:9090
# http://localhost:9090
```

### 2단계: Grafana 설정

```bash
# Grafana 접근
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
# http://localhost:3000 (기본 사용자: admin, 암호: prom-operator)

# 대시보드 임포트
# - Kubernetes Cluster Monitoring
# - Manpasik Services Overview
# - Database Performance
# - API Gateway Metrics
```

### 3단계: 로깅 설정 (ELK)

```bash
# Elasticsearch 설치
helm install elasticsearch elastic/elasticsearch \
  --namespace logging \
  --create-namespace \
  --set replicas=3 \
  --set volumeClaimTemplate.resources.requests.storage=50Gi

# Kibana 설치
helm install kibana elastic/kibana \
  --namespace logging \
  --create-namespace \
  --set elasticsearchHosts=http://elasticsearch-master:9200

# Filebeat 설치 (로그 수집)
helm install filebeat elastic/filebeat \
  --namespace logging \
  --create-namespace
```

### 4단계: 경고 규칙 설정

```bash
# 경고 규칙 생성
cat > alert-rules.yaml << 'EOF'
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: manpasik-alerts
  namespace: monitoring
spec:
  groups:
  - name: manpasik.rules
    interval: 30s
    rules:
    - alert: ServiceDown
      expr: up{job=~"manpasik-.*"} == 0
      for: 5m
      annotations:
        summary: "서비스 {{ $labels.job }}이(가) 다운되었습니다"
        
    - alert: HighErrorRate
      expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.01
      for: 5m
      annotations:
        summary: "높은 에러율 감지"
        
    - alert: HighLatency
      expr: histogram_quantile(0.95, http_request_duration_seconds) > 2
      for: 10m
      annotations:
        summary: "응답 시간이 높음 (> 2s)"
EOF

kubectl apply -f alert-rules.yaml
```

### 5단계: 대시보드 생성

```bash
# Grafana 대시보드 JSON 생성
cat > grafana-dashboard.json << 'EOF'
{
  "dashboard": {
    "title": "MANPASIK Services Overview",
    "panels": [
      {
        "title": "Request Rate",
        "targets": [{"expr": "rate(http_requests_total[5m])"}]
      },
      {
        "title": "Error Rate",
        "targets": [{"expr": "rate(http_requests_total{status=~\"5..\"}[5m])"}]
      },
      {
        "title": "Latency P95",
        "targets": [{"expr": "histogram_quantile(0.95, http_request_duration_seconds)"}]
      },
      {
        "title": "Service Health",
        "targets": [{"expr": "up{job=~\"manpasik-.*\"}"}]
      }
    ]
  }
}
EOF

# Grafana에 임포트
curl -X POST http://admin:prom-operator@localhost:3000/api/dashboards/db \
  -H 'Content-Type: application/json' \
  -d @grafana-dashboard.json
```

---

## 보안 설정

### 1단계: TLS/SSL 인증서 설정

```bash
# cert-manager 설치
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true

# Let's Encrypt ClusterIssuer 생성
cat > cluster-issuer.yaml << 'EOF'
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: admin@manpasik.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
EOF

kubectl apply -f cluster-issuer.yaml

# Ingress에서 TLS 사용
cat > ingress-tls.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: manpasik-ingress
  namespace: manpasik
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - api.manpasik.com
    - app.manpasik.com
    secretName: manpasik-tls
  rules:
  - host: api.manpasik.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-gateway
            port:
              number: 8080
EOF

kubectl apply -f ingress-tls.yaml
```

### 2단계: RBAC (역할 기반 접근 제어) 설정

```bash
# 서비스 계정 생성
kubectl create serviceaccount manpasik-user --namespace manpasik

# 역할 생성
cat > rbac.yaml << 'EOF'
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: manpasik-viewer
  namespace: manpasik
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: manpasik-viewer-binding
  namespace: manpasik
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: manpasik-viewer
subjects:
- kind: ServiceAccount
  name: manpasik-user
  namespace: manpasik
EOF

kubectl apply -f rbac.yaml
```

### 3단계: 네트워크 정책 설정

```bash
# 네트워크 정책 (Pod 격리)
cat > network-policy.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: manpasik-network-policy
  namespace: manpasik
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: api-gateway
    ports:
    - protocol: TCP
      port: 8000
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: database
    ports:
    - protocol: TCP
      port: 5432
  - to:
    - namespaceSelector:
        matchLabels:
          name: kube-system
    ports:
    - protocol: TCP
      port: 53
EOF

kubectl apply -f network-policy.yaml
```

### 4단계: 시크릿 암호화

```bash
# etcd 암호화 활성화 (Kubernetes 1.28+에서 기본값)
kubectl create secret generic mysql-password \
  --from-literal=password=$(openssl rand -base64 32) \
  --namespace manpasik

# 시크릿 조회 (암호화됨)
kubectl get secret mysql-password -o yaml --namespace manpasik
```

### 5단계: Pod 보안 정책

```bash
# Pod 보안 정책
cat > pod-security-policy.yaml << 'EOF'
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
  name: restricted
spec:
  privileged: false
  allowPrivilegeEscalation: false
  requiredDropCapabilities:
  - ALL
  volumes:
  - 'configMap'
  - 'emptyDir'
  - 'projected'
  - 'secret'
  - 'downwardAPI'
  - 'persistentVolumeClaim'
  hostNetwork: false
  hostIPC: false
  hostPID: false
  runAsUser:
    rule: 'MustRunAsNonRoot'
  seLinux:
    rule: 'MustRunAs'
    seLinuxOptions:
      level: "s0:c123,c456"
  readOnlyRootFilesystem: false
EOF

kubectl apply -f pod-security-policy.yaml
```

---

## 문제 해결

### Pod가 Starting 상태인 경우

```bash
# Pod 로그 확인
kubectl logs <pod-name> --namespace manpasik

# 이전 로그 확인 (크래시된 경우)
kubectl logs <pod-name> --previous --namespace manpasik

# Pod 상세 정보
kubectl describe pod <pod-name> --namespace manpasik

# 이벤트 확인
kubectl get events --namespace manpasik --sort-by='.lastTimestamp'
```

### 서비스 간 통신 오류

```bash
# DNS 해석 확인
kubectl exec -it <pod-name> -n manpasik -- nslookup auth-service

# 네트워크 정책 확인
kubectl get networkpolicy --namespace manpasik

# Pod 간 연결 테스트
kubectl run -it --image=busybox:1.28 debug --restart=Never -- wget -q -O- http://auth-service:8001/health
```

### 메모리/CPU 부족

```bash
# 리소스 사용량 확인
kubectl top nodes
kubectl top pods --namespace manpasik

# 노드 상세 정보
kubectl describe node <node-name>

# 자동 확장 상태 확인
kubectl get hpa --namespace manpasik

# 수동 스케일링 (필요 시)
kubectl scale deployment auth-service --replicas=5 --namespace manpasik
```

### 데이터베이스 연결 실패

```bash
# 서비스 엔드포인트 확인
kubectl get endpoints --namespace manpasik

# 데이터베이스 Pod 상태 확인
kubectl get pod -l app=postgres --namespace manpasik

# PVC 상태 확인
kubectl get pvc --namespace manpasik

# 저장소 이용 확인
kubectl exec -it postgres-0 -n manpasik -- df -h
```

### 인증 오류

```bash
# JWT 토큰 검증
curl -X POST https://api.manpasik.com/auth/validate \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json"

# 인증 로그 확인
kubectl logs -f deployment/auth-service --namespace manpasik

# 시크릿 확인
kubectl get secret manpasik-secrets -o yaml --namespace manpasik
```

---

## 재해 복구

### 1단계: 정기 백업 설정

```bash
# 백업 스토리지 클래스
cat > backup-storage.yaml << 'EOF'
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: backup-storage
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  iops: "3000"
allowVolumeExpansion: true
EOF

kubectl apply -f backup-storage.yaml

# 백업 스크립트
cat > backup.sh << 'SCRIPT'
#!/bin/bash
BACKUP_DIR="/backups/manpasik-$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR

# PostgreSQL 백업
kubectl exec -n manpasik postgres-0 -- \
  pg_dump -U manpasik manpasik_prod | \
  gzip > $BACKUP_DIR/postgres.sql.gz

# MongoDB 백업
kubectl exec -n manpasik mongodb-0 -- \
  mongodump --archive | \
  gzip > $BACKUP_DIR/mongodb.archive.gz

# Kubernetes 리소스 백업
kubectl get all -n manpasik -o yaml > $BACKUP_DIR/k8s-resources.yaml

# 클라우드 저장소로 업로드
aws s3 cp $BACKUP_DIR s3://manpasik-backups/ --recursive
SCRIPT

chmod +x backup.sh

# Cron Job 생성
cat > backup-cronjob.yaml << 'EOF'
apiVersion: batch/v1
kind: CronJob
metadata:
  name: manpasik-backup
  namespace: manpasik
spec:
  schedule: "0 2 * * *"  # 매일 오전 2시
  jobTemplate:
    spec:
      template:
        spec:
          serviceAccountName: backup-sa
          containers:
          - name: backup
            image: amazon/aws-cli
            command: ["/backup.sh"]
            volumeMounts:
            - name: backup-script
              mountPath: /backup.sh
              subPath: backup.sh
          volumes:
          - name: backup-script
            configMap:
              name: backup-script
              defaultMode: 0755
          restartPolicy: OnFailure
EOF
```

### 2단계: 재해 복구 계획

```bash
# RTO/RPO 목표
# RTO (복구 시간): 최대 1시간
# RPO (복구 데이터): 최대 15분

# 재해 복구 절차

## 데이터베이스 복구
kubectl exec -it postgres-0 -n manpasik -- \
  psql -U manpasik -d manpasik_prod < backup/postgres.sql

## 애플리케이션 복구
helm rollback manpasik --namespace manpasik

## 전체 클러스터 복구
# 1. 새 클러스터 생성
# 2. Kubernetes 매니페스트 재적용
# 3. 데이터베이스 백업 복구
# 4. DNS 업데이트 (새 엔드포인트로)
```

### 3단계: 복구 테스트

```bash
# 월간 복구 드릴 실행
# 1. 테스트 환경에서 백업 복구
# 2. 기능 검증
# 3. 성능 검증
# 4. 결과 문서화

# 복구 테스트 스크립트
cat > test-recovery.sh << 'SCRIPT'
#!/bin/bash
echo "복구 테스트 시작..."

# 테스트 네임스페이스 생성
kubectl create namespace manpasik-test

# 백업에서 복구
kubectl restore -f backup/postgres.sql -n manpasik-test

# 기능 테스트
npm test --workspace=tests --env=test

# 리포트 생성
echo "복구 테스트 완료: $(date)" > recovery-report.txt
SCRIPT
```

---

## 성능 튜닝

### 1단계: CPU/메모리 최적화

```bash
# 리소스 요청/제한 조정
cat > resource-optimization.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: auth-service
  namespace: manpasik
spec:
  template:
    spec:
      containers:
      - name: auth-service
        resources:
          requests:
            cpu: 100m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi
EOF

kubectl apply -f resource-optimization.yaml

# 실제 사용량 모니터링
kubectl top pods --namespace manpasik --sort-by=memory
kubectl top pods --namespace manpasik --sort-by=cpu
```

### 2단계: 캐싱 최적화

```bash
# Redis 캐시 정책 설정
redis-cli CONFIG SET maxmemory 1gb
redis-cli CONFIG SET maxmemory-policy allkeys-lru

# 캐시 히트율 모니터링
redis-cli INFO stats | grep -E "keyspace_hits|keyspace_misses"
```

### 3단계: 데이터베이스 최적화

```bash
# PostgreSQL 쿼리 분석
EXPLAIN ANALYZE SELECT * FROM measurements WHERE user_id = 123;

# 인덱스 생성
CREATE INDEX idx_user_measurements ON measurements(user_id);

# 느린 쿼리 로그 활성화
ALTER SYSTEM SET log_min_duration_statement = 1000;
```

### 4단계: 네트워크 최적화

```bash
# �연결 풀링 설정
# Node.js: pg-pool 모듈 사용
const pool = new Pool({
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

# 압축 활성화
# Nginx: gzip 활성화
gzip on;
gzip_types text/plain application/json;
```

### 5단계: 자동 확장 미세 조정

```bash
# HPA 정책 조정
kubectl patch hpa auth-service -n manpasik -p \
  '{"spec":{"maxReplicas":20,"metrics":[{"type":"Resource","resource":{"name":"cpu","target":{"type":"Utilization","averageUtilization":70}}}]}}'

# 스케일 다운 정책 조정 (느린 스케일 다운)
kubectl patch hpa auth-service -n manpasik --type merge -p \
  '{"spec":{"behavior":{"scaleDown":{"stabilizationWindowSeconds":300}}}}'
```

---

## 체크리스트

배포 전:
- [ ] 모든 컨테이너 이미지가 빌드되고 푸시됨
- [ ] 모든 시크릿이 생성됨
- [ ] 데이터베이스 백업 생성됨
- [ ] 롤백 계획이 문서화됨
- [ ] 팀이 교육을 받음

배포 중:
- [ ] Kubernetes 매니페스트 적용됨
- [ ] 모든 Pod가 Running 상태
- [ ] 헬스 체크 통과
- [ ] 로그에서 오류 없음
- [ ] 모니터링 활성화됨

배포 후:
- [ ] 통합 테스트 통과
- [ ] 부하 테스트 통과
- [ ] 성능 메트릭 확인
- [ ] 사용자 접근 가능 확인
- [ ] 정기 모니터링 시작

---

## 참고 자료

- [Kubernetes 공식 문서](https://kubernetes.io/docs/)
- [Helm 문서](https://helm.sh/docs/)
- [AWS EKS 문서](https://docs.aws.amazon.com/eks/)
- [Google GKE 문서](https://cloud.google.com/kubernetes-engine/docs)
- [Azure AKS 문서](https://learn.microsoft.com/en-us/azure/aks/)

---

**마지막 업데이트**: 2024-01-10  
**상태**: ✅ 프로덕션 준비 완료  
**유지보수**: Manpasik 팀

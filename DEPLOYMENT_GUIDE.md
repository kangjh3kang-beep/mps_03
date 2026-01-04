# Manpasik Ecosystem - Production Deployment Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Kubernetes Cluster Setup](#kubernetes-cluster-setup)
4. [Deploying with Kubectl](#deploying-with-kubectl)
5. [Deploying with Helm](#deploying-with-helm)
6. [Verification & Testing](#verification--testing)
7. [Monitoring & Logging](#monitoring--logging)
8. [Troubleshooting](#troubleshooting)
9. [Scaling & Performance Tuning](#scaling--performance-tuning)
10. [Backup & Disaster Recovery](#backup--disaster-recovery)

---

## Prerequisites

### Required Tools
```bash
# Kubernetes
kubectl v1.24+ (https://kubernetes.io/docs/tasks/tools/)
helm v3.0+ (https://helm.sh/docs/intro/install/)
kubeadm/kubelet (for cluster setup)

# Container & Image Management
docker v20.10+ (https://docs.docker.com/engine/install/)
docker-compose v1.29+ (for local development)
skopeo or podman (for image transfer)

# Cloud Providers (choose one)
# AWS EKS
aws-cli v2+ (https://aws.amazon.com/cli/)
eksctl (https://github.com/weaveworks/eksctl)

# Google GKE
gcloud CLI (https://cloud.google.com/sdk/docs/install)
gke-gcloud-auth-plugin

# Azure AKS
az CLI (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
```

### System Requirements
```
Kubernetes Cluster:
- Minimum 3 nodes (for production HA)
- Each node: 4 CPU cores, 8GB RAM minimum
- Storage: 50GB per node for Docker images
- Network: Low latency, high bandwidth between nodes

Total Cluster Resources:
- CPU: 12+ cores
- Memory: 32GB+ RAM
- Storage: 500GB+ (databases + logs)
- Bandwidth: 1Gbps+

Load Balancer:
- External load balancer (cloud provider) or Nginx ingress
- TLS/SSL support required
```

---

## Environment Setup

### 1. Set Environment Variables

```bash
# Create environment file
cat > ~/.manpasik-env << 'EOF'
# Cluster Configuration
CLUSTER_NAME=manpasik-prod
REGION=ap-northeast-2
NAMESPACE=manpasik

# Database Configuration
DB_USER=manpasik
DB_PASSWORD=$(openssl rand -base64 32)
DB_HOST=postgres.manpasik.svc.cluster.local
DB_PORT=5432

# Redis Configuration
REDIS_PASSWORD=$(openssl rand -base64 32)
REDIS_HOST=redis.manpasik.svc.cluster.local

# JWT Configuration
JWT_SECRET=$(openssl rand -base64 64)
JWT_EXPIRY=3600

# External Services
STRIPE_SECRET_KEY=sk_live_...
STRIPE_PUBLISHABLE_KEY=pk_live_...
AGORA_APP_ID=...
AGORA_APP_CERTIFICATE=...
GOOGLE_API_KEY=...

# Domain Configuration
API_DOMAIN=api.manpasik.com
APP_DOMAIN=app.manpasik.com
ADMIN_DOMAIN=admin.manpasik.com

# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=noreply@manpasik.com
SMTP_PASSWORD=...

# Monitoring
GRAFANA_ADMIN_PASSWORD=$(openssl rand -base64 32)
PROMETHEUS_RETENTION_DAYS=30

# Backup
BACKUP_RETENTION_DAYS=30
BACKUP_LOCATION=s3://manpasik-backups/
EOF

# Load environment
source ~/.manpasik-env
```

### 2. Create Kubernetes Secrets

```bash
# Create namespace
kubectl create namespace $NAMESPACE

# Create database credentials secret
kubectl create secret generic mps-secrets \
  --from-literal=db-user="$DB_USER" \
  --from-literal=db-password="$DB_PASSWORD" \
  --from-literal=jwt-secret="$JWT_SECRET" \
  --from-literal=redis-password="$REDIS_PASSWORD" \
  --from-literal=stripe-secret-key="$STRIPE_SECRET_KEY" \
  --from-literal=agora-app-id="$AGORA_APP_ID" \
  --from-literal=agora-certificate="$AGORA_APP_CERTIFICATE" \
  -n $NAMESPACE

# Create registry credentials (if using private registry)
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=$GITHUB_USER \
  --docker-password=$GITHUB_TOKEN \
  -n $NAMESPACE

# Verify secrets
kubectl get secrets -n $NAMESPACE
```

### 3. Create ConfigMap

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: mps-config
  namespace: $NAMESPACE
data:
  API_DOMAIN: "$API_DOMAIN"
  APP_DOMAIN: "$APP_DOMAIN"
  DB_HOST: "$DB_HOST"
  DB_PORT: "$DB_PORT"
  REDIS_HOST: "$REDIS_HOST"
  JWT_EXPIRY: "$JWT_EXPIRY"
  ENVIRONMENT: "production"
  LOG_LEVEL: "info"
EOF
```

---

## Kubernetes Cluster Setup

### AWS EKS (Recommended)

```bash
# 1. Create EKS cluster with eksctl
eksctl create cluster \
  --name=$CLUSTER_NAME \
  --region=$REGION \
  --nodes=3 \
  --node-type=t3.xlarge \
  --enable-ssm \
  --auto-update-cluster-config \
  --tags=Environment=Production,Team=Manpasik

# 2. Update kubeconfig
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME

# 3. Verify cluster
kubectl cluster-info
kubectl get nodes

# 4. Install AWS Load Balancer Controller
helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$CLUSTER_NAME

# 5. Create storage class
kubectl apply -f - <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-gp3
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  iops: "3000"
  throughput: "125"
  encrypted: "true"
allowVolumeExpansion: true
EOF
```

### Google GKE

```bash
# 1. Create GKE cluster
gcloud container clusters create $CLUSTER_NAME \
  --region=$REGION \
  --num-nodes=3 \
  --machine-type=n1-standard-4 \
  --enable-autoscaling \
  --min-nodes=3 \
  --max-nodes=10 \
  --enable-autorepair \
  --enable-autoupgrade \
  --enable-vertical-pod-autoscaling

# 2. Get credentials
gcloud container clusters get-credentials $CLUSTER_NAME --region=$REGION

# 3. Verify cluster
kubectl cluster-info
```

### Azure AKS

```bash
# 1. Create resource group
az group create --name manpasik-rg --location eastasia

# 2. Create AKS cluster
az aks create \
  --resource-group manpasik-rg \
  --name $CLUSTER_NAME \
  --node-count 3 \
  --vm-set-type VirtualMachineScaleSets \
  --load-balancer-sku standard \
  --enable-managed-identity \
  --enable-addons monitoring

# 3. Get credentials
az aks get-credentials --resource-group manpasik-rg --name $CLUSTER_NAME
```

---

## Deploying with Kubectl

### 1. Deploy Infrastructure Layer

```bash
# Apply infrastructure manifests
kubectl apply -f deploy/k8s/00-infrastructure.yaml -n $NAMESPACE

# Wait for databases to be ready
kubectl wait --for=condition=ready pod \
  -l app=postgres \
  -n $NAMESPACE \
  --timeout=300s

kubectl wait --for=condition=ready pod \
  -l app=mongo \
  -n $NAMESPACE \
  --timeout=300s

# Verify infrastructure
kubectl get pvc,pv,configmap,secret -n $NAMESPACE
```

### 2. Deploy Microservices

```bash
# Apply service manifests
kubectl apply -f deploy/k8s/01-services.yaml -n $NAMESPACE

# Monitor rollout
kubectl rollout status deployment -n $NAMESPACE --timeout=600s

# Verify services
kubectl get deployments,services -n $NAMESPACE
```

### 3. Deploy Networking

```bash
# Install Nginx Ingress Controller (if not using cloud provider)
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --values deploy/helm/ingress-values.yaml

# Apply ingress manifests
kubectl apply -f deploy/k8s/02-ingress.yaml -n $NAMESPACE

# Wait for external IP
kubectl get ingress -n $NAMESPACE --watch
```

### 4. Deploy Autoscaling

```bash
# Apply autoscaling manifests
kubectl apply -f deploy/k8s/03-autoscaling.yaml -n $NAMESPACE

# Verify HPA status
kubectl get hpa -n $NAMESPACE
```

---

## Deploying with Helm

### 1. Add Helm Repository

```bash
# Add Manpasik Helm repo (if using chart registry)
helm repo add manpasik https://charts.manpasik.com
helm repo update

# Or use local chart
cd deploy/helm/
```

### 2. Create Values Override

```bash
cat > values-production.yaml << 'EOF'
global:
  environment: production
  domain: manpasik.com

postgresql:
  auth:
    password: $DB_PASSWORD

mongodb:
  auth:
    password: $DB_PASSWORD

redis:
  auth:
    password: $REDIS_PASSWORD

secrets:
  jwtSecret: $JWT_SECRET
  stripeSecretKey: $STRIPE_SECRET_KEY

services:
  api-gateway:
    replicas: 3
    autoscaling:
      maxReplicas: 20

monitoring:
  enabled: true
  grafana:
    adminPassword: $GRAFANA_ADMIN_PASSWORD
EOF
```

### 3. Install Helm Chart

```bash
# Install or upgrade release
helm upgrade --install manpasik ./deploy/helm/manpasik \
  -f values-production.yaml \
  -n $NAMESPACE \
  --create-namespace \
  --timeout=10m \
  --wait

# Monitor installation
helm status manpasik -n $NAMESPACE

# View release history
helm history manpasik -n $NAMESPACE
```

---

## Verification & Testing

### 1. Pod Health Check

```bash
# Check all pods running
kubectl get pods -n $NAMESPACE

# Detailed pod status
kubectl describe pod <pod-name> -n $NAMESPACE

# Check pod logs
kubectl logs <pod-name> -n $NAMESPACE --tail=100

# Stream logs (follow)
kubectl logs -f <pod-name> -n $NAMESPACE
```

### 2. Service Health Check

```bash
# Check service endpoints
kubectl get endpoints -n $NAMESPACE

# Test service connectivity (port-forward)
kubectl port-forward svc/api-gateway 8080:8080 -n $NAMESPACE
curl http://localhost:8080/health

# Test from pod
kubectl exec -it <pod-name> -n $NAMESPACE -- curl http://api-gateway:8080/health
```

### 3. Database Connection

```bash
# Test PostgreSQL
kubectl exec -it postgres-0 -n $NAMESPACE -- \
  psql -U $DB_USER -d mps_db -c "SELECT version();"

# Test MongoDB
kubectl exec -it mongo-0 -n $NAMESPACE -- \
  mongosh --host mongo --eval "db.adminCommand('ping')"

# Test Redis
kubectl exec -it redis-0 -n $NAMESPACE -- \
  redis-cli ping
```

### 4. Run Integration Tests

```bash
# Port-forward API Gateway
kubectl port-forward svc/api-gateway 8080:8080 -n $NAMESPACE &

# Run test suite
npm test -- tests/integration.test.ts

# Or with Jest
jest --runInBand tests/integration.test.ts
```

### 5. Load Testing

```bash
# Install k6 (load testing tool)
npm install -g k6

# Run load test
k6 run tests/load-test.js
```

---

## Monitoring & Logging

### 1. Install Prometheus & Grafana

```bash
# Add Prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --create-namespace \
  --values deploy/helm/prometheus-values.yaml

# Verify installation
kubectl get pods -n monitoring
```

### 2. Access Grafana

```bash
# Port-forward Grafana
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80 &

# Access at: http://localhost:3000
# Default credentials: admin / prom-operator

# Import dashboards
# - Kubernetes Cluster Monitoring
# - Node Exporter
# - Nginx Ingress Controller
```

### 3. Configure Application Monitoring

```bash
# Enable metrics endpoints
kubectl apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: app-metrics
  namespace: $NAMESPACE
  labels:
    app: api-gateway
spec:
  selector:
    app: api-gateway
  ports:
  - port: 9090
    name: metrics
EOF
```

### 4. Set Up Logging with ELK Stack

```bash
# Install Elasticsearch, Logstash, Kibana
helm repo add elastic https://helm.elastic.co
helm repo update

# Install Elasticsearch
helm install elasticsearch elastic/elasticsearch \
  -n logging \
  --create-namespace

# Install Kibana
helm install kibana elastic/kibana \
  -n logging

# Access Kibana
kubectl port-forward -n logging svc/kibana-kibana 5601:5601 &
# Visit: http://localhost:5601
```

---

## Troubleshooting

### Common Issues

```bash
# 1. Pod not starting
kubectl describe pod <pod-name> -n $NAMESPACE
kubectl logs <pod-name> -n $NAMESPACE --previous

# 2. CrashLoopBackOff
# Check resource limits
kubectl describe pod <pod-name> -n $NAMESPACE | grep -A 5 "Limits"

# 3. ImagePullBackOff
# Check image credentials
kubectl describe secret ghcr-secret -n $NAMESPACE

# 4. PVC not binding
kubectl describe pvc <pvc-name> -n $NAMESPACE
kubectl get events -n $NAMESPACE

# 5. Network issues
kubectl run -it --rm debug --image=busybox --restart=Never -n $NAMESPACE -- sh
# Inside pod: ping, nslookup, nc commands

# 6. Database connection errors
kubectl exec -it <service-pod> -n $NAMESPACE -- env | grep DB_
```

### Debug Commands

```bash
# Get all resources
kubectl get all -n $NAMESPACE

# Check resource usage
kubectl top nodes
kubectl top pods -n $NAMESPACE

# View events
kubectl get events -n $NAMESPACE --sort-by='.lastTimestamp'

# Check RBAC permissions
kubectl auth can-i create deployments --as=system:serviceaccount:$NAMESPACE:default

# Dry run deployment
kubectl apply -f deploy/k8s/01-services.yaml -n $NAMESPACE --dry-run=client -o yaml
```

---

## Scaling & Performance Tuning

### 1. Horizontal Pod Autoscaling

```bash
# View HPA status
kubectl get hpa -n $NAMESPACE

# Manual scaling
kubectl scale deployment api-gateway --replicas=5 -n $NAMESPACE

# Check metrics
kubectl get hpa api-gateway-hpa -n $NAMESPACE --watch
```

### 2. Vertical Pod Autoscaling (VPA)

```bash
# Install VPA
git clone https://github.com/kubernetes/autoscaler.git
cd autoscaler/vertical-pod-autoscaler
./hack/vpa-up.sh

# Monitor VPA recommendations
kubectl describe vpa <vpa-name> -n $NAMESPACE
```

### 3. Resource Optimization

```bash
# Analyze resource requests/limits
kubectl get pods -n $NAMESPACE -o json | \
  jq '.items[] | {name: .metadata.name, resources: .spec.containers[].resources}'

# Update resource limits
kubectl set resources deployment api-gateway \
  -n $NAMESPACE \
  --limits=cpu=1,memory=1Gi \
  --requests=cpu=500m,memory=512Mi
```

---

## Backup & Disaster Recovery

### 1. Database Backups

```bash
# PostgreSQL backup
kubectl exec -i postgres-0 -n $NAMESPACE -- \
  pg_dump -U $DB_USER mps_db | gzip > backup-$(date +%Y%m%d).sql.gz

# MongoDB backup
kubectl exec -i mongo-0 -n $NAMESPACE -- \
  mongodump --uri="mongodb://localhost:27017" --archive | gzip > mongo-backup-$(date +%Y%m%d).archive.gz

# Restore from backup
kubectl exec -i postgres-0 -n $NAMESPACE -- \
  gunzip < backup-20240101.sql.gz | psql -U $DB_USER mps_db
```

### 2. Automated Backup with Velero

```bash
# Install Velero
velero install \
  --provider aws \
  --bucket manpasik-backups \
  --secret-file ./credentials-velero

# Create backup schedule
velero schedule create daily-backup --schedule="0 2 * * *"

# View backups
velero backup get

# Restore from backup
velero restore create --from-backup daily-backup-20240101
```

### 3. Cluster Backup

```bash
# Backup all resources
kubectl get all -A -o yaml > cluster-backup-$(date +%Y%m%d).yaml

# Backup ETCD (if self-hosted cluster)
etcdctl snapshot save backup-$(date +%Y%m%d).db
```

---

## Final Verification

```bash
# Health check dashboard
./scripts/health-check.sh

# Performance test
npm run test:performance

# Security scan
kubectl scan ns -l app=api-gateway

# Compliance check
./scripts/compliance-check.sh
```

---

## Support & Documentation

- **Documentation**: https://docs.manpasik.com
- **Support Portal**: https://support.manpasik.com
- **GitHub Issues**: https://github.com/manpasik/ecosystem/issues
- **Community Discord**: https://discord.gg/manpasik

---

**Last Updated**: 2024-01-10
**Version**: 1.0.0
**Status**: Production Ready ✅

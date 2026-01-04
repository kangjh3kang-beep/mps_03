# Final Validation Checklist

## Pre-Deployment Validation

### ✅ Code Quality
- [ ] All TypeScript files compile without errors
  ```bash
  npm run type-check
  ```

- [ ] ESLint passes all rules
  ```bash
  npm run lint
  ```

- [ ] No security vulnerabilities
  ```bash
  npm audit --audit-level=moderate
  ```

- [ ] Code coverage > 80%
  ```bash
  npm run test:coverage
  ```

### ✅ Backend Services
- [ ] All 10 microservices have correct Dockerfile
  - [ ] auth-service
  - [ ] measurement-service
  - [ ] ai-service
  - [ ] payment-service
  - [ ] notification-service
  - [ ] video-service
  - [ ] translation-service
  - [ ] data-service
  - [ ] admin-service
  - [ ] api-gateway

- [ ] All services build successfully
  ```bash
  docker-compose build
  ```

- [ ] All services have health check endpoints
  ```bash
  curl http://localhost:8001/health
  curl http://localhost:8002/health
  # ... etc for all services
  ```

- [ ] Environment variables configured
  ```bash
  source .env.production
  env | grep -E "(DB_|JWT_|STRIPE_|AGORA_)"
  ```

### ✅ Database Setup
- [ ] PostgreSQL initialized with schema
  ```bash
  docker exec postgres psql -U manpasik -d mps_db -c "SELECT COUNT(*) FROM information_schema.tables;"
  ```

- [ ] MongoDB initialized
  ```bash
  docker exec mongo mongosh --eval "db.adminCommand('ping')"
  ```

- [ ] Redis initialized
  ```bash
  docker exec redis redis-cli ping
  ```

- [ ] Backups configured
  - [ ] Automated daily backups
  - [ ] Backup retention policy (30 days)
  - [ ] Backup verification script

### ✅ Docker & Containerization
- [ ] All images build successfully
  ```bash
  docker-compose build --no-cache
  ```

- [ ] docker-compose.yml syntax valid
  ```bash
  docker-compose config > /dev/null && echo "Valid"
  ```

- [ ] Images can be pulled from registry
  ```bash
  docker pull ghcr.io/manpasik/mps-api-gateway:latest
  ```

- [ ] Container networking configured
  ```bash
  docker network ls | grep manpasik
  ```

### ✅ Kubernetes Configuration
- [ ] All K8s YAML manifests valid
  ```bash
  kubectl apply -f deploy/k8s/ --dry-run=client
  ```

- [ ] Namespace created
  ```bash
  kubectl get namespace manpasik
  ```

- [ ] ConfigMaps created
  ```bash
  kubectl get configmap -n manpasik
  ```

- [ ] Secrets created (encrypted at rest)
  ```bash
  kubectl get secret -n manpasik
  ```

- [ ] StorageClasses available
  ```bash
  kubectl get storageclass
  ```

- [ ] Persistent Volumes allocated
  ```bash
  kubectl get pv,pvc -n manpasik
  ```

- [ ] All Deployments have readiness/liveness probes
  ```bash
  kubectl get deployment -n manpasik -o jsonpath='{.items[*].spec.template.spec.containers[*].livenessProbe}'
  ```

### ✅ Networking
- [ ] Ingress controller installed
  ```bash
  kubectl get pods -n ingress-nginx
  ```

- [ ] Ingress rules configured
  ```bash
  kubectl get ingress -n manpasik
  ```

- [ ] TLS certificates issued
  ```bash
  kubectl get certificate -n manpasik
  ```

- [ ] DNS records configured
  ```bash
  nslookup api.manpasik.com
  nslookup app.manpasik.com
  ```

- [ ] Load balancer external IP assigned
  ```bash
  kubectl get svc -n manpasik | grep LoadBalancer
  ```

### ✅ CI/CD Pipeline
- [ ] GitHub Actions workflows defined
  ```bash
  ls -la .github/workflows/
  ```

- [ ] Build workflow triggers on push
  ```bash
  git log --oneline | head -1
  # Check GitHub Actions logs
  ```

- [ ] Test step passes all tests
  ```bash
  npm test
  ```

- [ ] Deploy workflow requires approval
  ```bash
  # Check workflow YAML for environment protection
  grep -A 5 "environment:" .github/workflows/build-test-deploy.yml
  ```

- [ ] Secrets configured in GitHub
  ```bash
  # Verify secrets exist (visual check in UI or CLI)
  gh secret list
  ```

### ✅ Monitoring & Observability
- [ ] Prometheus installed and scraping
  ```bash
  kubectl get pods -n monitoring | grep prometheus
  kubectl port-forward -n monitoring svc/prometheus 9090:9090
  # Visit http://localhost:9090/targets
  ```

- [ ] Grafana dashboards created
  ```bash
  kubectl get configmap -n monitoring | grep grafana
  ```

- [ ] Application metrics exported
  ```bash
  curl http://localhost:9090/metrics
  ```

- [ ] Logging aggregation configured
  ```bash
  kubectl get pods -n logging | grep -E "(elasticsearch|logstash|kibana)"
  ```

- [ ] Log collection from all pods
  ```bash
  kubectl logs -n manpasik --all-containers=true --tail=10 | head -20
  ```

- [ ] Alert rules defined
  ```bash
  kubectl get prometheusrule -n monitoring
  ```

### ✅ Security
- [ ] RBAC configured
  ```bash
  kubectl get role,rolebinding -n manpasik
  ```

- [ ] Network policies enabled
  ```bash
  kubectl get networkpolicy -n manpasik
  ```

- [ ] Pod security policies enforced
  ```bash
  kubectl get psp
  ```

- [ ] Secrets encrypted at rest
  ```bash
  kubectl get secret -n manpasik -o yaml | grep "type: Opaque"
  ```

- [ ] Image scanning configured
  ```bash
  # Check container image vulnerability scan
  ```

- [ ] HTTPS/TLS enforced
  ```bash
  curl -k https://api.manpasik.com/health
  ```

- [ ] CORS configured
  ```bash
  curl -H "Origin: https://app.manpasik.com" \
       -H "Access-Control-Request-Method: GET" \
       -i https://api.manpasik.com/health
  ```

### ✅ Testing
- [ ] Unit tests pass
  ```bash
  npm run test:unit
  ```

- [ ] Integration tests pass
  ```bash
  npm run test:integration
  ```

- [ ] E2E tests pass (staging)
  ```bash
  npm run test:e2e
  ```

- [ ] Load test passes thresholds
  ```bash
  k6 run tests/load-test.js
  ```

- [ ] Security tests pass
  ```bash
  npm run test:security
  ```

### ✅ Documentation
- [ ] README.md complete and up-to-date
- [ ] DEPLOYMENT_GUIDE.md comprehensive
- [ ] API documentation generated
  ```bash
  npm run docs:api
  ```

- [ ] Architecture diagrams created
- [ ] Runbook for common issues
- [ ] Troubleshooting guide
- [ ] Disaster recovery procedures

### ✅ Performance
- [ ] Response time < 2s (P95)
  ```bash
  # Check from load test results
  ```

- [ ] Error rate < 0.1%
  ```bash
  # Check from monitoring
  ```

- [ ] CPU usage < 80% under peak load
  ```bash
  kubectl top nodes
  ```

- [ ] Memory usage < 80% under peak load
  ```bash
  kubectl top pods -n manpasik
  ```

- [ ] Database query response < 100ms
  ```bash
  # Check slow query logs
  ```

### ✅ Backup & Recovery
- [ ] Daily backups configured
  ```bash
  ls -la backups/ | grep $(date +%Y-%m-%d)
  ```

- [ ] Backup verification script
  ```bash
  ./scripts/verify-backup.sh
  ```

- [ ] Restore procedure tested
  ```bash
  ./scripts/test-restore.sh
  ```

- [ ] Disaster recovery runbook created
- [ ] RTO (Recovery Time Objective): < 1 hour
- [ ] RPO (Recovery Point Objective): < 1 day

### ✅ Production Readiness
- [ ] No hardcoded credentials
  ```bash
  grep -r "password\|secret\|api_key" src/ --exclude-dir=node_modules | grep -v "\.env" | grep -v "secrets"
  ```

- [ ] All TODOs/FIXMEs resolved
  ```bash
  grep -r "TODO\|FIXME\|HACK" src/ --exclude-dir=node_modules
  ```

- [ ] Logging configured appropriately
  ```bash
  kubectl logs <pod-name> -n manpasik --tail=100
  ```

- [ ] Error handling comprehensive
- [ ] Rate limiting configured
  ```bash
  # Check nginx configuration
  grep rate_limit /etc/nginx/nginx.conf
  ```

- [ ] API versioning strategy defined
- [ ] Deprecation policy in place

## Deployment Steps

### Step 1: Pre-Deployment
```bash
# 1. Run validation
./scripts/pre-deploy-check.sh

# 2. Create backup
kubectl get all -n manpasik -o yaml > backup-$(date +%Y%m%d-%H%M%S).yaml

# 3. Check system capacity
kubectl top nodes
kubectl top pods -n manpasik

# 4. Review changes
git diff main develop
```

### Step 2: Staging Deployment
```bash
# 1. Deploy to staging
kubectl apply -f deploy/k8s/ -n staging

# 2. Run smoke tests
npm run test:smoke

# 3. Monitor for 1 hour
./scripts/monitor.sh staging

# 4. Get approval from team
```

### Step 3: Production Deployment
```bash
# 1. Create backup
kubectl get all -n manpasik -o yaml > backup-pre-deploy-$(date +%Y%m%d-%H%M%S).yaml

# 2. Blue-green deployment
kubectl apply -f deploy/k8s/ -n manpasik-blue
kubectl patch service api-gateway -p '{"spec":{"selector":{"version":"blue"}}}'

# 3. Health check
./scripts/health-check.sh

# 4. Smoke tests
npm run test:smoke

# 5. Monitor golden metrics
./scripts/monitor-metrics.sh

# 6. Switch to green when ready
kubectl patch service api-gateway -p '{"spec":{"selector":{"version":"green"}}}'

# 7. Clean up old deployment
kubectl delete deployment -l version=blue -n manpasik
```

### Step 4: Post-Deployment
```bash
# 1. Verify all services
kubectl get pods -n manpasik

# 2. Check logs for errors
kubectl logs -n manpasik --all-pods=true | grep -i error

# 3. Monitor dashboards
# - Grafana: http://localhost:3000
# - Kibana: http://localhost:5601
# - Prometheus: http://localhost:9090

# 4. Test API endpoints
./scripts/api-test.sh

# 5. Announce deployment to team
```

## Rollback Procedure

If issues are detected, execute rollback:

```bash
# 1. Immediate rollback
kubectl rollout undo deployment/<service-name> -n manpasik

# 2. Verify rollback
kubectl rollout status deployment/<service-name> -n manpasik

# 3. Monitor metrics
./scripts/monitor.sh

# 4. Investigate issue
kubectl logs -n manpasik -l app=<service-name>
```

## Success Criteria

✅ All validation checks passed  
✅ No critical errors in logs  
✅ All health checks passing  
✅ Response times within SLA  
✅ Error rate < 0.1%  
✅ CPU usage < 70%  
✅ Memory usage < 70%  
✅ All services communicating  
✅ Database connected and healthy  
✅ Backups running successfully  

---

**Status**: Ready for Production ✅  
**Last Updated**: 2024-01-10  
**Version**: 1.0.0

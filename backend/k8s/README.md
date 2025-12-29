# Kubernetes Deployment for Gold Platform Backend

This directory contains Kubernetes manifests for deploying the Gold Platform backend with containerd runtime.

## Prerequisites

- Kubernetes cluster (1.24+) with containerd runtime
- kubectl configured to access your cluster
- Container registry access (Docker Hub, GCR, ECR, etc.)
- Ingress controller (nginx-ingress recommended)
- cert-manager for TLS certificates (optional)

## Architecture

```
┌─────────────────────────────────────────────────┐
│                   Ingress                        │
│            (api.goldplatform.com)                │
└─────────────────┬───────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────┐
│          Backend Service (ClusterIP)            │
│                  Port: 8000                      │
└─────────────────┬───────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────┐
│        Backend Deployment (3-10 replicas)       │
│              with HPA enabled                    │
└──────────┬──────────────────────┬────────────────┘
           │                      │
┌──────────▼──────────┐  ┌───────▼────────────────┐
│  PostgreSQL         │  │      Redis             │
│  StatefulSet        │  │   Deployment           │
│  (Persistent)       │  │   (Ephemeral)          │
└─────────────────────┘  └────────────────────────┘
```

## Quick Start

### 1. Build and Push Docker Image

```bash
# Build the image
docker build -t your-registry/gold-platform-backend:latest -f Dockerfile ..

# Push to registry
docker push your-registry/gold-platform-backend:latest
```

### 2. Update Configuration

Edit `secret.yaml` and replace placeholder values:
- `DATABASE_URL` - PostgreSQL connection string
- `SECRET_KEY` - JWT secret key (generate with `openssl rand -hex 32`)
- `MARKET_DATA_API_KEY` - Your market data API key
- `POSTGRES_PASSWORD` - Secure PostgreSQL password

Edit `backend-deployment.yaml` and update the image name:
```yaml
image: your-registry/gold-platform-backend:latest
```

### 3. Deploy to Kubernetes

Using kubectl:
```bash
kubectl apply -f namespace.yaml
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f postgres-statefulset.yaml
kubectl apply -f redis-deployment.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f ingress.yaml
kubectl apply -f hpa.yaml
```

Or using kustomize:
```bash
kubectl apply -k .
```

### 4. Verify Deployment

```bash
# Check all resources
kubectl get all -n gold-platform

# Check pod status
kubectl get pods -n gold-platform

# Check logs
kubectl logs -n gold-platform -l app=backend --tail=100

# Check service endpoints
kubectl get endpoints -n gold-platform
```

### 5. Run Database Migrations

```bash
# Get backend pod name
POD=$(kubectl get pod -n gold-platform -l app=backend -o jsonpath='{.items[0].metadata.name}')

# Run migrations
kubectl exec -n gold-platform $POD -- alembic upgrade head
```

## Scaling

### Manual Scaling
```bash
kubectl scale deployment backend -n gold-platform --replicas=5
```

### Auto-scaling (HPA)
The HPA is configured to scale between 3-10 replicas based on:
- CPU utilization (target: 70%)
- Memory utilization (target: 80%)

## Monitoring

### Check HPA Status
```bash
kubectl get hpa -n gold-platform
```

### View Metrics
```bash
kubectl top pods -n gold-platform
kubectl top nodes
```

## Troubleshooting

### Pod not starting
```bash
kubectl describe pod <pod-name> -n gold-platform
kubectl logs <pod-name> -n gold-platform
```

### Database connection issues
```bash
# Test PostgreSQL connectivity
kubectl exec -n gold-platform <backend-pod> -- pg_isready -h postgres-service -p 5432

# Check PostgreSQL logs
kubectl logs -n gold-platform postgres-0
```

### Redis connection issues
```bash
# Test Redis connectivity
kubectl exec -n gold-platform <backend-pod> -- redis-cli -h redis-service ping
```

## Cleanup

```bash
# Delete all resources
kubectl delete -k .

# Or delete namespace (removes everything)
kubectl delete namespace gold-platform
```

## Production Considerations

1. **Secrets Management**: Use external secret managers (Vault, AWS Secrets Manager, etc.)
2. **Database Backup**: Set up automated PostgreSQL backups
3. **Monitoring**: Deploy Prometheus + Grafana for metrics
4. **Logging**: Use EFK/ELK stack for centralized logging
5. **Resource Limits**: Adjust based on actual usage patterns
6. **Network Policies**: Implement network policies for security
7. **Pod Security**: Enable Pod Security Standards
8. **TLS**: Configure cert-manager for automatic certificate renewal

## containerd Runtime

This deployment is compatible with containerd runtime. Ensure your Kubernetes cluster is configured with containerd:

```bash
# Verify containerd runtime
kubectl get nodes -o wide
# Look for CONTAINER-RUNTIME column showing containerd://
```

No special configuration is needed - Kubernetes with containerd will automatically use the containerd runtime for all pods.


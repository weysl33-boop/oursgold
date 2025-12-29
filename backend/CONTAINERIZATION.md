# Containerization Guide - Gold Platform Backend

This document describes the containerization strategy for the Gold Platform backend using **containerd** runtime and **PostgreSQL** database.

## Overview

The backend is containerized using Docker and can be deployed to:
- **Local Development**: Docker Compose
- **Production**: Kubernetes with containerd runtime

## Technology Stack

- **Container Runtime**: containerd (via Docker/Kubernetes)
- **Database**: PostgreSQL 14
- **Cache**: Redis 6
- **Orchestration**: Kubernetes
- **Image Registry**: Docker Hub / GCR / ECR / ACR

## Architecture

### Container Images

1. **Backend Application** (`gold-platform-backend:latest`)
   - Multi-stage build for optimized size
   - Non-root user for security
   - Health checks included
   - Production-ready with 4 workers

2. **PostgreSQL** (`postgres:14-alpine`)
   - Official PostgreSQL image
   - Persistent storage via StatefulSet
   - Health checks configured

3. **Redis** (`redis:6-alpine`)
   - Official Redis image
   - Ephemeral storage (cache only)
   - Health checks configured

### Deployment Options

#### Option 1: Local Development (Docker Compose)

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f backend

# Stop services
docker-compose down
```

**Features**:
- Hot reload enabled
- Volume mounts for code changes
- PostgreSQL and Redis included
- Suitable for development only

#### Option 2: Production (Kubernetes + containerd)

```bash
# Build and push image
cd scripts
./build-and-push.sh

# Deploy to Kubernetes
./deploy-k8s.sh
```

**Features**:
- High availability (3-10 replicas)
- Auto-scaling (HPA)
- Persistent PostgreSQL storage
- TLS/SSL support
- Health checks and probes
- Resource limits
- Production-ready

## containerd Runtime

### What is containerd?

containerd is an industry-standard container runtime that:
- Manages container lifecycle
- Pulls and stores images
- Executes containers
- Provides low-level container primitives

### Why containerd?

1. **Performance**: Lightweight and fast
2. **Security**: Minimal attack surface
3. **Stability**: Production-grade runtime
4. **Kubernetes Native**: Default runtime in Kubernetes 1.24+
5. **OCI Compliant**: Follows Open Container Initiative standards

### Verification

Check if your Kubernetes cluster uses containerd:

```bash
kubectl get nodes -o wide
# Look for CONTAINER-RUNTIME column showing "containerd://x.x.x"
```

### Compatibility

All Docker images are OCI-compliant and work seamlessly with containerd. No special configuration needed.

## PostgreSQL Configuration

### Local Development

```yaml
# docker-compose.yml
postgres:
  image: postgres:14-alpine
  environment:
    POSTGRES_DB: gold_platform
    POSTGRES_USER: postgres
    POSTGRES_PASSWORD: postgres
  volumes:
    - postgres_data:/var/lib/postgresql/data
```

### Production (Kubernetes)

```yaml
# StatefulSet with persistent storage
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  volumeClaimTemplates:
  - metadata:
      name: postgres-storage
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

**Features**:
- Persistent storage (10Gi default)
- StatefulSet for stable network identity
- Health checks (pg_isready)
- Resource limits
- Automatic backups (configure separately)

### Connection String

```
postgresql+asyncpg://postgres:password@postgres-service:5432/gold_platform
```

## Build Process

### Multi-Stage Dockerfile

```dockerfile
# Stage 1: Builder - Install dependencies
FROM python:3.11-slim as builder
# ... install build dependencies

# Stage 2: Runtime - Minimal image
FROM python:3.11-slim
# ... copy only runtime dependencies
```

**Benefits**:
- Smaller image size (~200MB vs ~500MB)
- Faster deployment
- Reduced attack surface
- Better layer caching

### Build Commands

```bash
# Local build
docker build -t gold-platform-backend:latest .

# Multi-platform build (for ARM/AMD64)
docker buildx build --platform linux/amd64,linux/arm64 -t gold-platform-backend:latest .

# Build with specific version
docker build -t gold-platform-backend:v1.0.0 .
```

## Deployment Workflow

### Development Workflow

1. Make code changes
2. Docker Compose auto-reloads
3. Test locally
4. Commit changes

### Production Workflow

1. **Build**: Create Docker image
   ```bash
   ./scripts/build-and-push.sh
   ```

2. **Push**: Upload to registry
   ```bash
   docker push your-registry/gold-platform-backend:latest
   ```

3. **Deploy**: Apply to Kubernetes
   ```bash
   ./scripts/deploy-k8s.sh
   ```

4. **Migrate**: Run database migrations
   ```bash
   kubectl exec -n gold-platform <pod> -- alembic upgrade head
   ```

5. **Verify**: Check deployment
   ```bash
   kubectl get pods -n gold-platform
   kubectl logs -n gold-platform -l app=backend
   ```

## Security Best Practices

1. **Non-root User**: Container runs as user `appuser` (UID 1000)
2. **Secrets Management**: Use Kubernetes Secrets (not hardcoded)
3. **Image Scanning**: Scan images for vulnerabilities
4. **Resource Limits**: Set CPU/memory limits
5. **Network Policies**: Restrict pod-to-pod communication
6. **TLS**: Enable HTTPS with cert-manager
7. **Read-only Filesystem**: Consider read-only root filesystem

## Monitoring & Observability

### Health Checks

- **Liveness Probe**: `/health` endpoint (HTTP GET)
- **Readiness Probe**: `/health` endpoint (HTTP GET)
- **Startup Probe**: Initial delay 30s

### Metrics

- Prometheus metrics (add prometheus-client)
- Custom application metrics
- Database connection pool metrics

### Logging

- Structured JSON logging
- Centralized logging (EFK/ELK stack)
- Log aggregation in Kubernetes

## Troubleshooting

### Container won't start

```bash
# Check pod events
kubectl describe pod <pod-name> -n gold-platform

# Check logs
kubectl logs <pod-name> -n gold-platform

# Check previous container logs
kubectl logs <pod-name> -n gold-platform --previous
```

### Database connection failed

```bash
# Test PostgreSQL connectivity
kubectl exec -n gold-platform <pod> -- pg_isready -h postgres-service -p 5432

# Check PostgreSQL logs
kubectl logs postgres-0 -n gold-platform
```

### Image pull errors

```bash
# Check image pull secrets
kubectl get secrets -n gold-platform

# Verify image exists
docker pull your-registry/gold-platform-backend:latest
```

## Performance Tuning

### Database Connection Pool

```python
# app/core/config.py
DATABASE_POOL_SIZE: int = 20
DATABASE_MAX_OVERFLOW: int = 10
```

### Uvicorn Workers

```dockerfile
# Dockerfile
CMD ["uvicorn", "app.main:app", "--workers", "4"]
```

### Resource Requests/Limits

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

## Next Steps

1. Set up CI/CD pipeline (GitHub Actions, GitLab CI)
2. Configure monitoring (Prometheus + Grafana)
3. Set up automated backups for PostgreSQL
4. Implement blue-green deployments
5. Add canary deployments
6. Configure service mesh (Istio/Linkerd)

## References

- [containerd Documentation](https://containerd.io/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [PostgreSQL on Kubernetes](https://www.postgresql.org/docs/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)


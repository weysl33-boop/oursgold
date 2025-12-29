#!/bin/bash
# Deploy to Kubernetes cluster

set -e

NAMESPACE="gold-platform"
K8S_DIR="../k8s"

echo "Deploying Gold Platform to Kubernetes..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
  echo "Error: kubectl is not installed"
  exit 1
fi

# Check cluster connectivity
echo "Checking cluster connectivity..."
kubectl cluster-info || {
  echo "Error: Cannot connect to Kubernetes cluster"
  exit 1
}

# Create namespace if it doesn't exist
echo "Creating namespace: ${NAMESPACE}"
kubectl apply -f "${K8S_DIR}/namespace.yaml"

# Apply configurations
echo "Applying ConfigMap..."
kubectl apply -f "${K8S_DIR}/configmap.yaml"

echo "Applying Secrets..."
kubectl apply -f "${K8S_DIR}/secret.yaml"

# Deploy PostgreSQL
echo "Deploying PostgreSQL StatefulSet..."
kubectl apply -f "${K8S_DIR}/postgres-statefulset.yaml"

# Deploy Redis
echo "Deploying Redis..."
kubectl apply -f "${K8S_DIR}/redis-deployment.yaml"

# Wait for databases to be ready
echo "Waiting for PostgreSQL to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n ${NAMESPACE} --timeout=300s

echo "Waiting for Redis to be ready..."
kubectl wait --for=condition=ready pod -l app=redis -n ${NAMESPACE} --timeout=120s

# Deploy backend
echo "Deploying Backend application..."
kubectl apply -f "${K8S_DIR}/backend-deployment.yaml"

# Deploy Ingress
echo "Deploying Ingress..."
kubectl apply -f "${K8S_DIR}/ingress.yaml"

# Deploy HPA
echo "Deploying HorizontalPodAutoscaler..."
kubectl apply -f "${K8S_DIR}/hpa.yaml"

# Wait for backend to be ready
echo "Waiting for Backend to be ready..."
kubectl wait --for=condition=ready pod -l app=backend -n ${NAMESPACE} --timeout=300s

# Show deployment status
echo ""
echo "Deployment complete! Status:"
kubectl get all -n ${NAMESPACE}

echo ""
echo "To view logs: kubectl logs -n ${NAMESPACE} -l app=backend --tail=100"
echo "To run migrations: kubectl exec -n ${NAMESPACE} \$(kubectl get pod -n ${NAMESPACE} -l app=backend -o jsonpath='{.items[0].metadata.name}') -- alembic upgrade head"


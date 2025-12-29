#!/bin/bash
# Build and push Docker image to registry

set -e

# Configuration
REGISTRY="${DOCKER_REGISTRY:-docker.io}"
IMAGE_NAME="${IMAGE_NAME:-gold-platform-backend}"
VERSION="${VERSION:-latest}"
FULL_IMAGE="${REGISTRY}/${IMAGE_NAME}:${VERSION}"

echo "Building Docker image: ${FULL_IMAGE}"

# Build multi-stage Docker image
docker build \
  --platform linux/amd64 \
  -t "${FULL_IMAGE}" \
  -f Dockerfile \
  ..

echo "Image built successfully: ${FULL_IMAGE}"

# Tag with git commit hash if available
if command -v git &> /dev/null; then
  GIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
  if [ "$GIT_HASH" != "unknown" ]; then
    HASH_TAG="${REGISTRY}/${IMAGE_NAME}:${GIT_HASH}"
    docker tag "${FULL_IMAGE}" "${HASH_TAG}"
    echo "Tagged with git hash: ${HASH_TAG}"
  fi
fi

# Push to registry
echo "Pushing image to registry..."
docker push "${FULL_IMAGE}"

if [ -n "$HASH_TAG" ]; then
  docker push "${HASH_TAG}"
fi

echo "Image pushed successfully!"
echo "To deploy: kubectl set image deployment/backend backend=${FULL_IMAGE} -n gold-platform"


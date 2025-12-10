#!/bin/bash

# Multi-architecture Docker Build Script for Local Testing

set -e

# Configuration
REGISTRY_URL="${DOCKER_REGISTRY:-docker.io}"
NAMESPACE="${DOCKER_NAMESPACE:-styliteag}"

# Read version from VERSION file
if [ -f "../VERSION" ]; then
    VERSION=$(cat "../VERSION")
    VERSION_TAG="v${VERSION}"
else
    VERSION_TAG="latest"
fi

echo "🔨 Building multi-architecture images for local testing..."
echo "Registry: ${REGISTRY_URL}"
echo "Namespace: ${NAMESPACE}"
echo "Tag: ${VERSION_TAG}"
echo ""

# Setup buildx for multi-architecture builds
echo "🔧 Setting up buildx for multi-architecture builds..."

# Create and use a new builder instance if it doesn't exist
if ! docker buildx inspect multiarch-builder >/dev/null 2>&1; then
    echo "Creating new buildx builder..."
    docker buildx create --name multiarch-builder --use
else
    echo "Using existing buildx builder..."
    docker buildx use multiarch-builder
fi

# Start the builder
docker buildx inspect --bootstrap

# Build the images first
echo "🔨 Building multi-architecture images..."

cd ..
docker buildx build --platform linux/amd64,linux/arm64 \
    -t styliteag/blog:${VERSION_TAG} \
    -t styliteag/blog:latest \
    -f docker/Dockerfile . --load

docker buildx build --platform linux/amd64,linux/arm64 \
    -t styliteag/gitsync:${VERSION_TAG} \
    -t styliteag/gitsync:latest \
    -f docker/gitsync.Dockerfile . --load

echo "✅ Images built successfully for local testing!"
echo ""
echo "📋 Local image tags:"
echo "   Blog:     styliteag/blog:${VERSION_TAG}"
echo "   Gitsync:  styliteag/gitsync:${VERSION_TAG}"
echo ""
echo "💡 To push to registry, run: ./docker/push-to-registry.sh" 
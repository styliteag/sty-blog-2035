#!/bin/bash

# FIO Analyzer Docker Registry Push Script

set -e

# Configuration
REGISTRY_URL="${DOCKER_REGISTRY:-docker.io}"  # Default to Docker Hub
NAMESPACE="${DOCKER_NAMESPACE:-styliteag}"  # Change this to your username/organization

# Read version from VERSION file
if [ -f "../VERSION" ]; then
    VERSION=$(cat "../VERSION")
    VERSION_TAG="v${VERSION}"
else
    VERSION_TAG="latest"
fi

echo "🚀 Pushing StyliteAG Blog images to registry..."
echo "Registry: ${REGISTRY_URL}"
echo "Namespace: ${NAMESPACE}"
echo "Tag: ${IMAGE_TAG}"
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
    -t ${REGISTRY_URL}/${NAMESPACE}/blog:${VERSION_TAG} \
    -t ${REGISTRY_URL}/${NAMESPACE}/blog:latest \
    -f docker/Dockerfile . --push

docker buildx build --platform linux/amd64,linux/arm64 \
    -t ${REGISTRY_URL}/${NAMESPACE}/gitsync:${VERSION_TAG} \
    -t ${REGISTRY_URL}/${NAMESPACE}/gitsync:latest \
    -f docker/gitsync.Dockerfile . --push

echo "📤 Images built and pushed successfully!"

echo ""
echo "✅ Images pushed successfully!"
echo ""
echo "📋 Image URL:"
echo "   Blog:     ${REGISTRY_URL}/${NAMESPACE}/blog:${VERSION_TAG}"
echo "   Gitsync:  ${REGISTRY_URL}/${NAMESPACE}/gitsync:${VERSION_TAG}"
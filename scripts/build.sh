#!/bin/bash
# Build and push Hytale Docker image to GHCR
# Prerequisites: Docker running, authenticated to ghcr.io

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

IMAGE_NAME="ghcr.io/evrenbunch/hytale-server"
TAG="${1:-java25}"

cd "$ROOT_DIR"

echo "=== Hytale Docker Image Builder ==="
echo ""

# Verify required files exist
echo "Checking required files..."
if [ ! -f "Server/HytaleServer.jar" ]; then
    echo "Error: Server/HytaleServer.jar not found"
    echo "Run ./scripts/download.sh first"
    exit 1
fi

if [ ! -f "Server/HytaleServer.aot" ]; then
    echo "Error: Server/HytaleServer.aot not found"
    echo "Run ./scripts/download.sh first"
    exit 1
fi

if [ ! -f "Assets.zip" ]; then
    echo "Error: Assets.zip not found"
    echo "Run ./scripts/download.sh first"
    exit 1
fi

echo "Server JAR: $(du -h Server/HytaleServer.jar | cut -f1)"
echo "Server AOT: $(du -h Server/HytaleServer.aot | cut -f1)"
echo "Assets: $(du -h Assets.zip | cut -f1)"
echo ""

# Check Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running"
    exit 1
fi

# Check GHCR authentication
echo "Checking GHCR authentication..."
if ! docker pull ghcr.io/parkervcp/yolks:java_25 > /dev/null 2>&1; then
    echo "Warning: May need to authenticate to GHCR"
    echo "Run: echo \$GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin"
fi

echo ""
echo "Building Docker image: ${IMAGE_NAME}:${TAG}"
echo ""

# Build the image
docker build \
    --tag "${IMAGE_NAME}:${TAG}" \
    --tag "${IMAGE_NAME}:latest" \
    --label "org.opencontainers.image.source=https://github.com/evrenbunch/egg-hytale" \
    --label "org.opencontainers.image.description=Hytale dedicated server with game files pre-installed" \
    .

echo ""
echo "Build complete!"
echo ""

# Ask to push
read -p "Push to GHCR? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Pushing ${IMAGE_NAME}:${TAG}..."
    docker push "${IMAGE_NAME}:${TAG}"

    echo "Pushing ${IMAGE_NAME}:latest..."
    docker push "${IMAGE_NAME}:latest"

    echo ""
    echo "=== Push Complete ==="
    echo ""
    echo "Image available at:"
    echo "  ${IMAGE_NAME}:${TAG}"
    echo "  ${IMAGE_NAME}:latest"
else
    echo ""
    echo "Image built but not pushed."
    echo "To push later: docker push ${IMAGE_NAME}:${TAG}"
fi

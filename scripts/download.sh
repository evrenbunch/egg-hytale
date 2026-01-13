#!/bin/bash
# Download Hytale server files using the official downloader
# Run this script when a new Hytale version is released

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

echo "=== Hytale Server File Downloader ==="
echo ""

# Check if downloader exists
if [ ! -f "hytale-downloader" ]; then
    echo "Downloading Hytale Downloader..."
    curl -Lo hytale-downloader.zip https://downloader.hytale.com/hytale-downloader.zip
    unzip -o hytale-downloader.zip

    # Make executable (Linux/Mac)
    if [ -f "hytale-downloader-linux-amd64" ]; then
        chmod +x hytale-downloader-linux-amd64
        mv hytale-downloader-linux-amd64 hytale-downloader
    elif [ -f "hytale-downloader-darwin-amd64" ]; then
        chmod +x hytale-downloader-darwin-amd64
        mv hytale-downloader-darwin-amd64 hytale-downloader
    fi

    rm -f hytale-downloader.zip
fi

echo ""
echo "Starting download (requires Hytale account authentication)..."
echo "Follow the OAuth prompts to authenticate."
echo ""

# Download game files
./hytale-downloader -download-path game.zip

echo ""
echo "Extracting game files..."
unzip -o game.zip

# Move server files to correct locations
if [ -d "Server" ]; then
    echo "Server files already in place"
else
    echo "Error: Server directory not found after extraction"
    exit 1
fi

# Rename Assets.zip if needed
if [ -f "Assets.zip" ]; then
    echo "Assets.zip ready"
elif [ -f "assets.zip" ]; then
    mv assets.zip Assets.zip
fi

# Clean up
rm -f game.zip

echo ""
echo "=== Download Complete ==="
echo ""
echo "Files ready:"
ls -lh Server/HytaleServer.jar Server/HytaleServer.aot Assets.zip 2>/dev/null || true
echo ""
echo "Next step: Run ./scripts/build.sh to build and push the Docker image"

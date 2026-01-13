#!/bin/bash
# Hytale Server Entrypoint Script
# Automatically copies pre-installed server files on first run

set -e

# Copy files if they don't exist in the working directory
if [ ! -f /home/container/HytaleServer.jar ]; then
    echo "=== First run - copying Hytale server files ==="

    # Ensure we can write to home directory
    if [ -w /home/container ]; then
        cp /hytale/HytaleServer.jar /home/container/
        cp /hytale/HytaleServer.aot /home/container/
        cp /hytale/assets.zip /home/container/
        cp -r /hytale/Licenses /home/container/
        echo "=== Server files copied successfully ==="
    else
        echo "Warning: Cannot write to /home/container, skipping file copy"
    fi
fi

# Change to container home directory
cd /home/container

# Execute the original entrypoint or passed command
exec "$@"

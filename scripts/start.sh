#!/bin/bash
# Hytale Server Entrypoint Script
# Automatically copies pre-installed server files on first run

set -e

# Generate persistent machine-id for hardware UUID (needed for encrypted credential storage)
# The machine-id is stored in the volume so it persists across container restarts
MACHINE_ID_FILE="/home/container/.machine-id"
if [ ! -f "$MACHINE_ID_FILE" ]; then
    echo "=== Generating persistent machine-id ==="
    # Generate a 32-character hex string (standard machine-id format)
    cat /proc/sys/kernel/random/uuid | tr -d '-' > "$MACHINE_ID_FILE"
    echo "Machine ID: $(cat $MACHINE_ID_FILE)"
fi

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

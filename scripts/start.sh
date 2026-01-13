#!/bin/bash
# Hytale Server Startup Script
# Copies pre-installed server files to container volume on first run

if [ ! -f /home/container/HytaleServer.jar ]; then
    echo "=== First run - copying Hytale server files ==="
    cp /hytale/HytaleServer.jar /home/container/
    cp /hytale/HytaleServer.aot /home/container/
    cp /hytale/assets.zip /home/container/
    cp -r /hytale/Licenses /home/container/
    echo "=== Server files ready ==="
fi

# Execute the startup command passed as arguments
exec "$@"

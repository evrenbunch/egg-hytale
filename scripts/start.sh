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

# Update config.json with environment variables if set
if [ -n "$MAX_PLAYERS" ]; then
    if [ -f config.json ]; then
        echo "Setting MaxPlayers to $MAX_PLAYERS"
        # Use sed to update MaxPlayers in config.json
        sed -i "s/\"MaxPlayers\": [0-9]*/\"MaxPlayers\": $MAX_PLAYERS/" config.json
    else
        echo "Creating config.json with MaxPlayers=$MAX_PLAYERS"
        cat > config.json << EOF
{
  "Version": 3,
  "ServerName": "Hytale Server",
  "MOTD": "",
  "Password": "",
  "MaxPlayers": $MAX_PLAYERS,
  "MaxViewRadius": 32,
  "LocalCompressionEnabled": false,
  "Defaults": {
    "World": "default",
    "GameMode": "Adventure"
  }
}
EOF
    fi
fi

# Execute the startup command
# Zephyr passes the command via STARTUP env variable, not as arguments
if [ -n "$STARTUP" ]; then
    # Replace template variables in STARTUP command
    MODIFIED_STARTUP=$(echo "$STARTUP" | sed -e 's/{{/${/g' -e 's/}}/}/g')
    echo "Starting: $MODIFIED_STARTUP"
    exec /bin/bash -c "$MODIFIED_STARTUP"
elif [ $# -gt 0 ]; then
    exec "$@"
else
    echo "Error: No STARTUP command or arguments provided"
    exit 1
fi

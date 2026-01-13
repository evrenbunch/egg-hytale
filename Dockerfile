FROM ghcr.io/parkervcp/yolks:java_25

LABEL org.opencontainers.image.source="https://github.com/plex-host/hytale-server"
LABEL org.opencontainers.image.description="Hytale dedicated server with game files pre-installed"
LABEL org.opencontainers.image.licenses="MIT"

# Create /hytale directory with proper permissions
RUN mkdir -p /hytale && chmod 777 /hytale

# Copy server files to /hytale (will be copied to volume on first run)
COPY Server/HytaleServer.jar /hytale/HytaleServer.jar
COPY Server/HytaleServer.aot /hytale/HytaleServer.aot
COPY Server/Licenses /hytale/Licenses

# Copy split assets and reassemble (split due to GitHub LFS 2GB limit)
COPY Assets.zip.part-* /tmp/
RUN cat /tmp/Assets.zip.part-* > /hytale/assets.zip && rm /tmp/Assets.zip.part-*

# Copy startup script (with execute permission)
COPY --chmod=755 scripts/start.sh /hytale/start.sh

ENV HYTALE_PREINSTALLED=true
ENV HYTALE_VERSION=2026.01.13

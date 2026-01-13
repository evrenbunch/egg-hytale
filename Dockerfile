FROM ghcr.io/parkervcp/yolks:java_25

LABEL org.opencontainers.image.source="https://github.com/plex-host/egg-hytale"
LABEL org.opencontainers.image.description="Hytale dedicated server with game files pre-installed"
LABEL org.opencontainers.image.licenses="MIT"

# Switch to root to create directory
USER root

# Create /hytale directory with proper permissions
RUN mkdir -p /hytale && chmod 777 /hytale

# Copy server files
COPY Server/HytaleServer.jar /hytale/HytaleServer.jar
COPY Server/HytaleServer.aot /hytale/HytaleServer.aot
COPY Server/Licenses /hytale/Licenses
COPY Assets.zip /hytale/assets.zip

# Copy startup script
COPY --chmod=755 scripts/start.sh /hytale/start.sh

ENV HYTALE_PREINSTALLED=true
ENV HYTALE_VERSION=2026.01.13

# Switch back to container user
USER container

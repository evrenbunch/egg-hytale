FROM ghcr.io/parkervcp/yolks:java_25

LABEL org.opencontainers.image.source="https://github.com/evrenbunch/egg-hytale"
LABEL org.opencontainers.image.description="Hytale dedicated server with game files pre-installed"
LABEL org.opencontainers.image.licenses="MIT"

# Switch to root to create directory and set permissions
USER root

# Create /hytale directory with proper permissions
RUN mkdir -p /hytale && chmod 777 /hytale

# Copy server files (readable by all users)
COPY --chmod=644 Server/HytaleServer.jar /hytale/HytaleServer.jar
COPY --chmod=644 Server/HytaleServer.aot /hytale/HytaleServer.aot
COPY --chmod=644 Assets.zip /hytale/assets.zip
COPY Server/Licenses /hytale/Licenses
RUN chmod -R 755 /hytale/Licenses

# Copy entrypoint script
COPY --chmod=755 scripts/start.sh /entrypoint.sh

ENV HYTALE_PREINSTALLED=true
ENV HYTALE_VERSION=2026.01.13

# Switch back to container user
USER container

# Use our entrypoint script that copies files then runs the command
ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/entrypoint.sh"]

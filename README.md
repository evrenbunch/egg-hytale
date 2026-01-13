# Hytale Server Docker Image

Official Hytale dedicated server Docker image with game files pre-installed.

## Usage

```bash
docker pull ghcr.io/evrenbunch/hytale-server:java25
```

## Quick Start

```bash
docker run -d \
  -p 5520:5520/udp \
  -v ./data:/home/container \
  ghcr.io/evrenbunch/hytale-server:java25 \
  java -jar HytaleServer.jar --assets assets.zip --bind 0.0.0.0:5520
```

## Features

- **Pre-installed game files** - No OAuth download required during server creation
- **AOT Cache included** - Faster server startup with `HytaleServer.aot`
- **Based on Java 25** - Required by Hytale server

## For Hosting Providers

This image is designed for game server hosting platforms. The installation script copies files from `/hytale/` to the container volume on first run.

### Files included in `/hytale/`:
- `HytaleServer.jar` - Main server executable
- `HytaleServer.aot` - AOT compilation cache
- `assets.zip` - Game assets (~3.5GB)
- `Licenses/` - License files

## Building the Image

Due to large file sizes (3.7GB+), the Docker image must be built locally.

### Prerequisites

- Docker Desktop running
- Hytale account (for OAuth authentication)
- GitHub account with write access to ghcr.io/evrenbunch

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/evrenbunch/egg-hytale.git
   cd egg-hytale
   ```

2. **Download Hytale game files**
   ```bash
   ./scripts/download.sh
   ```
   This will:
   - Download the Hytale Downloader
   - Prompt you to authenticate via OAuth
   - Download and extract game files (~3.7GB)

3. **Authenticate to GHCR**
   ```bash
   echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin
   ```

4. **Build and push the image**
   ```bash
   ./scripts/build.sh
   ```

### Windows Users

Use Git Bash or WSL to run the shell scripts:
```bash
# In Git Bash or WSL
bash ./scripts/download.sh
bash ./scripts/build.sh
```

## Updating Game Files

When a new Hytale version is released:

1. Run `./scripts/download.sh` to get new files
2. Update `HYTALE_VERSION` in `Dockerfile`
3. Run `./scripts/build.sh` to build and push

## Contributing

Community members can help by:
1. Reporting when new Hytale versions are available
2. Testing the Docker image
3. Improving documentation

Note: Game files cannot be committed to git due to size limits.

## License

Game files are property of Hypixel Studios. This repository only provides a convenient Docker packaging.

## Links

- [Hytale Official](https://hytale.com)
- [Hytale Server Manual](https://support.hytale.com/hc/en-us/articles/45326769420827-Hytale-Server-Manual)
- [Plex Host](https://plex.gg)

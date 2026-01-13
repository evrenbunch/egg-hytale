# Hytale Server Docker Image

Official Hytale dedicated server Docker image with game files pre-installed.

## Usage

```bash
docker pull ghcr.io/plex-host/hytale-server:java25
```

## Quick Start

```bash
docker run -d \
  -p 5520:5520/udp \
  -v ./data:/home/container \
  ghcr.io/plex-host/hytale-server:java25 \
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

## Contributing

### Updating Game Files

When a new Hytale version is released:

1. Fork this repository
2. Download new game files using the Hytale Downloader:
   ```bash
   ./hytale-downloader -download-path game.zip
   unzip game.zip
   ```
3. Replace the files in this repo:
   - `Server/HytaleServer.jar`
   - `Server/HytaleServer.aot`
   - `Server/Licenses/`
   - `Assets.zip`
4. Update the version in the PR title (e.g., `Update to 2026.01.15`)
5. Submit a Pull Request

### Requirements

- Git LFS (for Assets.zip)
- Hytale account (for downloading game files)

## License

Game files are property of Hypixel Studios. This repository only provides a convenient Docker packaging.

## Links

- [Hytale Official](https://hytale.com)
- [Hytale Server Manual](https://support.hytale.com/hc/en-us/articles/45326769420827-Hytale-Server-Manual)
- [Plex Host](https://plex.gg)

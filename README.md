# OpenCode Desktop for Raspberry Pi

Build scripts and Pi-Apps integration for running OpenCode Desktop on Raspberry Pi (arm64).

## What's here

| Path | Description |
|------|-------------|
| `build.sh` | Convenience script to rebuild from source |
| `repo/` | Cloned opencode repository (anomalyco/opencode, dev branch) |
| `pi-apps/` | Pi-Apps package directory for easy installation |

## Quick install

```bash
cd pi-apps/opencode-desktop && ./install
```

Then launch `OpenCode Dev` from the menu.

## Build from source

```bash
./build.sh dev      # dev channel
OPENCODE_CHANNEL=prod ./build.sh prod   # production channel
```

## Pi-Apps integration

Copy the `pi-apps/opencode-desktop/` directory to your Pi-Apps `apps/` folder.

## Prerequisites

- Raspberry Pi 4 or 5 running 64-bit Raspberry Pi OS (Bookworm)
- 8GB RAM recommended (building needs ~6GB heap)
- 2GB free disk space for build artifacts

## Notes

- Built from commit on dev branch (version 1.18.3)
- This is the dev channel (app ID: `ai.opencode.desktop.dev`)
- For production channel, set `OPENCODE_CHANNEL=prod` before building
- The official opencode.ai/download page only offers amd64 Linux builds currently

# OpenCode Desktop (opencode-desktop)

The [OpenCode](https://opencode.ai) desktop app — an Electron GUI wrapping the open source AI coding agent, for Raspberry Pi (arm64).

## What's here

| File | Description |
|------|-------------|
| `install` | Pi-Apps install script (uses `dist/` package if present, else builds from source) |
| `uninstall` | Pi-Apps uninstall script |
| `settings` | Pi-Apps metadata |
| `build.sh` | Build recipe that produces the `.deb`/`.AppImage` from source |
| `dist/` | Prebuilt artifacts (`.deb` via Git LFS) |
| `README.md` | This file |

## Install

```bash
cd apps/opencode-desktop
./install
```

Launch `OpenCode Dev` from the menu, or `ai.opencode.desktop`.

## Build from source

```bash
./build.sh dev      # dev channel (default)
./build.sh prod     # production channel
```

Note: building needs ~2 GB disk space and ~8 GB RAM (set `NODE_OPTIONS=--max-old-space-size=6144`). The build script handles this.

## Notes

- Built from commit on the `dev` branch of `anomalyco/opencode` (version 1.18.3)
- Dev channel app ID: `ai.opencode.desktop.dev`; set `OPENCODE_CHANNEL=prod` for production
- Official opencode.ai/download only ships amd64 Linux builds — this is a custom arm64 build
- Prebuilt `.deb` is stored in git via Git LFS (GitHub blocks files over 100 MB)
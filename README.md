# my-pi-apps

A collection of application builds for Raspberry Pi (arm64), packaged for [Pi-Apps](https://github.com/Botspot/pi-apps).

Everything here is built and tested on 64-bit Raspberry Pi OS (Bookworm). Each app folder is a self-contained Pi-Apps package plus a build recipe, so you can install via the Pi-Apps GUI, a script, or build from source.

## What's in here

Focus areas:

- **Developer & console tools** — CLIs, editors, and productivity utilities
- **OpenCode** — desktop app, TUI, and related tooling for the open source AI coding agent
- **Local AI engines** — self-hosted LLM/ML runtimes that run entirely on the Pi
- **Rust projects** — apps and tools written in (or built from) Rust
- **Retro Atari stuff** — emulators and homebrew for classic Atari systems

## Layout

```
my-pi-apps/
├── apps/                     # one folder per app
│   └── <app>/
│       ├── install           # Pi-Apps install script
│       ├── uninstall         # Pi-Apps uninstall script
│       ├── settings          # Pi-Apps metadata
│       ├── build.sh          # builds the app's packages from source
│       ├── README.md         # app-specific notes
│       └── dist/             # prebuilt artifacts (.deb via Git LFS)
└── README.md
```

## Install an app

```bash
sudo apt install git-lfs
git lfs install
git clone https://github.com/bcmichalsamek/my-pi-apps
cd my-pi-apps/apps/<app>
./install
```

Or copy app folders into Pi-Apps and use the Pi-Apps GUI:

```bash
cp -r apps/*/ ~/pi-apps/apps/
```

## Build an app

Each app has its own build recipe:

```bash
cd apps/<app>
./build.sh          # dev channel (default)
./build.sh prod     # production channel
```

Artifacts land in `apps/<app>/dist/`.

## Apps

| App | Focus | Description | Status |
|-----|-------|-------------|--------|
| [opencode-desktop](apps/opencode-desktop/) | OpenCode | OpenCode Desktop (Electron AI coding agent) | arm64 |

## Notes

- Prebuilt `.deb` files are stored with Git LFS (GitHub has a 100 MB per-file limit for regular git)
- Builds target arm64 (Raspberry Pi 4/5, 64-bit Bookworm)

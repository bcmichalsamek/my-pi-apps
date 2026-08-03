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
├── pi-install.sh              # browse + install any app without cloning
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

## Install an app (preferred): `pi-install.sh`

The quickest way is a single command — `pi-install.sh` fetches the app list from this repo (no git clone needed), lets you browse the builds with a menu (or X11/terminal dialog if you have one), and installs immediately:

```bash
curl -fsSL https://raw.githubusercontent.com/bcmichalsamek/my-pi-apps/main/pi-install.sh | bash
```

Once it has downloaded the script you can rerun it anytime with `./pi-install.sh`. It gives you these choices for each app:

| Action | What it does |
|--------|--------------|
| **install** | Downloads the app (incl. any prebuilt `.deb`) and runs its install script |
| **build from source** | Downloads the app and runs its `build.sh` from source |
| **download files only** | Copies the app folder (scripts + `.deb` via Git LFS) into `./apps/<app>/` without a git clone |
| **copy scripts to Pi-Apps** | Drops `install`/`uninstall`/`settings` into `~/pi-apps/apps/<app>/` so the Pi-Apps GUI manages it |

`pi-install.sh` reuses each app's existing `install` / `uninstall` / `build.sh`, so one canonical copy of every script stays in the repo. You can pin a specific release with env vars:

```bash
MY_PI_APPS_REPO=bcmichalsme/my-pi-apps MY_PI_APPS_BRANCH=main curl -fsSL https://raw.githubusercontent.com/bcmichalsme/my-pi-apps/main/pi-install.sh | bash
```

> Note: `curl ... | bash` needs `git-lfs` installed only if you plan to run its `install` action against an app shipped as a `.deb`; plain script downloads need just `curl`.

## Alternative: full clone

```bash
sudo apt install git-lfs && git lfs install
git clone https://github.com/bcmichalsme/my-pi-apps
cd my-pi-apps/apps/<app> && ./install
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
| [atari800](apps/atari800/) | Retro Atari | Atari 800 emulator + FujiNet-PC network emulator | arm64 |

## Notes

- Prebuilt `.deb` files are stored with Git LFS (GitHub has a 100 MB per-file limit for regular git)
- Builds target arm64 (Raspberry Pi 4/5, 64-bit Bookworm)

# my-pi-apps

A collection of application builds for Raspberry Pi (arm64), packaged for [Pi-Apps](https://github.com/Botspot/pi-apps).

## Layout

```
my-pi-apps/
├── apps/                     # one folder per app
│   └── <app>/
│       ├── install           # Pi-Apps install script
│       ├── uninstall         # Pi-Apps uninstall script
│       ├── settings          # Pi-Apps metadata
│       ├── build.sh          # builds the app's packages from source
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

Or copy an app folder into Pi-Apps and use the Pi-Apps GUI:

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

| App | Description | Status |
|-----|-------------|--------|
| [opencode-desktop](apps/opencode-desktop/) | OpenCode Desktop (Electron AI coding agent) | arm64 |

## Notes

- Prebuilt `.deb` files are stored with Git LFS (GitHub has a 100 MB per-file limit for regular git)
- Builds are for 64-bit Raspberry Pi OS (Bookworm) on arm64

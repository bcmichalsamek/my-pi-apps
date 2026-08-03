# Atari 800 + FujiNet for Raspberry Pi

The [Atari 800](https://atari800.github.io/) emulator (v7.0.0) rebuilt with built-in [FujiNet](https://fujinet.online/) network-device emulation — lets your Atari 8-bit virtual machine boot disks, browse TNFS servers, use virtual modems and printers, and talk to the modern internet.

FujiNet is emulated by the **FujiNet-PC** companion service, which talks to atari800 over the **NetSIO** UDP bridge.

## What's here

| File | Description |
|------|-------------|
| `install` | Pi-Apps install script (builds both from source) |
| `uninstall` | Pi-Apps uninstall script |
| `settings` | Pi-Apps metadata |
| `build.sh` | Build both programs and copy binaries to `dist/` |
| `dist/` | Built binaries (`.deb` style artifacts) |

## Install

The package builds from source (the emulator is small, so it's quick; FujiNet-PC takes a few minutes):

```bash
cd apps/atari800
./install
```

## Run

```bash
atari800-fujinet
```

or manually, in two terminals:

```bash
fujinet                  # terminal 1 - FujiNet companion service
atari800 -netsio 9997    # terminal 2 - the emulator
```

**Keys:** `F1` emulator config · `F2` FujiNet CONFIG boot · `Ctrl+Q` quit

## Components

- **atari800** — the emulator ([v7.0.0](https://github.com/atari800/atari800), June 2026). NetSIO is enabled by default in Linux builds.
- **FujiNet-PC** — built from [fujinet-firmware](https://github.com/FujiNetWIFI/fujinet-firmware) for the `ATARI` target. It emulates the FujiNet device (disk drives, network, modem, printer).
- **NetSIO** — the UDP bridge (`localhost:9997`) between atari800 and FujiNet-PC.

## Notes

- Requires the Atari OS/BASIC ROMs (not redistributable). Drop them in the atari800 default ROM path, or point to them via the F1 config.
- Needs SDL2 — installed by the script.
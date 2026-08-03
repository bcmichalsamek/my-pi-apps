#!/bin/bash
set -e

# Atari 800 (v7.0.0) + FujiNet-PC builder for Raspberry Pi (arm64)
# Builds both from source and copies artifacts into ./dist

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$SCRIPT_DIR/dist"

echo "==> Installing build deps (may prompt for sudo)..."
sudo apt-get install -y \
  build-essential autoconf automake libtool pkg-config \
  libsdl2-dev zlib1g-dev libpng-dev libcurl4-openssl-dev libreadline-dev \
  libgl1-mesa-dev libssl-dev libmbedtls-dev cmake python3 python3-venv 2>&1 | tail -2

echo "==> Building atari800..."
cd "$STAGE"
git clone --depth 1 https://github.com/atari800/atari800.git a800
cd a800
autoreconf -vif
./configure --with-video=sdl2 --with-sound=sdl2
make -j"$(nproc)"
install -m 755 src/atari800 "$SCRIPT_DIR/dist/atari800"

echo "==> Building FujiNet-PC..."
cd "$STAGE"
git clone --depth 1 https://github.com/FujiNetWIFI/fujinet-firmware.git fi
cd fi
./build.sh -p ATARI -b
if [ -f build/fujinet ]; then
  install -m 755 build/fujinet "$SCRIPT_DIR/dist/fujinet"
else
  echo "WARN: fujinet binary not found, skipping"
fi

cp data/webui/device_specific/BUILD_ATARI/fnconfig.ini "$SCRIPT_DIR/dist/" 2>/dev/null || true

echo "==> Done! Artifacts in $SCRIPT_DIR/dist/"
ls -lh "$SCRIPT_DIR/dist/"

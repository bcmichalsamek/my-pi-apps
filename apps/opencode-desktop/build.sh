#!/bin/bash
set -e

# OpenCode Desktop builder for Raspberry Pi (arm64)
# Usage: ./build.sh [prod|dev]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKDIR="${TMPDIR:-/tmp}/opencode-build"

CHANNEL="${1:-dev}"
export OPENCODE_CHANNEL="$CHANNEL"

if [ "$(dpkg --print-architecture)" != "arm64" ]; then
  echo "This build is for arm64 (Raspberry Pi 64-bit)."
  exit 1
fi

echo "==> OpenCode Desktop Builder (channel: $CHANNEL)"
echo "==> Platform: $(uname -m)"

rm -rf "$WORKDIR"

echo "==> Cloning repository..."
git clone --depth 1 --branch dev https://github.com/anomalyco/opencode.git "$WORKDIR"

echo "==> Installing dependencies..."
cd "$WORKDIR"
bun install

echo "==> Building opencode server + desktop assets..."
cd packages/desktop
NODE_OPTIONS="--max-old-space-size=6144" bun run build

echo "==> Packaging for Linux..."
bun run package:linux

echo "==> Copying artifacts..."
mkdir -p "$SCRIPT_DIR/dist"
cp dist/opencode-desktop-linux-arm64.deb "$SCRIPT_DIR/dist/" 2>/dev/null || true
cp dist/opencode-desktop-linux-arm64.AppImage "$SCRIPT_DIR/dist/" 2>/dev/null || true

echo "==> Done! Artifacts in $SCRIPT_DIR/dist/"
ls -lh "$SCRIPT_DIR/dist/opencode-desktop-linux-arm64.*" 2>/dev/null

cd /
rm -rf "$WORKDIR"

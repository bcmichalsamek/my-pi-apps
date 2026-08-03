#!/bin/bash
set -e

# OpenCode Desktop builder for Raspberry Pi (arm64)
# Usage: ./build.sh [prod|dev]

CHANNEL="${1:-dev}"
export OPENCODE_CHANNEL="$CHANNEL"

echo "==> OpenCode Desktop Builder (channel: $CHANNEL)"
echo "==> Platform: $(uname -m)"

cd "$(dirname "$0")/repo"

echo "==> Installing dependencies..."
bun install

echo "==> Building opencode server + desktop assets..."
cd packages/desktop
NODE_OPTIONS="--max-old-space-size=6144" bun run build

echo "==> Packaging for Linux..."
bun run package:linux

echo "==> Done! Artifacts in packages/desktop/dist/"
ls -lh dist/opencode-desktop-linux-arm64.* 2>/dev/null

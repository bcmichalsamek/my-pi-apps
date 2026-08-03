#!/bin/bash
# pi-install - browse and install apps from my-pi-apps without cloning the repo
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/bcmichalsamek/my-pi-apps/main/pi-install.sh | bash
#   ./pi-install.sh [dest_dir]

set -euo pipefail

REPO_OWNER="bcmichalsamek"
REPO_NAME="my-pi-apps"
BRANCH="${MY_PI_APPS_BRANCH:-main}"
REPO="${MY_PI_APPS_REPO:-${REPO_OWNER}/${REPO_NAME}}"
API="https://api.github.com/repos/${REPO}"
RAW="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
LFS="https://media.githubusercontent.com/media/${REPO}/${BRANCH}"

DEST="${1:-$PWD}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

need() { command -v "$1" >/dev/null 2>&1 || { echo "error: '$1' is required"; exit 1; }; }
need curl

detect_ui() {
  [ -t 0 ] || { echo text; return; }
  if [ -n "${DISPLAY:-}" ] && command -v zenity >/dev/null 2>&1; then echo zenity
  elif command -v whiptail >/dev/null 2>&1; then echo whiptail
  elif command -v dialog >/dev/null 2>&1; then echo dialog
  else echo text; fi
}

is_local() { [ -d "$DEST/apps" ]; }

list_apps() {
  curl -fsSL "${API}/git/trees/${BRANCH}?recursive=1" \
    | sed -n 's/^ *"path": "apps\/\([^/]*\)",/\1/p' | sort -u
}

list_app_files() { # list_app_files <app> -> one blob path per line
  curl -fsSL "${API}/git/trees/${BRANCH}?recursive=1" | awk -v app="apps/$1/" '
    /"path":/ { path=$0 }
    /"type":/ { typ=$0 }
    /"sha"/ {
      if (path ~ app && typ ~ /blob/) {
        gsub(/.*"path": "/,"",path); gsub(/",.*/,"",path)
        print path
      }
      path=""; typ=""
    }'
}

fetch() { # fetch <repo_path> <dest_path>
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  case "$src" in
    *.deb) curl -fsSL "${LFS}/${src}" -o "$dst" ;;
    *)     curl -fsSL "${RAW}/${src}" -o "$dst" ;;
  esac
}

download_app() { # download_app <app> <dest_root>
  local app="$1" root="$2"
  local paths
  paths="$(list_app_files "$app")"
  [ -n "$paths" ] || { echo "error: no files found for '$app'"; return 1; }
  while IFS= read -r p; do
    printf '  %s\n' "$p"
    fetch "$p" "$root/$p"
  done <<< "$paths"
  chmod +x "$root/apps/$app/install" "$root/apps/$app/build.sh" 2>/dev/null || true
}

run_install() {
  local app="$1"
  download_app "$app" "$TMP"
  echo "==> Installing $app..."
  cd "$TMP/apps/$app"
  bash ./install
}

run_build() {
  local app="$1"
  download_app "$app" "$TMP"
  echo "==> Building $app..."
  cd "$TMP/apps/$app"
  bash ./build.sh
}

copy_to_piapps() {
  local app="$1"
  local dst="$HOME/pi-apps/apps/$app"
  mkdir -p "$dst"
  echo "==> Copying $app scripts to $dst"
  for f in install uninstall settings; do
    fetch "apps/$app/$f" "$dst/$f" 2>/dev/null || true
  done
  chmod +x "$dst/install" "$dst/uninstall" 2>/dev/null || true
  echo "==> Done. Open Pi-Apps to see '$app'."
}

text_menu() {
  local -a choices=("$@")
  local i=1
  for c in "${choices[@]}"; do echo "$i) $c" >&2; i=$((i+1)); done
  printf 'Select (1-%d): ' "$(( ${#choices[@]} ))" >&2
  local sel
  read -r sel
  [ "$sel" -ge 1 ] 2>/dev/null && [ "$sel" -le "${#choices[@]}" ] 2>/dev/null \
    || { echo "invalid" >&2; return 1; }
  echo "${choices[$((sel-1))]}"
}

main() {
  local ui apps app action

  if is_local; then
    apps="$(ls "$DEST/apps" 2>/dev/null)"
  else
    echo "==> Fetching app list from github.com/${REPO} (${BRANCH})..."
    apps="$(list_apps)"
  fi
  [ -n "$apps" ] || { echo "error: no apps found"; exit 1; }

  ui="$(detect_ui)"
  echo "==> Found apps:"
  echo "$apps" | sed 's/^/  /'

  local -a names
  while IFS= read -r a; do [ -n "$a" ] && names+=("$a"); done <<< "$apps"

  case "$ui" in
    zenity)
      app=$(zenity --list --title="my-pi-apps" --column="App" "${names[@]}" 2>/dev/null) ;;
    whiptail|dialog)
      local args=()
      local a
      for a in "${names[@]}"; do args+=("$a" "$a"); done
      app=$("$ui" --title "my-pi-apps" --menu "Choose an app" 18 60 10 "${args[@]}" 2>&1 1>/dev/null) ;;
    *)
      app=$(text_menu "${names[@]}") ;;
  esac

  [ -n "$app" ] || { echo "cancelled"; exit 1; }
  echo "==> Selected: $app"

  local acts=("install" "build from source" "download files only" "copy scripts to Pi-Apps")
  local act
  case "$ui" in
    zenity) act=$(zenity --list --title="Action for $app" --column="Action" "${acts[@]}" 2>/dev/null) ;;
    whiptail|dialog)
      local args=()
      local a
      for a in "${acts[@]}"; do args+=("$a" "$a"); done
      act=$("$ui" --title "Action" --menu "What should I do?" 12 50 10 "${args[@]}" 2>&1 1>/dev/null) ;;
    *) act=$(text_menu "${acts[@]}") ;;
  esac
  [ -n "$act" ] || { echo "cancelled"; exit 1; }

  case "$act" in
    install*)               run_install "$app" ;;
    build*)                 run_build "$app" ;;
    download*)              download_app "$app" "$DEST"; echo "==> Saved to $DEST/apps/$app" ;;
    copy*)                  copy_to_piapps "$app" ;;
    *)                      echo "unknown action: $act"; exit 1 ;;
  esac
}

main "$@"

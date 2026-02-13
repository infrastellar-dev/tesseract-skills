#!/usr/bin/env bash
# Download and launch Tesseract desktop app.
# Called by the SessionStart hook or manually via /tesseract-install.

set -euo pipefail

RELEASES_URL="https://infrastellar.dev/releases"
INSTALL_DIR="${HOME}/.tesseract"
MCP_URL="http://localhost:7440/mcp"

# Detect OS and architecture
detect_platform() {
  local os arch
  os="$(uname -s)"
  arch="$(uname -m)"

  case "$os" in
    Linux)
      case "$arch" in
        x86_64)  echo "linux-x64" ;;
        aarch64) echo "linux-arm64" ;;
        *)       echo ""; return 1 ;;
      esac
      ;;
    Darwin)
      case "$arch" in
        x86_64)  echo "darwin-x64" ;;
        arm64)   echo "darwin-arm64" ;;
        *)       echo ""; return 1 ;;
      esac
      ;;
    *)
      echo ""; return 1
      ;;
  esac
}

# Check if Tesseract MCP server is already running
is_running() {
  curl -sf -o /dev/null --connect-timeout 2 "$MCP_URL" 2>/dev/null
}

# Get the latest version from the releases server
get_latest_version() {
  curl -sf "${RELEASES_URL}/latest.json" 2>/dev/null | grep -o '"version":"[^"]*"' | cut -d'"' -f4
}

# Download Tesseract for the current platform
download() {
  local platform="$1"
  local version="$2"
  local filename

  case "$platform" in
    linux-*)  filename="Tesseract-${version}.AppImage" ;;
    darwin-*) filename="Tesseract-${version}.dmg" ;;
  esac

  local url="${RELEASES_URL}/${filename}"

  mkdir -p "$INSTALL_DIR"
  echo "Downloading Tesseract ${version} for ${platform}..."
  curl -fL -o "${INSTALL_DIR}/${filename}" "$url"

  # Make executable on Linux
  if [[ "$platform" == linux-* ]]; then
    chmod +x "${INSTALL_DIR}/${filename}"
  fi

  echo "$filename"
}

# Launch Tesseract
launch() {
  local filename="$1"
  local filepath="${INSTALL_DIR}/${filename}"

  case "$filename" in
    *.AppImage)
      echo "Launching Tesseract..."
      nohup "$filepath" >/dev/null 2>&1 &
      ;;
    *.dmg)
      echo "Opening Tesseract DMG..."
      open "$filepath"
      ;;
  esac
}

main() {
  if is_running; then
    echo "Tesseract is already running at ${MCP_URL}"
    exit 0
  fi

  local platform
  platform="$(detect_platform)" || {
    echo "Error: Unsupported platform ($(uname -s) $(uname -m))"
    exit 1
  }

  local version
  version="$(get_latest_version)" || {
    echo "Error: Could not fetch latest version from ${RELEASES_URL}"
    exit 1
  }

  local filename
  filename="$(download "$platform" "$version")"

  launch "$filename"

  # Wait for MCP server to be ready
  echo "Waiting for Tesseract MCP server..."
  for i in $(seq 1 30); do
    if is_running; then
      echo "Tesseract is ready!"
      exit 0
    fi
    sleep 1
  done

  echo "Warning: Tesseract started but MCP server not yet responding at ${MCP_URL}"
  exit 1
}

main "$@"

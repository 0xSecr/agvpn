#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/0xSecr/agvpn.git"
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
COMP_DIR="${COMP_DIR:-$HOME/.local/share/bash-completion/completions}"

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"

if [[ -z "$SRC_DIR" || ! -f "$SRC_DIR/bin/agvpn" ]]; then
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TMP_DIR"' EXIT
  echo "Скачиваю репозиторий..."
  if command -v git >/dev/null 2>&1; then
    git clone -q --depth 1 "$REPO_URL" "$TMP_DIR/agvpn"
    SRC_DIR="$TMP_DIR/agvpn"
  else
    curl -fsSL "$REPO_URL/archive/refs/heads/main.tar.gz" | tar -xz -C "$TMP_DIR"
    SRC_DIR="$TMP_DIR/agvpn-main"
  fi
fi

mkdir -p "$BIN_DIR" "$COMP_DIR"

install -m 755 "$SRC_DIR/bin/agvpn" "$BIN_DIR/agvpn"
install -m 755 "$SRC_DIR/bin/bash-completion.sh" "$COMP_DIR/agvpn"

echo "Установлено:"
echo "  $BIN_DIR/agvpn"
echo "  $COMP_DIR/agvpn"

if ! command -v adguardvpn-cli >/dev/null 2>&1; then
  echo
  echo "Внимание: adguardvpn-cli не найден в PATH."
  echo "Установите AdGuard VPN CLI с официального сайта AdGuard."
fi

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *)
    echo
    echo "Добавьте в PATH (если ещё не добавлено):"
    echo "  export PATH=\"$BIN_DIR:\$PATH\""
    ;;
esac

echo
"$BIN_DIR/agvpn" --version 2>/dev/null || true

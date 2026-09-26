#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
COMP_DIR="${COMP_DIR:-$HOME/.local/share/bash-completion/completions}"
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"

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

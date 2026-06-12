#!/bin/sh
set -e

REPO="ljellevo/ghostab"
SCRIPT="ghostab"
DEFAULT_DIR="/usr/local/bin"
URL="https://github.com/$REPO/releases/latest/download/$SCRIPT"

printf 'Install location [%s]: ' "$DEFAULT_DIR"
read -r INSTALL_DIR </dev/tty
INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_DIR}"

# Expand ~ manually since it may not expand inside a variable
case "$INSTALL_DIR" in
  "~"*) INSTALL_DIR="$HOME${INSTALL_DIR#\~}" ;;
esac

CUSTOM_DIR=0
if [ "$INSTALL_DIR" != "$DEFAULT_DIR" ]; then
  CUSTOM_DIR=1
fi

if [ ! -d "$INSTALL_DIR" ]; then
  mkdir -p "$INSTALL_DIR"
  echo "Created $INSTALL_DIR"
fi

echo "Downloading ghostab..."
curl -fsSL "$URL" -o "$INSTALL_DIR/$SCRIPT"
chmod +x "$INSTALL_DIR/$SCRIPT"

# Add to PATH in shell profile if using a custom directory
add_to_path() {
  profile="$1"
  line='export PATH="$PATH:'"$INSTALL_DIR"'"'
  if [ -f "$profile" ] && grep -qF "$INSTALL_DIR" "$profile" 2>/dev/null; then
    echo "$INSTALL_DIR is already in $profile, skipping."
    return
  fi
  printf '\n# ghostab\n%s\n' "$line" >> "$profile"
  echo "Added $INSTALL_DIR to PATH in $profile"
}

if [ "$CUSTOM_DIR" = "1" ]; then
  case "$SHELL" in
    */zsh)  add_to_path "$HOME/.zshrc" ;;
    */bash) add_to_path "$HOME/.bashrc" ;;
    *)      add_to_path "$HOME/.profile" ;;
  esac
  echo ""
  echo "ghostab installed to $INSTALL_DIR/$SCRIPT"
  echo "Restart your shell (or run: export PATH=\"\$PATH:$INSTALL_DIR\") to use it."
else
  echo ""
  echo "ghostab installed to $INSTALL_DIR/$SCRIPT"
fi

echo ""
echo "Then run: ghostab -h"

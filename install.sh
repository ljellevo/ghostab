#!/bin/sh
set -e

main() {
  REPO="ljellevo/ghostab"
  SCRIPT="ghostab"
  DEFAULT_DIR="/usr/local/bin"
  URL="https://github.com/$REPO/releases/latest/download/$SCRIPT"

  printf 'Install location [%s]: ' "$DEFAULT_DIR"
  read -r INSTALL_DIR </dev/tty
  if [ -z "$INSTALL_DIR" ]; then
    INSTALL_DIR="$DEFAULT_DIR"
  else
    # Prepend ~/ unless the path already starts with ~
    case "$INSTALL_DIR" in
      "~"*) ;;
      *) INSTALL_DIR="~/$INSTALL_DIR" ;;
    esac
    # Expand leading ~
    case "$INSTALL_DIR" in
      "~"*) INSTALL_DIR="$HOME${INSTALL_DIR#\~}" ;;
    esac
  fi

  CUSTOM_DIR=0
  if [ "$INSTALL_DIR" != "$DEFAULT_DIR" ]; then
    CUSTOM_DIR=1
  fi

  if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
    echo "Created $INSTALL_DIR"
  fi

  echo "Downloading ghostab..."
  TMP="$(mktemp)"
  curl -fsSL "$URL" -o "$TMP"
  chmod +x "$TMP"

  if [ -w "$INSTALL_DIR" ]; then
    mv "$TMP" "$INSTALL_DIR/$SCRIPT"
  else
    echo "Installing to $INSTALL_DIR (requires sudo)..."
    sudo mv "$TMP" "$INSTALL_DIR/$SCRIPT"
  fi

  if [ "$CUSTOM_DIR" = "1" ]; then
    add_to_path
    echo ""
    echo "ghostab installed to $INSTALL_DIR/$SCRIPT"
    echo "Restart your shell (or run: export PATH=\"\$PATH:$INSTALL_DIR\") to use it."
  else
    echo ""
    echo "ghostab installed to $INSTALL_DIR/$SCRIPT"
  fi

  echo ""
  echo "Then run: ghostab -h"
}

add_to_path() {
  case "$SHELL" in
    */zsh)  profile="$HOME/.zshrc" ;;
    */bash) profile="$HOME/.bashrc" ;;
    *)      profile="$HOME/.profile" ;;
  esac

  line='export PATH="$PATH:'"$INSTALL_DIR"'"'
  if [ -f "$profile" ] && grep -qF "$INSTALL_DIR" "$profile" 2>/dev/null; then
    echo "$INSTALL_DIR is already in $profile, skipping."
    return
  fi
  printf '\n# ghostab\n%s\n' "$line" >> "$profile"
  echo "Added $INSTALL_DIR to PATH in $profile"
}

main "$@"

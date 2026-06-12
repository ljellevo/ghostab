#!/bin/sh
set -e

main() {
  REPO="ljellevo/ghostab"
  SCRIPT="ghostab"
  PRESETS_DIR="$HOME/.ghostab"
  DEFAULT_BIN="/usr/local/bin"
  URL="https://github.com/$REPO/releases/latest/download/$SCRIPT"

  printf 'Install location [%s]: ' "$DEFAULT_BIN"
  read -r INSTALL_DIR </dev/tty

  if [ -z "$INSTALL_DIR" ]; then
    INSTALL_DIR="$DEFAULT_BIN"
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

  # Create the presets directory
  mkdir -p "$PRESETS_DIR"

  # Add ~/.ghostab to PATH in shell profile (for generated presets)
  add_presets_to_path

  # Export to the current session (takes effect when the script is sourced)
  export PATH="$PATH:$PRESETS_DIR"

  echo ""
  echo "ghostab installed to $INSTALL_DIR/$SCRIPT"
  echo "Presets will be stored in $PRESETS_DIR"
  echo ""
  echo "Then run: ghostab -h"
}

add_presets_to_path() {
  case "$SHELL" in
    */zsh)  profile="$HOME/.zshrc" ;;
    */bash) profile="$HOME/.bashrc" ;;
    *)      profile="$HOME/.profile" ;;
  esac

  line='export PATH="$PATH:'"$PRESETS_DIR"'"'
  if [ -f "$profile" ] && grep -qF "$PRESETS_DIR" "$profile" 2>/dev/null; then
    echo "$PRESETS_DIR is already in $profile, skipping."
    return
  fi
  printf '\n# ghostab presets\n%s\n' "$line" >> "$profile"
  echo "Added $PRESETS_DIR to PATH in $profile"
}

main "$@"

#!/usr/bin/env bash
set -euo pipefail

echo "Installing Microsoft Core Fonts..."
dnf install -y cabextract curl

TARGET_DIR="/usr/share/fonts/ms-fonts"
mkdir -p "$TARGET_DIR"

# Liste aller Schriftarten-Pakete
FONTS=(
  "arial32.exe"
  "arialb32.exe"
  "courie32.exe"
  "times32.exe"
  "verdan32.exe"
  "trebu32.exe"
  "comic32.exe"
  "georg32.exe"
)

for font in "${FONTS[@]}"; do
  echo "Fetching $font..."
  # Versuche von SourceForge zu laden; breche bei einzelnen Fehlern nicht den Build ab
  curl -sSL "https://downloads.sourceforge.net/corefonts/$font" -o "/tmp/$font" || true
  
  if [ -s "/tmp/$font" ]; then
    cabextract -q -o -d "$TARGET_DIR" "/tmp/$font" 2>/dev/null || echo "Warning: Failed to extract $font, skipping..."
    rm -f "/tmp/$font"
  fi
done

# Zugriffsrechte & Font-Cache setzen
chmod 644 "$TARGET_DIR"/*.ttf 2>/dev/null || true
fc-cache -f "$TARGET_DIR"

echo "Microsoft Fonts script completed!"

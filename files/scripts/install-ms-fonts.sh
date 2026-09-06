#!/usr/bin/env bash
set -euo pipefail

echo "Installing Microsoft Fonts from fonts repository..."

TARGET_DIR="/usr/share/fonts/ms-fonts"
mkdir -p "$TARGET_DIR"

WORK_DIR=$(mktemp -d)
cd "$WORK_DIR"

# Öffentliches Repository klonen
echo "Cloning from the fonts repository..."
git clone --depth 1 "https://github.com/Gilverion/ttf-ms-win10" fonts-repo

echo "Copying fonts to $TARGET_DIR..."
find fonts-repo -type f \( -name "*.ttf" -o -name "*.TTF" -o -name "*.ttc" -o -name "*.TTC" \) -exec cp {} "$TARGET_DIR/" \;

# Aufräumen
cd /
rm -rf "$WORK_DIR"

# Dateinamen in Kleinbuchstaben umwandeln & Rechte setzen
cd "$TARGET_DIR"
for f in *; do
  if [ -f "$f" ]; then
    lower_f=$(echo "$f" | tr '[:upper:]' '[:lower:]')
    if [ "$f" != "$lower_f" ]; then
      mv -f "$f" "$lower_f" 2>/dev/null || true
    fi
  fi
done

chmod 644 "$TARGET_DIR"/* 2>/dev/null || true
fc-cache -f "$TARGET_DIR"

echo "Microsoft Fonts successfully installed!"

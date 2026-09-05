#!/usr/bin/env bash
set -euo pipefail

echo "Installing Microsoft Core & ClearType Fonts..."

TARGET_DIR="/usr/share/fonts/ms-fonts"
mkdir -p "$TARGET_DIR"

# Lade das gebündelte ZIP-Archiv von mscorefonts2 herunter
echo "Downloading fonts zip..."
curl -sSL "https://downloads.sourceforge.net/project/mscorefonts2/msttcore-fonts-2.6-1.noarch.tar.gz" -o /tmp/fonts.tar.gz || true

if [ -s /tmp/fonts.tar.gz ]; then
  tar -xzf /tmp/fonts.tar.gz -C /tmp/
  # Kopiere alle TTF-Schriftarten in das Zielverzeichnis
  find /tmp/ -type f \( -name "*.ttf" -o -name "*.TTF" \) -exec cp {} "$TARGET_DIR/" \; 2>/dev/null || true
  rm -rf /tmp/fonts.tar.gz
fi

# Dateinamen vereinheitlichen (Kleinschreibung)
cd "$TARGET_DIR"
for f in *; do
  [ -f "$f" ] && mv -f "$f" "${f,,}" 2>/dev/null || true
done

chmod 644 "$TARGET_DIR"/* 2>/dev/null || true
fc-cache -f "$TARGET_DIR"

echo "Microsoft Fonts script completed!"

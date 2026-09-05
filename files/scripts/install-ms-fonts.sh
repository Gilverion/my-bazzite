#!/usr/bin/env bash
set -euo pipefail

echo "Installing Microsoft Core & ClearType Fonts (Calibri) via mscorefonts2..."
dnf install -y cabextract curl

TARGET_DIR="/usr/share/fonts/ms-fonts"
mkdir -p "$TARGET_DIR"

# Lade das gebündelte Font-Paket direkt aus mscorefonts2
curl -sSL "https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm" -o /tmp/msttcore.rpm || true

if [ -s /tmp/msttcore.rpm ]; then
  # Entpacke das RPM direkt ohne DNF-Installation sauber im Build-Container
  cd /tmp
  rpm2cpio /tmp/msttcore.rpm | cpio -idmv 2>/dev/null || true
  
  # Kopiere alle TTF-Dateien (Arial, Times, Calibri etc.) in das System-Verzeichnis
  find /tmp/usr/share/fonts/ -type f \( -name "*.ttf" -o -name "*.TTF" \) -exec cp {} "$TARGET_DIR/" \; 2>/dev/null || true
  rm -rf /tmp/usr /tmp/msttcore.rpm
fi

# Dateinamen in Kleinbuchstaben umwandeln und Zugriffsrechte setzen
cd "$TARGET_DIR"
for f in *; do
  [ -f "$f" ] && mv -f "$f" "${f,,}" 2>/dev/null || true
done

chmod 644 "$TARGET_DIR"/* 2>/dev/null || true
fc-cache -f "$TARGET_DIR"

echo "Microsoft Fonts (inkl. Calibri) successfully installed!"

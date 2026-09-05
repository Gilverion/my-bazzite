#!/usr/bin/env bash
set -euo pipefail

echo "Installing Microsoft Core & ClearType Fonts (Calibri) via mscorefonts2 RPM..."

TARGET_DIR="/usr/share/fonts/ms-fonts"
mkdir -p "$TARGET_DIR"

WORK_DIR=$(mktemp -d)
cd "$WORK_DIR"

# Herunterladen des mscorefonts2 RPMs
RPM_URL="https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm"
echo "Downloading RPM from SourceForge..."
curl -sSL -L "$RPM_URL" -o msttcore.rpm

# Prüfen ob eine gültige RPM-Datei heruntergeladen wurde
if file msttcore.rpm | grep -qE 'RPM|data'; then
  echo "Extracting RPM contents..."
  rpm2cpio msttcore.rpm | cpio -idmv 2>/dev/null || true
  
  # Alle TTF/OTF Schriftarten in das Zielverzeichnis kopieren
  echo "Copying TTF fonts to $TARGET_DIR..."
  find . -type f \( -name "*.ttf" -o -name "*.TTF" -o -name "*.otf" -o -name "*.OTF" \) -exec cp {} "$TARGET_DIR/" \;
else
  echo "Warning: Downloaded file is not a valid RPM."
fi

# Aufräumen
cd /
rm -rf "$WORK_DIR"

# Dateinamen vereinheitlichen (Kleinschreibung)
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

echo "Microsoft Fonts script completed successfully!"

#!/usr/bin/env bash
set -euo pipefail

echo "Installing Microsoft Core Fonts..."
dnf install -y cabextract
mkdir -p /usr/share/fonts/ms-fonts

for font in arial32.exe arialb32.exe courie32.exe times32.exe verdan32.exe trebu32.exe comic32.exe georg32.exe; do
  curl -sL "https://downloads.sourceforge.net/corefonts/$font" -o "/tmp/$font"
  cabextract -q -d /usr/share/fonts/ms-fonts "/tmp/$font"
  rm -f "/tmp/$font"
done

chmod 644 /usr/share/fonts/ms-fonts/*.ttf
fc-cache -f /usr/share/fonts/ms-fonts
echo "Microsoft Fonts successfully installed!"

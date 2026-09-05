```bash
#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Microsoft Core Fonts for Bazzite / BlueBuild
#
# Installs Microsoft Core Fonts into:
#   /usr/local/share/fonts/microsoft
#
# Designed for:
#   - Fedora Atomic / Bazzite
#   - BlueBuild
#   - Flatpak applications
#   - ONLYOFFICE Desktop Editors
###############################################################################

FONT_DIR="/usr/local/share/fonts/microsoft"
WORK_DIR="$(mktemp -d)"

# Clean up temporary files when the script exits
trap 'rm -rf "$WORK_DIR"' EXIT

echo "=============================================="
echo " Microsoft Fonts Installer"
echo " Bazzite / BlueBuild"
echo "=============================================="

###############################################################################
# 1. Check required tools
###############################################################################

echo "[1/6] Checking required tools..."

for cmd in curl rpm2cpio cpio fc-cache; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: Required command '$cmd' was not found."
        exit 1
    fi
done

###############################################################################
# 2. Create font directory
###############################################################################

echo "[2/6] Creating font directory..."

mkdir -p "$FONT_DIR"

###############################################################################
# 3. Download msttcore-fonts-installer
###############################################################################

echo "[3/6] Downloading Microsoft Core Fonts installer..."

cd "$WORK_DIR"

FONT_RPM="msttcore-fonts-installer-2.6-1.noarch.rpm"

FONT_URL="https://downloads.sourceforge.net/project/mscorefonts2/rpms/$FONT_RPM"

curl \
    --fail \
    --location \
    --retry 3 \
    --retry-delay 2 \
    --output "$FONT_RPM" \
    "$FONT_URL"

if [[ ! -s "$FONT_RPM" ]]; then
    echo "ERROR: Font RPM download failed."
    exit 1
fi

###############################################################################
# 4. Extract RPM without installing it
###############################################################################

echo "[4/6] Extracting Microsoft fonts..."

mkdir -p "$WORK_DIR/extracted"

cd "$WORK_DIR/extracted"

rpm2cpio "../$FONT_RPM" | cpio -idm --quiet

###############################################################################
# 5. Locate and install fonts
###############################################################################

echo "[5/6] Installing fonts..."

# The exact directory inside the RPM can vary.
# Search for actual font files instead of relying on one fixed path.

mapfile -t FONT_FILES < <(
    find "$WORK_DIR/extracted" \
        -type f \
        \( \
            -iname "*.ttf" \
            -o -iname "*.TTF" \
            -o -iname "*.otf" \
            -o -iname "*.OTF" \
        \) \
        -print
)

if [[ ${#FONT_FILES[@]} -eq 0 ]]; then
    echo "ERROR: No font files were found in the RPM."
    exit 1
fi

for font in "${FONT_FILES[@]}"; do
    install -m 0644 "$font" "$FONT_DIR/"
done

###############################################################################
# 6. Rebuild font cache
###############################################################################

echo "[6/6] Updating font cache..."

fc-cache -f "$FONT_DIR"

# Also rebuild the global font cache.
fc-cache -f

###############################################################################
# Verification
###############################################################################

echo
echo "=============================================="
echo " Font installation complete"
echo "=============================================="

FONT_COUNT=$(find "$FONT_DIR" -type f \
    \( -iname "*.ttf" -o -iname "*.otf" \) | wc -l)

echo "Installed font files: $FONT_COUNT"
echo "Font directory:       $FONT_DIR"

echo
echo "Checking important Microsoft fonts..."

CHECK_FONTS=(
    "Arial"
    "Comic Sans MS"
    "Courier New"
    "Georgia"
    "Impact"
    "Times New Roman"
    "Trebuchet MS"
    "Verdana"
)

for font in "${CHECK_FONTS[@]}"; do
    if fc-list : family | grep -Fqi "$font"; then
        echo "  [OK] $font"
    else
        echo "  [--] $font"
    fi
done

echo
echo "Microsoft fonts are ready for the Bazzite desktop."
echo "Flatpak applications such as ONLYOFFICE can use"
echo "the system font collection through fontconfig."

exit 0
```

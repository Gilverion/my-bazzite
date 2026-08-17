#!/usr/bin/env bash
set -oue pipefail

# Löscht alle Waydroid-Desktop-Starter aus /usr/share/applications
rm -vf /usr/share/applications/*waydroid*.desktop

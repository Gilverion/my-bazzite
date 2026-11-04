
#!/usr/bin/bash
set -euxo pipefail

# Offizielles Discord RPM herunterladen
curl -fL -o /tmp/discord.rpm \
  "https://discord.com/api/download?platform=linux&format=rpm"

# Discord im Build-Container installieren
dnf install -y /tmp/discord.rpm

# Temporäre Datei entfernen
rm -f /tmp/discord.rpm

# Update-Sperre deaktivieren
mkdir -p /etc/skel/.config/discord

cat << 'EOF' > /etc/skel/.config/discord/settings.json
{
  "SKIP_HOST_UPDATE": true
}
EOF

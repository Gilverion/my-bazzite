#!/usr/bin/bash
set -edxu

# 1. Offizielles Discord RPM direkt herunterladen
curl -L -o /tmp/discord.rpm "https://discord.com/api/download?platform=linux&format=rpm"

# 2. RPM ins System integrieren
rpm-ostree install /tmp/discord.rpm
rm /tmp/discord.rpm

# 3. Update-Sperre deaktivieren (damit Discord nicht den Start blockiert)
mkdir -p /etc/skel/.config/discord
cat << 'EOF' > /etc/skel/.config/discord/settings.json
{
  "SKIP_HOST_UPDATE": true
}
EOF

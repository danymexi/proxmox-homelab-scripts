#!/bin/bash
set -euo pipefail

# Set up Cloudflare Tunnel in an LXC container
# Usage: bash setup-cloudflare-tunnel.sh
# Prerequisites: cloudflared auth token from https://dash.cloudflare.com

echo "Installing cloudflared..."

# Install cloudflared
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | gpg --dearmor -o /usr/share/keyrings/cloudflare-main.gpg
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" > /etc/apt/sources.list.d/cloudflared.list
apt-get update -qq
apt-get install -y -qq cloudflared

echo ""
echo "cloudflared installed. Next steps:"
echo "1. Authenticate: cloudflared tunnel login"
echo "2. Create tunnel: cloudflared tunnel create my-tunnel"
echo "3. Configure: edit /etc/cloudflared/config.yml (see cloudflare-config.yml template)"
echo "4. Install service: cloudflared service install"
echo "5. Start: systemctl start cloudflared"

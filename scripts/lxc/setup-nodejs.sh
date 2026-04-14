#!/bin/bash
set -euo pipefail

# Install Node.js LTS in an LXC container
# Usage: bash setup-nodejs.sh --container-id 110

CTID="${1:?Usage: setup-nodejs.sh <container-id>}"

echo "Installing Node.js LTS in container $CTID..."

pct exec "$CTID" -- bash -c '
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
  apt-get install -y -qq nodejs
  node --version
  npm --version
  echo "Node.js installed successfully"
'

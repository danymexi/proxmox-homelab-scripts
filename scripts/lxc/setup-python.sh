#!/bin/bash
set -euo pipefail

# Install Python 3 + venv in an LXC container
# Usage: bash setup-python.sh <container-id>

CTID="${1:?Usage: setup-python.sh <container-id>}"

echo "Installing Python 3 in container $CTID..."

pct exec "$CTID" -- bash -c '
  apt-get update -qq
  apt-get install -y -qq python3 python3-pip python3-venv
  python3 --version
  echo "Python installed successfully"
'

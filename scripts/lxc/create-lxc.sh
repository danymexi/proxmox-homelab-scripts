#!/bin/bash
set -euo pipefail

# Create and configure an LXC container on Proxmox VE
# Usage: bash create-lxc.sh --id 110 --name my-app --ip 192.168.1.110 --ram 2048 --disk 16

# Defaults
CTID=""
NAME=""
IP=""
RAM=2048
DISK=16
CORES=2
BRIDGE="vmbr0"
GATEWAY="192.168.1.1"
TEMPLATE="local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
SSH_KEY="${HOME}/.ssh/authorized_keys"
STORAGE="local-lvm"

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --id) CTID="$2"; shift 2 ;;
    --name) NAME="$2"; shift 2 ;;
    --ip) IP="$2"; shift 2 ;;
    --ram) RAM="$2"; shift 2 ;;
    --disk) DISK="$2"; shift 2 ;;
    --cores) CORES="$2"; shift 2 ;;
    --bridge) BRIDGE="$2"; shift 2 ;;
    --gateway) GATEWAY="$2"; shift 2 ;;
    --template) TEMPLATE="$2"; shift 2 ;;
    --storage) STORAGE="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# Validate required
[[ -z "$CTID" ]] && { echo "Error: --id required"; exit 1; }
[[ -z "$NAME" ]] && { echo "Error: --name required"; exit 1; }
[[ -z "$IP" ]] && { echo "Error: --ip required"; exit 1; }

echo "Creating LXC container $CTID ($NAME) at $IP..."

# Download template if not present
TMPL_FILE=$(echo "$TEMPLATE" | cut -d: -f2)
if [[ ! -f "/var/lib/vz/$TMPL_FILE" ]]; then
  echo "Downloading Debian 12 template..."
  pveam update
  pveam download local debian-12-standard_12.7-1_amd64.tar.zst
fi

# Create container
pct create "$CTID" "$TEMPLATE" \
  --hostname "$NAME" \
  --memory "$RAM" \
  --swap 512 \
  --cores "$CORES" \
  --rootfs "${STORAGE}:${DISK}" \
  --net0 "name=eth0,bridge=${BRIDGE},ip=${IP}/24,gw=${GATEWAY}" \
  --features nesting=1 \
  --unprivileged 1 \
  --onboot 1 \
  --start 1

echo "Waiting for container to start..."
sleep 5

# Inject SSH keys
if [[ -f "$SSH_KEY" ]]; then
  pct exec "$CTID" -- mkdir -p /root/.ssh
  pct push "$CTID" "$SSH_KEY" /root/.ssh/authorized_keys
  pct exec "$CTID" -- chmod 600 /root/.ssh/authorized_keys
fi

# Basic setup
pct exec "$CTID" -- bash -c '
  apt-get update -qq
  apt-get install -y -qq curl wget git sudo htop
  echo "Base packages installed"
'

echo ""
echo "Container $CTID ($NAME) created successfully!"
echo "  IP: $IP"
echo "  RAM: ${RAM}MB | Cores: $CORES | Disk: ${DISK}GB"
echo "  SSH: ssh root@$IP"

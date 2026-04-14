#!/bin/bash
set -euo pipefail

# Backup all running LXC containers
# Usage: bash backup-all.sh [--storage backup-storage] [--keep 5]

STORAGE="${1:-local}"
KEEP=5
MAILTO=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --storage) STORAGE="$2"; shift 2 ;;
    --keep) KEEP="$2"; shift 2 ;;
    --mailto) MAILTO="$2"; shift 2 ;;
    *) shift ;;
  esac
done

echo "Backing up all running containers to $STORAGE (keep last $KEEP)..."

for CTID in $(pct list | awk 'NR>1 && $2=="running" {print $1}'); do
  NAME=$(pct list | awk -v id="$CTID" '$1==id {print $3}')
  echo "  Backing up CT $CTID ($NAME)..."
  vzdump "$CTID" \
    --storage "$STORAGE" \
    --mode snapshot \
    --compress zstd \
    --prune-backups "keep-last=$KEEP" \
    --quiet 1 || echo "  WARNING: Backup of $CTID failed!"
done

echo "All backups complete."

# Cleanup notification
if [[ -n "$MAILTO" ]]; then
  echo "Backup completed at $(date)" | mail -s "Proxmox Backup Report" "$MAILTO"
fi

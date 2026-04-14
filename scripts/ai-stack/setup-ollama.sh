#!/bin/bash
set -euo pipefail

# Deploy Ollama + Open WebUI in an LXC container
# Usage: bash setup-ollama.sh --container-id 110

CTID=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --container-id) CTID="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

[[ -z "$CTID" ]] && { echo "Error: --container-id required"; exit 1; }

echo "Setting up Ollama AI stack in container $CTID..."

pct exec "$CTID" -- bash -c '
  # Install Ollama
  curl -fsSL https://ollama.com/install.sh | sh
  
  # Start Ollama service
  systemctl enable ollama
  systemctl start ollama
  
  # Wait for Ollama to be ready
  sleep 3
  
  # Pull a default model
  echo "Pulling llama3.2:3b (small, fast model)..."
  ollama pull llama3.2:3b
  
  echo ""
  echo "Ollama installed and running!"
  echo "  API: http://localhost:11434"
  echo "  Test: ollama run llama3.2:3b \"Hello!\""
  echo ""
  echo "Optional: Install Open WebUI for a ChatGPT-like interface:"
  echo "  pip install open-webui"
  echo "  open-webui serve --host 0.0.0.0 --port 8080"
'

# Proxmox Home Lab Scripts

Automation scripts and configs for setting up and managing a Proxmox VE home lab. Includes LXC container provisioning, Cloudflare tunnel setup, Ollama AI stack deployment, and automated backups.

Battle-tested on a real home lab running 7 LXC containers serving production websites, AI inference, and home automation.

## What's Inside

### LXC Container Provisioning
Scripts to create and configure LXC containers with:
- Automatic Debian/Ubuntu template download
- Resource allocation (CPU, RAM, disk)
- Network configuration (static IP, bridge)
- SSH key injection
- Post-creation setup (Node.js, Python, Docker)

### Cloudflare Tunnel Setup
Expose services securely without port forwarding:
- Cloudflare Tunnel installation and configuration
- Multi-service routing template
- TLS and access policy config

### AI Stack (Ollama + Open WebUI)
Self-hosted AI inference on consumer hardware:
- Ollama installation in LXC
- Open WebUI deployment
- Model management scripts
- GPU passthrough guide

### Automated Backups
PBS (Proxmox Backup Server) and manual backup scripts:
- Scheduled LXC snapshots
- Off-site backup to NAS/S3
- Retention policy management
- Restore verification

## Quick Start

```bash
git clone https://github.com/danymexi/proxmox-homelab-scripts.git
cd proxmox-homelab-scripts

# Create a new LXC container
# Run on the Proxmox host:
bash scripts/lxc/create-lxc.sh --id 110 --name my-app --ip 192.168.1.110 --ram 2048 --disk 16

# Set up Cloudflare Tunnel
bash scripts/networking/setup-cloudflare-tunnel.sh

# Deploy Ollama AI stack
bash scripts/ai-stack/setup-ollama.sh --container-id 110
```

## Hardware Recommendations

This setup runs great on:
- **Mini PC**: Beelink EQ12 / SER5 (Intel N100/AMD 5560U) — 16-32GB RAM
- **Storage**: Samsung 870 EVO SSD (OS) + WD Red for data
- **Network**: TP-Link 2.5GbE switch for inter-container traffic

## My Setup

| CT ID | Name | Purpose | Resources |
|-------|------|---------|-----------|
| 102 | app-server | Web apps (Node.js) | 4 cores, 4GB RAM, 32GB disk |
| 103 | website-1 | WordPress site | 2 cores, 2GB RAM, 16GB disk |
| 104 | cms | Headless CMS | 2 cores, 2GB RAM, 16GB disk |
| 105 | api-server | API services | 2 cores, 2GB RAM, 16GB disk |
| 106 | iot-hub | Home Assistant | 4 cores, 4GB RAM, 32GB disk |
| 107 | static-site | Astro static sites | 2 cores, 2GB RAM, 16GB disk |

Total: ~16 cores, 18GB RAM on a single mini PC.

## Directory Structure

```
proxmox-homelab-scripts/
├── scripts/
│   ├── lxc/
│   │   ├── create-lxc.sh         # Create and configure LXC container
│   │   ├── setup-nodejs.sh       # Install Node.js in LXC
│   │   └── setup-python.sh       # Install Python + venv in LXC
│   ├── backup/
│   │   └── backup-all.sh         # Backup all containers
│   ├── networking/
│   │   ├── setup-cloudflare-tunnel.sh  # Cloudflare Tunnel
│   │   └── cloudflare-config.yml       # Template config
│   └── ai-stack/
│       └── setup-ollama.sh       # Ollama + Open WebUI
├── configs/
│   ├── lxc-defaults.conf         # Default LXC config
│   └── systemd-service.template  # Systemd service template
└── docs/
    └── gpu-passthrough.md        # GPU passthrough guide
```

## License

MIT

## Author

**Daniele Messi** — [daniele-messi.com](https://daniele-messi.com) · [GitHub](https://github.com/danymexi)

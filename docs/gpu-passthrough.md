# GPU Passthrough for AI Workloads

Guide to passing through a GPU to a Proxmox VM for Ollama/AI inference.

## Prerequisites

- IOMMU-capable CPU (Intel VT-d / AMD-Vi)
- Dedicated GPU (not the one driving your display)
- Proxmox VE 8.x

## Steps

### 1. Enable IOMMU in BIOS
Enable VT-d (Intel) or AMD-Vi (AMD) in your BIOS settings.

### 2. Configure Kernel Boot Parameters

Edit `/etc/default/grub`:

```bash
# Intel
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"

# AMD
GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt"
```

Then: `update-grub && reboot`

### 3. Blacklist Host GPU Drivers

```bash
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
echo "blacklist nvidia" >> /etc/modprobe.d/blacklist.conf
echo "options vfio-pci ids=10de:XXXX,10de:YYYY" >> /etc/modprobe.d/vfio.conf
update-initramfs -u
```

Replace `10de:XXXX` with your GPU's PCI ID (find with `lspci -nn | grep -i nvidia`).

### 4. Add GPU to VM

```bash
qm set <VMID> -hostpci0 0000:01:00,pcie=1
```

### 5. Install Drivers in VM

Boot the VM and install NVIDIA drivers:

```bash
apt install nvidia-driver-550
nvidia-smi  # Verify
```

### 6. Install Ollama with GPU

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama run llama3.1:8b  # GPU-accelerated
```

## Notes

- GPU passthrough requires a **VM**, not an LXC container
- For LXC, you can share the GPU using NVIDIA Container Toolkit (more complex)
- Test with a small model first (llama3.2:3b) before large ones

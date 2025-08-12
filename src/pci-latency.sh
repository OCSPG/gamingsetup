#!/bin/bash

set -e

echo "Configuring PCI Express latencies for gaming..."

# Create systemd service to set PCI latencies on boot
sudo tee /etc/systemd/system/pci-latency-gaming.service > /dev/null << 'EOF'
[Unit]
Description=Set PCI Express latencies for gaming
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'setpci -v -s "*:*" latency_timer=20; setpci -v -s "0:0" latency_timer=0; setpci -v -d "*:*:04xx" latency_timer=80'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
sudo systemctl enable pci-latency-gaming.service

# Apply the settings immediately
echo "Applying PCI latency settings..."
sudo setpci -v -s '*:*' latency_timer=20
sudo setpci -v -s '0:0' latency_timer=0
sudo setpci -v -d "*:*:04xx" latency_timer=80

echo "PCI Express latency optimization completed"
echo "Settings will be applied automatically on boot via systemd service"
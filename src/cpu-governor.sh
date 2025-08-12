#!/bin/bash

set -e

echo "Setting CPU governor to performance for gaming..."

# Set all CPU cores to performance governor
echo "Setting all CPU cores to performance governor..."
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    if [ -f "$cpu" ]; then
        echo performance | sudo tee "$cpu" > /dev/null
    fi
done

# Create systemd service to set performance governor on boot
sudo tee /etc/systemd/system/cpu-performance-gaming.service > /dev/null << 'EOF'
[Unit]
Description=Set CPU governor to performance for gaming
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do if [ -f "$cpu" ]; then echo performance > "$cpu"; fi; done'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
sudo systemctl enable cpu-performance-gaming.service

echo "CPU governor set to performance and service enabled for boot persistence"
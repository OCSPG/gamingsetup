#!/bin/bash

set -e

echo "Setting vm.max_map_count for improved game compatibility..."

# Create sysctl config file for game compatibility
sudo tee /etc/sysctl.d/80-gamecompatibility.conf > /dev/null << 'EOF'
vm.max_map_count = 2147483642
EOF

# Apply the setting immediately
sudo sysctl -p /etc/sysctl.d/80-gamecompatibility.conf

echo "vm.max_map_count set to 2147483642 (SteamOS default)"
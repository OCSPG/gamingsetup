#!/bin/bash

set -e

echo "Disabling split lock mitigate for improved gaming performance..."

# Create sysctl config to disable split lock mitigate
sudo tee /etc/sysctl.d/99-splitlock.conf > /dev/null << 'EOF'
kernel.split_lock_mitigate=0
EOF

# Apply the setting immediately if the parameter exists
if [ -f /proc/sys/kernel/split_lock_mitigate ]; then
    sudo sysctl kernel.split_lock_mitigate=0
    echo "Split lock mitigate disabled immediately"
else
    echo "Split lock mitigate parameter not available on this kernel"
fi

echo "Split lock mitigate configuration completed"
echo "Setting will be applied on boot via /etc/sysctl.d/99-splitlock.conf"
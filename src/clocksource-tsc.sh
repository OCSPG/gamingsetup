#!/bin/bash

set -e

echo "Configuring TSC clocksource for improved clock_gettime throughput..."

# Check if we're using GRUB
if [ -f /etc/default/grub ]; then
    echo "Adding TSC clocksource parameters to GRUB..."
    
    # Backup original grub config
    sudo cp /etc/default/grub /etc/default/grub.backup
    
    # Check if parameters already exist
    if ! grep -q "tsc=reliable clocksource=tsc" /etc/default/grub; then
        # Add TSC parameters to GRUB_CMDLINE_LINUX_DEFAULT
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 tsc=reliable clocksource=tsc"/' /etc/default/grub
        
        # Remove any double spaces
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=" /GRUB_CMDLINE_LINUX_DEFAULT="/' /etc/default/grub
        
        echo "TSC parameters added to GRUB configuration"
        echo "Regenerating GRUB configuration..."
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        
        echo ""
        echo "WARNING: TSC clocksource has been enabled with tsc=reliable clocksource=tsc"
        echo "This provides ~50x higher throughput for clock_gettime() calls used by games"
        echo "However, forcing TSC when unreliable may cause Firefox to crash randomly"
        echo "A reboot is required for changes to take effect"
        echo ""
        echo "After reboot, verify clocksource with:"
        echo "cat /sys/devices/system/clocksource/clocksource*/current_clocksource"
    else
        echo "TSC parameters already present in GRUB configuration"
    fi
else
    echo "GRUB configuration not found. Please manually add 'tsc=reliable clocksource=tsc' to your bootloader parameters"
fi
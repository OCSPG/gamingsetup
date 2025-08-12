#!/bin/bash

set -e

echo "Configuring AMD P-State driver for optimal gaming performance..."

# Check if system has AMD CPU
if ! grep -q "AuthenticAMD" /proc/cpuinfo; then
    echo "This system does not have an AMD CPU. Skipping AMD P-State configuration."
    exit 0
fi

# Check if we're using GRUB
if [ -f /etc/default/grub ]; then
    echo "Configuring AMD P-State in GRUB..."
    
    # Backup original grub config if not already backed up
    if [ ! -f /etc/default/grub.backup ]; then
        sudo cp /etc/default/grub /etc/default/grub.backup
    fi
    
    # Check if amd-pstate parameter already exists
    if ! grep -q "amd-pstate=" /etc/default/grub; then
        # Add AMD P-State active mode to GRUB_CMDLINE_LINUX_DEFAULT
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 amd-pstate=active"/' /etc/default/grub
        
        # Remove any double spaces
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=" /GRUB_CMDLINE_LINUX_DEFAULT="/' /etc/default/grub
        
        echo "AMD P-State active mode added to GRUB configuration"
        echo "Regenerating GRUB configuration..."
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        
        echo ""
        echo "AMD P-State EPP (Autonomous Mode) has been configured"
        echo "This provides finer grain frequency management than legacy ACPI P-States"
        echo "A reboot is required for changes to take effect"
        echo ""
        echo "After reboot, you can check the current mode with:"
        echo "cat /sys/devices/system/cpu/amd_pstate/status"
        echo ""
        echo "Available modes:"
        echo "- active (EPP/Autonomous): Best for gaming performance"
        echo "- guided (Guided Autonomous): Balanced performance"
        echo "- passive (Non-Autonomous): Legacy-like behavior"
    else
        echo "AMD P-State parameter already present in GRUB configuration"
        
        # Check current mode if system is already configured
        if [ -f /sys/devices/system/cpu/amd_pstate/status ]; then
            current_mode=$(cat /sys/devices/system/cpu/amd_pstate/status)
            echo "Current AMD P-State mode: $current_mode"
        fi
    fi
else
    echo "GRUB configuration not found. Please manually add 'amd-pstate=active' to your bootloader parameters"
fi

# Configure AMD P-State EPP settings if available
if [ -f /sys/devices/system/cpu/amd_pstate/status ]; then
    current_status=$(cat /sys/devices/system/cpu/amd_pstate/status)
    if [[ "$current_status" == *"active"* ]]; then
        echo "Configuring AMD P-State EPP settings for gaming..."
        
        # Set performance governor for gaming
        if command -v cpupower >/dev/null 2>&1; then
            echo "Setting performance governor..."
            sudo cpupower frequency-set -g performance
        fi
        
        # Set performance preference for gaming
        if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
            echo "Setting performance preference for gaming..."
            echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference > /dev/null
            echo "Energy performance preference set to 'performance'"
        fi
        
        # Create systemd service to apply EPP settings on boot
        sudo tee /etc/systemd/system/amd-pstate-epp-gaming.service > /dev/null << 'EOF'
[Unit]
Description=AMD P-State EPP Gaming Configuration
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'cpupower frequency-set -g performance; echo performance > /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
        
        sudo systemctl enable amd-pstate-epp-gaming.service
        echo "AMD P-State EPP gaming service enabled"
    fi
fi

echo "AMD P-State configuration completed"
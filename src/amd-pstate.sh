#!/usr/bin/env bash

set -e

echo "==> AMD P-State Configuration"
echo ""

echo "  [INFO] Configuring AMD P-State driver for optimal gaming performance..."

# Check if system has AMD CPU
if ! grep -q "AuthenticAMD" /proc/cpuinfo; then
    echo "  [INFO] This system does not have an AMD CPU. Skipping AMD P-State configuration."
    exit 0
fi

# Check if we're using GRUB
if [ -f /etc/default/grub ]; then
    echo "  [INFO] Configuring AMD P-State in GRUB..."
    
    # Backup original grub config if not already backed up
    if [ ! -f /etc/default/grub.backup ]; then
        sudo cp /etc/default/grub /etc/default/grub.backup
        echo "  ✓ GRUB configuration backed up"
    fi
    
    # Check if amd-pstate parameter already exists
    if ! grep -q "amd-pstate=" /etc/default/grub; then
        # Add AMD P-State active mode to GRUB_CMDLINE_LINUX_DEFAULT
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 amd-pstate=active"/' /etc/default/grub
        
        # Remove any double spaces
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=" /GRUB_CMDLINE_LINUX_DEFAULT="/' /etc/default/grub
        
        echo "  ✓ AMD P-State active mode added to GRUB configuration"
        echo "  [INFO] Regenerating GRUB configuration..."
        if sudo grub-mkconfig -o /boot/grub/grub.cfg; then
            echo "  ✓ GRUB configuration regenerated"
        else
            echo "  ✗ Failed to regenerate GRUB configuration"
            exit 1
        fi
        
        echo ""
        echo "  ✓ AMD P-State EPP (Autonomous Mode) has been configured"
        echo "  [INFO] This provides finer grain frequency management than legacy ACPI P-States"
        echo "  [INFO] A reboot is required for changes to take effect"
    else
        echo "  ✓ AMD P-State parameter already present in GRUB configuration"
        
        # Check current mode if system is already configured
        if [ -f /sys/devices/system/cpu/amd_pstate/status ]; then
            current_mode=$(cat /sys/devices/system/cpu/amd_pstate/status)
            echo "  [INFO] Current AMD P-State mode: $current_mode"
        fi
    fi
else
    echo "  [WARNING] GRUB configuration not found. Please manually add 'amd-pstate=active' to your bootloader parameters"
fi

# Configure AMD P-State EPP settings if available
if [ -f /sys/devices/system/cpu/amd_pstate/status ]; then
    current_status=$(cat /sys/devices/system/cpu/amd_pstate/status)
    if [[ "$current_status" == *"active"* ]]; then
        echo "  [INFO] Configuring AMD P-State EPP settings for gaming..."
        
        # Ensure cpupower is installed
        if ! command -v cpupower >/dev/null 2>&1; then
            echo "  [INFO] Installing cpupower..."
            if sudo pacman -S --noconfirm cpupower; then
                echo "  ✓ cpupower installed"
            else
                echo "  ✗ Failed to install cpupower"
            fi
        fi
        
        # Set performance governor for gaming
        if command -v cpupower >/dev/null 2>&1; then
            echo "  [INFO] Setting performance governor..."
            if sudo cpupower frequency-set -g performance; then
                echo "  ✓ Performance governor set"
            fi
        fi
        
        # Set performance preference for gaming
        if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
            echo "  [INFO] Setting performance preference for gaming..."
            if echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference > /dev/null; then
                echo "  ✓ Energy performance preference set to 'performance'"
            fi
        fi
        
        # Create systemd service to apply EPP settings on boot
        sudo tee /etc/systemd/system/amd-pstate-epp-gaming.service > /dev/null << 'EOF'
[Unit]
Description=AMD P-State EPP Gaming Configuration
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'cpupower frequency-set -g performance; for cpu in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do echo performance > "$cpu"; done'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
        
        if sudo systemctl enable amd-pstate-epp-gaming.service; then
            echo "  ✓ AMD P-State EPP gaming service enabled"
        else
            echo "  ✗ Failed to enable AMD P-State EPP gaming service"
        fi
    fi
fi

echo "  ✓ AMD P-State configuration completed"
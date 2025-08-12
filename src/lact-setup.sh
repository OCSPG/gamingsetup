#!/bin/bash

set -e

echo "Installing and configuring LACT (Linux AMDGPU Configuration Tool)..."

echo "Installing LACT..."
yes | yay -S --noconfirm --needed lact

echo "Enabling and starting LACT daemon..."
sudo systemctl enable --now lactd

echo "Adding AMDGPU ppfeaturemask kernel parameter..."

# Check if we're using GRUB
if [ -f /etc/default/grub ]; then
    # Backup original grub config if not already backed up
    if [ ! -f /etc/default/grub.backup ]; then
        sudo cp /etc/default/grub /etc/default/grub.backup
    fi
    
    # Check if amdgpu.ppfeaturemask parameter already exists
    if ! grep -q "amdgpu.ppfeaturemask=" /etc/default/grub; then
        # Add AMDGPU ppfeaturemask to GRUB_CMDLINE_LINUX_DEFAULT
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 amdgpu.ppfeaturemask=0xffffffff"/' /etc/default/grub
        
        # Remove any double spaces
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=" /GRUB_CMDLINE_LINUX_DEFAULT="/' /etc/default/grub
        
        echo "AMDGPU ppfeaturemask parameter added to GRUB configuration"
        echo "Regenerating GRUB configuration..."
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        
        echo ""
        echo "LACT has been installed and configured"
        echo "AMDGPU ppfeaturemask=0xffffffff kernel parameter added"
        echo "A reboot is required for the kernel parameter to take effect"
        echo "After reboot, you can use LACT to configure your AMD GPU"
    else
        echo "AMDGPU ppfeaturemask parameter already present in GRUB configuration"
    fi
else
    echo "GRUB configuration not found. Please manually add 'amdgpu.ppfeaturemask=0xffffffff' to your bootloader parameters"
fi

echo "LACT installation and configuration completed"
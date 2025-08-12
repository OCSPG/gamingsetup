#!/bin/bash

set -e

echo "Installing CachyOS gaming packages..."

echo "Installing CachyOS kernel with headers..."
yes | yay -S --noconfirm --needed linux-cachyos linux-cachyos-headers

echo "Skipping Wine installation (will be handled by Wine dependencies script)"

echo "CachyOS gaming packages installation completed"
echo "CachyOS kernel installed"
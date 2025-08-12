#!/bin/bash

set -e

echo "Installing gaming utilities..."

echo "Installing GameMode, MangoHud and MangoJuice..."
yes | yay -S --noconfirm --needed gamemode mangohud mangojuice

echo "Gaming utilities installation completed"
echo "GameMode, MangoHud and MangoJuice are now installed"
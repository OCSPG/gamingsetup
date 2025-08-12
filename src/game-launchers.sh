#!/bin/bash

set -e

echo "Installing game launchers..."

echo "Installing Steam..."
yes | yay -S --noconfirm --needed steam

echo "Installing Heroic Games Launcher..."
yes | yay -S --noconfirm --needed heroic-games-launcher

echo "Game launchers installation completed"
echo "Steam and Heroic Games Launcher are now installed"
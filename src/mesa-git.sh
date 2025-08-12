#!/bin/bash

set -e

echo "Installing Mesa-git packages..."

echo "Installing Mesa-git and lib32-mesa-git (replacing mesa packages)..."
yes | yay -S --needed --overwrite '*' mesa-git lib32-mesa-git

echo "Mesa-git packages installation completed"
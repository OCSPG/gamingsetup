#!/bin/bash

set -e

echo "Installing Discord..."

yes | yay -S --noconfirm --needed discord

echo "Discord installation completed"
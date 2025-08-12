#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$SCRIPT_DIR/src"

echo "Gaming Setup Wrapper Script"
echo "==========================="

echo "Running CachyOS repository setup..."
sudo "$SRC_DIR/cachyos-repo.sh"

echo "Setting vm.max_map_count for game compatibility..."
"$SRC_DIR/vm-max-map-count.sh"

echo "Configuring consistent response time optimizations..."
"$SRC_DIR/consistent-response-time.sh"

echo "Configuring DRI for reduced latency..."
"$SRC_DIR/dri-latency.sh"

echo "Configuring TSC clocksource for improved throughput..."
"$SRC_DIR/clocksource-tsc.sh"

echo "Optimizing PCI Express latencies..."
"$SRC_DIR/pci-latency.sh"

echo "Configuring AMD P-State driver..."
"$SRC_DIR/amd-pstate.sh"

echo "Disabling split lock mitigate..."
"$SRC_DIR/disable-split-lock.sh"

echo "Installing Wine dependencies..."
"$SRC_DIR/wine-dependencies.sh"

echo "Installing Mesa-git packages..."
"$SRC_DIR/mesa-git.sh"

echo "Installing CachyOS gaming packages..."
"$SRC_DIR/cachyos-gaming-packages.sh"

echo "Installing game launchers..."
"$SRC_DIR/game-launchers.sh"

echo "Installing Discord..."
"$SRC_DIR/discord.sh"

echo "Installing gaming utilities..."
"$SRC_DIR/gaming-utilities.sh"

echo "Installing and configuring LACT..."
"$SRC_DIR/lact-setup.sh"

echo "Setting CPU governor to performance..."
"$SRC_DIR/cpu-governor.sh"

echo "All gaming optimizations completed!"
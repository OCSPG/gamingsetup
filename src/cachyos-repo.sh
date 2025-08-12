#!/bin/bash

set -e

echo "Gaming Setup - CachyOS Repository Installation"
echo "=============================================="

# Change to /tmp for downloads
cd /tmp

echo "Downloading CachyOS repository setup..."
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz

echo "Extracting archive..."
tar xvf cachyos-repo.tar.xz && cd cachyos-repo

echo "Running CachyOS repository setup..."
yes | sudo ./cachyos-repo.sh

echo "CachyOS repository setup completed!"
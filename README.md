# Gaming Setup for Arch Linux

An automated gaming optimization setup script for Arch Linux systems, designed to configure optimal gaming performance through system tweaks, package installations, and hardware optimizations.

## Features

### System Optimizations
- **CachyOS Repository**: Adds optimized packages and kernel builds
- **VM Max Map Count**: Sets optimal memory mapping for games (Steam, etc.)
- **CPU Governor**: Configures performance governor for gaming
- **AMD P-State**: Enables AMD P-State EPP for optimal CPU frequency management
- **TSC Clocksource**: Configures TSC for improved clock_gettime throughput
- **PCI Latency**: Optimizes PCI Express latencies
- **Split Lock Mitigation**: Disables for improved gaming performance
- **DRI Latency**: Reduces graphics latency

### Gaming Software
- **Wine & Dependencies**: Complete Wine setup with all required libraries
- **Mesa-git**: Latest Mesa graphics drivers
- **Game Launchers**: Steam, Lutris, and other gaming platforms
- **Gaming Utilities**: GameMode, MangoHud, and performance tools
- **Discord**: Communication platform for gaming
- **LACT**: AMD GPU configuration tool

## Usage

```bash
# Clone the repository
git clone https://github.com/OCSPG/gamingsetup.git
cd gamingsetup

# Run the gaming setup (requires sudo)
sudo bash gaming-setup.sh
```

## Requirements

- Arch Linux system
- Sudo privileges
- Active internet connection

## What it does

The script runs through multiple optimization phases:

1. **Repository Setup**: Adds CachyOS repository for optimized packages
2. **System Tuning**: Applies kernel parameters and system optimizations
3. **Package Installation**: Installs gaming-related packages and dependencies
4. **Hardware Configuration**: Optimizes graphics and CPU settings
5. **Service Configuration**: Sets up gaming-related system services

## Post-Installation

After running the script:

1. **Reboot** your system for all optimizations to take effect
2. Verify optimizations with:
   ```bash
   # Check CPU governor
   cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
   
   # Check VM max map count
   sysctl vm.max_map_count
   
   # Check clocksource (after reboot)
   cat /sys/devices/system/clocksource/clocksource*/current_clocksource
   ```

## Components

The setup is modular, with individual scripts in the `src/` directory:

- `cachyos-repo.sh`: CachyOS repository setup
- `vm-max-map-count.sh`: Memory mapping optimization
- `cpu-governor.sh`: CPU performance tuning
- `amd-pstate.sh`: AMD CPU optimization
- `clocksource-tsc.sh`: Timer optimization
- `pci-latency.sh`: PCI latency reduction
- `wine-dependencies.sh`: Wine setup
- `mesa-git.sh`: Graphics driver installation
- `game-launchers.sh`: Gaming platform installation
- `gaming-utilities.sh`: Additional gaming tools
- `lact-setup.sh`: AMD GPU configuration

## Compatibility

- **Arch Linux**: Primary target
- **CachyOS**: Fully supported
- **Other Arch derivatives**: Should work with minimal modifications

## Safety

- All system modifications are logged
- Original configurations are preserved where possible
- Individual components can be run separately if needed

## Contributing

Feel free to submit issues and pull requests to improve the gaming setup experience.

## License

This project is open source. See individual script files for specific licensing information.
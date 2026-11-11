# Universal Linux Hostname Changer

A lightweight, universal shell script to permanently change the hostname of a Linux machine. 

This script is designed to be compatible with all standard shells (Bash, Zsh, Dash, sh) and works across virtually all known Linux distributions, bridging the gap between modern `systemd`-based systems and older legacy systems.

## Features

- **Universal Shell Compatibility:** Uses `#!/bin/sh` for maximum portability.
- **Modern & Legacy Support:** Utilizes `hostnamectl` if available (systemd), and falls back to standard `hostname` commands and config files for older systems (SysVinit).
- **Comprehensive Updates:** Automatically updates:
  - Memory state (immediate effect)
  - `/etc/hostname` (Debian, Arch, Fedora, etc.)
  - `/etc/sysconfig/network` (Legacy RHEL/CentOS)
  - `/etc/hosts` (Replaces the old hostname to prevent local DNS resolution issues)
- **Safety Checks:** Ensures the script is run with root privileges and validates the input parameters.

## Prerequisites

- Root access (`sudo`) is required to modify system configuration files.

## Usage

1. **Clone the repository or download the script:**
   ```bash
   git clone https://github.com/yourusername/hostname-changer.git
   cd hostname-changer
   ```

2. **Make the script executable:**
   ```bash
   chmod +x change_hostname.sh
   ```

3. **Run the script with `sudo`, passing the new hostname as an argument:**
   ```bash
   sudo ./change_hostname.sh <new_hostname>
   ```
   *Example:*
   ```bash
   sudo ./change_hostname.sh MyNewServerName
   ```

4. **Verify the change:**
   ```bash
   hostname
   ```
   *(Note: You may need to open a new terminal session or re-login for the prompt to reflect the new hostname).*

## Compatibility

Tested and compatible with:
- Debian / Ubuntu / Linux Mint
- Arch Linux / Manjaro
- Fedora / CentOS / RHEL / Rocky Linux
- Alpine Linux
- Any other standard Linux distribution

## License

This project is licensed under the MIT License - see the LICENSE file for details.

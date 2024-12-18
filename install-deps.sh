#!/bin/bash

# Ensure the script is run with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script requires root privileges. Please run with sudo."
    exit 1
fi

# Check if the OS is Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Check if apt is available
    if ! command -v apt &> /dev/null; then
        echo "Error: 'apt' package manager is not available. This script is intended for Debian-based distributions."
        exit 1
    fi

    # Determine the distribution name
    if [ -f "/etc/os-release" ]; then
        source "/etc/os-release"
        
        # Check if Ubuntu 20.04 or 22.04 is detected
        if [[ "$VERSION_CODENAME" == "focal" || "$VERSION_CODENAME" == "jammy" || "$VERSION_CODENAME" == "noble" ]]; then
            echo "Detected Ubuntu $VERSION_CODENAME"
            # Update package repositories
            echo "[OSRM Dependencies Installer] Updating package repositories..."
            apt update || { echo "Error: Failed to update package repositories."; exit 1; }
            
            # Install software prerequisites for OSRM
            echo "[OSRM Dependencies Installer] Installing prerequisites for OSRM..."
            apt install -y \
                build-essential git cmake wget curl screen pkg-config doxygen libboost-all-dev libtbb-dev \
                lua5.2 liblua5.2-dev libluabind-dev libstxxl-dev libstxxl1v5 libxml2 libxml2-dev \
                libosmpbf-dev libbz2-dev libzip-dev libprotobuf-dev || { 
                    echo "Error: Failed to install some prerequisites."; 
                    exit 1; 
                }

            echo "[OSRM Dependencies Installer] All dependencies installed successfully."
        else
            echo "Error: This script is intended for Ubuntu 20.04 (focal) and 22.04 (jammy)."
            exit 1
        fi
    else
        echo "Error: Unable to determine the Linux distribution. '/etc/os-release' is missing."
        exit 1
    fi
else
    echo "Error: This script is intended to run on a Linux operating system."
    exit 1
fi

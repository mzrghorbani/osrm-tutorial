#!/bin/bash

# Check if sudo is available
if !command -v sudo &> /dev/null; then
    echo "Error: This script requires 'sudo' to run. Please ensure it is installed."
    exit 1
fi

# Check if the script is running with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script requires root privileges. Please run with sudo."
    exit 1
fi

# Check if the OS is Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Determine the distribution name
    if [ -f "/etc/os-release" ]; then
        # Read the contents of the os-release file
        source "/etc/os-release"
        
        # Check if Ubuntu 20.04 or 22.04 is detected
        if [[ "$VERSION_CODENAME" == "focal" || "$VERSION_CODENAME" == "jammy" ]]; then
            echo "Detected Ubuntu $VERSION_CODENAME"
            # Update package repositories
            echo "Updating software on your system..."
            sudo apt update || { echo "Error: Failed to update package repositories."; exit 1; }
            
            # Install software prerequisites for OSRM
            echo "Installing software prerequisites for OSRM..."
            sudo apt install build-essential git cmake wget curl screen pkg-config doxygen libboost-all-dev libtbb-dev \
                             lua5.2 liblua5.2-dev libluabind-dev libstxxl-dev libstxxl1v5 libxml2 libxml2-dev \
                             libosmpbf-dev libbz2-dev libzip-dev libprotobuf-dev || { echo "Error: Failed to install software prerequisites for OSRM."; exit 1; }
        else
            echo "Error: This script is intended for Ubuntu 20.04 and 22.04."
            exit 1
        fi
    else
        echo "Error: Unknown Linux distribution."
        exit 1
    fi
else
    echo "Error: This script is intended to run on a Linux operating system."
    exit 1
fi

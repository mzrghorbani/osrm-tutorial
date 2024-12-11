#!/bin/bash

set -e

# Function for logging
log() {
    echo "[OSRM Installer] $1"
}

# Check if required dependencies are installed
dependencies=(git cmake make lua5.2)
for dep in "${dependencies[@]}"; do
    if ! command -v $dep &> /dev/null; then
        echo "Error: $dep is not installed. Please install it before running this script."
        exit 1
    fi
done

# Check if in osrm-tutorial directory
if [[ "$(basename "$(pwd)")" != "osrm-tutorial" ]]; then
    log "Error: Please run this script from the 'osrm-tutorial' directory."
    exit 1
fi

log "You are in the osrm-tutorial directory."

# Clone osrm-backend
log "Cloning osrm-backend from GitHub..."
if [ ! -d "osrm-backend" ]; then
    git clone https://github.com/Project-OSRM/osrm-backend.git
else
    log "Directory 'osrm-backend' already exists. Skipping the clone."
fi

# Create osrm-install directory
log "Creating osrm-install directory for OSRM installation..."
mkdir -p osrm-install/

# Change to osrm-backend directory
cd osrm-backend/

# Remove and recreate build directory
log "Setting up build directory..."
rm -rf build/
mkdir -p build/
cd build/

# Set CXXFLAGS for compatibility
export CXXFLAGS="$CXXFLAGS -DBOOST_ALLOW_DEPRECATED_HEADERS -DBOOST_BIND_GLOBAL_PLACEHOLDERS -Wno-array-bounds -Wno-uninitialized"

# Configure and build OSRM
log "Configuring OSRM with CMake..."
cmake \
    -DCMAKE_INSTALL_PREFIX="$(realpath ../../osrm-install)" \
    -DLUA_INCLUDE_DIR="/usr/include/lua5.2" \
    -DLUA_LIBRARY="/usr/lib/x86_64-linux-gnu/liblua5.2.so" \
    -DCMAKE_CXX_STANDARD=17 \
    -DBOOST_ROOT="$HOME/boost_1_81_0" \
    -DCMAKE_CXX_FLAGS="$CXXFLAGS" \
    ..

log "Building OSRM..."
make -j $(nproc)

log "Installing OSRM..."
make install

# Add OSRM executables to PATH
OSRM_EXEC_PATH=$(realpath ../../osrm-install/bin)

# Check if the system is running on WSL
if grep -qi "Microsoft" /proc/version &> /dev/null; then
    log "Detected WSL environment."
    if command -v wslpath &> /dev/null; then
        WSL_PATH=$(wslpath -a "$OSRM_EXEC_PATH")
        if ! echo "$PATH" | tr ':' '\n' | grep -Fxq "$WSL_PATH"; then
            log "Adding OSRM executables path to system PATH for WSL..."
            export PATH=${PATH}:$OSRM_EXEC_PATH
        fi
    else
        log "wslpath not found. Skipping PATH adjustments for WSL."
    fi
else
    log "Non-WSL Linux environment detected."
    if ! echo "$PATH" | tr ':' '\n' | grep -Fxq "$OSRM_EXEC_PATH"; then
        log "Adding OSRM executables path to system PATH..."
        export PATH=${PATH}:$OSRM_EXEC_PATH
    fi
fi

log "OSRM installation completed. Please refer to instructions in README.md."

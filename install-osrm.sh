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

# Detect Lua include directory
LUA_INCLUDE_DIR=$(pkg-config --cflags-only-I lua5.2 | sed 's/-I//')
if [ -z "$LUA_INCLUDE_DIR" ]; then
    log "Error: Lua 5.2 development files not found. Please install them."
    exit 1
fi

# Boost version
log "Using Custom Installed boost Version 1_18_0..."

# Set CXXFLAGS for compatibility
export CXXFLAGS="$CXXFLAGS -DBOOST_ALLOW_DEPRECATED_HEADERS -DBOOST_BIND_GLOBAL_PLACEHOLDERS -Wno-array-bounds -Wno-uninitialized"

# Configure and build OSRM
log "Configuring OSRM with CMake..."
cmake \
    -DCMAKE_INSTALL_PREFIX="$(realpath ../../osrm-install)" \
    -DLUA_INCLUDE_DIR="$LUA_INCLUDE_DIR" \
    -DBOOST_ROOT="/home/mghorbani/boost_1_81_0" \
    -DCMAKE_CXX_FLAGS="$CXXFLAGS -Wno-array-bounds -Wno-uninitialized" \
    ..

log "Building OSRM..."
make -j $(nproc)

log "Installing OSRM..."
make install

log "OSRM installation completed."

# Add OSRM executables to PATH (for WSL)
OSRM_EXEC_PATH=$(realpath ../../osrm-install/bin)

# Check if the path is already in PATH
if ! echo "$PATH" | tr ':' '\n' | grep -Fxq "$OSRM_EXEC_PATH"; then
    echo "[INFO] OSRM executables path is not in the system PATH."
    echo "To use OSRM commands, add the following to your PATH:"
    echo ""
    echo "    export PATH=\$PATH:$OSRM_EXEC_PATH"
    echo ""
    echo "You can add this line to your shell configuration file (e.g., ~/.bashrc or ~/.zshrc) for persistence."
else
    echo "[INFO] OSRM executables path is already in PATH."
fi

log "Please refer to instructions in README.md."

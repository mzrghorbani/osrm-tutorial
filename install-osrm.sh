#!/bin/bash

set -e

# Check if the user is in the osrm-tutorial directory
if [[ "$(basename "$(pwd)")" == "osrm-tutorial" ]]; then
    echo "You are in the osrm-tutorial directory."

    echo "Cloning osrm-backend from GitHub..."
    if [ ! -d "osrm-backend" ]; then
        git clone https://github.com/Project-OSRM/osrm-backend.git
    else
        echo "Directory 'osrm-backend' already exists. Skipping the clone."
    fi

    echo "Making osrm-install directory for OSRM installation..."
    mkdir -p osrm-install/ && \

    echo "Changing directory to osrm-backend..."
    cd osrm-backend/ && \

    echo "Making build directory for building OSRM cmake files..."
    mkdir -p build/ && \

    echo "Changing directory to build for OSRM installation..."
    cd build/ && \

    echo "Setting CXXFLAGS variables to ensure the compiler applies settings for Boost..."
    export CXXFLAGS="-DBOOST_ALLOW_DEPRECATED_HEADERS -DBOOST_BIND_GLOBAL_PLACEHOLDERS" && \

    echo "Checking CMake version..."
    REQUIRED_CMAKE_VERSION="3.18"
    INSTALLED_CMAKE_VERSION=$(cmake --version | awk '/version/ {print $NF}')

    if dpkg --compare-versions "$INSTALLED_CMAKE_VERSION" "lt" "$REQUIRED_CMAKE_VERSION"; then
        echo "Error: CMake version $REQUIRED_CMAKE_VERSION or higher is required."
        echo "Making cmake-3.27 directory for CMake installation..."
        mkdir -p cmake-3.27/ && \

        echo "Changing directory to cmake-3.27"
        cd cmake-3.27/ && \

        echo "Downloading cmake-3.27.0-rc2-linux-x86_64.tar.gz ..."
        wget https://github.com/Kitware/CMake/releases/download/v3.27.0-rc2/cmake-3.27.0-rc2-linux-x86_64.tar.gz && \

        echo "Extracting cmake-3.27.0-rc2-linux-x86_64.tar.gz ..."
        tar -zxvf cmake-3.27.0-rc2-linux-x86_64.tar.gz && \

        echo "Cleaning up the redundant file..."
        rm cmake-3.27.0-rc2-linux-x86_64.tar.gz && \

        cmake_3_27="$(realpath ./cmake-3.27.0-rc2-linux-x86_64/bin/cmake)" && \

        echo "Installing OSRM with CMake with prefix osrm-install/ and Lua include directory..."
        ${cmake_3_27} -DCMAKE_INSTALL_PREFIX="$(realpath ../../../osrm-install)" -DLUA_INCLUDE_DIR="/usr/include/lua5.2" .. && \

        echo "Returning to osrm build directory..."
        cd .. && \

        echo "Continuing installation with making installation files..."
        make -j 4 && \

        echo "Finally, installing OSRM in osrm-install directory..."
        make install
    else
        echo "Installing OSRM with CMake with prefix osrm-install/ and Lua include directory..."
        cmake -DCMAKE_INSTALL_PREFIX="$(realpath ../../osrm-install)" -DLUA_INCLUDE_DIR="/usr/include/lua5.2" .. && \

        echo "Continuing installation with making installation files..."
        make -j 4 && \

        echo "Finally, installing OSRM in osrm-install directory..."
        make install
    fi

    echo "Adding OSRM executables path to system path..."
    export PATH=${PATH}:$(realpath ../../osrm-install/bin)

    echo "Returning to osrm-backend directory..."
    cd .. && \

    echo "Defining the region and filename for downloading map pbf..."
    # download location: http://download.geofabrik.de/europe/great-britain-latest.osm.pbf
    REGION="europe"
    FILENAME="great-britain-latest"

    # download location: http://download.geofabrik.de/africa/ethiopia-latest.osm.pbf
    # REGION="africa"
    # FILENAME="ethiopia-latest"

    # Construct the download link
    DOWNLOAD_LINK="http://download.geofabrik.de/${REGION}/${FILENAME}.osm.pbf"

    echo "Download link: $DOWNLOAD_LINK"

    echo "Downloading the map data for $FILENAME..."

    if [ ! -f "${FILENAME}.osm.pbf" ]; then
        if wget -c "$DOWNLOAD_LINK"; then
            echo "Download completed successfully."
        else
            echo "Error: Failed to download the map data. The download link is not valid or the file is not available."
            exit 1
        fi
    else
        echo "File '${FILENAME}.osm.pbf' already exists. Skipping the download."
    fi

    echo "Extracting map data. Extraction may take a long time depending on the map size."
    osrm-extract "${FILENAME}.osm.pbf" --threads=10 && \

    echo "Partitioning map data. Partitioning may take a long time depending on the map size."
    osrm-partition "${FILENAME}" && \

    echo "Customising map data. Customising may take a long time depending on the map size."
    osrm-customize "${FILENAME}" && \

    echo "Contracting map network. Contracting may take a long time depending on the map size."
    osrm-contract "${FILENAME}" && \

    echo "Starting the OSRM routing engine in a screen session..."
    screen -dmS osrm osrm-routed --algorithm=MLD "${FILENAME}"

    echo "Checking if osrm-routed process is running in the background..."
    if pgrep -x "osrm-routed" >/dev/null; then
        echo "Congratulations, OSRM routing engine is running."
        echo "Please return to the Jupyter Notebook to run the first python cell."
        echo "If you no longer need the engine running, use the 'screen -S osrm -X quit' to terminate the session."
    else
        echo "Failed to start OSRM routing engine."
        echo "Please run the failed commands, manually."
    fi

else
    echo "Please change directory to the osrm-tutorial directory before running this script."
fi

echo "OSRM installation completed. Please refer to instructions in README.md."
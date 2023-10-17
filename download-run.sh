#!/bin/bash

set -e

# Check the number of arguments passed
if [[ $# -ne 2 ]]; then
    echo "Execute the command with two arguments: region and filename"
    echo "$0 reion filename"
    echo "Example: $0 europe great-britain-latest for http://download.geofabrik.de/REGON/FILENAME.osm.pbf"
    echo "Please visit http://download.geofabrik.de/ to find the reion and filename." 
    exit 1
fi

# Assign command-line arguments to variables
REGION=$1
FILENAME=$2

echo "Changing directory to osrm-backend..."
cd osrm-backend/

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

# Define the OSRM executables path
OSRM_EXEC_PATH=$(realpath ../osrm-install/bin)

# Check if the OSRM executables path is already in the system path
if ! wslpath -a "$PATH" | tr ':' '\n' | grep -Fxq "$(wslpath -a "$OSRM_EXEC_PATH")" >/dev/null; then
    # Add the OSRM executables path to the system path
    echo "Adding OSRM executables path to system path..."
    export PATH=${PATH}:$OSRM_EXEC_PATH
fi

# Check if any osrm file is missing
if [[ ! -f "${FILENAME}.osrm.fileIndex" ]]; then
    # Execute OSRM commands only if any of the necessary osrm files are missing
    echo "Extracting map data. Extraction may take a long time depending on the map size."
    osrm-extract "${FILENAME}.osm.pbf" --threads=10

    echo "Partitioning map data. Partitioning may take a long time depending on the map size."
    osrm-partition "${FILENAME}"

    echo "Customising map data. Customising may take a long time depending on the map size."
    osrm-customize "${FILENAME}"

    echo "Contracting map network. Contracting may take a long time depending on the map size."
    osrm-contract "${FILENAME}"
else
    echo "OSRM files already exist. Skipping extraction, partitioning, customisation, and contraction."
fi

# Check if osrm-routed is already running with the given FILENAME
if ps -aux | grep "osrm-routed" | grep -w "${FILENAME}"; then
    echo "OSRM is already running with $FILENAME."
else
    echo "Terminating any existing osrm-routed processes..."
    killall osrm-routed 2>/dev/null || true

    # Run a new osrm-routed process with the new FILENAME
    echo "Starting OSRM with $FILENAME..."
    screen -dmS osrm osrm-routed --algorithm=MLD "$FILENAME"
fi

cd ../

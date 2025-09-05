#!/bin/bash
# Created by Nelson Durrant, Sep 2024
#
# Pulls and runs the most recent Docker image
# - Use 'bash compose.sh down' to stop the image
# - Run this script after running 'setup.sh' to pull the most recent image and run it
# - Make sure you run this from the root of the top-level repo

echo "This script should be run from the root of the CoUGARS directory"
source scripts/utils/print.sh

case $1 in
  "down")
    printWarning "Stopping all docker images"
    docker compose -f docker/docker-compose.yaml down
    ;;
  *)
    # Check the system architecture
    if [ "$(uname -m)" == "aarch64" ]; then
        printInfo "Loading the runtime image..."
        containers=("cougars")
    else
        # check if gpu is available
        if command -v nvidia-smi &> /dev/null; then
            printInfo "NVIDIA GPU detected. Loading the GPU-enabled development image..."
            containers=("cougars" "cougars_base" "cougars_sim")
        else
            printInfo "No NVIDIA GPU detected. Loading the CPU-only development image..."
            containers=("cougars" "cougars_base")
        fi
    fi
    docker compose -f docker/docker-compose.yaml up -d "${containers[@]}"
    ;;
esac

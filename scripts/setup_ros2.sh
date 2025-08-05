#!/bin/bash
set -e

# Check for force flag
FORCE=0
if [[ "$1" == "-f" ]]; then
    FORCE=1
fi

# Set up workspace
# To be run from the root of the top-level repo
if [ $FORCE -eq 1 ]; then
    echo "Force flag set: cleaning ros2_ws/src"
    rm -rf ros2_ws/src
fi

mkdir -p ros2_ws/src

# Import repositories
vcs import ros2_ws/src < .vcs/cougars.ros2.repos
#!/bin/bash
set -e

# Set up workspace
# To be run from the root of the top-level repo
mkdir -p ros2_ws/src

# Import repositories
vcs import ros2_ws/src < .vcs/cougars.ros2.repos

# Build
cd ros2_ws
colcon build
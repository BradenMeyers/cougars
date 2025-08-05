#!/bin/bash
# - Make sure you run this from the root of the top-level repo

source config/cougarsrc.sh

# Docker updates
docker pull frostlab/cougars:vehicle
docker pull frostlab/cougars:base_station

vcs pull ros2_ws/src




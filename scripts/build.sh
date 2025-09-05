# !/bin/bash

# Ask if they want to clean build
read -p "Do you want to do a clean build? (y/n): " clean_build
if [[ "$clean_build" == "y" || "$clean_build" == "Y" ]]; then
    docker exec -it cougars bash -c "rm -rf ~/ros2_ws/build ~/ros2_ws/install ~/ros2_ws/log"
    docker exec -it cougars_base bash -c "rm -rf ~/base_station/base-station-ros2/build ~/base_station/base-station-ros2/install ~/base_station/base-station-ros2/log"
fi

# Builds the ros2 ws for the cougars project
docker exec -it cougars bash -c "source /opt/ros/humble/setup.bash && cd ~/ros2_ws && colcon build"

docker exec -it cougars_base bash -c "source ~/ros2_ws/install/setup.bash && cd ~/base_station/base-station-ros2 && bash colcon_build.sh"

# Need the true because the first command fails when it can't source the workspace. Could be fixed in the setup.bash file
docker exec -it cougars_sim bash -c "source ~/sim_ws/setup.bash || true; cd ~/sim_ws && colcon build"

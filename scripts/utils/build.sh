# !/bin/bash

# Ask if they want to clean build
read -p "Do you want to do a clean build? (y/n): " clean_build
if [[ "$clean_build" == "y" || "$clean_build" == "Y" ]]; then
    docker exec -it cougars bash -c "rm -rf ~/ros2_ws/build ~/ros2_ws/install ~/ros2_ws/log"
    docker exec -it cougars_base bash -c "rm -rf ~/base_station/base-station-ros2/build ~/base_station/base-station-ros2/install ~/base_station/base-station-ros2/log"
fi

# check if cougars container is running
if ! [ "$(docker ps -q -f name=cougars)" ]; then
    printError "The cougars container is not running. Please start the container and try again."
else
    # Builds the ros2 ws for the cougars project
    docker exec -it cougars bash -c "source /opt/ros/humble/setup.bash && cd ~/ros2_ws && colcon build"
fi

# check architecture
ARCH=$(uname -m | tr -d '\r')
if [ "$ARCH" == "amd64" ]; then
    # check if cougars_base container is running
    if ! [ "$(docker ps -q -f name=cougars_base)" ]; then
        printWarning "The cougars_base container is not running. Please start the container and try again."
    else
        # Builds the base station ros2 ws for the cougars project
        docker exec -it cougars_base bash -c "source ~/ros2_ws/install/setup.bash && cd ~/base_station/base-station-ros2 && bash colcon_build.sh"
    fi


    if ! [ "$(docker ps -q -f name=cougars_sim)" ]; then
        printWarning "The cougars_sim container is not running. Please start the container and try again."
    else
        # Builds the simulation workspace for the cougars project
        # Need the true because the first command fails when it can't source the workspace. Could be fixed in the setup.bash file
        docker exec -it cougars_sim bash -c "source ~/sim_ws/setup.bash || true; cd ~/sim_ws && colcon build"
    fi
fi
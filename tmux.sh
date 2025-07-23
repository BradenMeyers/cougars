#!/bin/bash
# Enhanced tmux session script with flexible windows
# Created by Braden Meyers, Jul 2025

source config/cougarsrc.sh

SESSION="cougars"
ADD_BASE=false
ADD_SIM=false

# Parse arguments
while getopts ":abs" opt; do
  case $opt in
    a)
      ADD_BASE=true
      ADD_SIM=true
      ;;
    b)
      ADD_BASE=true
      ;;
    s)
      ADD_SIM=true
      ;;
    *)
      echo "Usage: $0 [-a] [-b] [-s] | kill"
      exit 1
      ;;
  esac
done

# Shift out processed flags
shift $((OPTIND -1))

# Handle kill case
if [ "$1" == "kill" ]; then
  printWarning "Killing the tmux session..."
  tmux kill-session -t $SESSION
  exit 0
fi

# Start session only if not already running
if ! tmux has-session -t $SESSION 2>/dev/null; then
  printInfo "Creating tmux session: $SESSION"

  #### WINDOW 1 - coug (default window) ####
  tmux new-session -d -s $SESSION -n "coug"

  # Create a 2x2 grid of panes
  tmux split-window -h -t $SESSION:coug.0
  tmux split-window -v -t $SESSION:coug.0
  tmux split-window -v -t $SESSION:coug.2
  tmux select-pane -t $SESSION:coug.0

  # Enter the cougars docker container in each pane
  tmux send-keys -t $SESSION:coug.0 "docker exec -it cougars bash" C-m
  tmux send-keys -t $SESSION:coug.1 "docker exec -it cougars bash" C-m
  tmux send-keys -t $SESSION:coug.2 "docker exec -it cougars bash" C-m
  tmux send-keys -t $SESSION:coug.3 "docker exec -it cougars bash" C-m

  # Run the relevant commands inside the container
  tmux send-keys -t $SESSION:coug.0 "clear" C-m
  tmux send-keys -t $SESSION:coug.0 "cd ~/ros2_ws && bash launch.sh <mission_type>" 

  tmux send-keys -t $SESSION:coug.1 "clear" C-m
  tmux send-keys -t $SESSION:coug.1 "cd ~/ros2_ws && bash test.sh <acoustics>" 

  tmux send-keys -t $SESSION:coug.2 "clear" C-m
  tmux send-keys -t $SESSION:coug.2 "cd ~/ros2_ws && bash record.sh <acoustics>" 

  tmux send-keys -t $SESSION:coug.3 "clear" C-m
  tmux send-keys -t $SESSION:coug.3 "cd ~/config && cat \$VEHICLE_PARAMS_FILE" C-m

  #### Optional: WINDOW 2 - base ####
  if [ "$ADD_BASE" = true ]; then
    tmux new-window -t $SESSION -n "base"
    tmux split-window -v -t $SESSION:base
    tmux split-window -h -t $SESSION:base.1
    tmux send-keys -t $SESSION:base.0 "docker exec -it cougars_base bash" C-m
    tmux send-keys -t $SESSION:base.0 "cd base_station/base-station-ros2 && source install/setup.bash" C-m
    tmux send-keys -t $SESSION:base.1 "docker exec -it cougars_base bash" C-m
    tmux send-keys -t $SESSION:base.2 "docker exec -it cougars_base bash" C-m

    tmux send-keys -t $SESSION:base.0 "clear" C-m
    tmux send-keys -t $SESSION:base.1 "clear" C-m
    tmux send-keys -t $SESSION:base.2 "clear" C-m

    tmux send-keys -t $SESSION:base.0 "ros2 launch launch/terminal_launch.py"
    tmux send-keys -t $SESSION:base.1 "ros2 run plotjuggler plotjuggler" 
    tmux send-keys -t $SESSION:base.2 "cd ~/base_station/mission_control && bash sync_bags.sh" 
  fi

  #### Optional: WINDOW 3 - sim ####
  if [ "$ADD_SIM" = true ]; then
    tmux new-window -t $SESSION -n "sim"
    # tmux split-window -h -t $SESSION:sim
    tmux send-keys -t $SESSION:sim.0 "docker exec -it cougars-sim-holoros bash" C-m
    # tmux send-keys -t $SESSION:sim.1 "docker exec -it cougars-sim-holoros bash" C-m

    tmux send-keys -t $SESSION:sim.0 "cd ~/sim_ws && source setup.bash" C-m
    
    tmux send-keys -t $SESSION:sim.0 "clear" C-m
    # tmux send-keys -t $SESSION:sim.1 "clear" C-m
    
    tmux send-keys -t $SESSION:sim.0 "ros2 launch reverse_converters full_launch.py params_file:=/home/ue4/sim_config/ros_params.yaml" 
  fi
else
  printInfo "Attaching to existing tmux session: $SESSION"
fi

# Attach to the session
tmux attach -t $SESSION

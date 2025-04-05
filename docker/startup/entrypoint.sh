#!/bin/bash

# build custom moos stuff
# cd /home/frostlab/moos-ivp-extend/scripts
# bash clean_build.sh


# TODO change this if from aarch to a bash param
if [ "$(uname -m)" == "aarch64" ]; then
    
    SESSION_NAME="cougars"
    START_DIR="$HOME/ros2_ws"

    # Create a new tmux session (detached)
    tmux new-session -d -s $SESSION_NAME -c "$START_DIR" -n main

    # Set terminal options
    tmux set-option -t $SESSION_NAME default-terminal "screen-256color"
    tmux set-option -t $SESSION_NAME mouse on

    # Pane 0: start with sleep, clear, then run fastdds
    tmux send-keys -t $SESSION_NAME:0.0 "sleep 10" C-m
    tmux send-keys -t $SESSION_NAME:0.0 "clear" C-m
    tmux send-keys -t $SESSION_NAME:0.0 "fastdds discovery --server-id \$VEHICLE_ID" C-m

    # Split horizontally (even-horizontal is default in split-window)
    tmux split-window -h -t $SESSION_NAME:0 -c "$START_DIR"

    # Pane 1: sleep, clear, echo, then run launch
    tmux send-keys -t $SESSION_NAME:0.1 "sleep 20" C-m
    tmux send-keys -t $SESSION_NAME:0.1 "clear" C-m
    tmux send-keys -t $SESSION_NAME:0.1 "echo \"Using ROS namespace \$NAMESPACE\"" C-m

    
    tmux send-keys -t $SESSION_NAME:0.1 "bash launch.sh full" C-m
fi


exec /bin/bash
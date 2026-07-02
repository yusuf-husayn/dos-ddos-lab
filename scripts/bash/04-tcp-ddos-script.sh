#!/bin/bash
# Session Name
SESSION="TCP_sim"

# Create a new tmux session
tmux new-session -d -s $SESSION

# Split screen into 10 parts (Tiled)
for i in {1..9}; do
    tmux split-window -h
    tmux select-layout tiled
done

# Sending the run command for each part
for pane in $(tmux list-panes -t $SESSION -F '#{pane_id}'); do
    tmux send-keys -t "$pane" "sudo python3 TCP_Data-Flood.py" C-m
done

# Login to the session
tmux attach-session -t $SESSION

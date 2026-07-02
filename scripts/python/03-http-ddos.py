import socket
import ssl
import threading
import time

# Goal settings
server_ip = '192.168.1.25'
server_port = 80 # Use 80 for HTTP, and 443 for HTTPS.
num_threads = 10000
test_duration = 10 # In seconds
delay_between_requests = 0.1 # In seconds

stop_time = time.time() + test_duration

success_count = 0
failure_count = 0
lock = threading.Lock()

def send_request():
    global success_count, failure_count
    while time.time() < stop_time:
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(5)
            sock.connect((server_ip, server_port))
            
            if server_port == 443:
                context = ssl.create_default_context()
                sock = context.wrap_socket(sock, server_hostname=server_ip)
            
            http_request = f"GET / HTTP/1.1\r\nHost: {server_ip}\r\nConnection: close\r\n\r\n"
            sock.sendall(http_request.encode())
            response = sock.recv(1024)
            sock.close()
            
            with lock:
                success_count += 1
        except Exception:
            with lock:
                failure_count += 1
        
        time.sleep(delay_between_requests)

threads = []
for _ in range(num_threads):
    t = threading.Thread(target=send_request)
    threads.append(t)
    t.start()

for t in threads:
    t.join()

print(f"Test completed. Successes: {success_count}, Failures: {failure_count}")

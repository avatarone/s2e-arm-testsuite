import socket
import sys
import json
import time

if __name__ == "__main__":
    print("Delayed server started")
    sock = socket.create_connection((sys.argv[1], int(sys.argv[2])))
    range_over = False
    while not range_over:
        buf = ""
        while not buf or not buf[-1] == '\n':
            buf += sock.recv(1)
        try:
            obj = json.loads(buf.strip())
        except Exception as e:
            print(e) 
        if obj["cmd"] == "write":
            time.sleep(0.02)
            print("Write: %s to %s (size %s)" % (obj["params"]["value"], obj["params"]["address"], obj["params"]["size"]))
            if int(obj["params"]["address"], 16) == 0x21998:
                print("Reached address 0x%08x" % int(obj["params"]["address"], 16))
        elif obj["cmd"] == "read":
            if int(obj["params"]["address"], 16) == 0x21998 and  int(obj["params"]["size"], 16) == 4:
                print("Last read received ok")
                sock.send(json.dumps({"reply": 'read', "value": "0x%x" % 0xdeadbeef}) + "\n")
                range_over=True
        else:
            print("ERROR: unexpected command: '%s'" % obj["cmd"])
    time.sleep(1)
        
    

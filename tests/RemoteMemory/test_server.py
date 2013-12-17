import socket
import sys
import json
import time

if __name__ == "__main__":
    print("Hello world")
    sock = socket.create_connection((sys.argv[1], int(sys.argv[2])))
    for i in range(0, 6):
        buf = ""
        while not buf or not buf[-1] == '\n':
            buf += sock.recv(1)
            
        obj = json.loads(buf.strip())
        if obj["cmd"] == "read":
            if i == 0 and int(obj["params"]["address"], 16) == 0x10000 and  int(obj["params"]["size"], 16) == 4:
                print("First read received ok")
                sock.send(json.dumps({"reply": 'read', "value": "0x%x" % 0xdeadbeef}) + "\n")
            elif i == 1 and int(obj["params"]["address"], 16) == 0x10010 and  int(obj["params"]["size"], 16) == 2:
                print("Second read received ok")
                sock.send(json.dumps({"reply": 'read', "value": "0x%x" % 0xbabe}) + "\n")
            elif i == 2 and int(obj["params"]["address"], 16) == 0x10020 and  int(obj["params"]["size"], 16) == 1:
                print("Third read received ok")
                sock.send(json.dumps({"reply": 'read', "value": "0x%x" % 0x13}) + "\n")
            else:
                print("ERROR: unexpected request: '%s'" % buf.strip())
        elif obj["cmd"] == "write":
            if i == 3 and int(obj["params"]["address"], 16) == 0x10000 and  int(obj["params"]["size"], 16) == 4 and int(obj["params"]["value"], 16) == 0xb16b00b5:
                print("Fourth write received ok")
            elif i == 4 and int(obj["params"]["address"], 16) == 0x10010 and  int(obj["params"]["size"], 16) == 2 and int(obj["params"]["value"], 16) == 0xcafe:
                print("Fifth write received ok")
            elif i == 5 and int(obj["params"]["address"], 16) == 0x10020 and  int(obj["params"]["size"], 16) == 1 and int(obj["params"]["value"], 16) == 0x42:
                print("Sixth write received ok")
            else:
                print("ERROR: unexpected request: '%s'" % buf.strip())
        else:
             print("ERROR: unexpected command: '%s'" % obj["cmd"])
        
    

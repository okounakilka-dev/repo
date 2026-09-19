import socket, json, sys
HOST="127.0.0.1"; PORT=9876
def send(cmd_type, params=None, timeout=180):
    s=socket.create_connection((HOST,PORT),timeout=10)
    s.settimeout(timeout)
    msg={"type":cmd_type,"params":params or {}}
    s.sendall(json.dumps(msg).encode())
    chunks=[]; s.settimeout(timeout)
    while True:
        ch=s.recv(8192)
        if not ch: break
        chunks.append(ch)
        try:
            data=b''.join(chunks)
            json.loads(data.decode())
            break
        except: continue
    s.close()
    d=json.loads(b''.join(chunks).decode())
    if d.get("status")=="error":
        print("BLENDER_ERROR:",d.get("message")[:2000]); sys.exit(1)
    r=d.get("result",{})
    print("OK:",str(r)[:2000])
    return r
if __name__=="__main__":
    code=open(sys.argv[1],encoding="utf-8").read()
    send("execute_code",{"code":code})

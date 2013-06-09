# Chapter 3 TCP
# Simple TCP client and server that receive and send 16 bytes 

import socket, sys
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

HOST = sys.argv.pop() if len(sys.argv) == 3 else '127.0.0.1'
PORT = 1060

def recv_all(sock, length): #equivalent to sendall()
    data = ''
    while len(data) < length:
        more = sock.recv(length - len(data)).decode()
        if not more:
            raise EOFError('socket closed %d bytes into a %d-byte message' % (len(data), length))
        data += more
    return data

if sys.argv[1] == 'server':
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1) #s is the passive socket; without waiting for natural timeout (4min) to expire
    s.bind((HOST,PORT))
    s.listen(1) # listen() only supports TCP
    while True:
        print('Listening at', s.getsockname())
        sc, sockname = s.accept() #incoming msg generates an active socket sc
        print('Passive socket', s.getsockname(), 'Active socket', sc.getsockname()) #same; TCP defined by (local_ip, local_port, remote_ip, remote_port)
        print('We have accepted a connection from', sockname)
        print('Socket connects', sc.getsockname(), 'and', sc.getpeername()) #getpeername = sockname
        message = recv_all(sc, 16) #know in advance that message is 16 bytes long
        print('The incoming sixteen-octet message says', repr(message))
        sc.sendall(b'Farewell, client') # complete delivery or fail assured; 16 bytes long
        sc.close()
        print('Reply sent. Socket closed')

elif sys.argv[1] == 'client':
    s.connect((HOST, PORT)) #TCP can fail here; UDP won't
    print('Client has been assigned socket name', s.getsockname())
    s.sendall(b'Hi there, server') # 16 bytes long
    reply = recv_all(s, 16)
    print('The server said', repr(reply))
    s.close()
else:
    print('usage: tcp_sixteen.py server|client [host]', file=sys.stderr)

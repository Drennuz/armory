# chapter 5
# sending blocks of data with length prefix
# unpack length of data first

import sys, struct, socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

HOST = sys.argv[2] if len(sys.argv) == 3 else '127.0.0.1'
PORT = 1060
structFormat = struct.Struct('!I')

def recvall(sock, length):
    data = b''
#    print(length)
    while len(data) < length:
        more = sock.recv(length - len(data))
        if not more:
            raise EOFError('socket closed %d bytes into a %d-byte message' % (len(data), length))
        data += more
    return data

def get(sock):
    lendata = recvall(sock, structFormat.size) # get first 4 bytes only
    (length,) = structFormat.unpack(lendata) # get length
    return recvall(sock, length) # get remaining

def put(sock, message):
    sock.send(structFormat.pack(len(message)) + message) # encode length into message

if len(sys.argv) < 2:
    print('usage: block.py server | client [<host>]', file = sys.stderr)
    sys.exit(2)

if sys.argv[1] == 'server':
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST, PORT))
    s.listen(1)
    print('Listening at', s.getsockname())
    sc, sockname = s.accept()
    print('Accepted connection from', sockname)
    sc.shutdown(socket.SHUT_WR)
    while True:
        message = get(sc)
        if not message:
            break
        print('Message says:', repr(message.decode()))
    sc.close()
    s.close()
elif sys.argv[1] == 'client':
    s.connect((HOST, PORT))
    s.shutdown(socket.SHUT_RD)
    put(s, b'Beautiful is better than ugly.\n')
    put(s, b'Explicity is better than implicity.\n')
    put(s, b'Simple is better than complexity.\n')
    put(s, b'')
    s.close()
else:
    print('usage: block.py server | client [<host>]', file = sys.stderr)

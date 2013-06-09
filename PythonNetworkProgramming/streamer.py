# client closes socket after writing complete

import sys, socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

HOST = sys.argv.pop() if len(sys.argv) == 3 else '127.0.0.1'
PORT = 1060

if len(sys.argv) >= 2 and sys.argv[1] == 'server':
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR,1)
    s.bind((HOST,PORT))
    s.listen(1)
    print('Listening at:', s.getsockname())
    sc, sockname = s.accept()
    print('Accepted connection from', sockname)
    sc.shutdown(socket.SHUT_WR)
    message = b''
    while True:
        more = sc.recv(8192)
        if not more:
            break
        message += more
    print('Done receiving the message; it says', message.decode())
    sc.close()
    s.close()
elif len(sys.argv) >= 2 and sys.argv[1] == 'client':
    s.connect((HOST,PORT))
    s.shutdown(socket.SHUT_RD)
    s.sendall(b'Beautiful is better than ugly.\n')
    s.sendall(b'Explicit is better than implicit.\n')
    s.sendall(b'Simple is better than complex.\n')
    s.close()
else:
    print('usage: streamer.py server | client [<hostname>]', file = sys.stderr)

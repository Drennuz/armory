# Chapter 3 TCP

import socket, sys
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

PORT = 1060
HOST = '127.0.0.1'

if sys.argv[1] == 'server':
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST,PORT))
    s.listen(1)
    while True:
        print('Listening at:', s.getsockname())
        sc, sockname = s.accept()
        print('Processing up to 1024 bytes at a time from', sockname)
        n = 0
        while True:
            message = sc.recv(1024).decode() # recv <= 1024
            if not message:
                break
            sc.sendall((message.upper()).encode())
            n += len(message)
            print('\r%d bytes processed so far' % n)
            sys.stdout.flush()
        print()
        sc.close()
        print('Complete processing')
elif len(sys.argv) == 3 and sys.argv[1] == 'client':
    bytes = (int(sys.argv[2]) + 15) // 16 * 16
    message = b'capitalize this!'
    print('Sending', bytes, 'bytes of data, in chunks of 16 bytes')
    s.connect((HOST, PORT))

    sent = 0
    while sent < bytes: # client send all data first then recv, while server keeps sending back --> deadlock
        s.sendall(message)
        sent += len(message)
        print('\r%d bytes sent' % sent)
        sys.stdout.flush()
    print()
    s.shutdown(socket.SHUT_WR)
    print('Receiving all the data the server sends back')

    received = 0
    while True:
        data = s.recv(42)
        if not received:
            print('The first data received says', repr(data))
        received += len(data)
        if not data:
            break
        print('\r%d bytes received' % received)
    s.close()
else:
    print('usage: tcp_deadlock.py server | client <bytes>', file=sys.stderr)

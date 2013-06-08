import socket, sys

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

MAX = 65535
PORT = 1060

if sys.argv[1:] == ['server']:
    s.bind(('127.0.0.1', PORT))
    print('Listening at', s.getsockname())
    while True:
        data, address = s.recvfrom(MAX)
        print('The client at', address, 'says ,', repr(data))
        reply = 'Your data was ' + str(len(data.decode())) + 'bytes'
        s.sendto(reply.encode(), address)

elif sys.argv[1:] == ['client']:
    print('Address before sending: ', s.getsockname())
    s.sendto(b'This is my message', ('127.0.0.1', PORT))
    print('Address after sending: ', s.getsockname())
    data, address = s.recvfrom(MAX)
    print('The server ', address, 'says ', repr(data))

else:
    print('usage: udp_local.py server|client', file=sys.stderr)

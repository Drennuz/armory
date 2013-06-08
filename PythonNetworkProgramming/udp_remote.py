import socket, random, sys
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

MAX = 65535
PORT = 1060

if 2 <= len(sys.argv) <= 3 and sys.argv[1] == 'server':
    interface = sys.argv[2] if len(sys.argv) > 2 else ''
    s.bind((interface, PORT))
    print('Listening at', s.getsockname())
    while True:
        data, address = s.recvfrom(MAX)
        if random.randint(0,1):
            print('The client at', address, ' says: ', repr(data))
            reply = 'Your data was ' + str(len(data.decode())) + 'bytes'
            s.sendto(reply.encode(), address)
        else:
            print('Pretending to drop packet from ', address)
elif len(sys.argv) == 3 and sys.argv[1] == 'client':
    hostname = sys.argv[2]
    s.connect((hostname, PORT))
    print('Client socket name is', s.getsockname())
    delay = 0.1
    while True:
        s.send(b'This is another message')
        print('Waiting up to ', delay, ' seconds for a reply')
        s.settimeout(delay)
        try:
            data = s.recv(MAX)
        except socket.timeout:
            delay *= 2
            if delay > 2.0:
                raise RuntimeError('I think the server is doen')
        except:
            raise
        else:
            break
else:
    print('usage: udp_remote.py server [ <interface> ]',file=sys.stderr)
    print('or: udp_remote.py client <host>', file = sys.stderr)
    sys.exit(2)

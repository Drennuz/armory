# chapter 4

import sys, socket

if len(sys.argv) != 2:
    print('usage: forward_reverse.py <hostname>', file = sys.stderr)
    exit(2)

hostname = sys.argv[1]

try:
    infolist = socket.getaddrinfo(hostname, 'www', 0, socket.SOCK_STREAM, 0, socket.AI_ADDRCONFIG | socket.AI_V4MAPPED | socket.AI_CANONNAME,)
except socket.gaierror as e:
    print('Forward name service failure:', e.args[1])
    sys.exit(1)

info = infolist[0]
cannonical = info[3]
socketname = info[4]
ip = socketname[0]

if not cannonical:
    print('WARNING: The IP address ', ip, 'has no reverse name')
    sys.exit(1)

print(hostname, 'has iP address', ip)
print(ip, 'has the cannonical hostname', cannonical)

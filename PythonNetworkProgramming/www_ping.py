# chapter 4 

import sys, socket

if len(sys.argv) != 2:
    print('usage: www_ping.py <hostname_or_ip>', file = sys.stderr)
    sys.exit(2)

hostname_or_ip = sys.argv[1]

try:
    infolist = socket.getaddrinfo(hostname_or_ip, 'www', 0, socket.SOCK_STREAM, 0, socket.AI_ADDRCONFIG | socket.AI_V4MAPPED | socket.AI_CANONNAME,)
except socket.gaierror as e:
    print('Name service failure:', e.args[1])
    sys.exit(1)

info = infolist[0]
socket_args = info[0:3]
address = info[4]
s = socket.socket(*socket_args) # completely general
try:
    s.connect(address)
except socket.error as e:
    print('Network failure:', e.args[1])
else:
    print('Success: host', info[3], address, 'is listening on port 80')


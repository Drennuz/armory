import socket, launcelot, select

listen_sock = launcelot.setup()
poll = select.poll()
requests = {}
responses = {}
socks = {listen_sock.fileno():listen_sock}

poll.register(listen_sock, select.POLLIN)

while True:
    for fd, event in poll.poll(): # poll() is blocking
        sock = socks[fd]
        if event & (select.POLLERR | select.POLLHUP | select.POLLNVAL):
            poll.unregister(fd)
            del socks[fd]
            requests.pop(sock, None)
            responses.pop(sock, None)

        elif sock is listen_sock: # new connection
            new_sock, address = sock.accept()
            new_sock.setblocking(False)
            poll.register(new_sock, select.POLLIN)
            socks[new_sock.fileno()] = new_sock
            requests[new_sock] = ''

        elif event & select.POLLIN:
            data = sock.recv(4096).decode()
            if not data:
                sock.close()
                continue
            requests[sock] += data
            if '?' in requests[sock]:
                q = requests.pop(sock)
                a = launcelot.qa_dict[q]
                poll.modify(sock, select.POLLOUT)
                responses[sock] = a

        elif event & select.POLLOUT:
            response = responses.pop(sock)
            n = sock.send(response.encode()) #non-blocking
            if n < len(response):
                responses[sock] = response[n:]
            else:
                poll.modify(sock, select.POLLIN)
                requests[sock] = ''

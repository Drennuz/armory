import launcelot

def handle_client(sock):
    try:
        while True:
            q = launcelot.recv_until(sock, '?')
            a = launcelot.qa_dict[q]
            sock.sendall(a.encode())
    except EOFError as e:
        sock.close()

def server_loop(listen_sock):
    while True:
        client_sock, address = listen_sock.accept()
        handle_client(client_sock)

if __name__ == '__main__':
    listen_sock = launcelot.setup()
    server_loop(listen_sock)

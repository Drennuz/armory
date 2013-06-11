import launcelot, socket, sys

def client(host, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, port))
    s.sendall(launcelot.qa_pair[0][0].encode())
    answer1 = launcelot.recv_until(s, '.')
    s.sendall(launcelot.qa_pair[1][0].encode())
    answer2 = launcelot.recv_until(s, '.')
    s.sendall(launcelot.qa_pair[2][0].encode())
    answer3 = launcelot.recv_until(s, '.')
    print(answer1, answer2, answer3)
    s.close()

if __name__ == '__main__':
    if not 2 <= len(sys.argv) <= 3:
        print("usage: client.py hostname [port]", file = sys.stderr)
    port = int(sys.argv[2]) if len(sys.argv) > 2 else launcelot.PORT
    client(sys.argv[1], port)

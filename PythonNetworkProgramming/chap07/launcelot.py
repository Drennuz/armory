import socket, sys
PORT = 1060

qa_pair = (('What is your name?', 'My name is Drennuz.'),\
           ('What is your quest?', 'To seek the Holy Grail.'),\
           ('What is your favorite color?', 'Grey.'))
qa_dict = dict(qa_pair)

def recv_until(socket, suffix):
    message = ''
    while not message.endswith(suffix):
        data = socket.recv(4096)
        if not data:
            raise EOFError('socket closed before we saw %r' % suffix)
        message += data.decode()
    return message

def setup():
    if len(sys.argv) < 2:
        print('usage: %s interface' % sys.argv[0], file = sys.stderr)
        exit(2)
    interface = sys.argv[1]
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind((interface, PORT))
    sock.listen(128)
    print('Ready and listening at %r port %d' % (interface, PORT))
    return sock

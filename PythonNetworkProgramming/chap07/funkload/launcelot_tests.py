from funkload.FunkLoadTestCase import FunkLoadTestCase
import socket, os, unittest, launcelot

SERVER_HOST = 'localhost'

class TestLauncelot(FunkLoadTestCase):
    def test_dialog(self):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((SERVER_HOST, launcelot.PORT))
        for i in range(10):
            q, a = launcelot.qa_pair[i % len(launcelot.qa_pair)]
            sock.sendall(q)
            reply = launcelot.recv_until(sock, '.')
            self.assertEqual(reply, a)
        sock.close()
if __name__ == '__main__':
    unittest.main()

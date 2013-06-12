from urllib.request import HTTPHandler
from http.client import HTTPResponse, HTTPConnection
import io

class VerboseHTTPResponse(HTTPResponse):
    def _read_status(self):
        s = self.fp.read()
        print('-' * 20, 'Response', '-' * 20)
        print(s.split(b'\r\n\r\n')[0].decode('ascii'))
        self.fp = io.BytesIO(s)
        return HTTPResponse._read_status(self)

class VerboseHTTPConnection(HTTPConnection):
    response_class = VerboseHTTPResponse
    def send(self, s):
        print ('-' * 50)
        print(s.strip().decode('ascii'))
        HTTPConnection.send(self, s)

class VerboseHTTPHandler(HTTPHandler):
    def http_open(self, req):
        return self.do_open(VerboseHTTPConnection, req)

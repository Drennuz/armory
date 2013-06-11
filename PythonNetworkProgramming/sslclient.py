import ssl, sys, socket, os

try:
    script_name, hostname = sys.argv
except ValueError:
    print('usage: sslclient.py <hostname>', file = sys.stderr)

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((hostname, 443))

ca_certs_path = os.path.join(os.path.dirname(script_name), 'certfiles.crt') #cert file is for validating certificates passed from other side

#CERT_REQUIRED for client
ssl_sock = ssl.wrap_socket(s, ssl_version=ssl.PROTOCOL_TLSv1, cert_reqs=ssl.CERT_REQUIRED, ca_certs=ca_certs_path) 

try:
    print(ssl_sock.getpeercert()) #already validated
    ssl.match_hostname(ssl_sock.getpeercert(), hostname)
except ssl.CertificateError as e:
    print('Certificate error!', str(e))
    sys.exit(1)

ssl_sock.sendall(b'GED / HTTP/1.0\r\n \r\n')
result = ssl_sock.makefile().read()
ssl_sock.close()
print('The document https://%s/ is %d bytes long' % (hostname, len(result)))

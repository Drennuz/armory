Foundations of Python Network Programming
======


Chapter 3 TCP
------

```python
sc.shutdown(socket.SHUT_WR) # no more writing
socket.SHUT_RD # no more reading
socket.SHUT_RDWR # disable socket for ALL processes
```

Chapter 4 Socket names and DNS
------

getaddrinfo :

```python
     infolist = socket.getaddrinfo('mit.edu', 'www')
     ftpca = infolist[0]
     s = socket.socket(*ftpca[0:3])
     s.connect(ftpca[4])
     socket.getprotobyname('UDP')
     socket.getservbyname('www')
     socket.getservbyport(80)
```

DNS :

use raw DNS for SMTP: connect to MX records

    whois python.org

VirtualEnv (Python 2.x):

    virtualenv --no-site-packages dns #create virtualenv
    cd dns/
    source ./bin/activate #activate
    pip install xxx
    python -c xxx # load package into python
    deactivate


Chapter 5 Network Data and Network Errors
------
`struct`, `pickle`  for converting to bytes objects

```python
hex(4253)
import struct
struct.pack('<i', 4253) # little endian
struct.pack('>i', 4253) # big endian
format = struct.Struct('!I')
format.pack(4253)
```

Framing: when is it safe for receiver to stop calling `recv()`?

Options:
* use delimitors
* Prefix each message with length

JSON: sending data between different languages
compression: zlib; self-framing

Raw socket exceptions:
* socket.gaierror
* socket.error
* socket.timeout

Python exception:
```python
try:
    ...
except:
    ...
else:
    ...
finally:
    ...
```
```python
class MyError(Exceptions):
    def __init__(self, value):
        self.value = value
    def __str__(self, value):
        return repr(self.value)
```

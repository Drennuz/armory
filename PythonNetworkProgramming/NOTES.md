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


Chapter 6 TLS and SSL
------
TLS encryption:
* public-key cryptography:
info encrypted by private key can be decrypted by all public key holders; info encrypted by public key can only be decrypted by private key
* server sends CA-signed public key to client, client sends back shared symmetric key encrypted by server's public key, talk with symmetric key afterwards. 
CA: generate certificate using CA's private key
* use `ssl` library:
```python
ssl_sock = ssl.wrap_socket #parameters can be different regarding server/client
try:
    ssl.match_hostname(ssl_sock.getpeercert(), hostname)
except ssl.CertificateError as ce:
    #do something
```

Chapter 7 Server Architecture
------
* `recv()`: blocking

* Benchmarking: funkload

* Event driven servers: handle multiple clients inter-leavingly
    `select` module, `poll` object. 
    `poll.poll()` is still blocking

* Parallelism: (can base on a single blocking logic)

    Thread-based: single processor; data shared automatically; Global Interpreter Lock prevents >= 2 threads under C Python (still ok for multiple I/O events -- GIL release Python interpreter upon reaching an external I/O call like `recv()` `accept()` `send()`

    Process-based: multiple processors

    `multiprocessing`, `thread` module:
    ```python
    worker = Thread(target = function, args = ()) | Process(target = function, args = ())
    worker.daemon = True
    worker.start() # start running the target function passed 
    ```

* Concurrent programming:
    How do threads/processes communicate to each other


Chap 08 Caches, Message Queues, Map-Reduce
------
* Memcached
    key-value cache (like dict) distributed & shared among servers; combine free RAM from servers
    operates on least-recently-used bases (expiration)
    * sharding:
        client hash the key-value to determine which server in the cluster to enquire for the key
    `/usr/share/dict/words`: dictionary file
    * hashlib
* Message Queues
    message as atomic unit; no more `recv` loops; not only point-to-point
    coordinate different parts of application (perhaps different hardware/languages/platforms)
    hiding number of servers or processes --> allow server disconnect/upgrade/reboot
    * pipe line
    * publisher - subscriber
    * request - reply
* Map-Reduce:
    distributed computing (distributing data & task -- map; collecting results -- result)
    ```python
    squares = map(lambda n: n*n, range(11)) # map
    reduce(operator.add, squares) # reduce
    ```
    hadoop: user build own server farms

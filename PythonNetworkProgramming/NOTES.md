Foundations of Python Network Programming
======

Chapter 4 Socket names and DNS
------

1. getaddrinfo :
```

    infolist = socket.getaddrinfo('mit.edu', 'www')
    ftpca = infolist[0]
    s = socket.socket(*ftpca[0:3])
    s.connect(ftpca[4])

    socket.getprotobyname('UDP')
    socket.getservbyname('www')
    socket.getservbyport(80)
```
2. DNS :

use raw DNS for SMTP: connect to MX records
```

    whois python.org
```
3. VirtualEnv (Python 2.x):
```

    virtualenv --no-site-packages dns #create virtualenv
    cd dns/
    source ./bin/activate #activate
    pip install xxx
    python -c xxx # load package into python
    deactivate
```

    

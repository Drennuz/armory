Foundations of Python Network Programming
======

Chapter 4 Socket names and DNS
------

1. getaddrinfo :

    infolist = socket.getaddrinfo('mit.edu', 'www')
    ftpca = infolist[0]
    s = socket.socket(*ftpca[0:3])
    s.connect(ftpca[4])



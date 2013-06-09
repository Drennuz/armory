# Python 2.x compatible

import sys, DNS

if len(sys.argv) != 2:
    print>>sys.stderr, 'usage: dns_mx.py <hostname>'
    sys.exit(2)

def resolve_hostname(hostname, indent = 0):
    indent += 4
    istr = ' ' * indent
    request = DNS.Request()
    dnstype = {'A':DNS.Type.A, 'AAAA':DNS.Type.AAAA, 'CNAME': DNS.Type.CNAME}
    for key in dnstype.keys():
        reply = request.req(name = hostname, qtype = dnstype[key])
        if reply.answers:
            for answer in reply.answers:
                print istr, 'Hostname', hostname, ' = ', key, answer['data']
            return
    print istr, 'ERROR: no records for', hostname

def resolve_email_domain(domain):
    request = DNS.Request()
    reply = request.req(name = domain, qtype = DNS.Type.MX)
    if reply.answers:
        print 'The domain %r has explicit MX records!' % domain
        print 'Try the servers in this order:'
        datalist = [answer['data'] for answer in reply.answers]
        datalist.sort()
        for data in datalist:
            priority = data[0]
            hostname = data[1]
            print 'Priority:', priority, ' Hostname', hostname
            resolve_hostname(hostname)
    else:
        print 'Drat, this domain has no explicit MX records'
        print 'We will have to try resolving it as an A, AAAA, CNAME'
        resolve_hostname(domain)

DNS.DiscoverNameServers()
resolve_email_domain(sys.argv[1])


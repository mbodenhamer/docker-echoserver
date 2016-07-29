import os
import sys
import gevent
import signal
import subprocess
from gevent.server import StreamServer

args = sys.argv[1:]
SERVERS = []

#-------------------------------------------------------------------------------

def get_ports():
    ports = os.environ.get('LISTEN_PORTS', '5000')
    return map(ports.split(','), int)

#-------------------------------------------------------------------------------

# https://github.com/gevent/gevent/blob/master/examples/echoserver.py
def echo(socket, address):
    print('New connection from %s:%s' % address)
    socket.sendall(b'Welcome to the echo server! Type quit to exit.\r\n')
    # using a makefile because we want to use readline()
    rfileobj = socket.makefile(mode='rb')
    while True:
        line = rfileobj.readline()
        if not line:
            print("client disconnected")
            break
        if line.strip().lower() == b'quit':
            print("client quit")
            break
        socket.sendall(line)
        print("echoed %r" % line)
    rfileobj.close()

#-------------------------------------------------------------------------------

def shutdown():
    print('Shutting down ...')
    for server in SERVERS:
        server.stop(timeout=0.1)    
    exit(signal.SIGTERM)

#-------------------------------------------------------------------------------

def main():
    gevent.signal(signal.SIGTERM, shutdown)

    for port in get_ports():
        server = StreamServer(('', port), echo)
        SERVERS.append(server)
        server.serve_forever()

#-------------------------------------------------------------------------------

if __name__ == '__main__':
    if args:
        subprocess.call(args, shell=True)
    else:
        main()

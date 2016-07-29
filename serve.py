import sys
import gevent
import signal
from gevent.server import StreamServer

#-------------------------------------------------------------------------------

# https://github.com/gevent/gevent/blob/master/examples/echoserver.py
def echo(socket, address):
    print('New connection from %s:%s' % address)
    #socket.sendall(b'Welcome to the echo server! Type quit to exit.\r\n')
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

port = int(sys.argv[1])
server = StreamServer(('', port), echo)

def shutdown():
    print('Shutting down ...')
    server.stop(timeout=0.1)    
    exit(signal.SIGTERM)

#-------------------------------------------------------------------------------

def main():
    gevent.signal(signal.SIGTERM, shutdown)
    server.serve_forever()

#-------------------------------------------------------------------------------

if __name__ == '__main__':
    main()

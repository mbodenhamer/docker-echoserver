A dockerized echo server using [gevent](http://www.gevent.org/).

## Usage

The container can be configured to listen on multiple ports. Specify the ports as a comma-separated list given to the `LISTEN_PORTS` environment variable:

    $ docker run --rm -it -e LISTEN_PORTS=5000,5001,5002 mbodenhamer/echoserver

If no value is given to `LISTEN_PORTS`, the container will listen to port 5000 by default.

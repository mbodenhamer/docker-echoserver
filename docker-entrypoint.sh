#!/bin/bash

function sighandler {
    for pid in ${SERVERS[@]}; do
	kill -s SIGTERM $pid
    done
    exit
}

if [ -z "$@" ]; then
    trap sighandler SIGTERM

    PORTS=${LISTEN_PORTS:-5000}
    for port in $(echo $PORTS | sed "s/,/ /g"); do
    	python serve.py $port &
	SERVERS[$port]=$!
    done

    while true; do
    	sleep 1
    done
fi

exec "$@"

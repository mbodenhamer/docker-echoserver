TEST_FILE=$(basename $BATS_TEST_FILENAME .bats)
TEST_CONTAINER=bats_echo

function launch {
    docker run -d --name $TEST_CONTAINER "$@" mbodenhamer/echoserver:latest
    sleep 0.5
}

function launch_args {
    docker run --rm -it mbodenhamer/echoserver:latest "$@"
}

function ip_address {
    echo $(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $TEST_CONTAINER)
}

function test_live_port {
    addr=$(ip_address)
    port=$1

    out=$(echo test | nc $addr $port) || true
    [[ $out = "test" ]]
}

function test_dead_port {
    addr=$(ip_address)
    port=$1

    out=$(echo test | nc $addr $port) || true
    [ -z $out ]
}

function cleanup {
    docker rm -f -v $TEST_CONTAINER
}

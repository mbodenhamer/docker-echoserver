#!/usr/bin/env bats
load test_helpers

@test "[$TEST_FILE] Check entrypoint args behavior" {
    run launch_args pwd
    [[ $lines[0] =~ "/" ]]
}

@test "[$TEST_FILE] Check default launch behavior" {
    launch
    
    test_live_port 5000
    test_dead_port 5001

    cleanup
}

@test "[$TEST_FILE] Check port-specified launch behavior" {
    launch -e LISTEN_PORTS=4999,5001,5002

    test_live_port 4999
    test_dead_port 5000
    test_live_port 5001
    test_live_port 5002

    cleanup
}

@test "[$TEST_FILE] Check single-port-specified launch behavior" {
    launch -e LISTEN_PORTS=5001

    test_dead_port 5000
    test_live_port 5001
    test_dead_port 5002

    cleanup
}

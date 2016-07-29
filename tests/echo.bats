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

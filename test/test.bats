#!/usr/bin/env bats
# vim: set ft=sh :

setup() {
    load $BATS_TEST_DIRNAME/test.sh
}

@test "append_sudo on wheel user" {
    [ "$(whoami)" = "root" ] \
        && skip "Current user is root."
    groups | grep -q "wheel" \
        || skip "Current user isn't belong with wheel group."
    run test_append_sudo
    [ $status -eq 0 ]
    [ "$output" = "sudo" ]
}

@test "append_sudo on root" {
    [ "$(whoami)" != "root" ] \
        && skip "Current user is not root."
    run test_append_sudo
    [ $status -eq 0 ]
    [ -z "$output" ]
}

@test "exec_hooks" {
    run test_exec_hooks
    [ $status -eq 0 ]
    [ ${lines[0]} -eq 1 ]
    [ ${lines[1]} -eq 2 ]
}

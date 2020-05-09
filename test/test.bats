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

@test "install_packages" {
    run get_pkglist
    PKGLIST="$output"

    run test_install_packages
    [ $status -eq 0 ]
    [ "${lines[0]}" = "T1 p1" ]
    [ "${lines[1]}" = "T2 p2 p3" ]
    [ "${lines[2]}" = "T3 p4 p5 p6" ]
}

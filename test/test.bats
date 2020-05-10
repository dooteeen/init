#!/usr/bin/env bats
# vim: set ft=sh :

setup() {
    load $BATS_TEST_DIRNAME/test.sh
}

@test "append_sudo on wheel user" {
    [ "$(whoami)" = "root" ] \
        && skip "Current user is root."
    groups | grep -q -e "wheel" -e "sudo" \
        || skip "Current user isn't belong with wheel group."

    run echo $(append_sudo)
    [ $status -eq 0 ]
    [ "$output" = "sudo" ]
}

@test "append_sudo on root" {
    [ "$(whoami)" != "root" ] \
        && skip "Current user is not root."

    run echo $(append_sudo)
    [ $status -eq 0 ]
    [ -z "$output" ]
}

@test "exec_hooks" {
    run test_exec_hooks
    [ $status -eq 0 ]
    [ ${lines[0]} -eq 1 ]
    [ ${lines[1]} -eq 2 ]
}

@test "executable git" {
    run executable git
    [ $status -eq 0 ]
    [ -z "$output" ]
}

@test "executable non-existent command (gitxxx)" {
    run executable gitxxx
    [ $status -ne 0 ]
    [ -z "$output" ]
}

@test "install_packages with pacman, yay" {
    grep -iq 'ID_LIKE=arch' /etc/os-release \
        || skip "This test is support only Archlinux."
    [ "$(type -t yay)" = "file" ] \
        || skip "yay has not installed."

    run get_pkglist
    PKGLIST="$output"

    run test_install_packages_arch
    [ "${lines[0]}" = "pacman -S p1 p2" ]
    [ "${lines[1]}" = "yay -S p3 p4 p5 p6" ]
}

@test "install_packages with wrong commands" {
    # git & bash have installed already, isn't it?
    [ -z $(type -t dummy) ] \
        || skip "dummy is executable. Please delete."

    run get_pkglist
    PKGLIST="$output"

    PKG=("git" "dummy" "bash")

    run test_install_packages_dummy
    [ "${lines[0]}" = "Note: ${PKG[0]} is unregisted package manager." ]
    [ "${lines[2]}" = "Note: ${PKG[1]} has not installed." ]
    [ "${lines[4]}" = "Note: cannot find packages which are installed by ${PKG[2]}." ]
}

@test "upper to lower" {
    echo_lower() {
        echo $1 | to_lower
    }

    run echo_lower ABC
    [ $status -eq 0 ]
    [ "$output" = "abc" ]

    run echo_lower xyz
    [ $status -eq 0 ]
    [ "$output" = "xyz" ]
}

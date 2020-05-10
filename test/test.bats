#!/usr/bin/env bats
# vim: set ft=sh :
# code: language=bats

load $BATS_TEST_DIRNAME/helper/bats-support/load.bash
load $BATS_TEST_DIRNAME/helper/bats-assert/load.bash

setup() {
    load $BATS_TEST_DIRNAME/test.sh
}

@test "append_sudo on wheel user" {
    [ "$(whoami)" = "root" ] \
        && skip "Current user is root."
    groups | grep -q -e "wheel" -e "sudo" \
        || skip "Current user hasn't belong to wheel group."

    run echo $(append_sudo)
    assert_success
    assert_output "sudo"
}

@test "append_sudo on root" {
    [ "$(whoami)" != "root" ] \
        && skip "Current user is not root."

    run echo $(append_sudo)
    assert_success
    refute_output
}

@test "clone_dotfiles" {
    check_network_connection \
        || skip "Failed to connect to network."

    current_remote=$(git remote get-url $(git remote))
    run git remote get-url $(git remote)
    assert_output "$current_remote"

    run get_dotfiles_dir
    DOTFILES="$output"

    run clone_dotfiles
    assert_success

    run get_repository_info
    assert_line --index 0 "$DOTFILES"
    assert_line --index 1 "origin"
    assert_line --index 2 "git@github.com:dooteeen/dotfiles.git"

    run git remote get-url $(git remote)
    assert_output "$current_remote"
}

@test "exec_hooks" {
    run test_exec_hooks
    assert_success
    assert_line --index 0 1
    assert_line --index 1 2
}

@test "executable git" {
    run executable git
    assert_success
    refute_output
}

@test "executable non-existent command (gitxxx)" {
    run executable gitxxx
    assert_failure
    refute_output
}

@test "install_packages with pacman, yay" {
    grep -iq 'ID_LIKE=arch' /etc/os-release \
        || skip "This test supports only Archlinux."
    [ "$(type -t yay)" = "file" ] \
        || skip "yay has not installed."

    run get_pkglist
    PKGLIST="$output"

    run test_install_packages_arch
    assert_line --index 0 "pacman -S p1 p2"
    assert_line --index 1 "yay -S p3 p4 p5 p6"
}

@test "install_packages with wrong commands" {
    [ -z $(type -t dummy) ] \
        || skip "dummy is executable. Please delete."

    run get_pkglist
    PKGLIST="$output"

    PKG=("git" "dummy" "bash")

    run test_install_packages_dummy
    assert_line --index 0 --partial "${PKG[0]}" "unregisted"
    assert_line --index 2 --partial "${PKG[1]}" "not installed"
    assert_line --index 4 --partial "${PKG[2]}" "cannot find packages"
}

@test "upper to lower" {
    echo_lower() {
        echo $1 | to_lower
    }

    run echo_lower ABC
    assert_success
    assert_output "abc"

    run echo_lower xyz
    assert_success
    assert_output "xyz"
}

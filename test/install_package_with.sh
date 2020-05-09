get_test_cmds_ok() {
    echo "pacman yay"
}

get_test_cmds_ng() {
    echo "git dummy bash"
}

install_with_pacman() {
    echo pacman -S $@
}

install_with_yay() {
    echo yay -S $@
}

install_with_bash() {
    echo "Do not print this."
}

test_install_packages_arch() {
    for cmd in $(get_test_cmds_ok); do
        install_packages_with $cmd
    done
}

test_install_packages_dummy() {
    for cmd in $(get_test_cmds_ng); do
        install_packages_with $cmd
    done
}


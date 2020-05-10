get_test_cmds_ok() {
    cmds=("pacman" "yay")
    echo ${cmds[@]}
}

get_test_cmds_ng() {
    cmds=("git" "dummy" "bash")
    echo ${cmds[@]}
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


get_test_cmds() {
    echo "t1 t2 t3"
}

install_with_t1() {
    echo "T1 $@"
}

install_with_t2() {
    echo "T2 $@"
}

install_with_t3() {
    echo "T3 $@"
}

test_install_packages() {
    for cmd in $(get_test_cmds); do
        install_packages_with $cmd
    done
}


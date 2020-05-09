testhook_test1() {
    echo 1
}

testhook_test2() {
    echo 2
}

another_hook_test3() {
    echo 3
}

export -f testhook_test1
export -f testhook_test2
export -f another_hook_test3

# exit-code: 0
# output:
# 1
# 2
test_exec_hooks() {
    exec_hooks testhook
}


pre_hook_pacman() {
    [ "$(detect_os_base)" = "arch" ] || return 0
    check_wheel || return 0

    $(append_sudo) sed -i -e 's/^#Color/Color/' /etc/pacman.conf
}


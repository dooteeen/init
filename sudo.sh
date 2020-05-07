pre_hook_sudo() {
    #sed 's/\(Defaults env_reset\)$/\1\nDefaults timestamp_timeout=300/' /etc/sudoers
    if which xsel >/dev/null 2>&1; then
        echo "Defaults timestamp_timeout=300" | xsel --clipboard --input
    fi
    echo "Edit /etc/sudoers:"
    echo "  Defaults timestamp_timeout=300"
    echo "press Enter to open visudo."
    read _void

    export EDITOR=vi
    executable() {
        which $1 >/dev/null 2>&1
        return $?
    }
    if executable xsel; then
        echo "Defaults timestamp_timeout=300" | xsel --clipboard --input
        if executable vim && vim --version | grep -q '+clipboard'; then
            export EDITOR=vim
        fi
    fi
    unset executable
    sudo -E visudo
}

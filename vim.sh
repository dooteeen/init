pre_hook_vim() {
    check_wheel || return 0
    case "$(detect_os_base)" in
        "debian")
            dpkg -s vim-tiny >/dev/null 2>&1 && $(append_sudo) apt remove -y vim-tiny
            ;;
    esac
}

post_hook_vim() {
    grep -q "source $DOTFILES/vim/vimrc" $HOME/.vimrc && return 0
    echo "source $DOTFILES/vim/vimrc"  >> $HOME/.vimrc
    echo "source $DOTFILES/vim/gvimrc" >> $HOME/.gvimrc
}


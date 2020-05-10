post_hook_intellij() {
    [ "$(detect_os_base)" = "arch" ] || return 0
    ln -sf $DOTFILES/intellij/ideavimrc $HOME/.ideavimrc
}


post_hook_vim() {
    grep "source $DOTFILES/vim/vimrc" $HOME/.vimrc >/dev/null 2>&1 && return 0
    echo "source $DOTFILES/vim/vimrc"  >> $HOME/.vimrc
    echo "source $DOTFILES/vim/gvimrc" >> $HOME/.gvimrc
}


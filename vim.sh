post_hook_vim() {
    grep -q "source $DOTFILES/vim/vimrc" $HOME/.vimrc && return 0
    echo "source $DOTFILES/vim/vimrc"  >> $HOME/.vimrc
    echo "source $DOTFILES/vim/gvimrc" >> $HOME/.gvimrc
}


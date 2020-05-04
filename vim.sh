deploy_hook_vim() {
    echo "source $DOTFILES/vim/vimrc"  >> $HOME/.vimrc
    echo "source $DOTFILES/vim/gvimrc" >> $HOME/.gvimrc
}


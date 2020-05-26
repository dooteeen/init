pre_hook_git() {
    [ -f $HOME/.gitconfig ] && return 0

    echo "Input your git name/email:"
    read n
    read e

    echo "Make ~/.gitconfig"
    echo "[user]\nname = $n\nemail = $e" > $HOME/.gitconfig
}

post_hook_git() {
    grep -q "$HOME/git/gitconfig" $HOME/.gitconfig && return 0
    echo "\n[include]\npath = $DOTFILES/git/config_base" >> $HOME/.gitconfig
    echo "\n[include]\npath = $DOTFILES/git/alias_linux" >> $HOME/.gitconfig
}


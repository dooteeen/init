post_hook_vscode() {
    executable code || return 1

    CODE=$HOME/.config/Code
    [ -d $CODE ] || mkdir -p $CODE

    ln -sf $DOTFILES/vscode $CODE/User

    cat $DOTFILES/vscode/extensions.txt \
        | xargs -I % code --install-extension %
}


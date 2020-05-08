post_hook_vscode() {
    CODE=$HOME/.config/Code
    [ -d $CODE ] || mkdir -p $CODE
    ln -sf $DOTFILES/vscode $CODE/User
    if executable code; then
        cat $DOTFILES/vscode/extensions.txt \
            | sed 's/^(.*)$/code --install-extension \1 &' \
            | xargs \
            | source
    fi
}


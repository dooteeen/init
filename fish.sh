install_hook_fish() {
    mkdir -p $HOME/.config/fish/functions
}

deploy_hook_fish() {
    ln -sf $DOTFILES/fish/config.fish $HOME/.config/fish/config.fish
    ln -sf $DOTFILES/fish/fishfile    $HOME/.config/fishfile
}


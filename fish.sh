post_hook_fish() {
    mkdir -p $HOME/.config/fish/functions
    mkdir -p $HOME/.config/fish/completions
    ln -sf $DOTFILES/fish/config.fish $HOME/.config/fish/config.fish
    ln -sf $DOTFILES/fish/fishfile    $HOME/.config/fishfile
    [ -d $HOME/.fish_local ] \
        || echo "#!$(which fish)" > $HOME/.fish_local

    case "$(detect_os_base)" in
        "android")
            chsh -s $(which fish)
            ;;
        "debian")
            chsh -s $(which fish)
            [ "$(whoami)" = "root" ] \
                && return 0
            check_wheel >/dev/null 2>&1 \
                && sudo chsh -s $(which fish)
            ;;
    esac
}


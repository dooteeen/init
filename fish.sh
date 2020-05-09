post_hook_fish() {
    mkdir -p $HOME/.config/fish/functions
    mkdir -p $HOME/.config/fish/completions
    ln -sf $DOTFILES/fish/config.fish $HOME/.config/fish/config.fish
    ln -sf $DOTFILES/fish/fishfile    $HOME/.config/fishfile
    echo "#!$(which fish)" $HOME/.fish_local

    case "$(detect_os_base)" in
        "ANDROID")
            chsh -s $(which fish)
            ;;
        "DEBIAN")
            chsh -s $(which fish)
            [ "$(whoami)" = "root" ] || sudo chsh -s $(which fish)
            ;;
    esac
}


get_dotfiles() {
    [ -d $DOTFILES ] && return 0
    [ "$(whoami)" = "root" ] && return 1

    check_dependencies git || return 1
    make_gitconfig
    HERE=$(pwd)

    echo "Install dotfiles"
    mkdir $HOME/.config

    git clone https://github.com/dooteeen/dotfiles $DOTFILES
    cd $DOTFILES
    git remote add origin git@github.com:dooteeen/dotfiles.git

    cd $HERE
}


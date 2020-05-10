get_repository_info() {
    HERE=$(pwd)
    cd $DOTFILES

    echo $(git rev-parse --show-toplevel)
    echo $(git remote)
    echo $(git remote get-url $(git remote))

    cd $HERE

    rm -rf $DOTFILES
}


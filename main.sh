pre_hooks() {
    exec_hooks 'pre_hook'
}

install_essentials() {
    [ -f $PKGLIST ] || get_package_list

    PM_CMD=$(os_package_manager)
    install_with_$PM_CMD $(get_packages $PM_CMD)
}

install_extras() {
    [ -f $PKGLIST ] || get_package_list

    for cmd in "$(extra_package_managers)"; do
        if executable $cmd; then
            install_with_$cmd $(get_packages $cmd)
        fi
    done
}

clone_dotfiles() {
    [ -d $DOTFILES ] && return 0
    check_dependencies git || return 1

    HERE=$(pwd)

    echo "Install dotfiles"
    mkdir $HOME/.config 2>/dev/null
    git clone https://github.com/dooteeen/dotfiles $DOTFILES

    cd $DOTFILES
    git remote add origin git@github.com:dooteeen/dotfiles.git
    cd $HERE
}

post_hooks() {
    exec_hooks 'post_hook'
}

# main scripts:

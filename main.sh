pre_hooks() {
    exec_hooks 'pre_hook'
}

install_essentials() {
    [ -f $PKGLIST ] || get_package_list

    install_packages_with $(os_package_manager)
}

install_extras() {
    [ -f $PKGLIST ] || get_package_list

    for cmd in $(extra_package_managers); do
        if executable $cmd; then
            install_packages_with $cmd
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


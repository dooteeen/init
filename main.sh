check_dependencies() {
    check_dependent sed || return 1
    [ ${BASH_VERSION:0:1} -ge 4 ] || check_dependent tr || return 1
}

pre_hooks() {
    exec_hooks 'first_hook'
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
    check_dependent git || return 1

    HERE=$(pwd)

    echo "Install dotfiles"
    mkdir $HOME/.config 2>/dev/null
    git clone https://github.com/dooteeen/dotfiles $DOTFILES
    if [ $? -ne 0]; then
        echo "Error: failed to clone dotfiles."
        return 1
    fi

    cd $DOTFILES
    git remote set-url origin git@github.com:dooteeen/dotfiles.git
    cd $HERE
}

post_hooks() {
    exec_hooks 'post_hook'
}

# main scripts:


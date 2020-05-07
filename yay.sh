install_yay() {
    [ "$(detect_os_base)" = "ARCH" ] || return 1
    check_dependencies git || $(append_sudo) pacman -S git

    HERE=$(pwd)

    cd /opt
    $(append_sudo) git clone https://aur.archlinux.org/yay.git
    [ "$(whoami)" = "root" ] || sudo chown -R $(whoami):$(whoami) /yay
    cd yay
    yes "" | makepkg -si

    cd $HERE
}


PKGLIST=$HOME/etc/install_packages.list
DOTFILES=$HOME/.config/dotfiles

executable() {
    which $1 >/dev/null 2>&1
    return $?
}

check_dependencies() {
    # arg 1: command name
    if executable $1; then
        return 0
    else
        echo "Error: require $1"
        return 1
    fi
}

append_sudo() {
    [ "$(whoami)" = 'root' ] || echo -n 'sudo'
}

dl_file() {
    if executable curl; then
        curl $1 -o $2
        return $?
    fi

    if executable wget; then
        wget $1 -O $2
        return $?
    fi
    
    echo "Error: any downloader has not exist."
    return 1
}

detect_os() {
    [ -e /data/data/com.termux/files/home ] \
        && echo "android" \
        || sed -n 's/^ID=\(.*\)$/\1/p' /etc/os-release
}

detect_os_base() {
    [ -e /data/data/com.termux/files/home ] \
        && echo "ANDROID" \
        || sed -n 's/^ID_LIKE=\(.*\)$/\1/p' /etc/os-release
}

os_package_manager() {
    case "$(detect_os_base)" in
        "ARCH")
            printf 'pacman'
            ;;
        "DEBIAN")
            printf 'apt'
            ;;
        "ANDROID")
            printf 'pkg'
            ;;
        "*")
            return
            ;;
    esac
}

extra_package_managers() {
    CMDS=()
    case "$(detect_os)" in
        "manjaro")
            CMDS+=("yay")
            ;;
        "ubuntu")
            CMDS+=("brew" "snap")
            ;;
        "*")
            return
            ;;
    esac

    RESULT=()
    for cmd in "${RESULT[@]}"; do
        if executable $cmd; then
            RESULT+=("$cmd")
        fi
    done
    printf $RESULT
}

install_with_pacman() {
    # args: packages
    yes '' | $(append_sudo) pacman -Syu
    yes '' | $(append_sudo) pacman -S $@
}

install_with_apt() {
    # args: packages
    $(append_sudo) apt update  -y
    $(append_sudo) apt upgrade -y
    $(append_sudo) apt install -y $@
}

install_with_pkg() {
    # args: packages
    pkg upgrade -y
    pkg install -y $@
}

install_with_yay() {
    [ "$(whoami)" = "root" ] && return
    yes '' | yay -S $@
}

install_with_brew() {
    brew install -y $@
}

install_with_snap() {
    snap install -y $@
}

get_package_list() {
    [ -f $PKGLIST ] && return 0
    check_dependencies wget || return 1

    [ -d $HOME/etc ] || mkdir $HOME/etc
    dl_file https://raw.githubusercontent.com/dooteeen/setup/master/packages.list $PKGLIST
    return $?
}

get_packages() {
    # arg 1: package manager name
    grep -E "^[^#_].+,$1,[^#]+$" $PKGLIST \
        | sed -r "s/^.*,$1,([^#]+)$/\1/"  \
        | xargs
}

exec_hooks() {
    grep -E "^$1_.*() {$" $0 \
        | sed 's/() {//g'    \
        | exec
}


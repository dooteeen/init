PKGLIST=$HOME/etc/install_packages.list
DOTFILES=$HOME/.config/dotfiles

executable() {
    which $1 >/dev/null 2>&1
    return $?
}

executable_fn() {
    [ "$(type -t $1)" = "function" ]
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

check_wheel() {
    [ "$(whoami)" = 'root' ] && return 0
    if test groups | grep -qv -e 'wheel' -e 'sudo'; then
        echo "Warning: This user can't use 'sudo'."
        return 1
    else
        return 0
    fi
}

append_sudo() {
    [ "$(whoami)" = 'root' ] && : || echo -n 'sudo'
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

to_lower() {
    tr '[:upper:]' '[:lower:]'
}

detect_os() {
    [ -e /data/data/com.termux/files/home ] \
        && echo "android" \
        || sed -n 's/^ID=\(.*\)$/\1/p' /etc/os-release | to_lower
}

detect_os_base() {
    [ -e /data/data/com.termux/files/home ] \
        && echo "android" \
        || sed -n 's/^ID_LIKE=\(.*\)$/\1/p' /etc/os-release | to_lower
}

os_package_manager() {
    case "$(detect_os_base)" in
        "arch")
            printf 'pacman'
            ;;
        "debian")
            printf 'apt'
            ;;
        "android")
            printf 'pkg'
            ;;
        "*")
            return 0
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
            return 0
            ;;
    esac

    RESULT=()
    for cmd in "${CMDS[@]}"; do
        if executable $cmd; then
            RESULT+=("$cmd")
        fi
    done
    printf ${RESULT[@]}
}

install_packages_with() {
    cmd="install_with_$1"
    pkg=$(get_packages $1)

    if [ -z "$1" ]; then
        echo "Warning: cannot detect package manager."
        return 1
    elif [ $(executable $1; echo $?) -ne 0 ]; then
        echo "Note: $1 has not installed."
        echo "      Skip installing with $1."
        return 1
    elif [ $(executable_fn $cmd; echo $?) -ne 0 ]; then
        echo "Note: $1 is unregisted package manager."
        echo "      Skip installing with $1."
        return 1
    elif [ -z "$pkg" ]; then
        echo "Note: cannot find packages which are installed by $1."
        echo "      Skip installing with $1."
        return 1
    fi

    install_with_$1 $(get_packages $1)
}

install_with_pacman() {
    # args: packages
    check_wheel
    if [ $? -ne 0 ]; then
        echo "Skip installing with pacman."
        return 0
    fi
    yes '' | $(append_sudo) pacman -Syu
    yes '' | $(append_sudo) pacman -S $@
}

install_with_apt() {
    # args: packages
    check_wheel
    if [ $? -ne 0 ]; then
        echo "Skip installing with apt."
        return 0
    fi
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
    [ "$(whoami)" = "root" ] && return 0
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
    grep -E "^$1_.*() {$" ${BASH_SOURCE[0]} \
        | sed 's/() {//g'    \
        | xargs -I % bash -c %
}


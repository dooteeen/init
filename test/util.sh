get_pkglist() {
    echo ${BASH_SOURCE[0]%/*}/packages.list
}

get_dotfiles_dir() {
    echo ${BASH_SOURCE[0]%/*}/dotfiles
}

check_network_connection() {
    ping -c 3 goo.gl >/dev/null 2>&1
    return $?
}


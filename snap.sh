install_snap() {
    executable snap && return 0
    case "$(detect_os_base)" in
        "DEBIAN")
            $(append_sudo) apt install -y snapd
            ;;
    esac
}


install_snap() {
    case "$(detect_os_base)" in
        "DEBIAN")
            $(append_sudo) apt install -y snapd
            ;;
    esac
}


install_brew() {
    # see:
    # - https://brew.sh/
    # - https://docs.brew.sh/Homebrew-on-Linux
    executable brew && return 0

    case "$(detect_os)" in
        "ubuntu")
            check_wheel || return 1
            $(append_sudo) apt update  -y
            $(append_sudo) apt upgrade -y
            $(append_sudo) apt install -y build-essential curl file git
            ;;
        "centos")
            check_wheel || return 1
            $(append_sudo) yum groupinstall 'Development Tools'
            $(append_sudo) yum install curl file git
            ;;
        "*")
            echo "Note: No need to install brew on $(detect_os)"
            return 0
            ;;
    esac

    if [ "$(whoami)" = "root" ]; then
        echo "Note: root user cannot use brew."
        echo "      run this script again as non-root user."
        return 0
    fi

    BREW_SCRIPT='https://raw.githubusercontent.com/Homebrew/install/master/install.sh'
    /bin/bash -c "$(curl -fsSL $BREW_SCRIPT)"

    BREW_DIR=
    [ -d $HOME/.linuxbrew ] \
        && BREW_DIR="$HOME/.linuxbrew"
    [ -d /home/linuxbrew/.linuxbrew ] \
        && BREW_DIR="/home/linuxbrew/.linuxbrew"

    eval $($BREW_DIR/bin/brew shellenv)
    eval $(brew shellenv --prefix) > $HOME/.init_brew.sh
    [ -r $HOME/.bash_profile ] \
        && echo "source $HOME/.init_brew.sh" >> $HOME/.bash_profile
    echo "source $HOME/.init_brew.sh" >> $HOME/.profile
}


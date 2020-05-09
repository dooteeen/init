install_brew() {
    # see:
    # - https://brew.sh/
    # - https://docs.brew.sh/Homebrew-on-Linux
    executable brew && return

    case "$(detect_os)" in
        "ubuntu")
            $(append_sudo) apt update  -y
            $(append_sudo) apt upgrade -y
            $(append_sudo) apt install -y build-essential curl file git
            ;;
        "centos")
            $(append_sudo) yum groupinstall 'Development Tools'
            $(append_sudo) yum install curl file git
        "*")
            echo "Note: No need to install brew on $(detect_os)"
            return 0
            ;;
    esac

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


#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="false"
HERE=$(dirname $(readlink -f ${BASH_SOURCE[0]}))
PKG_FILE="$HERE/dev_pkg.list"

#-------------------------------------------------------------------------------
function Usage() {
    cat <<EOF
NAME
$(basename $0) Rough Description

DESCRIPTION
    Detailed description
    -h  : Print this usage
    -v  : Enable verbosity
EOF
    exit 0
}

#-------------------------------------------------------------------------------
while getopts "hv" opt; do
    case $opt in
    h) Usage ;;
    v) VERBOSE="true" ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

#-------------------------------------------------------------------------------
# Configurations to system 
function PreConfigure() {
    # Turn off that absolutely nightmare bell. ding ding ding ding ding.
    sudo sed -i s/"^# set bell-style none"/"set bell-style none"/g /etc/inputrc
    # We want the default path to exist so that it doesn't become a symlink
    # owned by stow
    mkdir -p $HOME/.local/bin
    mkdir -p $HOME/.config
}

#-------------------------------------------------------------------------------
# Read in the list of installation packages and perform the installation.
# Discard any comments to allow the file list to be human readable
function InstallPackages() {
    sudo apt update

    while IFS= read -r line; do
        pkg=$(echo "$line" | sed 's/^\s*#.*$//g')
        if [[ -n $pkg ]]; then
            sudo apt-get -y install "$pkg"
        fi
    done <"$PKG_FILE"
}

#-------------------------------------------------------------------------------
# Download any target installations directly from git and perform in the
# installations
function NonstandardInstalls() {
    # Installs fuzzy finder for better directory searching
    if [[ ! -d $HOME/fzf ]]; then
	    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	    ~/.fzf/install
    fi

    # Ripgrep for better searching
    if ! command -v rg &> /dev/null;  then
        curl --create-dirs -LO --output-dir /tmp/ https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
        sudo dpkg -i /tmp/ripgrep_13.0.0_amd64.deb
    fi

    # Install neovim
    if ! command -v nvim &> /dev/null;  then
        local nvim_target=$HOME/.local/bin/nvim.appimage
        curl --create-dirs -LO --output-dir $(dirname $nvim_target) https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x $nvim_target
        ln -sf $nvim_target $HOME/.local/bin/nvim
    fi
}

#-------------------------------------------------------------------------------
function Main() {
    [[ $VERBOSE == "true" ]] && set -x

    # Have the user enter credentials so that the rest can run unattended
    sudo -v -p "Please enter the credentials for $USER: "
    
    # In case the user ran make first before calling this script
    make clean 
    PreConfigure
    InstallPackages
    NonstandardInstalls
    make
}

#-------------------------------------------------------------------------------
Main


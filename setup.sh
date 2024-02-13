#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="false"
HERE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
PKG_FILE="$HERE/pkg.list"

#-------------------------------------------------------------------------------
function Usage() {
    cat <<EOF
NAME
$(basename "$0") Downloads packages and generates prerequisite directories
so that the home can be configured the way that I'd like it to for dotfiles

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
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share/fonts"
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.tmux/plugins"

    # If we have a bashrc file backit up so there is no stow conflct 
    if [ -f "$HOME/.bashrc" ]; then 
	    mv "$HOME/.bashrc" "$HOME/bashrc.orig"
    fi
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
function NonStandardInstalls() {
    # Installs fuzzy finder for better directory searching
    if [[ ! -d $HOME/.fzf ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        # We only want to install the binary. The bashrc file will areeady be
        # configured to support fzf. If you do "--all" it will generate a bash
        # file for you and it will cause stow to fail
        ~/.fzf/install --bin
    fi

    # Ripgrep for better searching
    if ! command -v rg &> /dev/null;  then
        local link=https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
        curl --create-dirs -LO --output-dir /tmp/ $link
        sudo dpkg -i /tmp/ripgrep_13.0.0_amd64.deb
    fi

    # Install neovim
    if ! command -v nvim &> /dev/null;  then
        local nvim_target=$HOME/.local/bin/nvim.appimage
        local link=https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        curl --create-dirs -LO --output-dir "$(dirname "$nvim_target")" "$link"
        chmod u+x "$nvim_target"
        ln -sf "$nvim_target" "$HOME/.local/bin/nvim"
    fi

    # Install advanced fonts to show neovim icons
    local fira_dir=$HOME/.local/share/fonts/fira
    if [[ ! -d $fira_dir ]]; then
        local link=https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraMono.zip
        curl --create-dirs -LO --output-dir /tmp/ "$link"
        mkdir -p "$fira_dir"
        unzip /tmp/FiraMono.zip -d "$fira_dir"

        # Force gnome to recognize that a new font is in town
        fc-cache reload
    fi

    # Bat has a name collision with another app. It will be installed as "batcat"
    # so we move things around to make it work
    local bin=/usr/bin/batcat
    if [[ -x /usr/bin/batcat ]]; then
        ln -sf "$bin" "$HOME/.local/bin/bat"
    fi

    # Lazygit is great for managing git commands from within a terminal
    if ! command -v lazygit; then
        pushd /tmp
        local version=""
        version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        local link="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_x86_64.tar.gz"
        curl -Lo lazygit.tar.gz "$link"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        popd
    fi

}

# List of functions that come after our profile is in place. These might 
# augment the content we already have. 
function PostConfigurations() {
    # Calls the underlying Makefile which will call stow. This will move all
    # backed up dotfiles into their corresponding positions
	make

    # This will install the corresponding plugins. By the point we expect
    # that our tmux profile is ready
    local tmux_tpm=$HOME/.tmux/plugins/tpm
    if [[ ! -d $tmux_tpm ]]; then
        local link=https://github.com/tmux-plugins/tpm
        git clone "$link" "$tmux_tpm"

        "$tmux_tpm"/bin/install_plugins
    fi

    # This will update our gnome profile to set the proper fonts and the tokynight
    # color scheme
    dconf load /org/gnome/terminal/legacy/profiles:/ < "$HOME/.config/gnome-terminal/tokyonight-profile.dconf"

    # Setup startship, this will give you a spicy prompt confiugration
    if ! command -v starship &> /dev/null;  then
    local starship_install=/tmp/startship_install.sh
        curl -sS https://starship.rs/install.sh > "$starship_install"
        chmod +x "$starship_install"
        "$starship_install" -f
    fi
        
    # Finally load up our profile and load our bash configuration
    source "$HOME/.bashrc"
}

#-------------------------------------------------------------------------------
function Main() {
    [[ $VERBOSE == "true" ]] && set -x

    # Have the user enter credentials so that the rest can run unattended
    sudo -v -p "Please enter the credentials for $USER: "
    
    # In case the user ran make first before calling this script
    if command -v stow &> /dev/null;  then
        make clean
    fi

    # It is stongy recommended to keepo this order the same
    PreConfigure
    InstallPackages
    NonStandardInstalls

    PostConfigurations

    zenity --info --text="Environment succesfully configured. Please restart \
gnome terminal to take effect"
}

#-------------------------------------------------------------------------------
Main


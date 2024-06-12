#!/bin/bash

# Determine OS
OS="unknown"
case "$(uname)" in
    "Darwin") OS="mac" ;;
    "Linux") OS="linux" ;;
esac

# Determine home directory and create folders
HOME_DIR=$HOME
BIN_DIR=$HOME_DIR/bin
ETC_DIR=$HOME_DIR/etc
ZSH_DIR=$HOME_DIR/.zsh
CONFIG_DIR=$HOME_DIR/.config

# Function to create directory if it does not exist
create_dir() {
    [ ! -d $1 ] && mkdir -p $1 && echo "Created directory $1"
}

# Function to create file if it does not exist
create_file() {
    [ ! -f $1 ] && touch $1 && echo "Created file $1"
}

# Create directories
create_dir $BIN_DIR
create_dir $ETC_DIR
create_dir $ZSH_DIR
create_dir $CONFIG_DIR

# Install tools & fonts
if [ "$OS" = "mac" ] || [ "$OS" = "linux" ]; then
    if test ! $(which brew); then
        echo "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.profile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' > $ZSH_DIR/brew.zsh
        source $HOME/.zshrc
    fi
    echo "Installing tools with Homebrew, this will take a while !"
    brew tap homebrew/linux-fonts
    brew tap hashicorp/tap
    brew tap puppetlabs/puppet
    brew install hashicorp/tap/vault hashicorp/tap/consul hashicorp/tap/packer hashicorp/tap/terraform sshpass starship ansible gcc hashicorp/tap/boundary
#    brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install {} || true
fi

# Create starship.zsh, functions.zsh, and aliases.zsh in .zsh directory
create_file $ZSH_DIR/starship.zsh && echo 'eval "$(starship init zsh)"' > $ZSH_DIR/starship.zsh
create_file $ZSH_DIR/functions.zsh
create_file $ZSH_DIR/aliases.zsh

# Download starship.toml from GitHub and place it in .config directory
STARSHIP_CONFIG=$CONFIG_DIR/starship.toml
create_file $STARSHIP_CONFIG && curl -k -sS -o $STARSHIP_CONFIG https://raw.githubusercontent.com/abyss1/trancient/main/dotfiles/starship/starship.toml

source $HOME/.zshrc # this will do regardless of outcome of previous step

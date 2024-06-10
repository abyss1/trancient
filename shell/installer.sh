#!/bin/bash

# Determine OS
OS="unknown"
case "$(uname)" in
    "Darwin") OS="mac" ;;
    "Linux") OS="linux" ;;
esac

echo "Running on $OS"

# Determine home directory and create folders
HOME_DIR=$HOME
BIN_DIR=$HOME_DIR/bin
ETC_DIR=$HOME_DIR/etc
ZSH_DIR=$HOME_DIR/.zsh
CONFIG_DIR=$HOME_DIR/.config

# Create directories if they do not exist
[ ! -d $BIN_DIR ] && mkdir -p $BIN_DIR
[ ! -d $ETC_DIR ] && mkdir -p $ETC_DIR
[ ! -d $ZSH_DIR ] && mkdir -p $ZSH_DIR
[ ! -d $CONFIG_DIR ] && mkdir -p $CONFIG_DIR

echo "Created directories $BIN_DIR, $ETC_DIR, and $ZSH_DIR"

# Install tools & fonts
if [ "$OS" = "mac" ] || [ "$OS" = "linux" ]; then
    if test ! $(which brew); then
        echo "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.profile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        mkdir -p $HOME/.zsh
        echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' > $HOME/.zsh/brew.zsh
        source $HOME/.zshrc
    fi
    echo "Installing tools with Homebrew, this will take a while !"
    brew tap homebrew/linux-fonts
    brew install vault consul packer terraform sshpass starship ansible gcc
#    brew search '/font-.*-nerd-font/' | awk '{ print $1 }' | xargs -I{} brew install {} || true
fi

echo "Installed tools"

# Create starship.zsh, functions.zsh, and aliases.zsh in .zsh directory
[ ! -f $ZSH_DIR/starship.zsh ] && echo 'eval "$(starship init zsh)"' > $ZSH_DIR/starship.zsh
[ ! -f $ZSH_DIR/functions.zsh ] && touch $ZSH_DIR/functions.zsh
[ ! -f $ZSH_DIR/aliases.zsh ] && touch $ZSH_DIR/aliases.zsh

echo "Created starship.zsh, functions.zsh, and aliases.zsh in $ZSH_DIR"

# Download starship.toml from GitHub and place it in .config directory
[ ! -f $CONFIG_DIR/starship.toml ] && curl -o $CONFIG_DIR/starship.toml https://raw.githubusercontent.com/abyss1/trancient/main/dotfiles/starship/starship.toml

echo "Downloaded starship.toml to $CONFIG_DIR"

source $HOME/.zshrc # this will do regardless of outcome of previous step

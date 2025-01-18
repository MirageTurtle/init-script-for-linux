#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# This script is used to install somebasic tools for a new macOS system, using Homebrew.

# TODO:
# 1. some tools need to add tap before installing, e.g. bclm
# 2. use grep and brew info is too slow, need to find a better way to check if a package is installed

# color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'


# Install Homebrew
if command -v brew &> /dev/null; then
    echo -e "${GREEN}Homebrew is already installed.${NC}"
else
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [[ $? -ne 0 ]]; then
    echo -e "${RED}Failed to install Homebrew. Exiting...${NC}"
    exit 1
fi

# Install some basic tools
prompt_installation() {
    read -p "Do you want to install $1? (y/n)" choice
    case "$choice" in
	y|Y ) brew install $1;;
	n|N ) ;;
	* ) echo -e "${RED}Invalid choice. Please enter y or n.${NC}";;
    esac
}

# if_exists_install
if_exists_install() {
    if command -v $1 &> /dev/null || \
	    brew ls --version $1 > /dev/null || \
	    grep -q -e "^Installed$" <(brew info $1) > /dev/null; then
	echo -e "${GREEN}$1 is already installed.${NC}"
    else
	prompt_installation $1
    fi
}

basic_tools=(curl wget git zsh tmux)
modern_unix_tools=(eza bat delta fd ripgrep tldr fd jq)
gnu_tools=(gnu-sed gnu-tar coreutils)
fonts=(font-meslo-for-powerlevel10k font-jetbrains-mono font-lxgw-wenkai)
personal_tools=(bclm)
all_tools=(basic_tools modern_unix_tools gnu_tools fonts personal_tools)
for category in ${all_tools[@]}; do
    eval tools=(\${$category[@]})
    for tool in ${tools[@]}; do
	if_exists_install $tool
    done
done

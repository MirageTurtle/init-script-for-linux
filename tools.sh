#!/usr/bin/env bash

echo "Changing the package source into USTC source..."
# Change the package source of apt
sudo sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
# Change the security source
# sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
# Use HTTPS
# sudo sed -i 's/http:/https:/g' /etc/apt/sources.list
echo "Updating apt package list and upgrading the packages..."
sudo apt update && sudo apt upgrade
if [[ $? -ne 0 ]]; then
    echo "Error during apt update and upgrade."
    exit 1
fi
echo "Done."

# Tools
echo "Installing basic tools(git, ripgrep, fd-find)..."
sudo apt install -y git ripgrep fd-find
if [[ $? -ne 0 ]]; then
    echo "Error during install basic tools."
    exit 1
fi
echo "Basic tools are installed."
echo "Installing programming and editing tools(shellcheck, emacs)..."
sudo apt install -y shellcheck emacs
if [[ $? -ne 0 ]]; then
    echo "Error during install programming and editing tools."
fi
echo "Programming and editing tools are installed."
echo "Done."

echo "Configging Emacs with my personal configuration..."
if [[ ! -d ~/.emacs.d ]]; then
    mkdir -p ~/.emacs.d
fi
wget https://raw.githubusercontent.com/MirageTurtle/emacs-config/main/init.el -O ~/.emacs.d/init.el
if [[ $? -ne 0 ]]; then
    echo "Error during downloading Emacs configuration from Github."
fi
echo "Done."

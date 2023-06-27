#!/usr/bin/env bash

# TODO: More elegently.

echo "Changing the package source into USTC source..."
# Change the package source of apt
sudo sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
# Change the security source
# sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
# Use HTTPS
# sudo sed -i 's/http:/https:/g' /etc/apt/sources.list
echo "Updating apt package list and upgrading the packages..."
sudo apt update && sudo apt upgrade -y
if [[ $? -ne 0 ]]; then
    echo "Error during apt update and upgrade."
    exit 1
fi
echo "Done."

select_pkgs () {
    local options=("$@")
    local selected=()
    local option choice
    while true; do
	read -r -p "The default packages list is ${options[*]}, do you want to select some specified packages?(y/n)" choice
	case $choice in
	    [Nn]|[Nn][Oo])
		selected=("${options[@]}")
		break
		;;
	    [Yy]|[Yy][Ee][Ss])
		for option in "${options[@]}"; do
		    while true; do
			read -r -p "$option?(y/n)" choice
			case $choice in
			    [Yy]|[Yy][Ee][Ss])
				selected+=("$option")
				break
				;;
			    [Nn]|[Nn][Oo])
				break
				;;
			    *)
				;;
			esac
		    done
		done
		break
		;;
	    *)
		;;
	esac
    done
    echo "${selected[@]}"
}

basic_tools=(net-tools netcat git tmux)
selected=($(select_pkgs "${basic_tools[@]}"))
cmd="sudo apt install -y ${selected[*]}"
if [[ $? -ne 0 ]]; then
    echo "Error during execute command $cmd"
    exit 1
fi
personal_tools=(ripgrep fd-find emacs)
selected=($(select_pkgs "${personal_tools[@]}"))
cmd="sudo apt install -y ${selected[*]}"
if [[ $? -ne 0 ]]; then
    echo "Error during execute command $cmd"
    exit 1
fi
if [[ "${selected[@]}" =~ emacs ]]; then
    echo "Configging Emacs with my personal configuration..."
    if [[ ! -d ~/.emacs.d ]]; then
        mkdir -p ~/.emacs.d
    fi
    wget https://raw.githubusercontent.com/MirageTurtle/emacs-config/main/init.el -O ~/.emacs.d/init.el
    if [[ $? -ne 0 ]]; then
        echo "Error during downloading Emacs configuration from Github."
    fi
    echo "Emacs configuration succeed."
fi
programming_tools=(shellcheck)
selected=($(select_pkgs "${programming_tools[@]}"))
cmd="sudo apt install -y ${selected[*]}"
if [[ $? -ne 0 ]]; then
    echo "Error during execute command $cmd"
    exit 1
fi

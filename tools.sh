#!/usr/bin/env bash

# TODO: More elegently.
# TODO: Fix the installation of exa.


read -r -p "Change package source into USTC Mirror source?[y/n]" choice
case $choice in
    [Yy]|[Yy][Ee][Ss])
	echo "Changing the package source into USTC Mirror source..."
	# Change the package source of apt
	sudo sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list
	# Change the security source
	# sudo sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
	# Use HTTPS
	# sudo sed -i 's/http:/https:/g' /etc/apt/sources.list
	break
	;;
    [Nn]|[Nn][Oo])
	break
	;;
    *)
	;;
esac

echo "Updating apt package list and upgrading the packages..."
sudo apt update && sudo apt upgrade -y
if [[ $? -ne 0 ]]; then
    echo "Error during apt update and upgrade."
    exit 1
fi
echo "apt package list has updated."

select_pkgs () {
    local options=("$@")
    local selected=()
    local option choice
    while true; do
	read -r -p "The default packages list is ${options[*]}, do you want to select some specified packages?[y/n]" choice
	case $choice in
	    [Nn]|[Nn][Oo])
		selected=("${options[@]}")
		break
		;;
	    [Yy]|[Yy][Ee][Ss])
		for option in "${options[@]}"; do
		    while true; do
			read -r -p "$option?[y/n]" choice
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

basic_tools=(curl wget git docker exa)
network_tools=(net-tools tcpdump netcat)
efficiency_tools=(tmux fzf ripgrep fd-find jq)
program_tools=(emacs shellcheck ipython)
# all_tools=("${basic_tools[@]}" "${network_tools[@]}" "${efficiency_tools[@]}" "${program_tools[@]}")
all_tools=(basic_tools network_tools efficiency_tools program_tools)
for cate in "${all_tools[@]}"; do
    echo "Installing $cate"
    tools="$cate[@]"
    selected=($(select_pkgs "${!tools}"))
    # special tool
    if [[ "${selected[*]}" =~ .*docker.* ]]; then
	# TODO: if the last one is not docker. 
        unset selected[-1]
        selected+=(ca-certificates curl gnupg)
	if_docker=true
    fi
    cmd="sudo apt install -y ${selected[*]}"
    $cmd
    if [[ $? -ne 0 ]]; then
	echo "Error during execute $cmd"
	# read -r -p "Continue?[y/n]" if_continue
	# if [[ $if_continue =~ "Y|n"  ]]; then
	#     continue
	exit 1
    fi
    if [[ $if_docker = true ]]; then
	# Add Docker's official GPG key
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg
	# Set up the Docker repository
	echo \
	    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  	    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
	    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	# Install Docker
	sudo apt update
	sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	# TODO: Add user into docker group
	unset if_docker
    fi
done

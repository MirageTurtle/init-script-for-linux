#!/usr/bin/env bash

TEMP=`getopt -o r:l: --long remote-url:,local-dir: -- "$@"`
eval set -- "$TEMP"

remote_url="https://github.com/MirageTurtle/dotfiles.git"
local_dir="~/repo"

while true; do
    case "$1" in
	-r|--remote-url)
	    remote_url=$2
	    shift 2
	    ;;
	-l|--local-dir)
	    local_dir=$2
	    shift 2
	    ;;
	--)
	    shift
	    break
	    ;;
	*)
	    echo "Params error?"
	    exit 1
	    ;;
    esac
done

if [[ ! -d $local_dir ]]; then
    echo "[ERROR]$local_dir doesn't exists."
    exit 2
fi

if [[ ! -d ~/.config ]]; then
    read -r -p "No ~/.config directory, create one?[y/n]" choice
    case $choice in
	[Yy]|[Yy][Ee][Ss])
	    mkdir ~/.config/
	    ;;
	*)
	    echo "No ~/.config directory, exit."
	    exit 0
	    ;;
    esac
fi

echo "Cloning dotfiles repo..."
git clone $remote_url $local_dir/dotfiles
echo "Repo cloned, symlinking starts."
read -r -p "Symlink tmux configurations?[y/n]" choice
case $choice in
    [Yy]|[Yy][Ee][Ss])
	mkdir -p ~/.config/tmux
	ln -s $local_dir/dotfiles/.config/tmux/* ~/.config/tmux/
	;;
    *)
	;;
esac
read -r -p "Symlink emacs configurations?[y/n]" choice
case $choice in
    [Yy]|[Yy][Ee][Ss])
	mkdir -p ~/.config/emacs
	ln -s $local_dir/dotfiles/.config/emacs/* ~/.config/emacs
	;;
    *)
	;;
esac

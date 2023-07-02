#!/usr/bin/env bash

# TODO:
# 1. Add situation about existing of the repo.

TEMP=`getopt -o r:l: --long remote-url:,local-dir: -- "$@"`
eval set -- "$TEMP"

remote_url="https://github.com/MirageTurtle/dotfiles.git"
local_dir="$HOME/repo"

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

if [[ ! -d $HOME/.config ]]; then
    read -r -p "No $HOME/.config directory, create one?[y/n]" choice
    case $choice in
	[Yy]|[Yy][Ee][Ss])
	    mkdir $HOME/.config/
	    ;;
	*)
	    echo "No $HOME/.config directory, exit."
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
	# mkdir -p $HOME/.config/tmux
	ln -s $local_dir/dotfiles/.config/tmux $HOME/.config
	;;
    *)
	;;
esac
read -r -p "Symlink emacs configurations?[y/n]" choice
case $choice in
    [Yy]|[Yy][Ee][Ss])
	mkdir -p $HOME/.emacs.d/
	ln -s $local_dir/dotfiles/.emacs.d/* $HOME/.emacs.d/
	;;
    *)
	;;
esac

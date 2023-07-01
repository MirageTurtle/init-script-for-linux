#!/usr/bin/env bash

# TODO:
# 1. using $SHELL to check the default shell is not credible.
# 2. if the zsh is installed, the install should be passed.
# 3. extract the requirements into a function, curl/wget, git, ...
# 4. input /usr/bin/zsh to `chsh`.
# 5. update my personal powerlevel10k config.

if [[ ! `echo $SHELL` =~ (/usr)?/bin/zsh ]]; then
    echo "The default shell is $(echo $SHELL), will config default shell to zsh"
    sudo apt install -y zsh
    chsh
fi

ohmyzsh_folder="${HOME}/.oh-my-zsh/"
if [[ -d "$ohmyzsh_folder" ]]; then
    echo "There have been Oh-my-zsh and the installation is passed."
else
    echo "There's no Oh-my-zsh, will download and install oh-my-zsh."
    if command -v curl > /dev/null 2>&1
    then
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    elif command -v wget > /dev/null 2>&1
    then
	sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    else
	echo "[ERROR]Please install curl or wget first."
	exit 1
    fi
    echo "Oh-my-zsh installed."
fi

# Oh-my-zsh plug-ins
echo "Config Oh-my-zsh plug-ins..."
if command -v git > /dev/null 2>&1; then
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
    sed -i /"^plugins=("/s/")"/" zsh-syntax-highlighting zsh-autosuggestions fzf-zsh-plugin)"/ ~/.zshrc
else
    echo "[ERROR]Please install git first."
    exit 1
fi
echo "Plug-ins configuration finished."

# Oh-my-zsh theme
echo "Config Oh-my-zsh theme into powerlevel10k..."
if command -v git > /dev/null 2>&1; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i /'^ZSH_THEME="'/s/'^ZSH_THEME=".*"$'/'ZSH_THEME="powerlevel10k\/powerlevel10k"'/ ~/.zshrc
else
    echo "[ERROR]Please install git first."
    exit 1
fi
echo "powerlevel10k configuration finished."

# TODO:
# 1. using $SHELL to check the default shell is not credible.
# 2. if the zsh is installed, the install should be passed.

if ! [[ `echo $SHELL` =~ (\/usr)?\/bin\/zsh ]]
then
    echo "The default shell is $(echo $SHELL), will config default shell to zsh"
    sudo apt install -y zsh
    chsh
fi

ohmyzsh_folder="${HOME}/.oh-my-zsh/"
if [ ! -d "$ohmyzsh_folder" ]
then
    echo "no oh-my-zsh, will download and install oh-my-zsh."
    if command -v curl > /dev/null 2>&1
    then
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    elif command -v wget > /dev/null 2>&1
    then
	sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    else
	echo "Please install curl or wget first."
    fi
fi

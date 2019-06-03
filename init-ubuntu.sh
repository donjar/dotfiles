#!/bin/bash
set -ux

sudo apt install software-properties-common -y

if [[ `uname` != 'Linux' ]]; then
  exit
fi

mkdir ~/.vimtmp/
mkdir -p ~/.config/nvim/autoload/
mkdir -p ~/.config/nvim/language-client/

ln -s $PWD/.bashrc ~
ln -s $PWD/.config/fish/config.fish ~/.config/fish/config.fish
ln -s $PWD/.config/fish/fishfile ~/.config/fish/fishfile
ln -s $PWD/.config/nvim/autoload/plug.vim ~/.config/nvim/autoload/plug.vim
ln -s $PWD/.config/nvim/init.vim ~/.config/nvim/init.vim
ln -s $PWD/.config/nvim/language-client/settings.json ~/.config/nvim/language-client/settings.json
ln -s $PWD/.gitconfig ~
ln -s $PWD/.global_gitignore ~

# pyenv
curl https://pyenv.run | bash
pyenv install 3.7.3
pyenv global 3.7.3

# neovim
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim -y
pip install pynvim

# fish
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish -y

# fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fish -c "cat ~/.config/fish/fishfile | fisher add"

# pyls
pip install pyls

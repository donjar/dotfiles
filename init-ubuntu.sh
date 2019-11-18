#!/bin/bash
set -uxe

if [[ `uname` != 'Linux' ]]; then
  exit
fi

sudo apt-get install --no-install-recommends -y software-properties-common git make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

mkdir ~/.vimtmp/
mkdir -p ~/.config/fish
mkdir -p ~/.config/nvim/autoload/
mkdir -p ~/.config/nvim/language-client/

ln -fs $PWD/.bashrc ~
ln -fs $PWD/.config/fish/config.fish ~/.config/fish/config.fish
ln -fs $PWD/.config/fish/fishfile ~/.config/fish/fishfile
ln -fs $PWD/.config/nvim/autoload/plug.vim ~/.config/nvim/autoload/plug.vim
ln -fs $PWD/.config/nvim/autoload/fzf ~/.config/nvim/autoload/fzf
ln -fs $PWD/.config/nvim/init.vim ~/.config/nvim/init.vim
ln -fs $PWD/.gitconfig ~
ln -fs $PWD/.global_gitignore ~

# base16 color scheme
git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

# pyenv
curl https://pyenv.run | bash
pyenv install 3.7.3
pyenv global 3.7.3

# neovim
sudo apt install neovim -y
pip install pynvim

# fish
sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt update
sudo apt install fish -y

# fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fish -c "cat ~/.config/fish/fishfile | fisher add"

# pyls
pip install python-language-server

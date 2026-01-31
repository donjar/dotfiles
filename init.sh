#!/bin/bash
set -uxe

if [[ `uname` == 'Linux' ]]; then
  sudo apt-get install --no-install-recommends -y software-properties-common git make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev direnv ripgrep
elif [[ `uname` == 'Darwin' ]]; then
  if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install xz ripgrep fzf direnv gnu-sed
  brew install --cask font-inconsolata
fi

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

if [[ `uname` == 'Linux' ]]; then
  export PATH="/home/donjar/.pyenv/bin:$PATH"
elif [[ `uname` == 'Darwin' ]]; then
  export PATH="/Users/donjar/.pyenv/bin:$PATH"
fi
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

LATEST_PYTHON=$(pyenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
pyenv install $LATEST_PYTHON
pyenv global $LATEST_PYTHON

# neovim
if [[ `uname` == 'Linux' ]]; then
  sudo add-apt-repository ppa:neovim-ppa/stable
  sudo apt-get update
  sudo apt-get install neovim -y
elif [[ `uname` == 'Darwin' ]]; then
  brew install neovim
fi
pip install pynvim

# fish
if [[ `uname` == 'Linux' ]]; then
  sudo apt-add-repository -y ppa:fish-shell/release-3
  sudo apt update
  sudo apt install fish -y
elif [[ `uname` == 'Darwin' ]]; then
  brew install fish
fi

# fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fish -c "cat ~/.config/fish/fishfile | fisher install"

# pyls
pip install python-language-server

# claude
curl -fsSL https://claude.ai/install.sh | sh
ln -fs $PWD/.claude/CLAUDE.md ~/CLAUDE.md

# Dotfiles

These files are useful for new laptop/server setup.

## THIS THING GOT SUBMODULES
`git clone --recurse-submodules git@github.com:donjar/dotfiles.git`

## Contents
- Vim stuff: vimrc, vimtmp
- User .gitconfig
- Profiles, containing useful aliases, some things that need to be set in Mac, bash prompt:
  - .profile, for Mac
  - .bashrc, for Ubuntu (append it after the default Ubuntu!)

## What to do after git clone?
- `./init.sh`
- Generate SSH key

## What init.sh installs
- Homebrew (macOS only)
- Essential tools: ripgrep, fzf, direnv, gnu-sed
- Inconsolata font (macOS only)
- base16-shell color scheme
- pyenv and latest Python
- neovim with pynvim
- fish shell with fisher plugin manager (includes nvm.fish)
- python-language-server
- Claude CLI

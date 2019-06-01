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
- Install things like:
  - `brew`
  - `rvm`
  - `nvm`
  - `pip`

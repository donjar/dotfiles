# Base16 Shell
if status --is-interactive
  eval sh $HOME/.config/base16-shell/scripts/base16-dracula.sh
end

set -l OS (uname)
if test $OS = "Linux"
  alias ls "ls --color=auto"
else if test $OS = "Darwin"
  alias ls "ls -G"
end
rvm default

function c
  g++ $argv ; and echo 's' ; and ./a.out
end

# source (conda info --root)/etc/fish/conf.d/conda.fish

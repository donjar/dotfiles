# Base16 Shell
if status --is-interactive
  eval sh $HOME/.config/base16-shell/scripts/base16-dracula.sh
end

set -l OS (uname)
if test $OS = "Linux"
  alias ls "ls --color=auto"
  setxkbmap -option caps:escape
else if test $OS = "Darwin"
  alias ls "ls -G"
end

rvm default

function c
  g++ $argv ; and echo 's' ; and ./a.out
end

set -gx PATH "$HOME/.pyenv/shims" "$HOME/.pyenv/bin" $PATH
set -gx PYENV_SHELL fish
source "$HOME/.pyenv/libexec/../completions/pyenv.fish"
command pyenv rehash 2>/dev/null
function pyenv
  set command $argv[1]
  set -e argv[1]

  switch "$command"
  case activate deactivate rehash shell
    source (pyenv "sh-$command" $argv|psub)
  case '*'
    command pyenv "$command" $argv
  end
end

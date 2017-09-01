alias l="ls -hFC"
alias ll="ls -hlaF"
alias lc='ls -halF --color=none'
alias v="nvim"
alias wifi="sudo killall create_ap; sudo create_ap wlp3s0 enp4s0 perditus paradisus"

export VISUAL=nvim
export EDITOR="$VISUAL"

export PROMPT_COMMAND=set_prompt
set_prompt() {
  local exit=$?

  local red='\e[0;31m'
  local yellow='\e[0;32m'
  local green='\e[0;33m'
  local cyan='\e[0;36m'
  local reset='\e[m'
  PS1="\[$red\]$exit \[$cyan\]\t \[$green\]\u@\h\[$reset\]:\[$yellow\]\w\n\[$reset\]\$ "
}

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

set -o vi

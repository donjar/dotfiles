alias l="ls -FC"
alias ll="ls -laF"
alias v="nvim"

export LC_CTYPE=en_US.UTF-8
export CLICOLOR=1
export LSCOLORS=gxGxFxdxbxDxDxBxBxExEx

export VISUAL=nvim
export EDITOR="$VISUAL"

export PROMPT_COMMAND=set_prompt
set_prompt() {
	local exit=$?

	local red='\e[0;31m'
	local cyan='\e[0;36m'
	local reset='\e[m'
	PS1="\[$red\]$exit \[$cyan\]\t \[$reset\]\u@\h:\w\n\$ "
}

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
base16_dracula

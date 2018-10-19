#!/bin/zsh
setopt AUTO_CD

spaces=$(printf " %.0s" {1..$(( (COLUMNS - 40) / 2 ))})
fortune | cowsay | sed "s/^/$spaces/"
source .zsh_plugins.sh
source .zsh_aliases
source .zprofile

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# necessary for correct VIM colors
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# SSH & GPG agent config
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SHOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye &> /dev/null


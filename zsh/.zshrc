#!/bin/zsh
fortune | cowsay
# load zgen

fpath=(~/.completions $fpath)
setopt AUTO_CD
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=10000
setopt appendhistory inc_append_history share_history
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '/home/pinusc/.zshrc'

autoload -Uz compinit
autoload -U zmv
compinit
# End of lines added by compinstall

spaces=$(printf " %.0s" {1..$(( (COLUMNS - 40) / 2 ))})
fortune | cowsay | sed "s/^/$spaces/"
source .zsh_plugins.sh
source .zsh_aliases
source .zprofile
source "${HOME}/builds/zgen/zgen.zsh"

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

#!/bin/zsh

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

autoload -Uz run-help
unalias run-help
alias help=run-help
bindkey -a 'H' run-help # press H in command mode to see manpage
# End of lines added by compinstall

spaces=$(printf " %.0s" {1..$(( (COLUMNS - 40) / 2 ))})
fortune | cowsay | sed "s/^/$spaces/"
source ~/.zsh_plugins.sh
source ~/.zsh_aliases

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# necessary for correct VIM colors
# BASE16_SHELL=$HOME/.config/base16-shell/
# [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# SSH & GPG agent config
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SHOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye &> /dev/null

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'

export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

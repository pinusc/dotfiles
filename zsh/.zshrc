#!/bin/zsh

# ======== zsh options =========
fpath=(~/.completions $fpath)
setopt AUTO_CD
setopt NO_CLOBBER APPEND_CREATE  # will complain on > for existing file, but not >> on non-existing
zmodload zsh/zprof
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt share_history
setopt hist_find_no_dups hist_ignore_dups hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
bindkey -v

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt promptsubst

set -o noclobber
# not in alias file because security feature
alias cp='cp -i'
alias mv='mv -i'

# for jog
function zshaddhistory() {
	echo "${1%%$'\n'}|${PWD}   " >> ~/.zsh_history_ext
}

# ====== theming & style =======
zstyle ':completion:*' completer _expand _expand_alias _complete _ignored _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu yes select search
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '/home/pinusc/.zshrc'

PROMPT='%F{green}%m%f %F{blue}%~%f %# '

zmodload zsh/complist
# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'k' vi-down-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
# bindkey -M menuselect 'j' vi-down-line-or-history
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# completion regens cache one a day
autoload -Uz compinit
autoload -U zmv
# (#qN.mh+24) is fancy glob to match files older than 24 hours
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

hash run-help &>/dev/null && unalias run-help
autoload run-help
alias help=run-help
bindkey -a 'H' run-help # press H in command mode to see manpage
bindkey '^R' history-incremental-search-backward
bindkey '^e' push-line-or-edit
bindkey -M vicmd 'K' run-help
bindkey -M vicmd '_' vi-beginning-of-line

# === make <C-L> scroll instead of clearing
function scroll-top() {
    local esc
    local -i ROW COL OFFSET
    IFS='[;' read -sdR $'esc?\e[6n' ROW COL <$TTY
    OFFSET="${#${(@Af)PREBUFFER%$'\n'}}"+"${#${(@Af)LBUFFER:-1}}"
    (( ROW-OFFSET )) && printf '\e[%1$dS\e[%1$dA' ROW-OFFSET
    zle redisplay
}
zle -N clear-screen scroll-top

spaces=$(printf " %.0s" {1..$(( (COLUMNS - 40) / 2 ))})
if which fortune &>/dev/null && which cowsay &>/dev/null; then
    # must run in separate shell so that we hide job control's output
    (
        setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
        fortune | cowsay | sed "s/^/$spaces/" &
    )
fi

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye &> /dev/null

if which zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

if which fzf &>/dev/null; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh

    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
    export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

    which fd &>/dev/null && export FZF_ALT_C_COMMAND="fd --type directory --follow --min-depth 1"

    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# initialize plugins statically 
ANTIDOTE_FILE='/usr/share/zsh-antidote/antidote.zsh'
if [ -f "$ANTIDOTE_FILE" ]; then
    source "$ANTIDOTE_FILE"
    antidote load
fi

# ssh-agent (snippet from arch wiki)
# Ensure only one global ssh-agent is running
# In ~/.ssh/config, put
# AddKeysToAgent yes
# for automatic key adding
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# ===== Code that MUST be run after logins. Otherwise run it before. =======
if which history-substring-search-up &>/dev/null; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey '^K' history-substring-search-up
    bindkey '^J' history-substring-search-down
fi
# ====== load aliases =======
# *(N) is a glob qualifier so we don't get errors if there's no .alias_ files
for file in ~/.alias_*(N); do
    source "$file"
done
[ -e ~/.aliases ] && source ~/.aliases

PROMPT='${VENV_BASE:+($VENV_BASE) }'"$PROMPT"
# PROMPT="VENV $PROMPT"
#
# ==== run time ====
function preexec() {
  timer=$(($(date +%s%0N)/1000000))
}

function precmd() {
  if [ $timer ]; then
    now=$(($(date +%s%0N)/1000000))
    elapsed=$(($now-$timer))

    export RPROMPT="%F{cyan}${elapsed}ms %{$reset_color%}"
    unset timer
  fi
}

# wait # so we don't get a prompt before background jobs

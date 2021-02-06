#!/bin/zsh

fpath=(~/.completions $fpath)
setopt AUTO_CD
zmodload zsh/zprof
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt share_history
setopt hist_find_no_dups hist_ignore_dups hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
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

PROMPT="%F{green}%m%f %# "

autoload -Uz compinit
autoload -U zmv
compinit

autoload -Uz run-help
hash run-help &>/dev/null && unalias run-help
alias help=run-help
bindkey -a 'H' run-help # press H in command mode to see manpage
# End of lines added by compinstall

spaces=$(printf " %.0s" {1..$(( (COLUMNS - 40) / 2 ))})
which fortune &>/dev/null && which cowsay &>/dev/null && {
    fortune | cowsay | sed "s/^/$spaces/"
}

[ -e ~/.zsh_plugins.sh ] && source ~/.zsh_plugins.sh
# *(N) is a glob qualifier so we don't get errors if there's no .alias_ files
for file in ~/.alias_*(N); do
    source "$file"
done
[ -e ~/.aliases ] && source ~/.aliases

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

if which fzf &>/dev/null; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh

    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'

    export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# autocd for nnn
n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

which thefuck &>/dev/null && eval $(thefuck --alias)

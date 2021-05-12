#!/bin/zsh

# ======== zsh options =========
fpath=(~/.completions $fpath)
setopt AUTO_CD
zmodload zsh/zprof
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt share_history
setopt hist_find_no_dups hist_ignore_dups hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
bindkey -v

# completion regens cache one a day
autoload -Uz compinit
autoload -U zmv
# (#qN.mh+24) is fancy glob to match files older than 24 hours
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

autoload -Uz run-help
hash run-help &>/dev/null && unalias run-help
alias help=run-help
bindkey -a 'H' run-help # press H in command mode to see manpage
bindkey '^R' history-incremental-search-backward

spaces=$(printf " %.0s" {1..$(( (COLUMNS - 40) / 2 ))})
if which fortune &>/dev/null && which cowsay &>/dev/null; then
    # must run in separate shell so that we hide job control's output
    (
        setopt LOCAL_OPTIONS NO_NOTIFY NO_MONITOR
        fortune | cowsay | sed "s/^/$spaces/" &
    )
fi

# ====== load aliases =======
# *(N) is a glob qualifier so we don't get errors if there's no .alias_ files
for file in ~/.alias_*(N); do
    source "$file"
done
[ -e ~/.aliases ] && source ~/.aliases

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye &> /dev/null

if which fzf &>/dev/null; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh

    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'

    export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

    which fd &>/dev/null && export FZF_ALT_C_COMMAND="fd --type directory --follow --min-depth 1"

    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# ===== load plugins =======

[ -e ~/.zsh_plugins.sh ] && source ~/.zsh_plugins.sh

# ===== Code that MUST be run after logins. Otherwise run it before. =======

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

wait # so we don't get a prompt before background jobs

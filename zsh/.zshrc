#!/bin/zsh
fortune | cowsay
source $HOME/.zprofile
# load zgen
source "${HOME}/builds/zgen/zgen.zsh"
source ~/.zsh_aliases

fpath=(~/.completions $fpath)
autoload -U compinit
compinit

#BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-eighties.sh"
#[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

#if [ -n "$PS1" ]; then # if statement guards adding these helpers for non-interative shells
#  eval "$(~/.config/base16-shell/profile_helper.sh)"
#fi
#
# # Customize to your needs...
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

#alias lrvm='[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"'

fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# fzf + ag configuration
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
--color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168
'

export FZF_DEFAULT_COMMAND='ag -f -g ""' 

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SHOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye &> /dev/null

#
# virtalenvwrapper
# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/Devel
# source /usr/bin/virtualenvwrapper.sh

# ls colors: eliminate that ugly green background
#eval "$(dircolors ~/.config/dircolors)";


# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    # prezto options
    zgen prezto editor key-bindings 'vi'
    zgen prezto prompt theme 'sorin'

    # prezto and modules
    zgen prezto
    zgen prezto git
    zgen prezto syntax-highlighting
    zgen prezto history-substring-search 

    # completions
    zgen load zsh-users/zsh-completions src
    zgen load Tarrasch/zsh-autoenv
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load Vifon/deer

    zgen load changyuheng/fz
    zgen load rupa/z
    zgen load zuxfoucault/colored-man-pages_mod


    # save all to init script
    zgen save
fi

autoload -U deer
zle -N deer
bindkey '\ek' deer


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

sudo-expired() [[ $(
  trap "" XFSZ
  limit filesize 0
  LC_ALL=C sudo -n true 2>&1) = *"password is required" ]]

sudo-warning()
  if sudo-expired; then
    echo ""
  else
    echo '%F{red}# %f'
  fi

TMOUT=10
TRAPALRM() zle reset-prompt
set -o promptsubst
PS1='$(sudo-warning)'"$PROMPT"

#
# BEGIN: Shen's definitely not suspicious additions ;)
#
function AES-1337(){
  # AES-1337: Super top secret UNCRACKABLE encryption code (quantum-safe too :D)
  echo "$@" | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]' | cat
}

# Extra naughty hot and haughty. Definitely not executable. It's just a string!
PKG="CNLYBNQ='./zrffntr-cnlybnq.gkg';
    cevags '\r[1;34z~[Furavfz bs gur Qnl]~\a\r[0z';
    NRF-1337 \$(urnq -\$((\${ENAQBZ} % \`jp -y < \$CNLYBNQ\` + 1)) \$CNLYBNQ |
    gnvy -1)"

# What do you mean 'eval' is scary? eval is the nicest thing ever. Super safe!
eval "$(AES-1337 $PKG)"

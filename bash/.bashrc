case $- in # If not running interactively, don't do anything
    *i*) ;;
    *) return;;
esac

[ -e $HOME/.sensible.bash ] && source $HOME/.sensible.bash

export EDITOR=vim
export SUDO_EDITOR=vim

set +h
set -o vi
umask 022


>/dev/null hash fortune && fortune

bind -m vi-insert \C-l:clear-screen

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

sudo-active() [[ ! $(trap "" XFSZ
                     LC_ALL=C sudo -n true 2>&1) = *"password is required" ]]

green=$(tput setaf 2)
blue=$(tput setaf 4)
bold=$(tput bold)
reset=$(tput sgr0)

if [[ -n "$TMUX" ]]; then
    info='\u'
else
    if [[ $(uname -o) = Android ]]; then 
        hoststr="$(getprop net.hostname)"
    else
        hoststr='\h'
    fi
    info="$hoststr"
fi
PS1="\[$green$bold\]$info\[$reset\] \[$blue$bold\]\w\[$reset\] \$ "
unset hoststr

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

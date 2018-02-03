#!/bin/zsh

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

# For DuckPAN
alias lduckpan='eval $(perl -I${HOME}/perl5/lib/perl5 -Mlocal::lib)'

fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

source /usr/share/fzf/*.zsh

# fzf + ag configuration
export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
--color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
--color info:108,prompt:109,spinner:108,pointer:168,marker:168
'

export FZF_DEFAULT_COMMAND='ag -f -g ""' 

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

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

fortune | cowsay

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /usr/share/undistract-me/long-running.bash
notify_when_long_running_commands_finish_install


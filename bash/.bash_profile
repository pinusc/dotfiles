# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# Personal environment variables and startup programs.

# Personal aliases and functions should go in ~/.bashrc.  System wide
# environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.

# sourced by remote interactive login shells
# i.e. when you ssh into a machine
# NOT sourced on local interactive shells

append () {
    # First remove the directory
    local IFS=':'
    local NEWPATH
    for DIR in $PATH; do
        if [ "$DIR" != "$1" ]; then
            NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
        fi
    done

    # Then append the directory
    export PATH=$NEWPATH:$1
}

if [ -f "$HOME/.bashrc" ] ; then
    source $HOME/.bashrc
fi

if [ -d "$HOME/bin" ] ; then
    append $HOME/bin
fi

unset append

declare TMUX
# safe to start tmux, won't result in a loop
# because only run on remote interactive login shells
if [[ -z "$TMUX" ]]; then
    if tmux ls; then
        exec tmux attach
    else
        exec tmux new
    fi
fi

MOTD="/etc/motd"
ISSUE="/etc/issue"

if [[ ! -z "$TMUX" ]]; then
  if [[ -f "$MOTD" ]]; then
    cat "$MOTD"
  elif [[ -f "$ISSUE" ]]; then
    cat "$ISSUE"
  fi
fi

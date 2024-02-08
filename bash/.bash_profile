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

# safe to start tmux, won't result in a loop
# because only run on remote interactive login shells
if [[ -z "$TMUX" ]]; then
    # send hostname (for tmux & terminal window names)
    printf '\033]0;%s\007' "$(hostname -s)"
    printf '\ek%s\e\\' "$(hostname -s)"
    reset_title () {
        printf '\033]0;\007'
        printf '\ek\e\\'
    }
    trap reset_title EXIT

    if tmux ls; then
    	tmux_msg="$(tmux attach)"
    else
	tmux_msg="$(tmux new)"
    fi
    if [[ "$tmux_msg" != "[exited]" ]]; then
	    exit 0
    fi
fi

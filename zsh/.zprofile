#
# Executes commands at login pre-zshrc.
#
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi
# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
#export PATH="$HOME/bin:/home/pinusc/.gem/ruby/2.2.0/bin:$PATH"
# export PATH="/usr/local/heroku/bin:$HOME/.dotfiles:$PATH"

if [[ ! $DISPLAY && XDG_VTNR -eq 1 ]]; then
    # logverbose 20 is useful for detecting Modelines
    # startx -logverbose 100 &> X.log
    if uwsm check may-start; then
        exec uwsm start hyprland.desktop
    fi
fi

# start tmux IFF the shell is remote 
# shell is of course login or .zprofile wouldn't be sourced
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
# many other tests omitted
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi

if [[ ( "$SESSION_TYPE" = "remote/ssh" || "$(tty)" == "/dev/tty1" ) && -z "$TMUX" ]]; then 
    # send window name as hostname (for tmux & terminal window names)
    printf '\033]0;%s\007' "$(hostname -s)"
    printf '\ek%s\e\\' "$(hostname -s)"
    if tmux ls; then
    	tmux_msg="$(tmux attach)"
    else
	tmux_msg="$(tmux new)"
    fi
    # reset window title
    printf '\033]0;\007'
    printf '\ek\e\\'
    if [[ "$tmux_msg" != "[exited]" ]]; then
	    exit 0
    fi
fi

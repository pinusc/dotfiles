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
    # logverbose is useful for detecting Modelines
    exec startx -logverbose 20
    # exec startx
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

if [[ "$SESSION_TYPE" = "remote/ssh" && -z "$TMUX" ]]; then 
    if tmux ls; then
        exec tmux attach
    else
        exec tmux new
    fi
fi


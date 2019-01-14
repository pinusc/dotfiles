#! /bin/bash
export TMPDIR=$(mktemp -d)
# dim=$(xdpyinfo | awk '/dimensions:/ { print $2; exit }')
dim=$(xrandr | awk '/.*primary/ { print $4; exit }')
dimx=${dim%x*}
export PANEL_GAP=$(bspc config window_gap)
export PANEL_WIDTH=$(( dimx - 2 * PANEL_GAP))
FONT_SIZE=11
export PANEL_HEIGHT=$(( FONT_SIZE * 4 ))
export PANEL_FONT_FAMILY="Gohu GohuFont:size=$FONT_SIZE"
export ICON_FONT="GohuFont Nerd Font:size=$FONT_SIZE"
export dzencommand_music="$HOME/bin/panel/dzen2/scripts/mpdzen"
export dzencommand_calendar="zsh $HOME/bin/panel/dzen2/calendar"
export dkeyboard="$HOME/bin/dkeyboard"
export MAILDIR="$HOME/mail"
export MAILDIR_IMPORTANT="$HOME/mail/giuseppe@gstelluto.com"
export MAILCOMMAND='emacsclient -nqc --socket-name=/tmp/emacs1000/server -e "(mu4e)"'
export FETCHMAILCOMMAND='systemctl --user kill --signal=SIGUSR1 offlineimap'

#! /bin/bash
export TMPDIR=$(mktemp -d)
export PANEL_HEIGHT=45
# dim=$(xdpyinfo | awk '/dimensions:/ { print $2; exit }')
dim=$(xrandr | awk '/.*primary/ { print $4; exit }')
dimx=${dim%x*}
export PANEL_GAP=$(bspc config window_gap)
export PANEL_WIDTH=$(( dimx - 2 * PANEL_GAP))
export PANEL_FONT_FAMILY="Gohu GohuFont:size=11"
export ICON_FONT="GohuFont Nerd Font:size=11"
export dzencommand_music="$HOME/bin/panel/dzen2/scripts/mpdzen"
export dzencommand_calendar="zsh $HOME/bin/panel/dzen2/calendar"
export dkeyboard="$HOME/bin/dkeyboard"
export MAILDIR="$HOME/mail"
export MAILCOMMAND='emacsclient -nqc --socket-name=/tmp/emacs1000/server -e "(mu4e)"'
export FETCHMAILCOMMAND='systemctl --user kill --signal=SIGUSR1 offlineimap'

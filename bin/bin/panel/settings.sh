#! /bin/bash
export TMPDIR=$(mktemp -d)
export PANEL_FIFO="$TMPDIR/panel-fifo"
export PANEL_FIFO_2="$TMPDIR/panel-fifo-2"
export CLOCK_FIFO="$TMPDIR/panel-clock-fifo"
export PANEL_HEIGHT=45
# dim=$(xdpyinfo | awk '/dimensions:/ { print $2; exit }')
dim=$(xrandr | awk '/.*primary/ { print $4; exit }')
dimx=${dim%x*}
export PANEL_GAP=$(bspc config window_gap)
export PANEL_WIDTH=$(( dimx - 2 * PANEL_GAP))
# export PANEL_WIDTH=1910
# export PANEL_FONT_FAMILY="Source Code Pro for Powerline:size=12"
# export PANEL_FONT_FAMILY="-gohu-*-medium-*-*-*-14-*-*-*-*-*-*-*"
# export PANEL_FONT_FAMILY="Inconsolata for Powerline:size=14"
# export # PANEL_FONT_FAMILY="Monofur for Powerline:size=15"
export PANEL_FONT_FAMILY="Gohu GohuFont:size=11"
# export PANEL_FONT_FAMILY="Sauce Code Pro Nerd Font:size=11"
# export ICON_FONT="Font Awesome:size=11"
export ICON_FONT="GohuFont Nerd Font:size=11"
# export ICON_FONT="GohuFontMedium Nerd Font:size=14"
# export ICON_FONT_2="Weather Icons:size=11"
export dzencommand_music="$HOME/bin/panel/dzen2/scripts/mpdzen"
export dzencommand_calendar="zsh $HOME/bin/panel/dzen2/calendar"
export dkeyboard="$HOME/bin/dkeyboard"
export MAILDIR="$HOME/mail"
# export MAILCOMMAND='$HOME/bin/viewmail'
export MAILCOMMAND='emacsclient -nqc --socket-name=/tmp/emacs1000/server -e "(mu4e)"'
export FETCHMAILCOMMAND='systemctl --user kill --signal=SIGUSR1 offlineimap'
# export ICON_FONT2="fontcustom:size=17"
# export PANEL_FIFO PANEL_HEIGHT PANEL_FONT_FAMILY

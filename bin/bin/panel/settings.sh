#!/bin/bash
export TMPDIR=$(mktemp -d)
# dim=$(xdpyinfo | awk '/dimensions:/ { print $2; exit }')
dim=$(xrandr | awk '/.*primary/ { print $4; exit }')
dimx=${dim%x*}
export MAIN_MONITOR="$(xrandr | awk '/primary/{print $1;}')"

monitor_pos=$(xrandr --listactivemonitors | grep '^ 0' | \
    cut -d' ' -f4 | cut -d+ -f2)

export PANEL_GAP=$(bspc config window_gap)

export PANEL_GAP_X=$(( monitor_pos + PANEL_GAP ))
export PANEL_GAP_Y=$PANEL_GAP

export PANEL_WIDTH=$(( dimx - 2 * PANEL_GAP))
FONT_SIZE=11
export PANEL_HEIGHT=$(( FONT_SIZE * 35 / 10 - 5 ))
export PANEL_FONT_FAMILY="Terminus:size=$FONT_SIZE"
# export PANEL_FONT_FAMILY="Gohu GohuFont:size=$FONT_SIZE"
# export ICON_FONT="GohuFont Nerd Font:style=uni-14"
export ICON_FONT="Iosevka Nerd Font:size=13"
export redshift_command='$HOME/bin/redshift.sh'
export dzencommand_music="$HOME/bin/panel/dzen2/scripts/mpdzen"
export dzencommand_calendar="zsh $HOME/bin/panel/dzen2/calendar"
export dkeyboard="$HOME/bin/dkeyboard"
export MAILDIR="$HOME/mail"
export MAILDIR_IMPORTANT="$HOME/mail/gstelluto/inbox"
export MAILCOMMAND="$TERMINAL -name 'mail' -e mutt"
export FETCHMAILCOMMAND='mbsync -a'
export BATTERY_ZERO='0'

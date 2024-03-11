#!/usr/bin/env bash

function notify-send() {
    #Detect the name of the display in use
    local display=":$(ls /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"

    #Detect the user using such display
    local user=$(who | grep '('$display')' | awk '{print $1}' | head -n 1)

    #Detect the id of the user
    local uid=$(id -u $user)

    sudo -u $user DISPLAY=$display DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$uid/bus notify-send "$@"
}

journalctl --unit smtpd --follow --since "now" --grep 'delivery' | xargs -I{} sh -c 's="{}"; res="$(echo "$s" | sed "s/.*result=\(\S\+\).*/\1/")"; to="$(echo "$s" | sed "s/.*to=<\([^>]\+\)>.*/\1/")"; stat="$(echo "$s" | sed "s/.*stat=//")"; if [ "$res" = "Ok" ]; then  urgency="normal"; else not="NOT "; urgency="critical"; fi; notify-send -u "$urgency" "Email to $to ${not}sent" "Status: $stat"'

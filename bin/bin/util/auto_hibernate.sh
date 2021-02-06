#!/usr/bin/env bash

# checks if battery is too low
# if so, calls systemctl hibernate
# used in /etc/systemd/system/auto-hibernate.timer
#  and    /etc/systemd/system/auto-hibernate.service

ACTION=hibernate
BATTERY_ZERO="1"
THRESHOLD="5"

power=$(acpi -a | sed -r 's/.+(on|off).+/\1/')
if [ "$power" = "on" ]; then
    exit 0
fi
raw_charge=$(acpi | sed "s/[^,]\\+\?, //; s/%.\\+//; s/%//")
raw_charge=$(acpi | sed "s/[^,]\\+\?, //; s/%.\\+//; s/%//")
bcharge=$(( (raw_charge - BATTERY_ZERO) * 100 / (100 - BATTERY_ZERO) ))

if (( bcharge - THRESHOLD < 5 )); then
    remaining=$(( bcharge - THRESHOLD ))
    which notify-send 2>/dev/null && notify-send -u critical "Battery depleting. Only $remaining% of charge left until hibernating."
fi

if [ "$bcharge" -le "$THRESHOLD" ]; then
    which notify-send 2>/dev/null && notify-send -u critical "Battery depleted. Hibernating in 30 seconds..."
    sleep 15
    which notify-send 2>/dev/null && notify-send -u critical "Battery depleted. Hibernating in 15 seconds..."
    sleep 15
    systemctl "$ACTION"
    exit 0
fi
exit 0

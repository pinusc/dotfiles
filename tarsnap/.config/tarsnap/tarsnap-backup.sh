#!/bin/sh
email="giuseppe+root@gstelluto.com"
tarsnap_output_filename="$(mktemp /tmp/tarsnap-out-XXXX.log)"

excode=0
if ! /bin/tarsnap -v -c \
    -f "docs-$(uname -n | cut -d. -f1)-$(date --iso-8601)" \
    --configfile "$HOME/.config/tarsnap/tarsnaprc" \
    -X "$HOME/.config/tarsnap/exclude-patterns" \
    "/data/docs" >"$tarsnap_output_filename" 2>&1
then
    notify-send -u critical "Tarsnap backup failure" "See journalctl log" >/dev/null 2>&1 &
    mail -s "Tarsnap backup FAILURE" "$email" < "$tarsnap_output_filename"
    excode=1
fi
exit "$excode"

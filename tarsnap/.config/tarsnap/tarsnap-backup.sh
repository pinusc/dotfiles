#!/bin/sh
email="root+tarsnap@gstelluto.com"
tarsnap_output_filename="$(mktemp /tmp/tarsnap-out-XXXX.log)"

if ! /bin/tarsnap -v -c \
    -f "docs-$(uname -n | cut -d. -f1)-$(date --iso-8601)" \
    --configfile "$HOME/.config/tarsnap/tarsnaprc" \
    "$HOME/docs" >"$tarsnap_output_filename" 2>&1
then
    mail -s "Tarsnap backup FAILURE" "$email" < "$tarsnap_output_filename"
fi
rm "$tarsnap_output_filename"

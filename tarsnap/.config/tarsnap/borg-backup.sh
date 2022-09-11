#!/bin/bash

DIRECTORY="/data/docs"
REPOSITORY="/mnt/filer/borg-bak"
# export BORG_PASSCOMMAND="pass show servers/filer/borg-docs"
# export BORG_PASSPHRASE_FD="$HOME/.config/tarsnap/borg.key"
export BORG_PASSPHRASE="smhTGf3Pw92Ucc4I0NrFfXQEN1vgA1"

borg create \
    --patterns-from  <(sed 's/^\([^#]\)/-\1/' ~/.config/tarsnap/exclude-patterns) \
    "$REPOSITORY::docs-$(date -I)" \
    "$DIRECTORY"

exit $?

#!/usr/bin/env bash

showhelp () {
    cat <<EOF
Usage: remote_preview.sh [OPTIONS] SSH_HOST FILE/URL

Open a file or URL on a remote device, through SSH. Mostly supports android devices with termux.

Options:
    -d, --download      Downloads the URL as a file and then opens it remotely 
                        (the default behavior is to just open the URL remotely)
EOF
}

if [[ "$1" =~ "(-h|--help)" ]]; then
    showhelp
    exit 0
fi

argparse () {
    AS_URL=1
    # options first
    while [[ "$1" =~ ^- ]]; do
        case "$1" in
            -d|--download)
                AS_URL=0
                ;;
        esac
        shift
    done

    # now check if correct # of positional arguments are left
    if [[ "$#" -ne 2  ]]; then
        showhelp
        exit 1
    fi

    SSH_HOST="$1"
    TO_OPEN="$2"
}
argparse "$@"

ssh_do () {
    ssh "$SSH_HOST" -- "$@" 
}

if [[ "$AS_URL" -eq 1 && ! "$TO_OPEN" =~ ^https?: ]]; then
    TO_OPEN="https://$TO_OPEN"
fi

if [[ -f "$TO_OPEN" ]]; then
    file="$TO_OPEN"
else
    if [[ "$AS_URL" -ne 1 ]] && (echo "$TO_OPEN" | grep '^http'); then
        file="$(mktemp -p preview-file.XXXX)"
        echo "Downloading file..." >&2
        wget -q -O "$file" "$TO_OPEN"
    fi
fi

if ssh_do "command -v termux-open" | grep -q 'com.termux'; then
    ssh_is_android=1
else
    ssh_is_android=''
fi

if [[ "$AS_URL" -eq 1 ]]; then
    # open url remotely
    if [[ "$ssh_is_android" -eq 1 ]]; then
        ssh_do termux-open-url "$TO_OPEN"
    else
        if [[ -n "$(ssh_do 'echo "$BROWSER"')" ]]; then
            ssh_do '$BROWSER' "TO_OPEN"
        else
            ssh_do firefox "TO_OPEN"
        fi
    fi
else
    # remote_tmpdir="$(ssh_do mktemp --directory --tmpdir "remote_preview-XXXX")"
    remote_path="storage/shared/Download/$(basename "$file")"
    scp "$file" "$SSH_HOST:$remote_path"
    if [[ "$ssh_is_android" -eq 1 ]]; then
        ssh_do termux-open "$remote_path"
    else
        echo "idk, open it yourself"
    fi
fi

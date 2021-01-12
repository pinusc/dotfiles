#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] FILE

Share FILE with a python webserver and show a qr code to open it quickly
somehwere.

Script description here.

Available options:

-h, --help                Print this help and exit
-f, --flag                Some flag description
-v, --verbose             Print script debug info
-p PORT, --port PORT      Port number to listen on
--qr-host URL             Override url used in qr-code (useful for tunneling)
--tunnel HOST PORT        Also establish an ssh tunnel to HOST at PORT
EOF
exit
}

check_dependencies() {
    err=''
    if ! which qrencoder &>/dev/null; then
        msg "${RED}ERROR:${NOFORMAT} 'qrencode' not found."
        err=1
    fi
    if ! which python3 &>/dev/null; then
        msg "${RED}ERROR:${NOFORMAT} 'python3' not found."
        err=1
    fi
    [ -n "$err" ] && die "Dependencies unmet. Exiting."
}

cleanup() {
    trap - SIGINT SIGTERM ERR EXIT
    # script cleanup here
    msg "${YELLOW}Shutting down, now cleaning up...${NOFORMAT}"
    [ -d "$serverdir" ] && rm -r "$serverdir"
    jobs -pr | xargs kill 2>/dev/null
}

setup_colors() {
    if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
        NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
    else
        NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
    fi
}

msg() {
    echo >&2 -e "${1-}"
}

die() {
    local msg=$1
    local code=${2-1} # default exit status 1
    msg "$msg"
    exit "$code"
}

parse_params() {
    # default values of variables set from params
    port='8008'
    qrurl=''
    tunnel_host=''
    tunnel_port=''

    while :; do
        case "${1-}" in
            -h | --help) usage ;;
            -v | --verbose) set -x ;;
            --no-color) NO_COLOR=1 ;;
            -p | --port)
                port="${2-}"
                shift
                ;;
            --qr-host)
                qrurl="${2-}"
                shift
                ;;
            --tunnel)
                tunnel_host="${2-}"
                tunnel_port="${3-}"
                shift 2
                ;;
            -?*) die "Unknown option: $1" ;;
            *) break ;;
        esac
        shift
    done

    args=("$@")

    [[ ${#args[@]} -eq 0 ]] && die "Missing script argument: FILENAME"
    filename="${args[0]}"
    local fileext=".${filename#*.}"
    local filebase="${filename%.*}"
    prettyname="$(echo "$filebase" \
        | tr '[:space:]' '-' \
        | tr '[:upper:]' '[:lower:]' \
        | tr -d -C '[:alnum:]-' \
        | head -c -1)"
            prettyname="$prettyname$fileext"
    return 0
}

setup_directory () {
    serverdir="$(mktemp --tmpdir -d "fileshare-XXXX")"
    ln -s "$PWD/$filename" "$serverdir/$prettyname"
    return 0
}

function get_ip() {
    ip route get 1.1.1.1 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}'
}

function create_qrcode() {
    local qrfile
    qrfile="$(mktemp "$serverdir/qrcode-XXX.png")"
    if [ -z "$qrurl" ]; then
        qrurl="$(get_ip):$port"
    fi
    msg "${GREEN}Encoded QR for: ${NOFORMAT} http://$qrurl/$prettyname"
    qrencode "http://$qrurl/$prettyname" -o "$qrfile"
    echo "$qrfile"
}

function start_pyserver() {
    msg "${GREEN}Starting python server${NOFORMAT}"
    python3 -m http.server --bind "$(get_ip)" -d "$serverdir" "$port" &>/dev/null
}

function open_qrcode() {
    local openwith=""
    if which termux-open &>/dev/null; then
        openwith="termux-open"
    elif which sxiv &>/dev/null; then
        openwith="sxiv"
    elif which xdg-open &>/dev/null; then
        openwith="xdg-open"
    fi
    "$openwith" "$(create_qrcode)"
    return 0
}

serverdir=''

parse_params "$@"
setup_colors
check_dependencies

setup_directory
open_qrcode &
if [ -n "$tunnel_host" ] && [ -n "$tunnel_port" ]; then
    msg "${GREEN}Starting tunnel to ${YELLOW}$tunnel_host${GREEN}, port: ${YELLOW}$tunnel_port ${NOFORMAT}"
    ssh -N -R "$tunnel_port:$(get_ip):$port" "$tunnel_host" &
fi
start_pyserver &
wait -f %%

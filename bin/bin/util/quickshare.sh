#!/usr/bin/env bash

echo "Sharing $PWD"

parse_params() {
    # default values of variables set from params
    directory="$PWD"
    port=8000
    server=persephone

    while :; do
        case "${1-}" in
            -h | --help) usage ;;
            -v | --verbose) set -x ;;
            -d | --directory) 
                directory="${2-}"
                shift
                ;;
            -p | --port)
                port="${2-}"
                shift
                ;;
            -H | --host)
                server="${2-}"
                shift
                ;;
            -?*) die "Unknown option: $1" ;;
            *) break ;;
        esac
        shift
    done

    args=("$@")

    return 0
}
parse_params "$@"

{
    cd "$directory" || die "Directory does not exist: $directory"
    python ~/bin/lib/directoryserver.py &
}
sleep 0.5
echo "Started python server..."
ssh -N -R "$port:localhost:$port" "$server" &
echo "Started ssh tunnel..."
echo "You may now access this directory at quickshare.gstelluto.com"
echo "Press CTRL-C to stop..."
trap 'kill $(jobs -p) 2>/dev/null; exit' INT
while true; do
    sleep 30m
done

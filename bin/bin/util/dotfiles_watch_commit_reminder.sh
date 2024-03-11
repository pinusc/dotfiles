#!/usr/bin/bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

# script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

main(){
    notify-send "Watching dotfiles"
    # Watch for files with "sync-conflict" in the name
    cd "$HOME/dot"  
    git ls-tree --full-tree -r --name-only HEAD |
        inotifywait --monitor -e create,modify --format '%w%f' --fromfile - |
    while read NEWFILE; do
        msg f = $NEWFILE
        if [[ "${NEWFILE}" =~ .*tmp$ ]]; then
            : #Ignore .tmp files 
        else
            # Use sed to parse out just the final dirname/filename
            dirAndFilename=$(echo "${NEWFILE}" | sed -E 's/(.*)\/(.*)\//\2\//')
            # Show system notification. --hint makes it appear as syncthing.
            notify-send -u normal "Remember to commit your dotfiles!" "${dirAndFilename}"
        fi
    done
}


cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}


usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [--config FILE]

Watches ~/dot/ for modified files and sends notification to remember to commit changes

Available options:

-h, --help              Print this help and exit
EOF
  exit
}

parse_params() {
  # default values of variables set from params
  configfile=""

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  command -v notify-send &>/dev/null || die "notify-send not found"

  return 0
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

parse_params "$@"
main

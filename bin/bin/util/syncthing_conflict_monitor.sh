#!/usr/bin/bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

# script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

syncthing_conflict_monitor(){
    notify-send "Watching $1"
    # Watch for files with "sync-conflict" in the name
    inotifywait --monitor --recursive -e create,moved_to --include "sync-conflict" --format '%w%f' "$1" |
    while read NEWFILE; do
        if [[ "${NEWFILE}" =~ .*tmp$ ]]; then
            : #Ignore .tmp files (every syncing file starts as tmp, so notifying for those makes every notification happen 2x)
        else
            # Use sed to parse out just the final dirname/filename
            dirAndFilename=$(echo "${NEWFILE}" | sed -E 's/(.*)\/(.*)\//\2\//')
            # Show system notification. --hint makes it appear as syncthing.
            notify-send -u critical "Syncthing conflict" "${dirAndFilename}" --hint='string:desktop-entry:syncthing-ui'
        fi
    done
}

main() {
    if [ -n "$configfile" ]; then
        while IFS= read -r dir; do 
            syncthing_conflict_monitor "$dir" &
        done <<< "$(xq --raw-output '.configuration.folder.[] | .["@path"]' "$configfile")"
    fi

    wait
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}


usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [--config FILE]

Watches for syncthing conflict files in directories scanned from syncthing config file

Available options:

-h, --help              Print this help and exit
-c, --config-file FILE  Read directory information from FILE
EOF
  exit
}

parse_params() {
  # default values of variables set from params
  configfile=""

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -c | --config-file) # example named parameter
      configfile="${2-}"
      shift
      ;;
    -d | --directory) # example named parameter
        msg "Not implemented yet"
        usage
      shift ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ -z "${configfile-}" ]] && die "Missing required parameter: configfile"
  command -v notify-send &>/dev/null || die "notify-send not found"
  command -v xq &>/dev/null || die "xq not found"

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

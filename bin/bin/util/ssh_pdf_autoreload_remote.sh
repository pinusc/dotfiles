#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] REMOTE_WATCH_PATH [LOCAL_FILE_PATH]

Watch a remote file using ssh + inotifywait and copy it locally when it changes.

NOTE:
This programs starts a lot of independent ssh connections. Make sure to add they needed ssh keys to the keyring before starting it to avoid it asking for the key password multiple times.

Arguments:
REMOTE_WATCH_PATH       The path of the remote file, e.g. user@myserver.org:~/docs/paper.pdf
LOCAL_FILE_PATH         Where to copy the file. By default, it is copied in the current directory under the same name as on the remote.

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
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
  VERBOSE=""

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) 
        set -x; 
        VERBOSE=1;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments: REMOTE_WATCH_PATH"
  remote_path="${args[0]}"
  remote_host="${remote_path%%:*}"
  remote_path_nohost="${remote_path#*:}"

  if [[ ${#args[@]} -eq 2 ]]; then
      local_path="${args[1]}"
  else
      local_path="$(basename "$remote_path_nohost")"
  fi
  return 0
}

parse_params "$@"

# script logic here

if [[ -n "$VERBOSE" ]]; then
    msg "Read parameters"
    msg "remote_path = $remote_path"
    msg "remote_host = $remote_host"
    msg "remote_path_nohost = $remote_path_nohost"
    msg "local_path = $local_path"
fi

while true; do
    # this hangs until the file is written to
    ssh "$remote_host" inotifywait -e close_write "$remote_path_nohost"
    # now we just copy the file
    tempfile="$(mktemp ssh_autoreload.XXXX)"
    scp "$remote_path" "$tempfile"
    mv "$tempfile" "$local_path"
done

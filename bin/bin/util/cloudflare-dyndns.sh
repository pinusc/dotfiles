#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] [-k API_KEY] HOSTNAME ADDRESS

Script description here.

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-f, --flag      Some flag description
-p, --param     Some param description
-k API_KEY      The Cloudflare Token required for authentication. Can also be specivied using env variable CLOUDFLARE_API_KEY
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
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

check_dep() {
    if ! which curl &>/dev/null; then
        die "curl not installed"
    fi
    if ! which jq &>/dev/null; then
        die "jq not installed"
    fi
}

parse_params() {
    # default values of variables set from params
    flag=0
    param=''

    while :; do
        case "${1-}" in
            -h | --help) usage ;;
            -v | --verbose) set -x ;;
            --no-color) NO_COLOR=1 ;;
            -f | --flag) flag=1 ;; # example flag
            -k | --api-key) # example named parameter
                CLOUDFLARE_API_KEY="${2-}"
                shift
                ;;
            -?*) die "Unknown option: $1" ;;
            *) break ;;
        esac
        shift
    done

    args=("$@")

  # check required params and arguments
  if [[ -z "$CLOUDFLARE_API_KEY" ]]; then
      die "Needs API key!"
  fi
  [[ ${#args[@]} -lt 2 ]] && die "Missing script arguments"
  domain="${args[0]}"
  address="${args[1]}"
  return 0
}

BASEURL="https://api.cloudflare.com/client/v4"
parse_params "$@"
setup_colors
auth_header="Authorization: Bearer $CLOUDFLARE_API_KEY"

check_token_valid() {
    msg "Checking token validity..."
    local res success
    res=$(curl -s -X GET "$BASEURL/user/tokens/verify" -H "$auth_header")
    if [[ "$?" -eq 0 ]]; then
        die "${RED}Error performing request ${NOFORMAT}. Run with -v for more info."
    fi
    success=$(echo "$res" | jq .success)
    if [[ "$success" = true ]]; then
        msg "${GREEN}Success!${NOFORMAT}"
    else
        die "${RED}Error:${NOFORMAT} $(echo "$res" | jq)"
    fi
}

get_zone_id() {
    local zone_name res
    zone_name="$(echo "$domain" | rev | cut -d. -f1-2 | rev)"
    res=$(curl -X GET "$BASEURL/zones?name=$zone_name" -H "$auth_header" 2>/dev/null)
    if [[ "$(echo "$res" | jq .success)" = true ]]; then
        echo "$res" | jq --raw-output '.result[0].id'
    else
        die "${RED}Error:${NOFORMAT} $(echo "$res" | jq)"
    fi
}

get_record_info() {
    msg "Getting info for:\t${YELLOW}$domain${NOFORMAT}"
    res=$(curl -s -X GET "$BASEURL/zones/$zone_id/dns_records" -H "$auth_header")
    if [[ "$(echo "$res" | jq .success)" = true ]]; then
        local domain_info
        domain_info="$(echo "$res" | jq  ".result | map(select(.name == \"$domain\"))[0]")"
        msg "Current address:\t${YELLOW}$(echo "$domain_info" | jq --raw-output .content )${NOFORMAT}"
        echo "$domain_info"
    else
        die "${RED}Error:${NOFORMAT} $(echo "$res" | jq)"
    fi
}

update_record() {
    local res
    res=$(curl -s -X PUT "$BASEURL/zones/$zone_id/dns_records/$record_id" \
        -H "$auth_header" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"$DNS_TYPE\",\"name\":\"$domain\",\"content\":\"$address\",\"ttl\":\"$TTL\"}")
    # echo "$res" | jq >&2
    if [[ "$(echo "$res" | jq .success)" = true ]]; then
        msg "${GREEN}Success! ${NOFORMAT}"
        msg "Updated record to:\t${GREEN}$(echo "$res" | jq --raw-output .result.content )${NOFORMAT}"
    else
        die "${RED}Error:${NOFORMAT} $(echo "$res" | jq)"
    fi
}

# check_token_valid
zone_id=$(get_zone_id)
record_info=$(get_record_info)
record_id="$(echo "$record_info" | jq --raw-output .id )"
[[ -z "${TTL-}" ]] && TTL="$(echo "$record_info" | jq --raw-output .ttl )"
[[ -z "${DNS_TYPE-}" ]] && DNS_TYPE="$(echo "$record_info" | jq --raw-output '.type' )"
if [[ "$address" = "$(echo "$record_info" | jq --raw-output '.content' )" ]]; then
    die "Current address already set (${RED}$address${NOFORMAT}), no need to update. Exiting now..."
else
    update_record
fi

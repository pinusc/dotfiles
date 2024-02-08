#!/usr/bin/env bash
CACHEDIR="${XDG_CACHE_HOME-$HOME/.cache}"
HELPER_SCRIPT="$HOME/bin/util/cloudflare-dyndns.sh"
mkdir -p "$CACHEDIR"
CACHE="$CACHEDIR/dyndns.cache"
LOG="$CACHEDIR/dyndns.log"
if [[ -z "$IP" ]] && [[ -z "$INTERFACE" ]]; then
    die "need to set env var INTERFACE (e.g. wlan0)"
else
    if [[ -n "$IP" ]]; then
        ip_addr="$IP"
    else
        ip_addr="$(ip a show "$INTERFACE" | grep -Po 'inet \K[\d.]+')"
    fi
fi
echo "$ip_addr"

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

[[ -z "$DOMAIN" ]] && die "need to set env var DOMAIN (e.g. example.com)"
[[ -z "$CLOUDFLARE_API_KEY" ]] && die "need to set env var CLOUDFLARE_API_KEY"
export CLOUDFLARE_API_KEY
{
	if [[ ! -e "$CACHE" || "$ip_addr" != $(cat "$CACHE") ]]; then
		echo Running... 
		echo "(Updating $DOMAIN to $ip_addr)"
		res="$(bash "$HELPER_SCRIPT" "$DOMAIN" "$ip_addr" 2>&1)"
		if echo "$res" | grep -q "Updated record"; then
			new_addr="$(echo "$res" | grep -Po "Updated record to: \K[\d.]+")" 
		elif echo "$res" | grep -q "address already set"; then
			new_addr="$(echo "$res" | grep "address already set" | grep -Po "\([\d.]+\)" | tr -d '()')" 
		fi
		if [[ -n "$new_addr" ]]; then
			echo "$new_addr" > "$CACHE"
		fi
		echo "$res"
	else
		echo "No need to run, address is updated."
	fi
} | sed "s/^/$(date +'%Y-%m-%d %H:%M %Z'): /" | tee -a "$LOG"

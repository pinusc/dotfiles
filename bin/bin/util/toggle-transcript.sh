#!/usr/bin/env bash
set -euo pipefail

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/whisper-transcript.pid"

notify() {
  command -v notify-send >/dev/null 2>&1 || return 0
  notify-send -t 1200 "Dictation" "$1"
}

start() {
  notify "Start speaking"
  hyprctl dispatch submap dictation >/dev/null 2>&1 || true
  ( setsid -f bash -lc '
      exec whisper-stream --language auto -m dev/nchat/ggml-large-v2.bin 2>/dev/null | ansi2keys.py
    ' >/dev/null 2>&1 )
  pgrep -n -u "$UID" -x whisper-stream >"$PIDFILE" || true
}

stop() {
  if [[ -s "$PIDFILE" ]]; then
    pid="$(cat "$PIDFILE" || true)"
    rm -f "$PIDFILE"
    [[ -n "${pid:-}" ]] && kill "$pid" 2>/dev/null || true
  fi
  pkill -u "$UID" -x whisper-stream 2>/dev/null || true
  notify "Stopped"
  hyprctl dispatch submap reset >/dev/null 2>&1 || true
}

if pgrep -u "$UID" -x whisper-stream >/dev/null; then
  stop
else
  start
fi

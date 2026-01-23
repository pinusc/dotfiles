#!/usr/bin/env bash

# Pomodoro Timer - A simple bash-based pomodoro timer
# Commands: start, status, skip, toggle-pause, stop

set -euo pipefail

# XDG directories with fallback defaults
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pomodoro"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/pomodoro"
CONFIG_FILE="$CONFIG_DIR/pomodoro.conf"
STATE_FILE="$DATA_DIR/state"

# Default durations (in minutes)
DEFAULT_WORK_TIME=25
DEFAULT_BREAK_TIME=5

# Initialize directories
init_dirs() {
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$DATA_DIR"

    # Create default config if it doesn't exist
    if [[ ! -f "$CONFIG_FILE" ]]; then
        cat > "$CONFIG_FILE" << EOF
# Pomodoro Timer Configuration
# All times are in minutes

WORK_TIME=$DEFAULT_WORK_TIME
BREAK_TIME=$DEFAULT_BREAK_TIME

# Optional: Path to sound file to play when timer expires
# SOUND_FILE="/path/to/sound.wav"
EOF
    fi
}

# Load configuration
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        # Source the config file
        source "$CONFIG_FILE"
    fi

    # Set defaults if not defined
    WORK_TIME="${WORK_TIME:-$DEFAULT_WORK_TIME}"
    BREAK_TIME="${BREAK_TIME:-$DEFAULT_BREAK_TIME}"

    # Check if sound file is configured and exists
    if [[ -n "${SOUND_FILE:-}" ]]; then
        if [[ ! -f "$SOUND_FILE" ]]; then
            echo "Warning: Configured sound file does not exist: $SOUND_FILE" >&2
        fi
    fi
}

# Save state to file
save_state() {
    local phase="$1"
    local start_time="$2"
    local paused="$3"
    local pause_time="${4:-0}"
    local elapsed_before_pause="${5:-0}"
    local notification_sent="${6:-false}"

    cat > "$STATE_FILE" << EOF
PHASE=$phase
START_TIME=$start_time
PAUSED=$paused
PAUSE_TIME=$pause_time
ELAPSED_BEFORE_PAUSE=$elapsed_before_pause
NOTIFICATION_SENT=$notification_sent
EOF
}

# Load state from file
load_state() {
    if [[ -f "$STATE_FILE" ]]; then
        source "$STATE_FILE"
    else
        PHASE=""
        START_TIME=0
        PAUSED="false"
        PAUSE_TIME=0
        ELAPSED_BEFORE_PAUSE=0
        NOTIFICATION_SENT="false"
    fi
}

# Format seconds as MM:SS (handles negative values)
format_time() {
    local total_seconds=$1
    local sign=""

    # Handle negative time
    if [[ $total_seconds -lt 0 ]]; then
        sign="-"
        total_seconds=$((total_seconds * -1))
    fi

    local minutes=$((total_seconds / 60))
    local seconds=$((total_seconds % 60))
    printf "%s%02d:%02d" "$sign" "$minutes" "$seconds"
}

# Get current timestamp
now() {
    date +%s
}

# Start a new pomodoro session
cmd_start() {
    init_dirs
    load_config
    load_state

    local current_time=$(now)
    local elapsed=0
    local remaining=0
    local duration=0

    # Check if there's an active session
    if [[ -n "$PHASE" ]]; then
        # Calculate elapsed time
        if [[ "$PAUSED" == "true" ]]; then
            elapsed=$ELAPSED_BEFORE_PAUSE
        else
            elapsed=$((current_time - START_TIME + ELAPSED_BEFORE_PAUSE))
        fi

        # Determine phase duration
        if [[ "$PHASE" == "work" ]]; then
            duration=$((WORK_TIME * 60))
        else
            duration=$((BREAK_TIME * 60))
        fi

        remaining=$((duration - elapsed))

        # If timer hasn't expired, do nothing
        if [[ $remaining -gt 0 ]]; then
            echo "🍅 Timer already running! Current session: ${PHASE} with $(format_time $remaining) remaining"
            return
        fi

        # Timer has expired, switch to next phase
        if [[ "$PHASE" == "work" ]]; then
            save_state "break" "$current_time" "false" "0" "0" "false"
            echo "☕ Previous work session expired. Starting break session: ${BREAK_TIME} minutes"
        else
            save_state "work" "$current_time" "false" "0" "0" "false"
            echo "🍅 Previous break session expired. Starting work session: ${WORK_TIME} minutes"
        fi
    else
        # No active session, start a new work session
        save_state "work" "$current_time" "false" "0" "0" "false"
        echo "🍅 Pomodoro started! Work session: ${WORK_TIME} minutes"
    fi
}

# Show current status
cmd_status() {
    local json_output=false

    # Check for --json flag
    if [[ "${1:-}" == "--json" ]]; then
        json_output=true
    fi

    init_dirs
    load_config
    load_state

    # Build status text
    local text=""
    local tooltip=""
    local class=""
    local time_formatted="00:00"

    if [[ -z "$PHASE" ]]; then
        if [[ "$json_output" == "true" ]]; then
            text=""
        else
            text="00:00 idle"
        fi
        tooltip="No active pomodoro session"
        class="idle"
    else
        local current_time=$(now)
        local elapsed

        if [[ "$PAUSED" == "true" ]]; then
            elapsed=$ELAPSED_BEFORE_PAUSE
        else
            elapsed=$((current_time - START_TIME + ELAPSED_BEFORE_PAUSE))
        fi

        # Determine phase duration
        local duration
        local phase_emoji
        local phase_name
        if [[ "$PHASE" == "work" ]]; then
            duration=$((WORK_TIME * 60))
            phase_emoji="🍅"
            phase_name="Work"
        else
            duration=$((BREAK_TIME * 60))
            phase_emoji="☕"
            phase_name="Break"
        fi

        local remaining=$((duration - elapsed))
        time_formatted=$(format_time $remaining)

        # Check if timer is expired and notification hasn't been sent
        if [[ $remaining -le 0 && "$NOTIFICATION_SENT" == "false" && "$PAUSED" == "false" ]]; then
            # Send notification
            if command -v notify-send >/dev/null 2>&1; then
                if [[ "$PHASE" == "work" ]]; then
                    notify-send "🍅 Work Session Complete!" "Time for a ${BREAK_TIME} minute break" -u critical
                else
                    notify-send "☕ Break Session Complete!" "Time to get back to work for ${WORK_TIME} minutes" -u critical
                fi
            fi

            # Play sound if configured and file exists
            if [[ -n "${SOUND_FILE:-}" && -f "$SOUND_FILE" && -r "$SOUND_FILE" ]]; then
                if command -v aplay >/dev/null 2>&1; then
                    aplay -q "$SOUND_FILE" 2>/dev/null || true
                fi
            fi

            # Mark notification as sent
            save_state "$PHASE" "$START_TIME" "$PAUSED" "$PAUSE_TIME" "0" "true"
            NOTIFICATION_SENT="true"
        fi

        # Build text (machine-readable)
        if [[ "$json_output" == "true" ]]; then
            text="$time_formatted"
        else
            text="$time_formatted $PHASE"
            if [[ "$PAUSED" == "true" ]]; then
                text="$text paused"
            fi
        fi

        # Build tooltip (human-readable)
        if [[ $remaining -ge 0 ]]; then
            tooltip="$phase_emoji $phase_name session: $time_formatted remaining"
        else
            local elapsed_formatted=$(format_time $((remaining * -1)))
            tooltip="$phase_emoji $phase_name session: $elapsed_formatted since expiration"
        fi

        if [[ "$PAUSED" == "true" ]]; then
            tooltip="$tooltip (paused)"
        fi

        # Build class
        class="$PHASE"
        if [[ "$PAUSED" == "true" ]]; then
            class="$class-paused"
        fi
    fi

    # Output format
    if [[ "$json_output" == "true" ]]; then
        # Escape any special characters in strings for JSON
        local text_escaped="${text//\"/\\\"}"
        local tooltip_escaped="${tooltip//\"/\\\"}"
        echo "{\"text\":\"$text_escaped\",\"tooltip\":\"$tooltip_escaped\",\"class\":\"$class\"}"
    else
        echo "$text"
    fi
}

# Skip to next phase
cmd_skip() {
    init_dirs
    load_config
    load_state

    if [[ -z "$PHASE" ]]; then
        echo "No active pomodoro session. Run 'pomodoro start' to begin."
        return
    fi

    local current_time=$(now)

    if [[ "$PHASE" == "work" ]]; then
        save_state "break" "$current_time" "false" "0" "0" "false"
        echo "☕ Switched to break session: ${BREAK_TIME} minutes"
    else
        save_state "work" "$current_time" "false" "0" "0" "false"
        echo "🍅 Switched to work session: ${WORK_TIME} minutes"
    fi
}

# Toggle pause/resume
cmd_toggle_pause() {
    init_dirs
    load_config
    load_state

    local current_time=$(now)

    if [[ -z "$PHASE" ]]; then
        # No active session, start a new work session
        save_state "work" "$current_time" "false" "0" "0" "false"
        echo "🍅 Pomodoro started! Work session: ${WORK_TIME} minutes"
        return
    fi

    if [[ "$PAUSED" == "true" ]]; then
        # Resume: reset start time to account for paused duration
        save_state "$PHASE" "$current_time" "false" "0" "$ELAPSED_BEFORE_PAUSE" "$NOTIFICATION_SENT"
        echo "▶️  Session resumed"
    else
        # Pause: save elapsed time
        local elapsed=$((current_time - START_TIME + ELAPSED_BEFORE_PAUSE))
        save_state "$PHASE" "$START_TIME" "true" "$current_time" "$elapsed" "$NOTIFICATION_SENT"
        echo "⏸️  Session paused"
    fi
}

# Stop and clear the current session
cmd_stop() {
    init_dirs
    load_state

    if [[ -z "$PHASE" ]]; then
        echo "No active pomodoro session."
        return
    fi

    # Remove the state file
    if [[ -f "$STATE_FILE" ]]; then
        rm "$STATE_FILE"
    fi

    echo "🛑 Pomodoro session stopped and cleared."
}

# Show usage
usage() {
    cat << EOF
Usage: pomodoro <command>

Commands:
    start         Start a new work session
    status        Show current session status and remaining time
    skip          Skip to the next phase (work <-> break)
    toggle-pause  Pause or resume the current session
    stop          Stop and clear the current session

Configuration:
    Edit $CONFIG_FILE to customize work and break durations.

State:
    Session state is stored in $DATA_DIR
EOF
}

# Main command dispatcher
main() {
    if [[ $# -eq 0 ]]; then
        usage
        exit 1
    fi

    case "$1" in
        start)
            cmd_start
            ;;
        status)
            cmd_status "${2:-}"
            ;;
        skip)
            cmd_skip
            ;;
        toggle-pause)
            cmd_toggle_pause
            ;;
        stop)
            cmd_stop
            ;;
        help|--help|-h)
            usage
            ;;
        *)
            echo "Unknown command: $1"
            echo ""
            usage
            exit 1
            ;;
    esac
}

main "$@"


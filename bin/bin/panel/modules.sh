#!/usr/bin/bash

# TODO: rewrite modules so that variables are local!
. icons.sh
. settings.sh
clock() {
    if [ -n "$1" ]; then
        dtc="date +%H.%M"
        if [ -s "$1" ]; then
            clcommand=$(cat "$1")
            [ "$clcommand" = bash-fuzzy-clock ] && clother="$dtc" || clother="bash-fuzzy-clock"
        else
            clcommand=bash-fuzzy-clock
            clother="$dtc"
        fi
    else
        clcommand=bash-fuzzy-clock
    fi
    cloutput=$($clcommand)
    echo "C%{A:echo $clother > $1:}$IC_CLOCK $cloutput%{A}";
}

calendar() {
    echo "D%{A:$dzencommand_calendar:}$IC_CALENDAR $(date +'%a %b %d')%{A}"
}

bluetooth () {
    local bluetooth_icon=""
    local keyboard_connected
    keyboard_connected="$(bluetoothctl devices Connected | cut -d' ' -f2 | xargs -I{} bluetoothctl info {} | grep keyboard)"
    if ponymix | grep --silent bluez; then
            bluetooth_icon="$bluetooth_icon$IC_BLUETOOTH_HEADSET"
    fi
    if [ -n "$keyboard_connected" ]; then
            bluetooth_icon="$bluetooth_icon $IC_BLUETOOTH$IC_KEYBOARD"
    fi
    if [ -z "$bluetooth_icon" ]; then
            bluetooth_icon="$IC_BLUETOOTH_OFF"
    fi
    echo "h%{A:blueman-manager &:}%{A3:sudo /usr/local/bin/bluetooth_restart:}$bluetooth_icon%{A}%{A}"
}

pulse_volume() {
    volume=$(ponymix get-volume)
    local icon
    icon="$IC_VOLUME_MAX"
    if [[ $volume -ge 70 ]]; then
        icon="$IC_VOLUME_MAX"
    elif [[ $volume -gt 0 && $volume -lt 70 ]]; then
        icon="$IC_VOLUME_MEDIUM"
    elif [[ $volume -eq 0 ]]; then
        icon="$IC_VOLUME_MIN"
    fi
    echo "V%{A:pavucontrol:}$icon $volume%{A}"
}

getip() {
    echo -e I$IC_IP "$(curl -s icanhazip.com)"
    sleep 10
}

mailinfo() {
    # count=$(find "$MAILDIR" -type f | grep -cvE ',[^,]*S[^,]*$')
    count=$(find "$MAILDIR" -type d -path '*inbox/new' | xargs -I{} find {} -type f | wc -l)
    count_important=$(find "$MAILDIR_IMPORTANT" -type d -name 'new' | xargs -I{} find {} -type f | wc -l)
    if [ "$count_important" -gt 0 ]; then
        count_important="$count_important "
    else
        count_important="0 "
    fi
    if [ "$count" -gt 0 ]; then
        echo "Mf%{A3:$FETCHMAILCOMMAND:}%{A:$MAILCOMMAND:}$IC_MAIL $count_important$count%{A}%{A}"
    else
        echo "M0%{A3:$FETCHMAILCOMMAND:}%{A:MAILCOMMAND:}$IC_MAIL%{A}%{A}"
    fi
}

#iAir pollution
pollution() {
    location=$(geolocate)
    lng=${location#*,}
    lat=${location%,*}
    res=$(curl -s "http://api.waqi.info/feed/geo:$lat;$lng/?token=$API_WAQI")
    # 7874 is the Changshu code. When in a place where IP Localization is available, should use "here"
    # Or, to find station id, query as follows: "https://api.waqi.info/search/?token=$API_WAQI&keyword=changshu"
    # One should be able to use "http://api.waqi.info/feed/changshu/?token=$API_WAQI", but for some reason API queries by sity always return aqi for Ontario, Canada using my token. Problem does not arise using "demo" as a toke, but that is against terms of service.
    aqi=$(echo "$res"  | jq -r .data.aqi)
    # url=$(echo "$res"  | jq -r .data.city.url)
    # url_comm="firefox \"${url#*://}\"" # the colon in the URL will interfere with lemonbar's syntax and this is easier than figuring out how to escape ti
    icon=$IC_POLLUTION
    color=""
    if (( aqi <= 50 )); then
        color="g"
    elif (( aqi < 100 )); then
        color="y"
    elif (( aqi < 150 )); then
        color="o"
    elif (( aqi < 200 )); then
        color="r"
    elif (( aqi < 300 )); then
        color="b"
    else
        color="p"
    fi
    # echo A"$color%{A:$url_comm:}$icon $aqi%{A}"
    echo A"$color$icon $aqi"
}

weather() {
    >&2 echo "WEATHER"
    location=$(geolocate)
    weather_response=$(curl -s "https://api.pirateweather.net/forecast/$API_PIRATEWEATHER/$location?units=si&exclude=minutely,hourly,daily,alerts.flags")
    url_comm="firefox darksky.net/forecast/changshu/si12/en"
    apiicon=$(echo "$weather_response" | jq -r .currently.icon)
    temp=$(echo "$weather_response" | jq -r .currently.temperature)

    # I use en_DK as my locale, which separates decimals with a comma
    # But the api uses a point
    # So when printf is given a decimal number using a point, it gives error and fucks up
    # Setting LC_NUMERIC to C ensures this never happens
    LC_NUMERIC="C"
    [[ "$temp" = null ]] && return 1
    temperature=$(printf "%.1f" "$temp")
    icon=""
    color=""  # depending on temperature, can be blue, yellow or red
    case $apiicon in
        clear-day)
            icon=$IC_WEATHER_CLEAR
            ;;
        clear-night)
            icon=$IC_WEATHER_CLEAR_NIGHT
            ;;
        rain)
            icon=$IC_WEATHER_RAIN
            ;;
        cloudy)
            icon=$IC_WEATHER_CLOUDY
            ;;
        partly-cloudy-day)
            icon=$IC_WEATHER_PARTLY_CLOUDY_DAY
            ;;
        partly-cloudy-night)
            icon=$IC_WEATHER_PARTLY_CLOUDY_NIGHT
            ;;
        snow)
            icon=$IC_WEATHER_SNOW
            ;;
        wind)
            icon=$IC_WEATHER_WIND
            ;;
        fog)
            icon=$IC_WEATHER_FOG
            ;;
    esac
    temperature_int=$(printf "%.0f" "$temp")
    if (( temperature_int < 15 )); then
        color="b"
    elif (( temperature_int < 30 )); then
        color="y"
    else
        color="r"
    fi
    # echo -e F"$color%{A:$url_comm:}$icon $temperature%{A}"
    >&2 echo -e F"$color$icon $temperature"
    echo -e F"$color$icon $temperature"
}

vpn() {
    local vpn_interface
    vpn_interface=$(ip -br a | cut -d" " -f1 | grep -E "(tun[[:digit:]]|cs-.*)")
    if [[ -n "$vpn_interface" ]]; then
        # check that this is an actual vpn through which we route traffic
        if ip route get 1.1.1.1 | grep "$vpn_interface"; then
            echo "l$IC_VPN $vpn_interface"
        else
            echo "l-"
        fi
    else
        echo "l-"
    fi
}

# wifi
network() {
    interface="$(ip link | grep -E '(wl|en)p.*s.*:' | grep 'state UP' | awk '{ print $2 }')"
    network_type="${interface:0:2}"
    case $network_type in
        wl)
            link=$(iw "$interface" link)
            ic_type=$IC_WIFI
            ssid=$(echo "$link" | grep 'SSID' | sed 's/SSID: //' | sed 's/\t//')
            signal=$(echo "$link" | grep 'signal' | sed 's/signal: //; s/ dBm//; s/\t//')
            other=" ${ssid} ${signal}"
        ;;
        en)
            ic_type=$IC_ETHERNET
        ;;
        *)
            ic_state="$IC_NOCONNECTION"
            state=d
        ;;
    esac
    if [[ -z "$ic_state" ]]; then
        ADDRESS=perdu.com HTMLGREP="Vous Etes Perdu" check_connection
        case $? in
            0) 
                state=u
                ic_state=$IC_CONNECTED
                ;;
            63) 
                state=d
                other="${other} !HTML"
                ic_state=$IC_NOCONNECTION
                ;;
            64) 
                state=d
                other="${other} !DNS OK"
                ic_state=$IC_NOCONNECTION
                ;;
            65) 
                state=d
                other="${other} !NO DNSLOOKUP-DNSSERV OK"
                ic_state=$IC_NOCONNECTION
                ;;
            66) 
                state=d
                other="${other} !GATEWAY OK"
                ic_state=$IC_NOCONNECTION
                ;;
            67) 
                state=d
                other="${other} !PING OK"
                ic_state=$IC_NOCONNECTION
                ;;
            *) 
                state=d
                other="${other}-NO CONN"
                ic_state=$IC_NOCONNECTION
                ;;
        esac
    fi
    echo "L$state$ic_type|$ic_state|$other"
}

# some music services (mopidy-youtube) can't properly parse some titles
# also some titles just SUCK
# so we normalize them
music_normalize_title () {
    local arr
    read -r -a arr < <(echo "$1")
    arr=( "${arr[@],,}" )
    capitalized="${arr[*]^}"
    trim=$(echo "$capitalized" | sed "s/&#39/'/g")
    trim=$(echo "$trim" | sed "s/[Oo]fficial//; s/[Vv]ideo//")
    trim=$(echo "$trim" | sed "s/( *)//; s/\[ *\]//; s/^ *//; s/ *$//")
    grep "|" <(echo "$trim") && trim=$(echo "$trim" | grep -o '.*|' | head -c -2)
    echo "$trim"
}

# music controls
music() {
    local title
    local artist
    {
        local IC_PLAYPAUSE=""
        if command -v playerctl; then
            if command -v get_mpris_active_player.sh; then
                player=$(get_mpris_active_player.sh)
            else
                player=$(playerctl --list-all | head -n 1)
            fi
            if [[ -n "$player" ]]; then
                title="$(playerctl -p "$player" metadata title)"
                artist="$(playerctl -p "$player" metadata artist)"
                if [[ $(playerctl -p "$player" status) = "Paused" ]]; then
                    IC_PLAYPAUSE="$IC_MUSIC_PLAY"
                elif [[ $(playerctl -p "$player" status) = "Playing" ]]; then
                    IC_PLAYPAUSE="$IC_MUSIC_PAUSE"
                else
                    IC_PLAYPAUSE="$IC_MUSIC_PAUSE"
                fi
                music_command="%{A:playerctl -p $player previous:}$IC_MUSIC_PREV%{A} %{A:playerctl -p $player play-pause:}$IC_PLAYPAUSE%{A} %{A:playerctl -p $player next:}$IC_MUSIC_NEXT%{A}"
                [[ "$player" = spotify ]] && music_command="${music_command} $IC_SPOTIFY"
            fi
        fi
        if command -v mpc && [[ -z "$title" ]]; then
            title=$(mpc current -f "%title%" | head -n1)
            if [[ -z "$title" ]]; then
                title=$(grep -B 1 -m 1 "$(mpc | head -n 1)" .youtube-mpd | head -n 1)
            fi
            if [[ $(mpc status | awk '/volume/ {print $2}') != "n/a" ]]; then
                if mpc status | grep -q "paused"; then
                    IC_PLAYPAUSE="$IC_MUSIC_PLAY"
                else
                    IC_PLAYPAUSE="$IC_MUSIC_PAUSE"
                fi
                music_command="%{A:mpc prev:}$IC_MUSIC_PREV%{A} %{A:mpc pause:}$IC_PLAYPAUSE%{A} %{A:mpc next:}$IC_MUSIC_NEXT%{A}"
            fi
        fi
    } > /dev/null 2>&1

    title="$(music_normalize_title "$title")"

    # not outputting for bar, but for zscroll
    if [[ "$1" = "--lib" ]]; then
        if [[ -n "$title" ]] && [[ -n "$music_command" ]]; then
            echo "R$music_command  %{A:$dzencommand_music:}"
            echo "$title"
            echo "%{A}"
        fi
        return
    fi

    if [[ -n "$title" ]] && [[ -n "$music_command" ]]; then
        if [ "${#title}" -gt 25 ]; then
            title="${title:0:25}..."
        fi
        echo "R$music_command  %{A:$dzencommand_music:}$title%{A} "
    fi
}


# USAGE: music_zscroll_watch ZSCROLLFILE SLEEP
music_zscroll_watch() {
    local file="$1"
    local update="$2"
    local raw
    local oldraw
    local zscroll_pid
    local before
    local title
    local after
    while true; do
        raw="$(< "$file")"
        [[ -z "$raw" || "$raw" = "$oldraw" ]] && sleep 1 && continue
        before="$(echo "$raw" | sed '1q;d')"
        title="$(echo "$raw" | sed '2q;d')"
        after="$(echo "$raw" | sed '3q;d')"
        [[ -n "$zscroll_pid" ]] && kill "$zscroll_pid"
        zscroll -l 25 -b "$before" -a "$after" "$title" &
        zscroll_pid=$!
        oldraw="$raw"
        sleep "$update"
    done
}

songScroll() {
    zscroll -l 25 -n -u -b "R%{T3}%{A:mpc prev:}$IC_MUSIC_PREV%{A}%{A3:$dzencommand_music:} %{A:mpc pause:}$IC_MUSIC_PAUSE%{A}%{A} %{A:mpc next:}$IC_MUSIC_NEXT%{A}%{T1} " -d 0.3 "getSongName" > "$PANEL_FIFO" &

}

# music play only
musicp() {
    SONG_NAME=$(mpc | head -n1)
    if [[ $(mpc status | awk '/volume/ {print $2}') != "n/a" ]]; then
        if mpc status | grep -q paused; then
            command="play"
            icon=$IC_MUSIC_PLAY
        else
            command="pause"
            icon=$IC_MUSIC_PAUSE
        fi
        echo "m%{A:mpc $command:}%{A3:$dzencommand_music:}$icon%{A}%{A}"
        # echo "m%{A:mpc $command:}$icon%{A}"
    fi
}

#pomodoro
pcheck_pomodoro() {
    echo "P$(pomodoro -r -H)"
    ## failsafe in case we miss 0
    local pom_remaining
    # pom_last can not be local
    pom_remaining="$(pomodoro -r)"
    pom_remaining="${pom_remaining#?}"
    if [[ -n "$pom_last" && ("$pom_remaining" -gt "$pom_last") ]]; then
        notify-send POMODORO Completed &
        paplay /usr/share/sounds/freedesktop/stereo/complete.oga &
    fi
    pom_last="$pom_remaining"
}

#battery
battery() {
    local power
    local raw_charge 
    local bcharge
    local power
    power=$(acpi -a | sed -r 's/.+(on|off).+/\1/')
    raw_charge=$(acpi | sed "s/[^,]\\+\?, //; s/%.\\+//; s/%//")
    bcharge=$(( (raw_charge - BATTERY_ZERO) * 100 / (100 - BATTERY_ZERO) ))
    local bcolor=""
    if [[ -z $power ]]; then
        return 1
    elif [[ $power = "on" ]]; then
        bicon="$IC_BATTERY_POWER"
        bcolor="f"
    elif [[ $bcharge -ge 95 ]]; then
        bicon="$IC_BATTERY_FULL"
        bcolor="f"
    elif [[ $bcharge -ge 65 ]]; then
        bicon="$IC_BATTERY_GT_65"
        bcolor="f"
    elif [[ $bcharge -ge 35 ]]; then
        bicon="$IC_BATTERY_GT_35"
        bcolor="m"
    elif [[ $bcharge -ge 10 ]]; then
        bicon="$IC_BATTERY_GT_10"
        bcolor="m"
    else
        bicon="$IC_BATTERY_EMPTY"
        bcolor="e"
    fi
    echo "B$bcolor$bicon $bcharge%%"
}

phonebattery() {
    local bcharge
    local bicon
    bcharge=$(ssh sacripante termux-battery-status | jq .percentage)
    [[ -z "$bcharge" ]] && return 1
    if [[ $bcharge -ge 70 ]]; then
        bcolor="f"
    elif [[ $bcharge -ge 15 ]]; then
        bcolor="m"
    else
        bcolor="e"
    fi
    bicon="$IC_PHONE"
    echo "b$bcolor$bicon $bcharge%"
}



#keyboard
keyboard() {
    color="b"
    [ -f "$HOME/.keyboard" ] && read -r var< "$HOME/.keyboard"
    if [ "$var" = "disabled" ]; then
        color="r"
    fi
    echo "Kb$(setxkbmap -query | awk '/layout:/ {print $2; exit}' | head -c 2)"
    echo "Kc$color%{A:$dkeyboard:}$IC_KEYBOARD%{A}"
}

#wallpaper
wallpaper() {
    echo "Q%{A:$HOME/bin/util/wallpaper/random_wallpaper.sh:}%{A3:$HOME/bin/util/wallpaper/fortunewallpaper.sh:}$IC_WALLPAPER%{A}%{A}"
}


gpg_info () {
    # If $1 is passed, it gets called as command after locking the agent.
    # This is useful e.g. for resetting gnome-keyring (with gnome-keyring-daemon -r -d)
    # if it contains the password

    # The regex works because `keyinfo --list` (check `help keyinfo`)
    # lists a bunch of information after the key grips. CACHED state is 1 or -
    # and it immediately precedes PROTECTION, which is either P, C or -
    # So if there's a 1 right before a [PC-], we know at least one key is unlocked
    gpg_command="gpg-connect-agent 'reloadagent' /bye; $1"
    if gpg-connect-agent 'keyinfo --list' /bye 2>/dev/null | grep -q -E "1 [PC-]"; then
        icon="$IC_UNLOCK"
    else
        icon="$IC_LOCK"
    fi
    echo "g%{A:$gpg_command:}$icon%{A}"
}

notifications() {
    icon="$IC_BELL"
    if [ "$(dunstctl is-paused)" = 'true' ]; then
        icon="$IC_BELL_SLASH"
    fi
    echo "n%{A3:dunstctl set-paused toggle:}%{A:dunstctl history-pop:}$icon%{A}%{A}"
}

usedmemory() {
    icon="$IC_CHIP"
    used="$(free | awk '/Mem/{ printf("%d", $3/$2*100); }')"
    echo "f$icon $used"
}

p_redshift () {
    icon="$IC_SUN"
    echo "r%{A:killall -s USR1 redshift:}$icon%{A}"
}

cpufreq() {
    icon="$IC_CPU"
    icon_temp="$IC_TEMP"
    freq="$(grep MHz /proc/cpuinfo | awk -F: 'BEGIN{max=0} { if ($2 > max){ max = $2}; } END { printf "%.1f\n", max / 1000 }')"
    idle="$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}';)"
    temp=$(sensors coretemp-isa-0000 -u | grep temp1_input | cut -d' ' -f4 | cut -d. -f1)
    echo "G$icon${freq}GHz $idle $icon_temp$temp°C"
}

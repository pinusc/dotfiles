#!/usr/bin/bash
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
    url_comm="firefox calendar.google.com"
    echo "D%{A:$dzencommand_calendar:}%{A3:$url_comm:}$IC_CALENDAR $(date +'%a %b %d')%{A}%{A}"
}

pulse_volume() {
    volume=$(ponymix get-volume)
    ponymix | grep --silent bluez && bluetooth="$IC_BLUETOOTH "
    icon="$IC_VOLUME_MAX"
    if [[ $volume -ge 70 ]]; then
        icon="$IC_VOLUME_MAX"
    elif [[ $volume -gt 0 && $volume -lt 70 ]]; then
        icon="$IC_VOLUME_MEDIUM"
    elif [[ $volume -eq 0 ]]; then
        icon="$IC_VOLUME_MIN"
    fi
    echo "V%{A:pavucontrol:}$bluetooth$icon $volume%{A}"
}

getip() {
    echo -e I$IC_IP "$(curl -s icanhazip.com)"
    sleep 10
}

mailinfo() {
    # count=$(find "$MAILDIR" -type f | grep -cvE ',[^,]*S[^,]*$')
    count=$(find "$MAILDIR" -type d -name 'new' | xargs -I{} find {} -type f | wc -l)
    count_important=$(find "$MAILDIR_IMPORTANT" -type d -name 'new' | xargs -I{} find {} -type f | wc -l)
    if [ "$count_important" -gt 0 ]; then
        count_important="$count_important "
    else
        count_important=""
    fi
    if [ "$count" -gt 0 ]; then
        echo "Mf%{A3:$FETCHMAILCOMMAND:}%{A:$MAILCOMMAND:}$IC_MAIL $count_important$count%{A}${A}"
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
    weather_response=$(curl -s "https://api.darksky.net/forecast/$API_DARKSKY/$location?units=si&exclude=minutely,hourly,daily,alerts.flags")
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

# wifi
network() {
    interface="$(ip link | grep -E '(wl|en)p.*s.*:' | grep 'state UP' | awk '{ print $2 }')"
    network_type="${interface:0:2}"
    check_connection 54.37.204.227
    case $? in
        0) state=u
           ic_state=$IC_CONNECTED
           ;;
        *) state=d
           ic_state=$IC_NOCONNECTION
           ;;
    esac
    case $network_type in
        wl)
            link=$(iw "$interface" link)
            ic_type=$IC_WIFI
            ssid=$(echo "$link" | grep 'SSID' | sed 's/SSID: //' | sed 's/\t//')
            signal=$(echo "$link" | grep 'signal' | sed 's/signal: //' | sed 's/ dBm//' | sed 's/\t//')
            other=" ${ssid}, ${signal}"
        ;;
        en)
            ic_type=$IC_ETHERNET
        ;;
    esac
    echo "L$state$ic_type|$ic_state|$other"
}

# music controls
music() {
    {
        if command -v mpris && [[ -n $(mpris --list ) ]]; then
            echo "mpris"
            player=$(mpris --list | awk -F '.' '{ print $4; }')
            meta="$(mpris $player meta)"
            readarray -t metarray <<< "$meta"
            for l in "${!metarray[@]}"; do
                # lines are of the form mpris:$propname=$prop
                p="${metarray[$l]#*:}"  # gets the line and strips "mpris:"
                propname="${p%=*}"
                # for some reason sometimes artist is artist[]
                propname=$(echo "$propname" | tr -dc "[:alnum:]") # remove special characters
                value="${p#*=}"
                eval "${propname}=\"${value}\""
            done
            if [[ $(mpris "$player" get player/status) = "Paused" ]]; then
                command="%{A:mpris $player prev:}$IC_MUSIC_PREV%{A} %{A:mpris $player play:}$IC_MUSIC_PLAY%{A} %{A:mpris $player next:}$IC_MUSIC_NEXT%{A}"
            else
                command="%{A:mpris $player prev:}$IC_MUSIC_PREV%{A} %{A:mpris $player pause:}$IC_MUSIC_PAUSE%{A} %{A:mpris $player next:}$IC_MUSIC_NEXT%{A}"
            fi
            [[ "$player" = spotify ]] && command="${command} $IC_SPOTIFY"

        elif command -v mpc; then
            title=$(mpc -f "%title%" | head -n1)
            if [[ -z "$title" ]]; then
                title=$(grep -B 1 -m 1 "$(mpc | head -n 1)" .youtube-mpd | head -n 1)
            fi
            if [[ $(mpc status | awk '/volume/ {print $2}') != "n/a" ]]; then
                if mpc status | grep -q "paused"; then
                    command="%{A:mpc prev:}$IC_MUSIC_PREV%{A} %{A:mpc play:}$IC_MUSIC_PLAY%{A} %{A:mpc next:}$IC_MUSIC_NEXT%{A}"
                else
                    command="%{A:mpc prev:}$IC_MUSIC_PREV%{A} %{A:mpc pause:}$IC_MUSIC_PAUSE%{A} %{A:mpc next:}$IC_MUSIC_NEXT%{A}"
                fi
            fi
        fi
    } > /dev/null 2>&1

    if [[ -n "$title" ]] && [[ -n "$command" ]]; then
        if [ "${#title}" -gt 25 ]; then
            title="${title:0:25}..."
        fi
        echo "R$command  %{A:$dzencommand_music:}$title%{A} "
    fi
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
    if [ "$(pomodoro -r)" = p0 ]; then
        notify-send POMODORO Completed
        paplay /usr/share/sounds/freedesktop/stereo/complete.oga
    fi
}

#battery
battery() {
    power=$(acpi -a | sed -r 's/.+(on|off).+/\1/')
    raw_charge=$(acpi | sed "s/[^,]\\+\?, //; s/%.\\+//; s/%//")
    bcharge=$(( (raw_charge - BATTERY_ZERO) * 100 / (100 - BATTERY_ZERO) ))
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
    echo "B$bcolor$bicon $bcharge%"
}

#keyboard
keyboard() {
    color="b"
    [ -f "$HOME/.keyboard" ] && read -r var< "$HOME/.keyboard"
    if [ "$var" = "disabled" ]; then
        color="r"
    fi
    echo "K$(setxkbmap -query | awk '/layout:/ {print $2; exit}' | head -c 2)"
    echo "Kc$color%{A:$dkeyboard:}$IC_KEYBOARD%{A}"
}

#wallpaper
wallpaper() {
    echo "Q%{A:random_wallpaper.sh:}%{A3:fortunewallpaper.sh:}$IC_WALLPAPER%{A}%{A}"
}


gpg_info () {
    echo GPGINFO
    # If $1 is passed, it gets called as command after locking the agent.
    # This is useful e.g. for resetting gnome-keyring (with gnome-keyring-daemon -r -d)
    # if it contains the password

    # The regex works because `keyinfo --list` (check `help keyinfo`)
    # lists a bunch of information after the key grips. CACHED state is 1 or -
    # and it immediately precedes PROTECTION, which is either P, C or -
    # So if there's a 1 right before a [PC-], we know at least one key is unlocked
    command="gpg-connect-agent 'reloadagent' /bye; $1"
    if gpg-connect-agent 'keyinfo --list' /bye | grep -q -E "1 [PC-]"; then
        icon="$IC_UNLOCK"
    else
        icon="$IC_LOCK"
    fi
    echo "g%{A:$command:}$icon%{A}"
}

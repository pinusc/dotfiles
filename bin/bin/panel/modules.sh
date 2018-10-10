source icons.sh
cflag=0
clock() {
    if [ -n "$1" ]; then
        dtc="date +%H.%M"
        if [ -s $1 ]; then
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
    echo "C%{A:echo $clother > $1:}$icon_clock$cloutput%{A}";
}

calendar() {
    url_comm="firefox calendar.google.com"
    echo "D%{A:$dzencommand_calendar:}%{A3:$url_comm:}$IC_CALENDAR $(date +'%a %b %d')%{A}%{A}"
}

alsa_volume() {
    ALSA_STATE=1
    VOLUME=$(ponymix get-volume)
    ICON=$IC_VOLUME_MAX
    if [ $ALSA_STATE ]; then
        if [[ $VOLUME -ge 70 ]]
        then
            ICON=$IC_VOLUME_MAX
        fi
        if [[ $VOLUME -gt 0 && $VOLUME -lt 70 ]]
        then
            ICON=$IC_VOLUME_MAX
        fi
        if [[ $VOLUME -eq 0 ]]
        then
            ICON=$IC_VOLUME_MAX
        fi
    fi
    echo "V%{A:pavucontrol:}$ICON $VOLUME%{A}"
}

getip() {
    echo -e I$IC_IP $(curl -s icanhazip.com)
    sleep 10
}

mail() {
    count=$(find "$MAILDIR" -type f | grep -vE ',[^,]*S[^,]*$' | wc -l)
    if [ $count -gt 0 ]; then
        echo "Mf%{A3:$FETCHMAILCOMMAND:}%{A:$MAILCOMMAND:}$IC_MAIL $count%{A}${A}"
    else
        echo "M0%{A3:$FETCHMAILCOMMAND:}%{A:MAILCOMMAND:}$IC_MAIL%{A}%{A}"
    fi
}

#iAir pollution
pollution() {
    city_code="@7874"
    res=$(curl "http://api.waqi.info/feed/$city_code/?token=$API_WAQI")
    # 7874 is the Changshu code. When in a place where IP Localization is available, should use "here"
    # Or, to find station id, query as follows: "https://api.waqi.info/search/?token=$API_WAQI&keyword=changshu"
    # One should be able to use "http://api.waqi.info/feed/changshu/?token=$API_WAQI", but for some reason API queries by sity always return aqi for Ontario, Canada using my token. Problem does not arise using "demo" as a toke, but that is against terms of service.
    aqi=$(echo $res  | jq -r .data.aqi)
    url=$(echo $res  | jq -r .data.city.url)
    # url_comm="firefox \"${url#*://}\"" # the colon in the URL will interfere with lemonbar's syntax and this is easier than figuring out how to escape ti
    icon=$IC_POLLUTION
    color=""
    if (( $(echo $aqi '<=' 50 | bc -l) )); then
        color="g"
    elif (( $(echo 50 '<' $aqi '&&' $aqi '<=' 100 | bc -l) )); then
        color="y"
    elif (( $(echo 100 '<' $aqi '&&' $aqi '<=' 150 | bc -l) )); then
        color="o"
    elif (( $(echo 151 '<' $aqi '&&' $aqi '<=' 200 | bc -l) )); then
        color="r"
    elif (( $(echo 201 '<' $aqi '&&' $aqi '<=' 300 | bc -l) )); then
        color="b"
    elif (( $(echo $aqi '>' 300 | bc -l) )); then
        color="p"
    fi
    # echo A"$color%{A:$url_comm:}$icon $aqi%{A}"
    echo A"$color$icon $aqi"
}

weather() {
    export weather_response=$(curl "https://api.darksky.net/forecast/$API_DARKSKY/31.6035,120.7391?units=si")
    url_comm="firefox darksky.net/forecast/changshu/si12/en"
    apiicon=$(echo $weather_response | jq -r .currently.icon)
    temperature=$(echo $weather_response | jq -r .currently.temperature)

    # I use en_DK as my locale, which separates decimals with a comma
    # But the api uses a point
    # So when printf is given a decimal number using a point, it gives error and fucks up
    # Setting LC_NUMERIC to C ensures this never happens
    LC_NUMERIC="C" 
    temperature_int=$(printf "%.0f" "$temperature")
    temperature=$(printf "%.1f" "$temperature")
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
    if [ $temperature_int -lt 15 ]; then
        color="b"
    elif [ 15 -lt $temperature_int ] && [ $temperature_int -lt 30 ]; then
        color="y"
    elif [ $temperature_int -gt 30 ]; then
        color="r"
    fi
    # echo -e F"$color%{A:$url_comm:}$icon $temperature%{A}"
    echo -e F"$color$icon $temperature"
}

check_connection() {
    # returns:
    # 0 if connected (ssl to $1 works)
    # 64 if no connection to $1 but dns lookup worked
    # 65 if dns dnsookup failed but there is connection to dns server
    # 66 if no dns server but conenction to gateway works
    # 1 if not at all connected
    test="$1"
    gateway="$2"
    nameserver="$3"
    checkssl=$(
        nc -zw1 "$1" 443 && echo | openssl s_client -connect "${1}:443" 2>&1 | awk '
  handshake && $1 == "Verification" { if ($2=="OK") exit; exit 1 }
  $1 $2 == "SSLhandshake" { handshake = 1 }';
    )
    if $checkssl; then
        return 0
    elif host "$test"; then
        return 64
    elif nc -zw1 "$nameserver"; then
        return 65
    elif nc -zw1 "$gateway"; then
        return 66
    else
        return 1
    fi

}

# wifi
network() {
    interface="$(ip link | grep 'state UP' | awk '{ print $2 }')"
    network_type="${interface:0:2}"
    check_connection
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
            ic_type=$IC_WIFI
            ssid=$(echo $link | grep 'SSID' | sed 's/SSID: //' | sed 's/\t//')
            signal=$(echo $link | grep 'signal' | sed 's/signal: //' | sed 's/ dBm//' | sed 's/\t//')
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
    if [[ $(mpc) ]]; then
        SONG_NAME=$(mpc -f "%title%" | head -n1)
        if [ "${#SONG_NAME}" -eq 0 ]; then
            SONG_NAME=$(grep -B 1 -m 1 `mpc | head -n 1` .youtube-mpd | head -n 1)
        fi
        if [ "${#SONG_NAME}" -gt 25 ]; then
            SONG_NAME="${SONG_NAME:0:25}..."
        fi
        if [[ $(echo $(mpc status)| awk '/volume/ {print $2}') != "n/a" ]]; then
            if [[ -n $(mpc status | grep paused) ]]
            then
                echo "R%{T3}%{A:mpc prev:}$IC_MUSIC_PREV%{A} %{A:mpc play:}$IC_MUSIC_PLAY%{A}  %{A:mpc next:}$IC_MUSIC_NEXT%{A}%{T1} $SONG_NAME"
            else
                echo "R%{T3}%{A:mpc prev:}$IC_MUSIC_PREV%{A} %{A:mpc pause:}$IC_MUSIC_PAUSE%{A} %{A:mpc next:}$IC_MUSIC_NEXT%{A}%{T1} %{A:$dzencommand_music:}$SONG_NAME%{A} "
            fi
        fi
    fi
}

songScroll() {
    zscroll -l 25 -n -u -b "R%{T3}%{A:mpc prev:}\uf048%{A}%{A3:$dzencommand_music:} %{A:mpc pause:}\uf04c%{A}%{A} %{A:mpc next:}\uf051%{A}%{T1} " -d 0.3 "getSongName" > "$PANEL_FIFO" &
}

# music play only
musicp() {
        SONG_NAME=$(mpc | head -n1)
        if [[ $(echo $(mpc status)| awk '/volume/ {print $2}') != "n/a" ]]; then
            if [[ -n $(mpc status | grep paused) ]]
            then
                command="play"
                icon=$IC_MUSIC_PLAY
            else
                command="pause"
                icon=$IC_MUSIC_PAUSE
            fi
            echo "m%{A:mpc $command:}%{A3:$dzencommand_music:}$icon%{A}%{A}"
            # echo "m%{A:mpc $command:}$icon%{A}"
        fi
    sleep 1
}

#pomodoro
pomodoro() {
    echo "P$(pomodoro -r -h)"
}

#battery
battery() {
    BATTERY_CRITICAL=0
    power=$(acpi -a | sed -r 's/.+(on|off).+/\1/')
    bcharge=$(acpi | sed "s/[^,]\\+\?, //" | sed "s/%.\\+//" | sed "s/%//")
    if [[ -z $power ]]; then
        return 1
    elif [[ $power = "on" ]]; then
        bicon="\uf21e"
        bcolor="f"
    elif [[ $bcharge -ge 95 ]]; then
        bicon="\uf240"
        bcolor="f"
    elif [[ $bcharge -ge 65 ]]; then
        bicon="\uf241"
        bcolor="f"
    elif [[ $bcharge -ge 35 ]]; then
        bicon="\uf242"
        bcolor="m"
    elif [[ $bcharge -ge 10 ]]; then
        BATTERY_CRITICAL=1
        bicon="\uf243"
        bcolor="m"
    else
        bicon="\uf244"
        bcolor="e"
    fi
    echo "B$bcolor$bicon $bcharge%"
}

#keyboard
keyboard() {
    color="b"
    read -r var< "/home/pinusc/.keyboard"
    if [ "$var" = "disabled" ]; then
        color="r"
    fi
    echo "K$(setxkbmap -query | awk '/layout:/ {print $2; exit}')"
    echo "Kc$color%{A:$dkeyboard:}\uf11c%{A}"
}

#wallpaper
wallpaper() {
    echo "Q%{A:randomwallpaper.sh:}%{A3:fortunewallpaper.sh:}\uf03e%{A}%{A}"
}

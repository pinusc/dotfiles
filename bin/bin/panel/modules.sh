source icons.sh
cflag=0
clock() {
    cloutput=$(bash-fuzzy-clock)
    echo "C%{A:echo SWITCH > /tmp/panel-clock-fifo:}$icon_clock$cloutput%{A}";
}

calendar() {
    url_comm="firefox calendar.google.com"
    echo "D%{A:$dzencommand_calendar:}%{A3:$url_comm:}\uf073 $(date +'%a %b %d')%{A}%{A}"
}

alsa_volume() {
    ALSA_STATE=1
    VOLUME=$(ponymix get-volume)
    ICON='\uf028'
    if [ $ALSA_STATE ]; then
        if [[ $VOLUME -ge 70 ]]
        then
            ICON='\uf028'
        fi
        if [[ $VOLUME -gt 0 && $VOLUME -lt 70 ]]
        then
            ICON='\uf027'
        fi
        if [[ $VOLUME -eq 0 ]]
        then
            ICON='\uf026'
        fi
    fi
    echo "V%{A:pavucontrol:}$ICON $VOLUME%{A}"
}

ip() {
    echo -e I'\uf041' $(curl -s icanhazip.com)
    sleep 10
}

mail() {
    count=$(find "$MAILDIR" -type f | grep -vE ',[^,]*S[^,]*$' | wc -l)
    if [ $count -gt 0 ]; then
        echo "Mf%{A3:$FETCHMAILCOMMAND:}%{A:$MAILCOMMAND:}\uf0e0 $count%{A}${A}"
    else
        echo "M0%{A3:$FETCHMAILCOMMAND:}%{A:MAILCOMMAND:}\uf0e0%{A}%{A}"
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
    icon="\uf075"
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
    weather_response=$(curl "https://api.darksky.net/forecast/$API_DARKSKY/31.6035,120.7391?units=si")
    url_comm="firefox darksky.net/forecast/changshu/si12/en"
    apiicon=$(echo $weather_response | jq -r .currently.icon)
    temperature=$(echo $weather_response | jq -r .currently.temperature | bc -l)
    temperature=$(printf "%.1f" "$temperature")
    icon=""
    color=""  # depending on temperature, can be blue, yellow or red
    case $apiicon in
        clear-day)
            icon="\uf30d"
            ;;
        clear-night)
            icon="\uf32b"
            ;;
        rain)
            icon="\uf319"
            ;;
        cloudy)
            icon="\uf312"
            ;;
        partly-cloudy-day)
            icon="\uf302"
            ;;
        partly-cloudy-night)
            icon="\uf32e"
            ;;
        snow)
            icon="\uf31a"
            ;;
        wind)
            icon="\uf34b"
            ;;
        fog)
            icon="\uf31e"
            ;;
    esac
    if (( $(echo $temperature '<' 15 | bc -l) )); then
        color="b"
    elif (( $(echo 15 '<' $temperature '&&' $temperature '<' 30 | bc -l) )); then
        color="y"
    elif (( $(echo $temperature '>' 30 | bc -l) )); then
        color="r"
    fi
    # echo -e F"$color%{A:$url_comm:}$icon $temperature%{A}"
    echo -e F"$color$icon $temperature"
    #curl "https://api.darksky.net/forecast/cdd9e613e163fa9768e2a4d3b3219ca6/31.6035,120.7391?exclude=minutely,hourly,daily,alerts,flags" > /tmp/weather
}

# wifi
wifi() {
    link=$(iw wlp3s0 link)
    if [[ $? -ne 0 ]]; then # happens if no wifi card is installed
        exit 1
    fi
    if [[ $link != "Not Connected" ]]; then
        WIFI_SSID=$(iw wlp3s0 link | grep 'SSID' | sed 's/SSID: //' | sed 's/\t//')
        WIFI_SIGNAL=$(iw wlp3s0 link | grep 'signal' | sed 's/signal: //' | sed 's/ dBm//' | sed 's/\t//')
        if [[ $(pingtest.sh 8.8.8.8) = "Up" ]]; then
            connIcon="\uf1eb"
        else
            connIcon="\uf05e"
        fi
        echo L$connIcon $WIFI_SSID '|' $WIFI_SIGNAL 'dBm'
    else 
        echo L'\uf05e'
    fi
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
                echo "R%{T3}%{A:mpc prev:}\uf048%{A} %{A:mpc play:}\uf04b%{A}  %{A:mpc next:}\uf051%{A}%{T1} $SONG_NAME"
            else
                echo "R%{T3}%{A:mpc prev:}\uf048%{A} %{A:mpc pause:}\uf04c%{A} %{A:mpc next:}\uf051%{A}%{T1} %{A:$dzencommand_music:}$SONG_NAME%{A} "
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
                icon="\uf04b"
            else
                command="pause"
                icon="\uf04c"
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
    if [ $var = "disabled" ]; then
        color="r"
    fi
    echo "K$(setxkbmap -query | awk '/layout:/ {print $2; exit}')"
    echo "Kc$color%{A:$dkeyboard:}\uf11c%{A}"
}

#wallpaper
wallpaper() {
    echo "Q%{A:randomwallpaper.sh:}%{A3:fortunewallpaper.sh:}\uf03e%{A}%{A}"
}

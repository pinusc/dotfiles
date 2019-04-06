#! /bin/bash
. panel_colors.sh light
source icons.sh
num_mon=$(bspc query -M | wc -l)
PADDING="  "
PADDING_SHORT=" "
current_monitor=$1

while read -r line ; do
    case $line in
        A*)
            color=""
            case $line in
                Ag*)
                    color=$COLOR_GREEN
                    ;;
                Ao*)
                    color=$COLOR_ORANGE
                    ;;
                Ap*)
                    color=$COLOR_PURPLE
                    ;;
                Ab*)
                    color=$COLOR_BLUE
                    ;;
                Ar*)
                    color=$COLOR_RED
                    ;;
                Ay*)
                    color=$COLOR_YELLOW
                    ;;
            esac
            line=${line:2}
            aqi="$PADDING%{F$color}$line%{F-}"
            ;;
        F*)
            color=""
            case $line in
                Fb*)
                    color=$COLOR_BLUE
                    ;;
                Fr*)
                    color=$COLOR_RED
                    ;;
                Fy*)
                    color=$COLOR_YELLOW
                    ;;
            esac
            line=${line:2}
            forecast="$PADDING%{F$color}$line%{F-}"
            ;;
        M*)
            case $line in
                M0*)
                    color=$COLOR_GREEN
                    ;;
                Mf*)
                    color=$COLOR_RED
                    ;;
            esac
            mail="$PADDING%{F$color}${line:2}%{F-}"
            ;;
        Kc*)
            case $line in
                Kcb*)
                    kcolor="$COLOR_KEYBOARD"
                    ;;
                Kcr*)
                    kcolor="$COLOR_KEYBOARD_DISABLED"
                    ;;
            esac
            line=${line:3}
            keyboard_icon="$PADDING%{F$kcolor}$line%{F-}"
            ;;
        K*)
            keyboard="$PADDING_SHORT%{F$COLOR_KEYBOARD}${line#?}%{F-}"
            ;;
        B*)
            bcolor=$COLOR_CLOCK
            case $line in
                Bf*)
                    bcolor=$COLOR_BATTERY_FULL
                    ;;
                Bm*)
                    bcolor=$COLOR_BATTERY_MEDIUM
                    ;;
                Be*)
                    bcolor=$COLOR_BATTERY_EMPTY
                    ;;
            esac
            #battery
            line=${line#?}
            battery="$PADDING%{F$bcolor}${line#?}%{F-}"
            ;;
        L*)
            l=${line#?}
            l=${l#?}
            net_type=${l%%|*}

            o1=${l#*|}
            status=${o1%|*}
            other=${o1##*|}

            case $line in
                Lu*)
                    statuscolor=$COLOR_OK
                    ;;
                Lp*)
                    statuscolor=$COLOR_WARNING
                    ;;
                Ld*)
                    statuscolor=$COLOR_ERROR
                    ;;
            esac
            network="$PADDING%{F$COLOR_NETWORK}${net_type} %{F-}%{F$statuscolor}${status}${other}%{F-}"
            ;;
        Q*)
            wallpaper="$PADDING%{F$COLOR_KEYBOARD}${line#?}%{F-}"
            ;;
        D*)
            # date output
            date="$PADDING_SHORT$PADDING%{F$COLOR_DATE}${line#?}%{F-}"
            ;;
        C*)
            # clock output
            clock="$PADDING%{F$COLOR_CLOCK}${line#?}%{F-}"
            ;;
        V*)
            # alsa volume
            volume="$PADDING${line#?}"
            ;;
        W*)
            # bspwm internal state
            wm_infos=""
            IFS=':'
            auto_mon=1
            if [[ -n "$auto_mon" ]]; then
                line=$(echo "$line" | sed 's/^W//; s/^m.*:M/M/; s/M\(.*\):m.*/M\1/')
                echo "line: $line" >&2
                set -- $line
            else
                case $current_monitor in  # cut line to consider only interested monitor
                    1)
                        line=${line:0:43}  #only consider 1st monitor 
                        echo "line: $line" >&2
                        set -- ${line#?}
                        ;;
                    2)
                        line=${line:38}  #only consider 1st monitor 
                        echo "line: $line" >&2
                        set -- ${line}
                        ;;
                esac
            fi

            while [ $# -gt 0 ] ; do
                item=$1
                name=${item#?}
                echo "item: $1" >&2
                case $item in
                    M*)
                        if [ $num_mon -gt 1 ] ; then
                            # active monitor
                            name_cool=$([[ "$name" != "HDMI-0" ]] && echo "\uf25b" || echo "\uf259")
                            wm_infos="$wm_infos %{F$COLOR_ACTIVE_MONITOR_FG}%{B$COLOR_ACTIVE_MONITOR_BG}${name_cool}%{B-}%{F-}${PADDING}"
                        fi
                        ;;
                    m*)
                        # inactive monitor
                        if [ $num_mon -gt 1 ] ; then
                            name_cool=$([ "$name" == 1 ] && echo "\uf25b" || echo "\uf259")
                            # wm_infos="$wm_infos %{F$COLOR_INACTIVE_MONITOR_FG}%{B$COLOR_INACTIVE_MONITOR_BG}$PADDING${name_cool}%{B-}%{F-}  "
                        fi
                        ;;
                    O*)
                        # focused occupied desktop
                        name1=$(echo -n -e $name | tail -c 3)
                        wm_infos="${wm_infos}%{F$COLOR_FOCUSED_OCCUPIED_FG}%{B$COLOR_FOCUSED_OCCUPIED_BG}%{U$COLOR_FOREGROUND}%{+o}$PADDING_SHORT${name1}$PADDING_SHORT%{-o}%{B-}%{F-}"
                        ;;
                    F*)
                        # focused free desktop
                        name1=$(echo -n -e $name | tail -c 3)
                        wm_infos="${wm_infos}%{F$COLOR_FOCUSED_FREE_FG}%{B$COLOR_FOCUSED_FREE_BG}%{U$COLOR_FOREGROUND}%{+o}$PADDING_SHORT${name1}$PADDING_SHORT%{-o}%{B-}%{F-}"
                        ;;
                    U*)
                        # focused urgent desktop
                        name1=$(echo -n -e $name | tail -c 3)
                        wm_infos="${wm_infos}%{F$COLOR_FOCUSED_URGENT_FG}%{B$COLOR_FOCUSED_URGENT_BG}%{U$COLOR_FOREGROUND}%{+o}$PADDING_SHORT${name1}$PADDING_SHORT%{-o}%{B-}%{F-}"
                        ;;
                    o*)
                        # occupied desktop
                        name1=$(echo -n -e $name | tail -c 3)
                        wm_infos="${wm_infos}%{F$COLOR_OCCUPIED_FG}%{B$COLOR_OCCUPIED_BG}%{A:bspc desktop -f ${name}:}$PADDING_SHORT${name1}$PADDING_SHORT%{A}%{B-}%{F-}"
                        ;;
                    f*)
                        # free desktop
                        name1=$(echo -n -e $name | tail -c 3)
                        # ALERT: chdesktop function is declared in ~/.zsh_aliases
                        # I did not use an hardwritten command because lemonbar %{A} tag doesn't like colons
                        wm_infos="${wm_infos}%{F$COLOR_FREE_FG}%{B$COLOR_FREE_BG}%{A:bspc desktop -f ${name}:}$PADDING_SHORT${name1}$PADDING_SHORT%{A}%{B-}%{F-}"
                        ;;
                    u*)
                        # urgent desktop
                        name1=$(echo -n -e $name | tail -c 3)
                        wm_infos="${wm_infos}%{F$COLOR_URGENT_FG}%{B$COLOR_URGENT_BG}$PADDING_SHORT${name1}$PADDING_SHORT%{B-}%{F-}"
                        ;;
                esac
                shift
            done
            ;;
        P*)
            pom_rem=${line#?}
            if [ -n "$pom_rem" ]; then
                case $pom_rem in
                    P*)
                        color_pom=$COLOR_POMODORO_ACTIVE
                        pom_rem=$PADDING${pom_rem#?}
                        pom_icon=$IC_POMODORO_TICKING
                        ;;
                    p*)
                        color_pom=$COLOR_POMODORO_PAUSE
                        pom_rem=$PADDING${pom_rem#?}
                        pom_icon=$IC_POMODORO_EMPTY
                        ;;
                    n*)
                        color_pom=$COLOR_POMODORO_INACTIVE
                        pom_rem=${pom_rem#?}
                        pom_icon="$IC_POMODORO_FULL"
                        ;;
                esac
            else
                color_pom=$COLOR_POMODORO_INACTIVE
            fi

            pom="%{F$color_pom}$PADDING%{A:pomodoro start:}%{A3:pomodoro stop:}${pom_icon}${pom_rem}%{A}%{A}%{F-}"
            ;;
        R*)
            # music info
            music="%{B$COLOR_FOCUSED_OCCUPIED_BG}%{F$COLOR_FOCUSED_OCCUPIED_FG}$PADDING${line#?}%{F-}%{B-}"
            ;;
        m*)
            #music controls only
            music="$PADDING${line#?}"
            ;;
        I*)
            #IP
            ip="$PADDING${line#?}"
            ;;
        g*)
            gpginfo="$PADDING%{F$COLOR_LOCK}${line#?}%{F-}"
            ;;
    esac
    #printf "%s\n" "%{l}${wm_infos}%{Sf}%{c}${music}%{r}${volume}${date}${clock}"
    case $current_monitor in
        1)
            # echo -e "%{l}${date}${forecast}${aqi}${music}${volume}%{c}${wm_infos}%{r}${gpginfo}${battery}${network}${mail}${keyboard_icon}${keyboard}${wallpaper}${clock}$PADDING"
            # ;;
            echo -e "%{l}${date}${forecast}${aqi}${music}${volume}%{c}${wm_infos}%{r}${gpginfo}${network}${mail}${keyboard_icon}${keyboard}${wallpaper}${battery}${pom}${clock}$PADDING"
        ;;
        2)
            echo -e "%{l}${wm_infos}%{c}${music}%{r}${ip}"
            ;;
    esac
done

#!/bin/bash

#================================= VARIABLES ===================================

LOG_FILE="$HOME/docs/various/weight/log.txt"
PLOT_FILE="$HOME/docs/various/weight/weight.png"
PLOT_SRC="$HOME/docs/various/weight/weight.plt"

DATE_COMMAND="date -I"
TIME_COMMAND="date -Ihours"

#==================================== HELP =====================================

if [[ "$1" = "-h" || "$1" = "--help" ]]; then
    cat <<EOF
weight_logger.sh - log your weight in a text file and produce a gnuplot diagram

Usage: weight_logger.sh [OPTIONS] WEIGHT


Options:
    --ita Show titles in italian, not in english
    -n,--no-plot Do not update the plot
    -s,--show-plot Show the plot
    -d|--date The ISO 8601 formatted date at which to log the file. Defaults to today
EOF
    exit 0
fi

#============================== PARSE ARGUMENTS ================================

while (( "$#" )); do
    case "$1" in
	--ita|--italian)
	    lang="italian"
	    shift
	    ;;
	-n|--no-plot)
	    NO_PLOT="true"
	    shift
	    ;;
	-s|--show-plot)
	    SHOW_PLOT="true"
	    shift
	    ;;
	-d|--date)
	    date="$2"
	    shift 2
	    ;;
	-t|--time)
	    SAVE_TIME="true"
	    shift
	    ;;
	*,*|*.*)
	    if [[ -z "$weight" ]]; then
		weight="$1"
		shift
	    else
		echo "You can't specify more than one weight!" >&2
		exit 1
	    fi
	    ;;
	*)
	    echo "'$1': option not recognized" >&2
	    exit 1
	    ;;
    esac
done

if [[ -z "$date" ]]; then 
    [[ -n "$SAVE_TIME" ]] && date=$($TIME_COMMAND) || date=$($DATE_COMMAND)
fi

weight=$(echo "$weight" | tr , .)

#================================= LOG WEIGHT ==================================

echo -e "$date\t$weight" >> "$LOG_FILE"

#================================== GNUPLOT ====================================

[[ -n "$lang" ]] && lang_arguments=(-e "ita='true'")

gnuplot_args=(-e "data_file='$LOG_FILE'")

[[ -z "$NO_PLOT" ]] && gnuplot_args+=(-e "output_file='$PLOT_FILE'")

[[ -n "$SHOW_PLOT" ]] && gnuplot_args+=(-e "show='yes'")

gnuplot "${gnuplot_args[@]}" "${lang_arguments[@]}" "$PLOT_SRC" 

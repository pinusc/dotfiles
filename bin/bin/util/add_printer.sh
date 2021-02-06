#!/bin/bash

IFS='' read -r -d '' helpstring <<EOF
Usage: add_printer.sh NAME [OPTIONS]

Options:
    --driver DRIVER       Specify which driver file to use (see "lpinfo -m")
    -n, --no-interactive  Don't ask questions, go with default behaviour
EOF

if [[ -z "$1" ]]; then
    echo -n "$helpstring"
    exit 0
fi

while [[ -n "$*" ]]; do
    case "$1" in
        -h|--help)
            echo -n "$helpstring"
            exit 0
            ;;
        --driver)
            driver="$2"
            shift 2
            ;;
        -n|--no-interactive)
            no_interactive=1
            shift
            ;;
        *)
            if [[ -z "$name" ]]; then
                name="$1"
                shift
            else
                echo -n "$helpstring"
                exit 1
            fi
            ;;
    esac
done

name="$(echo "$name" | tr '[:upper:]' '[:lower:]')"  # $name should be lowercase
[[ -z "$driver" ]] && driver="CUPS-PDF_noopt.ppd"

fqdm="${name}.printers.colby.edu"
ip=$(host "$fqdm" 2>&1 | cut -d' ' -f4)
if [[ -z "$no_interactive" ]]; then
    read -e -p "Search for description? " -r query
    if [[ "$query" = "Y" || "$query" = "y" ]]; then
        read -e -p "Input your username: " -r user
        read -e -p "Input your password: " -r password
        echo "Searching for description..."
        description=$(smbclient -L '\\Printserver1' -U "${user}%${password}" 2>/dev/null | \
            grep -i "$name" | \
            cut -d' ' -f3-)
        echo "Found the following description: "
        echo "$description"
        read -e -p "Is this accurate? " -r desc_accurate 
        if [[ "$desc_accurate" != "Y" && "$desc_accurate" != "y" ]]; then
            description=""
        fi
    fi
    if [[ -z "$description" ]]; then
        read -e -p "Input a description? " -r input_desc_yn
        if [[ "$input_desc_yn" != "Y" && "$input_desc_yn" != "y" ]]; then
            read -e -p "Description: " -r description
        fi
    fi
fi

lpadmin -p "$name" -m "$driver" -D "$description" -v "ipp://${ip}/ipp"

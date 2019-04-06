#!/bin/bash
file=1
source ~/.dmenurc
while [ "$file" ]; do
        file=$(ls -1 --group-directories-first | $dmenu_command -l 0 -p "lol")
        if [ -e "$file" ]; then
                owd=$(pwd)
                if [ -d "$file" ]; then
                        cd "$file"
                else [ -f "$file" ]
                        if which xdg-open &> /dev/null; then
                                exec xdg-open "$owd/$file" &
                                unset file
                        fi
                fi
        fi
done

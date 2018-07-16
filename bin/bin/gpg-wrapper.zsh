encrypt() {
    if [ -f "$1" ]; then
        gpg --default-recipient-self -e $1
        /bin/rm $1
    elif [ -d "$1" ]; then
        tmptar=$(mktemp -p /dev/shm/ "$1.tar.gz.XXXX")
        tar czf "$tmptar" "$1"
        encrypt "$tmptar"
        mv "${tmptar}.gpg" "$1.tar.gz.gpg"
        /bin/rm -r "$1"
    fi
}

decrypt() {
    case "$1" in
        *tar.gz.gpg|*tgz.gpg)
            filename=$(mktemp -p /dev/shm/ "${1%.*}".XXXX)
            gpg -d $1 >> $filename
            dirname=$(mktemp -d -p /dev/shm/ "${1%%.*}".XXXX)
            tar xzf "$filename" -C "$dirname"
            /bin/rm "$filename"
            ln -s "$dirname/${1%%.*}" ./"${1%%.*}"
            ;;
        *.gpg)
            filename=$(mktemp -p /dev/shm/ "${1%%.*}".XXXX)
            gpg -d $1 >> $filename
            ln -s "$filename" ./"${1%.*}"
            ;;
        *)
            echo "Please use a .gpg file as input"
            ;;
    esac 
}

clean_decrypted() {
    case "$1" in
        *tar.gz.gpg|*tgz.gpg)
            linkedname=./"${1%%.*}"
            /bin/rm -r $(readlink -f "$linkedname")
            /bin/rm "$linkedname"
            ;;
        *.gpg)
            linkedname=./"${1%.*}"
            /bin/rm $(readlink -f "$linkedname")
            /bin/rm "$linkedname"
            ;;
        *)
            if [ -L $1 ]; then
                linked=$(readlink -f "$1")
                if [ -f "$linked" ]; then
                    rm "$linked"
                elif [ -d "$linked" ]; then
                    rm -r "$linked"
                fi
                rm "$1"
            else 
                echo "Invalid input"
            fi
            ;;
    esac
}

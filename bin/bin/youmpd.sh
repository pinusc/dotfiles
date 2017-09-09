url_list=`youtube-dl -f140 -g $1`
name_list=`youtube-dl -f140 -e $1`
# url_list=$1
# name_list=$2
song_num=$(echo $url_list | wc -l)
echo $song_num
for i in `seq 1 $song_num`; do
    echo $i
    echo "" >> .youtube-mpd
    echo "$(echo $name_list | sed -n $i\p)" >> .youtube-mpd
    echo "$(echo $url_list | sed -n $i\p)" >> .youtube-mpd
    mpc add $(echo $url_list | sed -n $i\p)
done

# echo "" >> .youtube-mpd
# echo "`youtube-dl -f140 -e $1`" >> .youtube-mpd
# URL=`youtube-dl -f140 -g $1`
# echo "$URL" >> .youtube-mpd
# mpc add $URL

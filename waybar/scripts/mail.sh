IC_MAIL="\\uf0e0"
MAILDIR="$HOME/mail"
MAILDIR_IMPORTANT="$HOME/mail/gstelluto/inbox"

# count=$(find "$MAILDIR" -type f | grep -cvE ',[^,]*S[^,]*$')
count=$(find "$MAILDIR" -type d -path '*inbox/new' | xargs -I{} find {} -type f | wc -l)
count_important=$(find "$MAILDIR_IMPORTANT" -type d -name 'new' | xargs -I{} find {} -type f | wc -l)
if [ "$count_important" -gt 0 ]; then
    count_important="$count_important "
else
    count_important="0 "
fi

if [ "$count" -gt 0 ]; then
    text="$IC_MAIL  $count_important$count"
    echo "{\"text\": \"$text\", \"class\": \"hasmail\"}"
else
    text="$IC_MAIL  "
    echo "{\"text\": \"$text\"}"
fi

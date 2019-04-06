#!/bin/bash

# Get an access token to automate matrix
# Good for scripting

[[ -z "$MATRIX_HOST" ]] && MATRIX_HOST="gstelluto.com"

username="$1"
password="$2"

response=$(curl -s -XPOST -d '{"type":"m.login.password", "user":"'"$username"'", "password":"'"$password"'"}' "https://$HOST/_matrix/client/r0/login")

access_token=$(echo "$response" | jq -r '.access_token')
echo "$access_token"


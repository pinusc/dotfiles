#!/usr/bin/env bash

. "$XDG_CONFIG_HOME/aichat/.env"

echo "DEEPSEEK BALANCE:"
deepseek_info="$(curl --silent https://api.deepseek.com/user/balance -H "Content-Type: application/json" -H "Authorization: Bearer $DEEPSEEK_API_KEY")" 
deepseek_balance="$(echo "$deepseek_info" | jq -r '.balance_infos.[] | .total_balance')"
deepseek_currency="$(echo "$deepseek_info" | jq -r '.balance_infos.[] | .currency')"
echo "$deepseek_balance $deepseek_currency"




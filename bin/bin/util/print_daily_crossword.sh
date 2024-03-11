#!/usr/bin/env bash

lpr -P home <(curl "https://crosswords-static.guim.co.uk/gdn.cryptic.$(date +'%Y%m%d').pdf" )

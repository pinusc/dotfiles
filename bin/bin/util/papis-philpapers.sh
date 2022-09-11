#! /bin/bash

url="$1"
# string expansion here will remove everything but the last slash
id="${url##*/}"
bibtex="$(curl -s "https://philpapers.org/export.html?__format=bib&eIds=${id}&formatName=BibT" | htmlq 'pre.export' -t)"
papis add --from bibtex "$bibtex" -s 'tags' 'philosophy'

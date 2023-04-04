#!/usr/bin/env bash

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] FILENAME

Extract pages from a scanned PDF to clean it in scantailor.

EOF
  exit
}

filename=""


args=("$@")
if [[ ${#args[@]} -eq 0 ]]; then
    echo "Missing script arguments" >&2
    exit 1
fi

case "$1" in
    -h|--help)
        usage
        exit 0
        ;;
    *)
        filename="$1"
        ;;
esac


tempdir="$(mktemp --tmpdir -d cleanpdf-XXXX)"
encoding="$(pdfimages -list "$filename" | awk '(NR==3){ print $9; }')"
if [[ "$encoding" = "ccitt" ]]; then
    pdfimages -tiff "$filename" "$tempdir/"
else
    pdfimages -all "$filename" "$tempdir/"
fi

echo "$tempdir" | xclip -i -selection clipboard
echo "$tempdir"

scantailor 

img2pdf --pillow-limit-break --output "tailored-$filename" -- "$tempdir"/out/*.tif

echo "Generated PDF: tailored-$filename"
echo "Opening... (close zathura to continue)"
zathura "tailored-$filename"

if read -q "OCR? "; then
    ocrmypdf --optimize 3 "tailored-$filename" "ocr-$filename"
    echo "Generated PDF: ocr-$filename"
    echo "Opening..."
    zathura "ocr-$filename"
fi

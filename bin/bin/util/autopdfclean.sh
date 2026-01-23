#!/bin/bash

set -e

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    cat <<EOF
Usage: $0 input.pdf [output.pdf]

Clean and OCR scanned PDFs using ScanTailor and ocrmypdf.

Process:
  1. Extract images from PDF (preserves original quality)
  2. Open in Zathura to verify rotation
  3. Correct rotation if needed (90°, 180°, 270°)
  4. Auto-orient images based on EXIF
  5. Optional: Split double-page spreads down the middle
  6. Process through ScanTailor:
     - Auto-deskew (±5° tolerance)
     - Aggressive content detection
     - Page detection
     - White margins
     - Illumination normalization
     - Despeckling
     - 600 DPI output
  7. Preview output (with option to abort or open GUI for manual adjustment)
  8. Convert to PDF
  9. OCR with ocrmypdf

Output: output.pdf (if specified) or input_final.pdf
Work directory: input_work/ (preserved on abort, deleted on success)

Dependencies: zathura, pdfimages, pdfinfo, mogrify, scantailor-universal-cli, nsxiv, convert, ocrmypdf
EOF
    exit 0
fi

INPUT_PDF="$1"

if [[ ! -f "$INPUT_PDF" ]]; then
    echo "Usage: $0 input.pdf [output.pdf]"
    echo "Run with -h or --help for more information"
    exit 1
fi

BASENAME="${INPUT_PDF%.pdf}"
OUTPUT_PDF="${2:-${BASENAME}_final.pdf}"
WORKDIR="${BASENAME}_work"

echo "==> Creating work directory"
mkdir -p "$WORKDIR/output"
echo "    $WORKDIR"

echo "==> Opening PDF in Zathura - verify rotation is correct"
zathura "$INPUT_PDF" &
ZATHURA_PID=$!

read -p "Additional clockwise rotation needed? (0/90/180/270/a(bort), default 0): " USER_ROT
USER_ROT="${USER_ROT:-0}"
if [ "$USER_ROT" = "a" ]; then
    exit 0
fi
kill $ZATHURA_PID 2>/dev/null || true

echo "==> Extracting images from PDF"
PAGE_COUNT=$(pdfinfo "$INPUT_PDF" | grep "Pages:" | awk '{print $2}')
IMAGE_COUNT=$(pdfimages -list "$INPUT_PDF" | tail -n +3 | wc -l)
HAS_CCITT=$(pdfimages -list "$INPUT_PDF" | grep -c "ccitt" || true)

PAGE_COUNT="${PAGE_COUNT:-0}"
IMAGE_COUNT="${IMAGE_COUNT:-0}"

# Detect input DPI
INPUT_DPI=$(pdfimages -list "$INPUT_PDF" | tail -n +3 | awk '{print $13}' | sort | tail -n 1)
INPUT_DPI="${INPUT_DPI:-300}"
echo "    Detected DPI: $INPUT_DPI"

if [ "$IMAGE_COUNT" -eq "$PAGE_COUNT" ] && [ "$IMAGE_COUNT" -gt 0 ] && [ "$HAS_CCITT" -eq 0 ]; then
    echo "    Using pdfimages (simple PDF)"
    pdfimages -all "$INPUT_PDF" "$WORKDIR/page"
    EXTRACTED=$(ls "$WORKDIR"/page-* 2>/dev/null | wc -l)
else
    echo "    Using pdftoppm (complex/layered PDF or CCITT encoding)"
    pdftoppm -r "$INPUT_DPI" "$INPUT_PDF" "$WORKDIR/page"
    EXTRACTED=$(ls "$WORKDIR"/page-* 2>/dev/null | wc -l)
fi

echo "==> Extracted $EXTRACTED images"

echo "==> Checking PDF rotation"
ROT=$(pdfinfo "$INPUT_PDF" | grep "Page.*rot:" | head -1 | awk '{print $3}')

if [ "$USER_ROT" != "0" ]; then
    echo "    Applying user ${USER_ROT}° clockwise rotation"
    mogrify -rotate "$USER_ROT" "$WORKDIR"/page-*
fi

if [ ! -z "$ROT" ] && [ "$ROT" != "0" ]; then
    echo "    Applying ${ROT}° rotation correction"
    case "$ROT" in
        90)  mogrify -rotate 90 "$WORKDIR"/page-* ;;
        180) mogrify -rotate 180 "$WORKDIR"/page-* ;;
        270) mogrify -rotate 270 "$WORKDIR"/page-* ;;
    esac
else
    echo "    No rotation needed"
fi


# echo "==> Auto-orienting images"
# mogrify -auto-orient "$WORKDIR"/page-*

SCANTAILOR_ARGS=(
    --output-project="$WORKDIR/project.ScanTailor"
    --color-mode=color_grayscale
    --output-dpi="$INPUT_DPI"
    --deskew=auto
    --skew-deviation=5.0
    --content-detection=aggressive
    --enable-page-detection
    --margins=10
    --white-margins
    --alignment=center
    --match-layout=true
    --normalize-illumination
    --enable-auto-margins
    --despeckle=cautious
    --start-filter=1
    --end-filter=6
)

# if [ "$split_response" = "y" ]; then
#     SCANTAILOR_ARGS+=(--layout=single-uncut)
# fi

echo "==> Running ScanTailor (this may take several minutes)"
scantailor-universal-cli "${SCANTAILOR_ARGS[@]}" "$WORKDIR"/* "$WORKDIR/output"

OUTPUT_COUNT=$(ls "$WORKDIR/output"/*.tif 2>/dev/null | wc -l)
echo "    Generated $OUTPUT_COUNT output images"

echo "==> Opening preview"
nsxiv "$WORKDIR/output"/*.tif

echo ""
read -p "Continue to OCR? (y/n/g for GUI): " response

if [ "$response" = "g" ]; then
    echo "==> Opening ScanTailor GUI"
    scantailor-universal "$WORKDIR/project.ScanTailor"
    echo "==> Opening preview after manual adjustments"
    nsxiv "$WORKDIR/output"/*.tif
    echo ""
    read -p "Continue to OCR? (y/n): " response
fi

if [ "$response" != "y" ]; then
    echo "==> Aborted"
    echo "    Work files preserved in: $WORKDIR"
    exit 0
fi

echo "==> Converting TIFFs to PDF"
magick -density "$INPUT_DPI" "$WORKDIR/output"/*.tif "$WORKDIR/processed.pdf"

echo "==> Running OCR"
ocrmypdf --deskew "$WORKDIR/processed.pdf" "$OUTPUT_PDF" # add deskew since broken in scantailor-cli

echo "==> Cleaning up work directory"
rm -rf "$WORKDIR"

echo "==> Done: $OUTPUT_PDF"

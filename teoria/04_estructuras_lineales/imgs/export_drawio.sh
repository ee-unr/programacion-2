#!/usr/bin/env bash
set -e

# Usage: ./export_drawio.sh path/to/file.drawio
if [ $# -lt 1 ]; then
  echo "Usage: $0 path/to/file.drawio"
  exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
  echo "Error: File not found: $FILE"
  exit 1
fi

# Get directory and base name (without extension)
DIR="$(dirname "$FILE")"
BASE="$(basename "$FILE" .drawio)"

# Count pages
PAGES=$(grep -o "<diagram" "$FILE" | wc -l)
echo "Found $PAGES pages"

# Export each page as PNG to same directory
for ((i=0; i<PAGES; i++)); do
  OUTFILE="${DIR}/${BASE}-${i}.png"
  drawio --export --format png \
         --page-index "$((i+1))" \
         --transparent \
         --scale 1.2 \
         --output "$OUTFILE" \
         "$FILE" 2>/dev/null
  echo "Exported page ${i} → $OUTFILE"
done

echo "Done exporting all pages to $DIR."

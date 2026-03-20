#!/bin/bash
# @file    Lab_paste_example.sh
# @brief   Demonstrate the paste command for merging files
# @author  Cheolwon Park
# @date    2025-06-05

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Create temporary input files for demonstration
FILE_IDS=$(mktemp)
FILE_NAMES=$(mktemp)

# Populate test data
cat > "$FILE_IDS" << 'EOF'
001
002
003
004
005
006
007
EOF

cat > "$FILE_NAMES" << 'EOF'
Hong Gil-Dong
Park Ji-Soo
Lee Na-Young
Kim Chan-Sook
Han Ju-Hyun
Jyun Doo-Ri
Lee Mi-Ra
EOF

echo "=== paste Command Examples ==="
echo ""

# Display source files
echo "--- File 1 (IDs) ---"
cat "$FILE_IDS"
echo ""

echo "--- File 2 (Names) ---"
cat "$FILE_NAMES"
echo ""

# Basic paste: merge two files side by side (vertical)
echo "--- Vertical Paste (default) ---"
echo "Command: paste file_ids file_names"
paste "$FILE_IDS" "$FILE_NAMES"
echo ""

# Paste with custom delimiter
echo "--- Paste with custom delimiter '|' ---"
echo "Command: paste -d'|' file_ids file_names"
paste -d'|' "$FILE_IDS" "$FILE_NAMES"
echo ""

# Serial paste: merge all lines of each file into one line
echo "--- Serial Paste (-s) for IDs ---"
echo "Command: paste -s file_ids"
paste -s "$FILE_IDS"
echo ""

echo "--- Serial Paste (-s) with delimiter ',' ---"
echo "Command: paste -s -d',' file_ids"
paste -s -d',' "$FILE_IDS"

# Clean up temporary files
rm -f "$FILE_IDS" "$FILE_NAMES"

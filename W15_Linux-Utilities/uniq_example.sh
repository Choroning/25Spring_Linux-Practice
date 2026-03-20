#!/bin/bash
# @file    uniq_example.sh
# @brief   Demonstrate the uniq command for filtering duplicate lines
# @author  Cheolwon Park
# @date    2025-06-05

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_FILE="$SCRIPT_DIR/u.dat"

echo "=== uniq Command Examples ==="
echo ""

# Display the source data
echo "--- Source Data (u.dat) ---"
cat "$DATA_FILE"
echo ""

# Default uniq: remove adjacent duplicate lines
echo "--- Default uniq (remove adjacent duplicates) ---"
echo "Command: uniq u.dat"
uniq "$DATA_FILE"
echo ""

# Show only duplicate lines (-d)
echo "--- Show Only Duplicated Lines (-d) ---"
echo "Command: uniq -d u.dat"
uniq -d "$DATA_FILE"
echo ""

# Show only unique (non-duplicated) lines (-u)
echo "--- Show Only Unique Lines (-u) ---"
echo "Command: uniq -u u.dat"
uniq -u "$DATA_FILE"
echo ""

# Count occurrences (-c)
echo "--- Count Occurrences (-c) ---"
echo "Command: uniq -c u.dat"
uniq -c "$DATA_FILE"
echo ""

# Important: uniq only detects ADJACENT duplicates
# Sort first for full deduplication
echo "--- Full Deduplication (sort | uniq) ---"
echo "Command: sort u.dat | uniq -c | sort -rn"
sort "$DATA_FILE" | uniq -c | sort -rn

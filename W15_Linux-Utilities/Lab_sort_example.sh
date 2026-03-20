#!/bin/bash
# @file    Lab_sort_example.sh
# @brief   Demonstrate the sort command with various options
# @author  Cheolwon Park
# @date    2025-06-05

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_FILE="$SCRIPT_DIR/s.dat"
PASSWD_FILE="$SCRIPT_DIR/passwd"

echo "=== sort Command Examples ==="
echo ""

# Display the source data
echo "--- Source Data (s.dat) ---"
cat "$DATA_FILE"
echo ""

# Default alphabetical sort (by entire line)
echo "--- Default Sort ---"
echo "Command: sort s.dat"
sort "$DATA_FILE"
echo ""

# Sort by a specific field (field 4 = score, numeric)
echo "--- Sort by Score (field 4, numeric) ---"
echo "Command: sort -k4 -n s.dat"
sort -k4 -n "$DATA_FILE"
echo ""

# Reverse sort by score
echo "--- Reverse Sort by Score ---"
echo "Command: sort -k4 -n -r s.dat"
sort -k4 -n -r "$DATA_FILE"
echo ""

# Sort passwd file by UID (field 3) with ':' delimiter
echo "--- Sort passwd by UID (numeric, delimiter ':') ---"
echo "Command: sort -t: -k3 -n passwd | head -5"
sort -t: -k3 -n "$PASSWD_FILE" | head -5
echo ""

# Sort with unique flag (remove duplicates)
echo "--- Sort with Unique (-u) ---"
echo "Command: echo data | sort -u"
printf "banana\napple\ncherry\napple\nbanana\n" | sort -u

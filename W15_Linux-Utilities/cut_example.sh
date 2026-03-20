#!/bin/bash
# @file    cut_example.sh
# @brief   Demonstrate the cut command for extracting fields and columns
# @author  Cheolwon Park
# @date    2025-06-05

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_FILE="$SCRIPT_DIR/s.dat"

echo "=== cut Command Examples ==="
echo ""

# Display the source data
echo "--- Source Data (s.dat) ---"
cat "$DATA_FILE"
echo ""

# Extract specific fields using tab delimiter (default)
echo "--- Extract fields 1 and 2 (ID and Last Name) ---"
echo "Command: cut -f1,2 s.dat"
cut -f1,2 "$DATA_FILE"
echo ""

# Extract a range of fields
echo "--- Extract fields 1 through 3 (ID, Last, First) ---"
echo "Command: cut -f1-3 s.dat"
cut -f1-3 "$DATA_FILE"
echo ""

# Extract by character position
echo "--- Extract characters 1-3 (ID only) ---"
echo "Command: cut -c1-3 s.dat"
cut -c1-3 "$DATA_FILE"
echo ""

# Use cut with a custom delimiter on /etc/passwd style data
echo "--- Extract from passwd file (delimiter ':') ---"
PASSWD_FILE="$SCRIPT_DIR/passwd"
echo "Command: cut -d: -f1,3 passwd  (username and UID)"
cut -d: -f1,3 "$PASSWD_FILE"

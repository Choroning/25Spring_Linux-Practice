#!/bin/bash
# @file    wc_example.sh
# @brief   Demonstrate the wc (word count) command
# @author  Cheolwon Park
# @date    2025-06-05

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PASSWD_FILE="$SCRIPT_DIR/passwd"

echo "=== wc Command Examples ==="
echo ""

# Default wc: lines, words, bytes
echo "--- Default wc (lines, words, bytes) ---"
echo "Command: wc passwd"
wc "$PASSWD_FILE"
echo ""

# Count lines only (-l)
echo "--- Line Count (-l) ---"
echo "Command: wc -l passwd"
wc -l "$PASSWD_FILE"
echo ""

# Count words only (-w)
echo "--- Word Count (-w) ---"
echo "Command: wc -w passwd"
wc -w "$PASSWD_FILE"
echo ""

# Count bytes only (-c)
echo "--- Byte Count (-c) ---"
echo "Command: wc -c passwd"
wc -c "$PASSWD_FILE"
echo ""

# Count characters (-m)
echo "--- Character Count (-m) ---"
echo "Command: wc -m passwd"
wc -m "$PASSWD_FILE"
echo ""

# Count multiple files
echo "--- Multiple Files ---"
echo "Command: wc -l passwd s.dat"
wc -l "$PASSWD_FILE" "$SCRIPT_DIR/s.dat" 2>/dev/null
echo ""

# Use wc with pipes
echo "--- Using wc with Pipes ---"
echo "Command: who | wc -l  (count logged-in users)"
echo "Logged-in users: $(who 2>/dev/null | wc -l)"

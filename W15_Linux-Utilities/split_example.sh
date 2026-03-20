#!/bin/bash
# @file    split_example.sh
# @brief   Demonstrate the split command for dividing files into smaller parts
# @author  Cheolwon Park
# @date    2025-06-05

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR=$(mktemp -d)

# Create a test file with 20 lines
TEST_FILE="$WORK_DIR/testdata.txt"
for i in $(seq 1 20); do
    echo "Line $i: This is line number $i of the test data." >> "$TEST_FILE"
done

echo "=== split Command Examples ==="
echo ""

echo "--- Source file has $(wc -l < "$TEST_FILE") lines ---"
echo ""

# Split by line count (default: 1000 lines, we use 5)
echo "--- Split into 5-line chunks ---"
echo "Command: split -l 5 testdata.txt chunk_"
cd "$WORK_DIR"
split -l 5 "$TEST_FILE" chunk_
echo "Generated files:"
ls -la chunk_*
echo ""

# Show content of each chunk
for f in chunk_*; do
    echo "--- $f ($(wc -l < "$f") lines) ---"
    head -2 "$f"
    echo "  ..."
done
echo ""

# Clean up previous chunks
rm -f chunk_*

# Split by byte size
echo "--- Split into 200-byte chunks ---"
echo "Command: split -b 200 testdata.txt bytes_"
split -b 200 "$TEST_FILE" bytes_
echo "Generated files:"
ls -la bytes_*
echo ""

# Clean up
cd "$SCRIPT_DIR"
rm -rf "$WORK_DIR"

echo "Note: Default output filenames follow the pattern xaa, xab, xac, ..."
echo "      Custom prefixes can be specified as the last argument."

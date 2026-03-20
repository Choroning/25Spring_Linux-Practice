#!/bin/bash
# @file    for_loop_range.sh
# @brief   Demonstrate for loop reading items from a file
# @author  Cheolwon Park
# @date    2025-05-20

# Create a temporary list file for demonstration
LIST_FILE="/tmp/for_loop_range_list.tmp"
cat > "$LIST_FILE" << 'EOF'
Alice
Bob
Charlie
Diana
EOF

# Read names from the file and greet each person
echo "=== Reading names from file ==="
for person in $(< "$LIST_FILE"); do
    echo "Hello, $person!"
done

# Clean up
rm -f "$LIST_FILE"

echo ""

# Demonstrate brace expansion range
echo "=== Using brace expansion {1..5} ==="
for i in {1..5}; do
    echo "Iteration $i"
done

#!/bin/bash
# @file    Lab_for_loop_range.sh
# @brief   Demonstrate for loop with file reading and brace expansion range
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

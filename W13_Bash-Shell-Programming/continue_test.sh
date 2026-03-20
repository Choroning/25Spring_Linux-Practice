#!/bin/bash
# @file    continue_test.sh
# @brief   Demonstrate the continue statement to skip loop iterations
# @author  Cheolwon Park
# @date    2025-05-20

# Create a temporary list file for demonstration
LIST_FILE="/tmp/continue_test_list.tmp"
cat > "$LIST_FILE" << 'EOF'
user1
user2
user3
user4
user5
EOF

SKIP_USER="user2"

echo "=== Greeting users (skipping '$SKIP_USER') ==="

# Read names from the list and skip a specific user
for person in $(< "$LIST_FILE"); do
    if [[ "$person" == "$SKIP_USER" ]]; then
        echo "  [Skipped: $person]"
        continue
    fi
    echo "Hello, $person!"
done

# Clean up
rm -f "$LIST_FILE"

echo ""

# Demonstrate continue with numbers: skip even numbers
echo "=== Printing odd numbers from 1 to 10 ==="
for i in {1..10}; do
    if (( i % 2 == 0 )); then
        continue
    fi
    echo "Odd number: $i"
done

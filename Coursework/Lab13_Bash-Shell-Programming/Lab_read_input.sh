#!/bin/bash
# @file    Lab_read_input.sh
# @brief   Demonstrate the read builtin for user input
# @author  Cheolwon Park
# @date    2025-05-20

# Basic read: single variable
echo "=== Single variable read ==="
read -p "Enter a value: " x
echo "You entered: $x"

echo ""

# Multiple variable read: splits input by whitespace
echo "=== Multiple variable read ==="
read -p "Enter two values (space-separated): " x y
echo "x = $x"
echo "y = $y"

echo ""

# Read without variable name: stored in $REPLY
echo "=== Read into \$REPLY ==="
read -p "Enter anything: "
echo "REPLY = $REPLY"

echo ""

# Read with timeout
echo "=== Read with 5-second timeout ==="
if read -t 5 -p "Quick! Enter something (5s): " answer; then
    echo "You entered: $answer"
else
    echo ""
    echo "Timed out!"
fi

echo ""

# Silent read (for passwords)
echo "=== Silent read (no echo) ==="
read -s -p "Enter a secret: " secret
echo ""
echo "Secret length: ${#secret} characters"

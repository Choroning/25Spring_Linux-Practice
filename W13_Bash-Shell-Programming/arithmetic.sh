#!/bin/bash
# @file    arithmetic.sh
# @brief   Demonstrate functions and arithmetic operations
# @author  Cheolwon Park
# @date    2025-05-20

# Usage: ./arithmetic.sh <num1> <num2>

# Define a function that adds two numbers
# Note: bash functions can return values via stdout (echo) or exit status.
# The return statement only supports values 0-255, so we use echo for larger sums.
add() {
    local result=$(( $1 + $2 ))
    echo "$result"
}

# Validate arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <num1> <num2>"
    echo "Example: $0 15 25"
    exit 1
fi

if [[ ! "$1" =~ ^-?[0-9]+$ ]] || [[ ! "$2" =~ ^-?[0-9]+$ ]]; then
    echo "Error: Both arguments must be integers."
    exit 1
fi

# Call the function and capture the result
result=$(add "$1" "$2")
echo "$1 + $2 = $result"

echo ""

# Demonstrate various arithmetic methods
echo "=== Arithmetic Methods ==="
a=$1
b=$2
echo "Using (( )):    $(( a + b ))"
echo "Using \$(()):    $(( a * b ))"
echo "Using let:"
let "product = a * b"
echo "  $a * $b = $product"
echo "Using expr:     $(expr "$a" + "$b")"

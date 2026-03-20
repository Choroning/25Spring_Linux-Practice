#!/bin/bash
# @file    for_loop.sh
# @brief   Demonstrate basic for loop with a word list
# @author  Cheolwon Park
# @date    2025-05-20

# Iterate over a list of values
echo "=== Iterating over a number list ==="
for num in 0 1 2; do
    echo "Number is $num"
done

echo ""

# Iterate over a list of strings
echo "=== Iterating over a string list ==="
for fruit in apple banana cherry; do
    echo "Fruit: $fruit"
done

#!/bin/bash
# @file    if_test.sh
# @brief   Demonstrate basic if-else conditional branching
# @author  Cheolwon Park
# @date    2025-05-20

# Prompt user for two integer values
read -p "Input x: " x
read -p "Input y: " y

# Validate that inputs are integers
if [[ ! "$x" =~ ^-?[0-9]+$ ]] || [[ ! "$y" =~ ^-?[0-9]+$ ]]; then
    echo "Error: Both inputs must be integers."
    exit 1
fi

# Compare the two values using arithmetic evaluation
if (( x < y )); then
    echo "$x is less than $y."
elif (( x > y )); then
    echo "$x is greater than $y."
else
    echo "$x is equal to $y."
fi

#!/bin/bash
# @file    Lab_case_statement.sh
# @brief   Demonstrate case statement with pattern matching
# @author  Cheolwon Park
# @date    2025-05-20

# Prompt the user for input
read -p "Enter a command or value: " cmd

# Use case statement with various patterns
case "$cmd" in
    [0-9])
        # Single digit: show current date
        echo "Single digit detected. Current date:"
        date
        ;;
    cd|CD)
        # Exact match: cd or CD
        echo "Home directory: $HOME"
        ;;
    [aA-C]*)
        # Starts with a, A, B, or C
        echo "String starts with a/A/B/C. Current directory:"
        pwd
        ;;
    quit|exit|q)
        echo "Exiting..."
        exit 0
        ;;
    *)
        # Default case
        echo "Usage: Enter a digit, 'cd', a string starting with a-C, or 'quit'"
        ;;
esac

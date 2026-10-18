#!/bin/bash
# @file    Lab_while_loop_menu.sh
# @brief   Demonstrate while loop with an interactive command menu
# @author  Cheolwon Park
# @date    2025-05-20

# Interactive menu loop using a flag variable
go=1
while (( go )); do
    echo ""
    echo "==============================="
    echo "  Available Commands"
    echo "==============================="
    echo "  pwd   - Print working directory"
    echo "  date  - Show current date/time"
    echo "  who   - Show logged-in users"
    echo "  quit  - Exit the program"
    echo "==============================="
    read -p "Enter command: " cmd

    case "$cmd" in
        pwd)  pwd ;;
        date) date ;;
        who)  who ;;
        quit) go=0 ;;
        *)    echo "Error: Unknown command '$cmd'" ;;
    esac
done

echo "Goodbye!"

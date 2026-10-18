#!/bin/bash
# @file    Lab_select_menu.sh
# @brief   Demonstrate the select construct for interactive menus
# @author  Cheolwon Park
# @date    2025-05-20

# Custom prompt for the select menu
PS3="Select a command (1-4): "

# The select construct generates a numbered menu automatically
select cmd in pwd date whoami quit; do
    case "$cmd" in
        pwd)
            echo "Current directory: $(pwd)"
            ;;
        date)
            echo "Current date/time: $(date)"
            ;;
        whoami)
            echo "Current user: $(whoami)"
            ;;
        quit)
            echo "Goodbye!"
            break
            ;;
        *)
            echo "Invalid selection. Please enter a number from 1 to 4."
            ;;
    esac

    echo ""
    # Reset REPLY to re-display the menu on next iteration
    REPLY=
done

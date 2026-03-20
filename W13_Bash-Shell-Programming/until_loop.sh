#!/bin/bash
# @file    until_loop.sh
# @brief   Demonstrate until loop - wait for a specific user to log in
# @author  Cheolwon Park
# @date    2025-05-20

# Prompt for the username to watch for
read -p "Enter username to wait for: " person

if [[ -z "$person" ]]; then
    echo "Error: Username cannot be empty."
    exit 1
fi

echo "Waiting for user '$person' to log in..."
echo "(Press Ctrl+C to cancel)"

# Loop until the user appears in the 'who' output
until who | grep -q "$person" 2>/dev/null; do
    sleep 3
done

# Alert when the user has logged in
echo -e "\a"  # Terminal bell
echo "User '$person' has logged in!"
who | grep "$person"

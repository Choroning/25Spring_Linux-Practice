#!/bin/bash
# @file    for_loop_files.sh
# @brief   Demonstrate for loop iterating over command-line arguments ($*)
# @author  Cheolwon Park
# @date    2025-05-20

# Check if arguments were provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <name1> <name2> ..."
    echo "Example: $0 Alice Bob Charlie"
    exit 1
fi

# Iterate over all command-line arguments using $*
echo "=== Greeting each argument (using \$*) ==="
for person in $*; do
    echo "Hi, $person!"
done

echo ""

# Preferred method: iterate using "$@" to handle spaces in arguments
echo "=== Greeting each argument (using \"\$@\") ==="
for person in "$@"; do
    echo "Hello, $person!"
done

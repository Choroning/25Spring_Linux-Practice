#!/bin/bash
# @file    exit_test.sh
# @brief   Demonstrate the exit command and $? (exit status)
# @author  Cheolwon Park
# @date    2025-05-20

# The exit command terminates the script with a specified exit code.
# After running this script, check the exit status with: echo $?
#
# Convention:
#   0     = success
#   1-125 = user-defined error codes
#   126   = command found but not executable
#   127   = command not found
#   128+N = terminated by signal N

echo "This script will exit with status code 30."
echo "After running, verify with: echo \$?"

# Exit with a custom status code
exit 30

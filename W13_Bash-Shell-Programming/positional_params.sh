#!/bin/bash
# @file    positional_params.sh
# @brief   Demonstrate positional parameters and special variables
# @author  Cheolwon Park
# @date    2025-05-20

# Usage: ./positional_params.sh arg1 arg2 arg3 ...

echo "=== Special Variables ==="
echo "Script name (\$0): $0"
echo "Number of arguments (\$#): $#"
echo "All arguments (\$*): $*"
echo "All arguments (\$@): $@"
echo "Process ID (\$\$): $$"

echo ""

# Display individual positional parameters
echo "=== Individual Parameters ==="
echo "First argument  (\$1): $1"
echo "Second argument (\$2): $2"
echo "Third argument  (\$3): $3"

echo ""

# Demonstrate the difference between "$*" and "$@"
echo "=== Difference: \"\$*\" vs \"\$@\" ==="
echo "Using \"\$*\" (single string):"
for arg in "$*"; do
    echo "  -> '$arg'"
done

echo "Using \"\$@\" (separate strings):"
for arg in "$@"; do
    echo "  -> '$arg'"
done

echo ""

# Clear all positional parameters
echo "=== Clearing positional parameters with 'set --' ==="
set --
echo "After 'set --', \$# = $#"

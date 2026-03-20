#!/bin/bash
# @file    signal_trap.sh
# @brief   Demonstrate the trap command for signal handling and debugging
# @author  Cheolwon Park
# @date    2025-05-20

# The trap command catches signals and executes specified commands.
# DEBUG trap: executes before every simple command.

echo "=== DEBUG Trap Example ==="
echo "This will trace variable changes during execution."
echo ""

# Set up a DEBUG trap to print variable state at each step
trap 'echo "[DEBUG] Line $LINENO: count=$count, sum=$sum"' DEBUG

count=1
sum=0

while (( count <= 10 )); do
    (( sum += count ))
    (( count++ ))
done

# Remove the DEBUG trap
trap - DEBUG

echo ""
echo "Final result - Sum(1~10): $sum"

echo ""
echo "=== Signal Trap Example ==="
echo "Try pressing Ctrl+C during the countdown..."

# Trap SIGINT (Ctrl+C) to perform cleanup
trap 'echo ""; echo "Caught SIGINT! Cleaning up..."; exit 0' INT

for i in {5..1}; do
    echo "Countdown: $i"
    sleep 1
done

echo "Countdown complete!"

# Remove signal trap
trap - INT

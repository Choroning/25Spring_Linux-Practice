#!/bin/bash
# @file    while_loop.sh
# @brief   Demonstrate while loop with arithmetic summation (1 to 10)
# @author  Cheolwon Park
# @date    2025-05-20

# Initialize counter and accumulator
count=1
sum=0

# Sum integers from 1 to 10
while (( count <= 10 )); do
    (( sum += count ))
    (( count++ ))
done

echo "Sum of 1 to 10: $sum"

echo ""

# Demonstrate while loop with user-specified range
read -p "Enter upper limit N: " n

if [[ ! "$n" =~ ^[0-9]+$ ]] || (( n < 1 )); then
    echo "Error: Please enter a positive integer."
    exit 1
fi

count=1
sum=0
while (( count <= n )); do
    (( sum += count ))
    (( count++ ))
done

echo "Sum of 1 to $n: $sum"

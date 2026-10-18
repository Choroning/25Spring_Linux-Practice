#!/bin/bash
# @file    Lab_elif_test.sh
# @brief   Demonstrate elif (else-if) branching with score grading
# @author  Cheolwon Park
# @date    2025-05-20

# Prompt user for a score
read -p "Input Score: " score

# Validate input is a number between 0 and 100
if [[ ! "$score" =~ ^[0-9]+$ ]] || (( score < 0 || score > 100 )); then
    echo "Error: Please enter a valid score (0-100)."
    exit 1
fi

# Grade the score using elif chain
if (( score >= 90 )); then
    echo "Grade: A - Your score is excellent."
elif (( score >= 80 )); then
    echo "Grade: B - Your score is good."
elif (( score >= 70 )); then
    echo "Grade: C - Your score is average."
elif (( score >= 60 )); then
    echo "Grade: D - Your score needs improvement."
else
    echo "Grade: F - Your score is failing."
fi

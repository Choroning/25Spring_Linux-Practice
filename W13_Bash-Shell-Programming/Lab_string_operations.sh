#!/bin/bash
# @file    Lab_string_operations.sh
# @brief   Demonstrate string comparison and pattern matching
# @author  Cheolwon Park
# @date    2025-05-20

# Basic string comparison using [[ ]]
echo "=== Yes/No String Comparison ==="
read -p "Are you OK? (y/n): " ans

if [[ "$ans" == [Yy]* ]]; then
    echo "Happy to hear it!"
elif [[ "$ans" == [Nn]* ]]; then
    echo "Sorry to hear that."
else
    echo "Please answer with 'y' or 'n'."
fi

echo ""

# String length
echo "=== String Length ==="
str="Hello, World!"
echo "String: '$str'"
echo "Length: ${#str}"

echo ""

# Substring extraction
echo "=== Substring Extraction ==="
echo "First 5 chars: ${str:0:5}"
echo "From index 7:  ${str:7}"

echo ""

# Pattern-based string operations
echo "=== Pattern Removal ==="
path="/usr/local/bin/myapp"
echo "Full path: $path"
echo "Filename (remove longest prefix */):  ${path##*/}"
echo "Directory (remove shortest suffix /*): ${path%/*}"

echo ""

# String replacement
echo "=== String Replacement ==="
text="foo bar foo baz foo"
echo "Original:        '$text'"
echo "Replace first:   '${text/foo/FOO}'"
echo "Replace all:     '${text//foo/FOO}'"

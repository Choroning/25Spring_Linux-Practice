#!/bin/bash
# @file    Lab_here_document.sh
# @brief   Demonstrate here documents (heredoc) for multi-line input
# @author  Cheolwon Park
# @date    2025-05-20

# Basic here document with line numbers using cat -n
echo "=== Basic Here Document (with line numbers) ==="
cat -n << 'END'
This
is
a
test
document
for
here document.
END

echo ""

# Here document with variable expansion
echo "=== Here Document with Variable Expansion ==="
user=$(whoami)
date_now=$(date)
cat << EOF
Hello, $user!
Current date: $date_now
Your home directory: $HOME
EOF

echo ""

# Here document with indentation (using <<-)
echo "=== Indented Here Document (using <<-) ==="
if true; then
	cat <<-INDENT
	This heredoc uses <<- to strip leading tabs.
	Useful for maintaining code indentation.
	Note: only leading TABS are stripped, not spaces.
	INDENT
fi

echo ""

# Here string (<<<)
echo "=== Here String ==="
greeting="Hello from a here string"
cat <<< "$greeting"

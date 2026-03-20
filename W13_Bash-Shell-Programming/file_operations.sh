#!/bin/bash
# @file    file_operations.sh
# @brief   Demonstrate file test operators (-e, -f, -d, -r, -w, -x)
# @author  Cheolwon Park
# @date    2025-05-20

# Prompt for a filename or path
read -p "Enter a file or directory path: " file

# Check if the path exists
if [[ ! -e "$file" ]]; then
    echo "'$file' does not exist."
    exit 1
fi

# Determine the file type
echo "=== File Type ==="
if [[ -f "$file" ]]; then
    echo "'$file' is a regular file."
elif [[ -d "$file" ]]; then
    echo "'$file' is a directory."
elif [[ -L "$file" ]]; then
    echo "'$file' is a symbolic link."
elif [[ -b "$file" ]]; then
    echo "'$file' is a block device."
elif [[ -c "$file" ]]; then
    echo "'$file' is a character device."
else
    echo "'$file' is a special file."
fi

# Check permissions
echo ""
echo "=== Permissions ==="
[[ -r "$file" ]] && echo "  Readable:   Yes" || echo "  Readable:   No"
[[ -w "$file" ]] && echo "  Writable:   Yes" || echo "  Writable:   No"
[[ -x "$file" ]] && echo "  Executable: Yes" || echo "  Executable: No"

# Show file size if it is a regular file
if [[ -f "$file" ]]; then
    echo ""
    echo "=== File Info ==="
    echo "  Size: $(wc -c < "$file") bytes"
    echo "  Lines: $(wc -l < "$file")"
fi

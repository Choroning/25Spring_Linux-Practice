#!/bin/bash
# @file    dd_example.sh
# @brief   Demonstrate the dd command for block-level data copying
# @author  Cheolwon Park
# @date    2025-06-05

WORK_DIR=$(mktemp -d)

echo "=== dd Command Examples ==="
echo ""

# Create a 1MB file filled with zeros
echo "--- Create a 1MB File ---"
echo "Command: dd if=/dev/zero bs=1M count=1 of=test_1mb.dat"
dd if=/dev/zero bs=1M count=1 of="$WORK_DIR/test_1mb.dat" 2>&1
echo ""
ls -lh "$WORK_DIR/test_1mb.dat"
echo ""

# Create a small file with specific content
echo "--- Create a File from String ---"
echo "Command: echo 'Hello dd' | dd of=hello.dat"
echo "Hello, dd command!" | dd of="$WORK_DIR/hello.dat" 2>&1
echo "Content:"
cat "$WORK_DIR/hello.dat"
echo ""

# Copy a file using dd
echo "--- Copy a File ---"
echo "Command: dd if=hello.dat of=hello_copy.dat"
dd if="$WORK_DIR/hello.dat" of="$WORK_DIR/hello_copy.dat" 2>&1
echo "Copy content:"
cat "$WORK_DIR/hello_copy.dat"
echo ""

# Convert lowercase to uppercase
echo "--- Convert to Uppercase ---"
echo "Command: dd if=hello.dat conv=ucase"
dd if="$WORK_DIR/hello.dat" conv=ucase 2>/dev/null
echo ""
echo ""

# Show common dd use cases (documentation only)
echo "=== Common dd Use Cases (Reference) ==="
echo "  1. Create a bootable USB:"
echo "     dd if=ubuntu.iso of=/dev/sdb bs=4M status=progress"
echo ""
echo "  2. Backup MBR (first 512 bytes):"
echo "     dd if=/dev/sda of=mbr_backup.img bs=512 count=1"
echo ""
echo "  3. Wipe a disk with zeros:"
echo "     dd if=/dev/zero of=/dev/sdb bs=1M status=progress"
echo ""
echo "  4. Create a swap file:"
echo "     dd if=/dev/zero of=/swapfile bs=1M count=1024"

# Clean up
rm -rf "$WORK_DIR"

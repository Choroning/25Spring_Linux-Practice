# Week 15 — Linux Utilities

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Text Processing Utilities](#1-text-processing-utilities)
2. [cut -- Extract Columns](#2-cut----extract-columns)
3. [paste -- Merge Files](#3-paste----merge-files)
4. [sort -- Sort Lines](#4-sort----sort-lines)
5. [uniq -- Remove Duplicates](#5-uniq----remove-duplicates)
6. [wc -- Word Count](#6-wc----word-count)
7. [split -- Split Files](#7-split----split-files)
8. [dd -- Data Duplicator](#8-dd----data-duplicator)
9. [Other Useful Utilities](#9-other-useful-utilities)
10. [Best Practices](#10-best-practices)
11. [Summary](#summary)

---

## 1. Text Processing Utilities

Linux provides a rich set of command-line utilities for processing text data. These tools follow the Unix philosophy of doing one thing well and can be combined with pipes for powerful data processing pipelines.

```bash
# Example pipeline: find top 10 largest files in /var/log
du -ah /var/log 2>/dev/null | sort -rh | head -10
```

---

## 2. cut -- Extract Columns

### 2.1 Usage

```bash
cut -c list file          # Cut by character position
cut -f list file          # Cut by field (tab-delimited)
cut -d delim -f list file # Cut by field with custom delimiter
```

### 2.2 Examples

```bash
# Extract characters 1-3
echo "Hello World" | cut -c1-3        # Output: Hel

# Extract fields from tab-delimited file
# s.dat: 001\tHong\tGil-Dong\t80\tM
cut -f 2,3 s.dat                      # Output: Hong  Gil-Dong

# Extract from colon-delimited file (like /etc/passwd)
cut -d: -f1,3 /etc/passwd            # Output: root:0
cut -d: -f1,6 /etc/passwd            # username:homedir

# Extract specific character ranges
cut -c1-5,10-15 filename
```

---

## 3. paste -- Merge Files

### 3.1 Usage

```bash
paste file1 file2         # Merge files side by side (tab-separated)
paste -d delim file1 file2 # Use custom delimiter
paste -s file             # Merge lines of a single file into one line
```

### 3.2 Examples

```bash
# Merge ID file with name file
# file1: 001\n002\n003
# file2: Hong Gil-Dong\nPark Ji-Soo\nLee Na-Young
paste file1 file2
# Output:
# 001  Hong Gil-Dong
# 002  Park Ji-Soo
# 003  Lee Na-Young

# Serial paste (merge all lines into one)
paste -s file1
# Output: 001  002  003  004  005  006  007

# Custom delimiter
paste -d',' file1 file2
# Output: 001,Hong Gil-Dong
```

---

## 4. sort -- Sort Lines

### 4.1 Usage

```bash
sort file                 # Alphabetical sort
sort -n file              # Numeric sort
sort -r file              # Reverse sort
sort -k field file        # Sort by specific field
sort -t delim file        # Specify field delimiter
sort -u file              # Sort and remove duplicates
```

### 4.2 Examples

```bash
# Basic alphabetical sort
sort names.txt

# Numeric sort
sort -n numbers.txt

# Sort by 4th field (score), numerically, reversed
sort -t' ' -k4 -n -r s.dat
# Output (highest score first):
# 002 Park Ji-Soo 100 M
# 001 Hong Gil-Dong 80 M
# 005 Han Ju-Hyun 75 M

# Sort /etc/passwd by UID (3rd field)
sort -t: -k3 -n /etc/passwd

# Case-insensitive sort
sort -f file.txt

# Sort locale-aware (special characters)
LC_ALL=C sort file.txt    # Use C locale for consistent results
```

---

## 5. uniq -- Remove Duplicates

### 5.1 Usage

```bash
uniq file                 # Remove adjacent duplicates
uniq -c file              # Count occurrences
uniq -d file              # Show only duplicated lines
uniq -u file              # Show only unique lines
uniq -i file              # Case-insensitive comparison
```

### 5.2 Examples

```bash
# Important: uniq only removes ADJACENT duplicates, so sort first!
sort data.txt | uniq

# Count occurrences
sort data.txt | uniq -c
# Output:
#   3 abcde
#   1 aaaaa
#   3 bbbbb
#   1 ccc

# Find only duplicated lines
sort data.txt | uniq -d

# Find unique (non-duplicated) lines
sort data.txt | uniq -u
```

> **Key Point:** Always `sort` before `uniq`, since `uniq` only compares adjacent lines.

---

## 6. wc -- Word Count

### 6.1 Usage

```bash
wc file                   # Lines, words, characters
wc -l file                # Line count only
wc -w file                # Word count only
wc -c file                # Byte count
wc -m file                # Character count
```

### 6.2 Examples

```bash
wc /etc/passwd
#   43   76  2237 /etc/passwd
# lines words bytes

# Count number of users
wc -l /etc/passwd

# Count files in directory
ls | wc -l

# Count lines in multiple files
wc -l *.txt

# Count unique lines
sort data.txt | uniq | wc -l
```

---

## 7. split -- Split Files

### 7.1 Usage

```bash
split -l lines file prefix    # Split by number of lines
split -b size file prefix     # Split by file size
split -n chunks file prefix   # Split into N equal chunks
```

### 7.2 Examples

```bash
# Split into 100-line chunks
split -l 100 largefile.txt part_
# Creates: part_aa, part_ab, part_ac, ...

# Split into 10MB chunks
split -b 10M backup.tar.gz chunk_

# Reassemble split files
cat part_* > reassembled.txt
cat chunk_* > reassembled.tar.gz
```

---

## 8. dd -- Data Duplicator

### 8.1 Usage

```bash
dd if=input of=output bs=blocksize count=blocks
```

### 8.2 Examples

```bash
# Create a 1GB file filled with zeros
dd if=/dev/zero of=test.img bs=1M count=1024

# Clone a disk (DANGEROUS - be very careful with device names!)
sudo dd if=/dev/sda of=/dev/sdb bs=4M status=progress

# Create a bootable USB from ISO
sudo dd if=ubuntu.iso of=/dev/sdb bs=4M status=progress

# Backup MBR
sudo dd if=/dev/sda of=mbr_backup.bin bs=512 count=1

# Convert file to uppercase
dd if=input.txt of=output.txt conv=ucase
```

> **Key Point:** `dd` operates at the raw device level. A wrong `of=` parameter can destroy data. Always double-check device names!

---

## 9. Other Useful Utilities

### 9.1 tr -- Translate Characters

```bash
echo "hello" | tr 'a-z' 'A-Z'         # HELLO
echo "hello  world" | tr -s ' '       # Remove duplicate spaces
echo "hello123" | tr -d '0-9'         # Remove digits: hello
```

### 9.2 sed -- Stream Editor

```bash
sed 's/old/new/' file                  # Replace first on each line
sed 's/old/new/g' file                 # Replace all
sed -n '5,10p' file                    # Print lines 5-10
sed '3d' file                          # Delete line 3
sed -i 's/old/new/g' file             # In-place edit
```

### 9.3 awk -- Pattern Processing

```bash
awk '{print $1, $3}' file             # Print fields 1 and 3
awk -F: '{print $1, $6}' /etc/passwd  # Custom delimiter
awk 'NR>=5 && NR<=10' file            # Print lines 5-10
awk '{sum += $1} END {print sum}' file # Sum first column
```

### 9.4 xargs -- Build Commands from Input

```bash
find . -name "*.tmp" | xargs rm       # Delete found files
echo "a b c" | xargs -n1 echo         # One arg per command
```

---

## 10. Best Practices

- Chain utilities with pipes for complex text processing
- Use `sort | uniq` pattern (sort before uniq)
- Prefer `awk` for complex field-based processing
- Use `sed -i.bak` to create backup before in-place edits
- Use `dd status=progress` for long operations
- Always verify `dd` device names before executing

---

## Summary

| Utility | Key Function | Common Usage |
|---------|-------------|--------------|
| `cut` | Extract columns/fields | `cut -d: -f1 /etc/passwd` |
| `paste` | Merge files side by side | `paste file1 file2` |
| `sort` | Sort lines | `sort -k2 -n file` |
| `uniq` | Remove adjacent duplicates | `sort file \| uniq -c` |
| `wc` | Count lines/words/chars | `wc -l file` |
| `split` | Split files into parts | `split -l 1000 file prefix_` |
| `dd` | Raw data copy/convert | `dd if=input of=output bs=4M` |
| `tr` | Translate/delete characters | `tr 'a-z' 'A-Z'` |
| `sed` | Stream text editing | `sed 's/old/new/g' file` |
| `awk` | Pattern-based processing | `awk '{print $1}' file` |

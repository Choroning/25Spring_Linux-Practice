# Week 4 -- Directory and File Management II

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [File Copy, Move, and Delete](#1-file-copy-move-and-delete)
2. [Hard Links and Symbolic Links](#2-hard-links-and-symbolic-links)
3. [Empty File Creation](#3-empty-file-creation)
4. [File Content Searching](#4-file-content-searching)
5. [File Location Searching](#5-file-location-searching)
6. [Wildcards and Globbing](#6-wildcards-and-globbing)
7. [I/O Redirection and Pipes](#7-io-redirection-and-pipes)
8. [Best Practices](#8-best-practices)
9. [Summary](#summary)

---

## 1. File Copy, Move, and Delete

### 1.1 cp -- Copy Files and Directories

```bash
cp source destination            # Copy file
cp file1.txt file2.txt           # Copy file1.txt to file2.txt
cp file.txt /tmp/                # Copy to /tmp directory
cp -r dir1/ dir2/                # Copy directory recursively
cp -i file.txt /tmp/             # Interactive (prompt before overwrite)
cp -p file.txt backup/           # Preserve timestamps and permissions
cp -a dir1/ dir2/                # Archive mode (preserve everything)
cp file1 file2 file3 destdir/    # Copy multiple files to directory
```

### 1.2 mv -- Move or Rename Files

```bash
mv oldname.txt newname.txt       # Rename file
mv file.txt /tmp/                # Move file to /tmp
mv dir1/ /home/user/             # Move directory
mv -i file.txt /tmp/             # Interactive (prompt before overwrite)
mv file1 file2 destdir/          # Move multiple files
```

> **Key Point:** `mv` serves dual purpose -- it both moves AND renames files.

### 1.3 rm -- Remove Files and Directories

```bash
rm file.txt                      # Remove file
rm -i file.txt                   # Interactive (confirm before delete)
rm -f file.txt                   # Force removal (no confirmation)
rm -r directory/                 # Remove directory and contents recursively
rm -rf directory/                # Force recursive removal (DANGEROUS)
```

**WARNING:** There is no "recycle bin" in Linux CLI. Deleted files are gone permanently.

```bash
# Safety tip: use rm -i by default
alias rm='rm -i'                 # Add to ~/.bashrc
```

---

## 2. Hard Links and Symbolic Links

### 2.1 Inodes

Every file on a Linux filesystem has an **inode** (index node) that stores:
- File type and permissions
- Owner and group
- File size
- Timestamps (created, modified, accessed)
- Pointers to data blocks
- **NOT the filename** (names are stored in directory entries)

```bash
ls -i file.txt                   # Show inode number
stat file.txt                    # Show detailed inode information
```

### 2.2 Hard Links

A hard link creates an additional directory entry pointing to the **same inode**.

```bash
ln original.txt hardlink.txt

# Both files share the same inode
$ ls -li
1234567 -rw-r--r-- 2 user1 user1 100 Mar 21 10:00 hardlink.txt
1234567 -rw-r--r-- 2 user1 user1 100 Mar 21 10:00 original.txt
```

**Properties:**
- Same inode number
- Hard link count increases (the `2` in the output above)
- Deleting one does not affect the other
- Cannot span across filesystems
- Cannot hard link directories (except `.` and `..`)

### 2.3 Symbolic Links (Soft Links)

A symbolic link creates a **new file** that contains the path to the original file.

```bash
ln -s /path/to/original.txt symlink.txt

$ ls -l
lrwxrwxrwx 1 user1 user1 21 Mar 21 10:00 symlink.txt -> /path/to/original.txt
```

**Properties:**
- Different inode number from the original
- Contains the path to the target file
- Can span across filesystems
- Can link to directories
- Becomes a "dangling link" if the target is deleted

### 2.4 Comparison

| Feature | Hard Link | Symbolic Link |
|---------|-----------|---------------|
| Inode | Same as original | Different |
| Cross-filesystem | No | Yes |
| Link to directory | No | Yes |
| Target deleted | File still accessible | Dangling (broken) link |
| File size | Same as original | Size of path string |
| Command | `ln file link` | `ln -s file link` |

---

## 3. Empty File Creation

### 3.1 touch -- Create or Update Timestamps

```bash
touch newfile.txt                # Create empty file (or update timestamp)
touch -t 202503211200 file.txt   # Set specific timestamp
touch -r ref.txt file.txt        # Copy timestamp from reference file
touch file1 file2 file3          # Create multiple files
```

---

## 4. File Content Searching

### 4.1 grep -- Search File Contents

```bash
grep "pattern" file.txt                  # Search for pattern in file
grep -i "pattern" file.txt               # Case-insensitive search
grep -n "pattern" file.txt               # Show line numbers
grep -r "pattern" directory/             # Recursive search in directory
grep -v "pattern" file.txt               # Invert match (show non-matching)
grep -c "pattern" file.txt               # Count matching lines
grep -l "pattern" *.txt                  # Show only filenames with matches
grep -w "word" file.txt                  # Match whole word only
grep -E "regex" file.txt                 # Extended regex (same as egrep)
```

**Regular Expression Basics:**

| Pattern | Meaning |
|---------|---------|
| `.` | Any single character |
| `*` | Zero or more of preceding character |
| `^` | Start of line |
| `$` | End of line |
| `[abc]` | Any character in the set |
| `[^abc]` | Any character NOT in the set |
| `\b` | Word boundary |

```bash
# Examples
grep "^root" /etc/passwd          # Lines starting with "root"
grep "bash$" /etc/passwd          # Lines ending with "bash"
grep "^$" file.txt                # Empty lines
grep -E "[0-9]{3}" file.txt       # Three consecutive digits
```

---

## 5. File Location Searching

### 5.1 find -- Search for Files

```bash
find /path -name "filename"              # Find by exact name
find /home -name "*.txt"                 # Find by pattern
find / -name "*.log" -size +10M          # Find logs larger than 10MB
find . -type f -name "*.sh"              # Find regular files only
find . -type d -name "backup"            # Find directories only
find /tmp -mtime -7                      # Modified within last 7 days
find . -user user1                       # Find files owned by user1
find . -perm 755                         # Find files with specific permissions
find . -empty                            # Find empty files/directories

# Execute command on found files
find . -name "*.tmp" -exec rm {} \;      # Delete all .tmp files
find . -name "*.sh" -exec chmod +x {} \; # Make all .sh files executable
```

### 5.2 whereis -- Locate Binary, Source, and Manual

```bash
whereis ls
# ls: /usr/bin/ls /usr/share/man/man1/ls.1.gz
```

### 5.3 which -- Locate Command Binary

```bash
which python3
# /usr/bin/python3
```

### 5.4 locate -- Fast File Search (Database-based)

```bash
sudo apt install mlocate           # Install if not present
sudo updatedb                      # Update the file database
locate filename                    # Fast search
locate -i filename                 # Case-insensitive
```

> **Key Point:** `locate` is much faster than `find` because it searches a pre-built database, but results may not reflect recent changes. Run `updatedb` to refresh.

---

## 6. Wildcards and Globbing

### 6.1 Shell Wildcards

| Wildcard | Meaning | Example |
|----------|---------|---------|
| `*` | Any number of characters | `*.txt` = all .txt files |
| `?` | Exactly one character | `file?.txt` = file1.txt, fileA.txt |
| `[abc]` | One character from set | `file[123].txt` = file1.txt, file2.txt |
| `[a-z]` | One character from range | `[a-z]*.txt` = lowercase starting files |
| `[!abc]` | One character NOT in set | `file[!0-9].txt` = non-digit suffix |
| `{a,b,c}` | Brace expansion | `file.{txt,log}` = file.txt, file.log |

```bash
ls *.txt                          # All .txt files
ls file[0-9].txt                  # file0.txt through file9.txt
cp *.{jpg,png} images/            # Copy all jpg and png files
rm test_?.log                     # Remove test_1.log, test_A.log, etc.
```

---

## 7. I/O Redirection and Pipes

### 7.1 Standard I/O Streams

| Stream | File Descriptor | Default |
|--------|-----------------|---------|
| stdin | 0 | Keyboard |
| stdout | 1 | Screen |
| stderr | 2 | Screen |

### 7.2 Output Redirection

```bash
command > file                    # Redirect stdout to file (overwrite)
command >> file                   # Redirect stdout to file (append)
command 2> file                   # Redirect stderr to file
command 2>&1                      # Redirect stderr to stdout
command > file 2>&1               # Redirect both stdout and stderr
command &> file                   # Shorthand for above (bash)
```

### 7.3 Input Redirection

```bash
command < file                    # Read input from file
sort < unsorted.txt               # Sort from file input
```

### 7.4 Pipes

```bash
command1 | command2               # Pipe stdout of command1 to stdin of command2
ls -la | grep "\.txt$"            # List only .txt files
cat /etc/passwd | sort            # Sort passwd entries
ps aux | grep nginx               # Find nginx processes
history | tail -20                # Show last 20 commands
```

### 7.5 tee -- Write to File and Screen

```bash
command | tee file.txt            # Write to both file and screen
command | tee -a file.txt         # Append to file and show on screen
```

---

## 8. Best Practices

### 8.1 Efficient File Management

- Use `cp -i`, `mv -i`, `rm -i` to prevent accidental operations
- Prefer symbolic links over hard links for directories
- Use `find` with `-exec` for batch operations
- Use `grep -r` to search across multiple files

### 8.2 Safety Tips

```bash
# Before running rm -rf, verify the path
echo rm -rf /path/to/dir         # Preview the command first
ls /path/to/dir                  # Verify the directory contents

# Use trash-cli instead of rm for safety
sudo apt install trash-cli
trash-put file.txt               # Move to trash instead of delete
```

---

## Summary

| Concept | Key Point |
|---------|-----------|
| `cp` | Copy files; use `-r` for directories, `-p` to preserve attributes |
| `mv` | Move or rename files and directories |
| `rm` | Remove files; `-r` for directories; no undo! |
| Hard Link | Same inode; cannot cross filesystems; file persists until all links removed |
| Symbolic Link | Different inode; can cross filesystems; can link directories |
| `touch` | Create empty files or update timestamps |
| `grep` | Search file contents using patterns and regex |
| `find` | Search for files by name, type, size, date, permissions |
| Wildcards | `*` (any), `?` (single char), `[set]`, `{a,b}` |
| Redirection | `>` (overwrite), `>>` (append), `2>` (stderr), `<` (input) |
| Pipes | `\|` chains commands, passing stdout to stdin |

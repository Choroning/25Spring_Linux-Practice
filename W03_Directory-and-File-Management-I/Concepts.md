# W03 -- Directory and File Management I

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Linux Files and Directories](#1-linux-files-and-directories)
2. [Directory Hierarchy Structure](#2-directory-hierarchy-structure)
3. [Absolute and Relative Paths](#3-absolute-and-relative-paths)
4. [File and Directory Naming Rules](#4-file-and-directory-naming-rules)
5. [Directory Commands](#5-directory-commands)
6. [File Content Commands](#6-file-content-commands)
7. [Best Practices](#7-best-practices)
8. [Summary](#summary)

---

## 1. Linux Files and Directories

### 1.1 Everything is a File

In Linux, almost everything is treated as a file, including devices and directories.

### 1.2 File Types

| Type | Symbol in `ls -l` | Description |
|------|-------------------|-------------|
| Regular file | `-` | Text files, executables, images, data files |
| Directory | `d` | Contains references to other files and directories |
| Symbolic link | `l` | Pointer to another file (like a Windows shortcut) |
| Block device | `b` | Block-oriented device (e.g., hard disk `/dev/sda`) |
| Character device | `c` | Character-oriented device (e.g., keyboard, terminal) |
| Pipe | `p` | Named pipe for inter-process communication |
| Socket | `s` | Network communication endpoint |

### 1.3 Identifying File Types

```bash
# Use the 'file' command to determine file type
$ file .profile
.profile: ASCII text

$ file /bin/bash
/bin/bash: ELF 64-bit LSB pie executable, x86-64

$ file /home
/home: directory
```

---

## 2. Directory Hierarchy Structure

### 2.1 The Directory Tree

```
/                          # Root directory (top of the hierarchy)
├── bin/                   # Essential user command binaries (-> /usr/bin)
├── boot/                  # Boot loader files (kernel, initramfs)
├── dev/                   # Device files
├── etc/                   # System configuration files
├── home/                  # User home directories
│   ├── user1/
│   └── user2/
├── lib/                   # Essential shared libraries
├── media/                 # Mount point for removable media
├── mnt/                   # Temporary mount point
├── opt/                   # Optional/add-on packages
├── proc/                  # Virtual filesystem for process/kernel info
├── root/                  # Root user's home directory
├── run/                   # Runtime data for running services
├── srv/                   # Service data (FTP, web)
├── sys/                   # Kernel and device information
├── tmp/                   # Temporary files (cleared on reboot)
├── usr/                   # User System Resources
│   ├── bin/               # User commands
│   ├── lib/               # Libraries
│   └── local/             # Locally installed software
└── var/                   # Variable data (logs, spool, cache)
    └── log/               # System log files
```

### 2.2 Key Directories

| Directory | Purpose | Notes |
|-----------|---------|-------|
| `/` | Root of the filesystem | Everything starts here |
| `/home` | User home directories | Each user gets `/home/username` |
| `/etc` | Configuration files | System-wide settings |
| `/var` | Variable data | Logs, mail, databases |
| `/tmp` | Temporary files | Cleared on reboot |
| `/proc` | Process information | Virtual filesystem (in memory only) |
| `/usr` | Unix System Resources | Executables, libraries, docs |
| `/root` | Root user home | Different from `/` (root directory) |

> **Key Point:** `/proc` exists only in memory, not on the hard disk. It provides real-time kernel and process information.

---

## 3. Absolute and Relative Paths

### 3.1 Absolute Path

- **Always starts with `/`** (root directory)
- Specifies the complete path from root to the target
- Always refers to the same location regardless of current directory

```bash
/home/user1/Documents/report.txt
/etc/hostname
/usr/bin/ls
```

### 3.2 Relative Path

- **Does NOT start with `/`**
- Relative to the current working directory
- Uses `.` (current directory) and `..` (parent directory)

```bash
# If current directory is /home/user1
Documents/report.txt        # Same as /home/user1/Documents/report.txt
../user2/file.txt           # Same as /home/user2/file.txt
./script.sh                 # Same as /home/user1/script.sh
```

### 3.3 Special Directory Symbols

| Symbol | Meaning | Example |
|--------|---------|---------|
| `.` | Current directory | `./script.sh` |
| `..` | Parent directory | `cd ..` |
| `~` | Home directory | `cd ~` or `cd` |
| `~user` | Another user's home | `cd ~user2` |
| `-` | Previous directory | `cd -` |

---

## 4. File and Directory Naming Rules

### 4.1 Rules

- Cannot use `/` in names (it is the path separator)
- Can use letters, digits, hyphens (`-`), underscores (`_`), periods (`.`)
- Avoid special characters: `> | : & space`
- **Case-sensitive:** `File.txt` and `file.txt` are different files
- Names starting with `.` are hidden files
- Cannot use null character (`\0`)
- Maximum filename length: typically 255 characters

### 4.2 Examples

| Good Names | Bad Names | Invalid Names |
|------------|-----------|---------------|
| `game.txt` | `&game` | `myhome/` |
| `hello.c` | `*dir` | `/test` |
| `test` | `my home` | `bad/name` |
| `sample11` | `game\` | |

---

## 5. Directory Commands

### 5.1 pwd -- Print Working Directory

```bash
$ pwd
/home/user1
```

### 5.2 cd -- Change Directory

```bash
cd /tmp                 # Absolute path
cd ../usr/lib           # Relative path
cd ~                    # Home directory
cd                      # Home directory (shortcut)
cd -                    # Previous directory
cd ..                   # Parent directory
```

### 5.3 ls -- List Directory Contents

```bash
ls                      # List current directory
ls -a                   # Show hidden files (starting with .)
ls -l                   # Long format (detailed info)
ls -la                  # Long format + hidden files
ls -lh                  # Human-readable file sizes
ls -R                   # Recursive listing
ls -F                   # Append type indicator (*=exec, /=dir, @=link)
ls -i                   # Show inode numbers
ls -d                   # Show directory itself, not contents
ls -t                   # Sort by modification time
ls -S                   # Sort by file size
```

**Understanding `ls -l` output:**

```
drwxr-xr-x  2  user1  user1  4096  Mar 21 12:05  Documents
│└─┬──┘└┬─┘ │   │       │      │       │            │
│  │    │   │   │       │      │       │            └── filename
│  │    │   │   │       │      │       └── last modified
│  │    │   │   │       │      └── size (bytes)
│  │    │   │   │       └── group owner
│  │    │   │   └── file owner
│  │    │   └── hard link count
│  │    └── other permissions (r-x)
│  └── group permissions (r-x)
│       owner permissions (rwx)
└── file type (d=directory, -=file, l=link)
```

### 5.4 mkdir -- Create Directories

```bash
mkdir mydir                     # Create single directory
mkdir -p parent/child/grandchild  # Create nested directories
mkdir dir1 dir2 dir3            # Create multiple directories
```

### 5.5 rmdir -- Remove Empty Directories

```bash
rmdir mydir                     # Remove empty directory only
rmdir -p parent/child/grandchild  # Remove nested empty directories
```

### 5.6 Similar Commands: dir, vdir

```bash
dir                 # Similar to ls (no color by default)
vdir                # Similar to ls -l
```

---

## 6. File Content Commands

### 6.1 cat -- Concatenate and Display

```bash
cat file.txt                    # Display entire file
cat -n file.txt                 # Show line numbers
cat file1.txt file2.txt         # Concatenate multiple files
cat > newfile.txt               # Create file from stdin (Ctrl+D to end)
cat >> existingfile.txt         # Append to file from stdin
```

### 6.2 more and less -- Page Through Files

```bash
more file.txt                   # Page forward only
less file.txt                   # Page forward and backward (recommended)
```

**less navigation:**

| Key | Action |
|-----|--------|
| `Space` / `f` | Next page |
| `b` | Previous page |
| `g` | Go to beginning |
| `G` | Go to end |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next search result |
| `q` | Quit |

### 6.3 head and tail -- View File Portions

```bash
head file.txt                   # First 10 lines (default)
head -n 20 file.txt             # First 20 lines
head -n -5 file.txt             # All lines except last 5

tail file.txt                   # Last 10 lines (default)
tail -n 20 file.txt             # Last 20 lines
tail -f /var/log/syslog         # Follow log in real-time
```

> **Key Point:** `tail -f` is invaluable for monitoring log files in real-time.

---

## 7. Best Practices

### 7.1 Navigation Tips

- Use `Tab` completion to avoid typos in paths
- Use `cd -` to toggle between two directories
- Use `pushd` and `popd` for directory stack management
- Prefer absolute paths in scripts for reliability

### 7.2 Common Mistakes

| Mistake | Correct Approach |
|---------|-----------------|
| Using spaces in filenames | Use underscores or hyphens |
| Forgetting case sensitivity | Linux is case-sensitive |
| Confusing `/root` with `/` | `/root` is root's home; `/` is filesystem root |
| Using `rm -rf /` | Never run this -- it deletes everything |

---

## Summary

| Concept | Key Point |
|---------|-----------|
| File Types | Regular files, directories, symbolic links, device files |
| Directory Tree | Hierarchical structure starting from `/` |
| Absolute Path | Full path from root (`/home/user1/file.txt`) |
| Relative Path | Path relative to current directory (`../file.txt`) |
| Hidden Files | Names starting with `.` (view with `ls -a`) |
| `pwd` | Print current working directory |
| `cd` | Change directory (absolute, relative, `~`, `-`, `..`) |
| `ls` | List directory contents (`-l`, `-a`, `-R`, `-F`) |
| `mkdir` / `rmdir` | Create / remove directories |
| `cat` / `less` | View file contents (full / paged) |
| `head` / `tail` | View first / last lines of a file |

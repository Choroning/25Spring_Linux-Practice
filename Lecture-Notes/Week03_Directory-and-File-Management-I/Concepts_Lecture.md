# Week 3 Lecture — Directory and File Management I

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 2

> **Learning Objectives:**
> 1. Explain the types and characteristics of Linux files and check a file's type with the `file` command
> 2. Explain the directory hierarchy of the Linux file system and the purposes of the key directories
> 3. Write absolute and relative paths and distinguish between them
> 4. Use the directory commands (pwd, cd, ls, mkdir, rmdir)
> 5. Use the file content commands (cat, more, less, head, tail)

---

## Table of Contents

- [1. Linux Files and Directories](#1-linux-files-and-directories)
  - [1.1 Everything is a File](#11-everything-is-a-file)
  - [1.2 File Types](#12-file-types)
  - [1.3 Identifying File Types](#13-identifying-file-types)
- [2. Directory Hierarchy Structure](#2-directory-hierarchy-structure)
  - [2.1 The Directory Tree](#21-the-directory-tree)
  - [2.2 Key Directories](#22-key-directories)
- [3. Absolute and Relative Paths](#3-absolute-and-relative-paths)
  - [3.1 Absolute Path](#31-absolute-path)
  - [3.2 Relative Path](#32-relative-path)
  - [3.3 Special Directory Symbols](#33-special-directory-symbols)
- [4. File and Directory Naming Rules](#4-file-and-directory-naming-rules)
  - [4.1 Rules](#41-rules)
  - [4.2 Examples](#42-examples)
- [5. Directory Commands](#5-directory-commands)
  - [5.1 pwd: Print Working Directory](#51-pwd-print-working-directory)
  - [5.2 cd: Change Directory](#52-cd-change-directory)
  - [5.3 ls: List Directory Contents](#53-ls-list-directory-contents)
  - [5.4 mkdir: Create Directories](#54-mkdir-create-directories)
  - [5.5 rmdir: Remove Empty Directories](#55-rmdir-remove-empty-directories)
  - [5.6 Similar Commands: dir, vdir](#56-similar-commands-dir-vdir)
- [6. File Content Commands](#6-file-content-commands)
  - [6.1 cat: Concatenate and Display](#61-cat-concatenate-and-display)
  - [6.2 more and less: Page Through Files](#62-more-and-less-page-through-files)
  - [6.3 head and tail: View File Portions](#63-head-and-tail-view-file-portions)
- [7. Best Practices](#7-best-practices)
  - [7.1 Navigation Tips](#71-navigation-tips)
  - [7.2 Common Mistakes](#72-common-mistakes)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. Linux Files and Directories

### 1.1 Everything is a File

A **file** is a collection of related information. In Linux, almost everything is treated as a file, including devices and directories. A directory is also a kind of file that holds information about the files and subdirectories stored in it, and devices such as hard disks and keyboards are handled as device files. In Linux, an extension is only a convention and does not determine a file's type, so many files have no extension.

### 1.2 File Types

| Type | Symbol in `ls -l` | Description |
|------|-------------------|-------------|
| Regular file | `-` | Text files, executables, images, data files |
| Directory | `d` | Contains references to other files and directories |
| Symbolic link | `l` | A file that points to an original file under another name (like a Windows shortcut) |
| Block device | `b` | Device read and written in blocks (e.g., hard disk `/dev/sda`) |
| Character device | `c` | Device read and written character by character (e.g., keyboard, terminal) |
| Pipe | `p` | Named pipe for inter-process communication |
| Socket | `s` | Socket file used for inter-process communication (Unix domain socket) |

*Table 1. Linux file types and their symbols in ls -l*

### 1.3 Identifying File Types

The `file` command examines the contents of a file and reports its type.

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

<br>

## 2. Directory Hierarchy Structure

### 2.1 The Directory Tree

Linux directories form a tree-shaped hierarchy with the root directory at the top.

- **Root directory:** The top-level directory of the hierarchy, written as `/`.
- **Subdirectory:** A directory located below a particular directory.
- **Parent and child directories:** The directory immediately above a directory is its parent directory (upper directory), and a directory immediately below it is its child directory (lower directory).
- **Working directory:** The directory you are currently working in; check it with the `pwd` command.
- **Home directory:** The default directory assigned to a user account; it becomes the first working directory after login.

```text
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
├── usr/                   # Unix System Resources
│   ├── bin/               # User commands
│   ├── lib/               # Libraries
│   └── local/             # Locally installed software
└── var/                   # Variable data (logs, spool, cache)
    └── log/               # System log files
```

*Figure 1. The Linux directory tree*

Ubuntu keeps `/bin`, `/sbin`, and `/lib` as symbolic links to `/usr/bin`, `/usr/sbin`, and `/usr/lib`, respectively. The `-> /usr/bin` in Figure 1 shows this relationship, and `ls -F /` lists such entries with an `@` after the name, as in `bin@`.

### 2.2 Key Directories

| Directory | Purpose | Notes |
|-----------|---------|-------|
| `/` | Root of the file system | Everything starts here |
| `/home` | User home directories | Each user gets `/home/username` |
| `/etc` | Configuration files | System-wide settings |
| `/var` | Variable data | Logs, mail, databases |
| `/tmp` | Temporary files | Cleared on reboot |
| `/proc` | Process information | Virtual file system (in memory only) |
| `/usr` | Unix System Resources | Basic executables, libraries, header files, docs |
| `/root` | Root user home | Different from `/` (root directory) |
| `/lost+found` | Recovered files | Stores problem files when a damaged file system is repaired; usually empty |

*Table 2. Purposes of the key directories*

> **Note:** usr is sometimes expanded as Unix System Resources, but the name originally comes from early Unix, where the home directories of users were kept there.

> **Key Point:** `/proc` is not stored on the hard disk; it is a virtual file system that the kernel generates in memory. It provides real-time kernel and process information.

---

<br>

## 3. Absolute and Relative Paths

### 3.1 Absolute Path

- **It always starts with `/`.** `/` is the root directory.
- It lists the names of all intermediate directories from the root directory down to the target file or directory.
- It always refers to the same location regardless of the current directory.

```text
/home/user1/Documents/report.txt
/etc/hostname
/usr/bin/ls
```

### 3.2 Relative Path

- **It does NOT start with `/`.**
- It is relative to the current working directory. To go down into a subdirectory, start directly with its name; to go up to a parent directory, start with `..`.
- It uses `.` (current directory) and `..` (parent directory), and the relative path to the same target differs depending on the current directory.

```text
# If current directory is /home/user1
Documents/report.txt        # Same as /home/user1/Documents/report.txt
../user2/file.txt           # Same as /home/user2/file.txt
./script.sh                 # Same as /home/user1/script.sh
```

For example, if the current directory is `/usr/lib`, `/usr/bin/ls` can be referred to with the relative path `../bin/ls`.

### 3.3 Special Directory Symbols

| Symbol | Meaning | Example |
|--------|---------|---------|
| `.` | Current directory | `./script.sh` |
| `..` | Parent directory | `cd ..` |
| `~` | Home directory | `cd ~` or `cd` |
| `~user` | Another user's home | `cd ~user2` |
| `-` | Previous directory | `cd -` |

*Table 3. Special directory symbols*

---

<br>

## 4. File and Directory Naming Rules

### 4.1 Rules

- Names cannot contain `/`, because it is the path separator.
- Names can use letters, digits, hyphens (`-`), underscores (`_`), and periods (`.`).
- Special characters other than `/` are allowed, but it is better to avoid `>`, `|`, `:`, `&`, and the space character.
- **Case-sensitive:** `File.txt` and `file.txt` are different files.
- Names starting with `.` are treated as hidden files.
- The null character (`\0`) cannot be used.
- The maximum filename length is typically 255 bytes (on ext4). In UTF-8 a Korean character takes 3 bytes, so Korean names can be shorter.

### 4.2 Examples

| Good Names | Bad Names | Invalid Names |
|------------|-----------|---------------|
| `game.txt` | `&game` | `myhome/` |
| `hello.c` | `*dir` | `/test` |
| `test` | `my home` | `bad/name` |
| `sample11` | `game\` | |

*Table 4. Examples of good, bad, and invalid names*

---

<br>

## 5. Directory Commands

### 5.1 pwd: Print Working Directory

`pwd` (print working directory) prints the absolute path of the current directory.

```bash
$ pwd
/home/user1
```

### 5.2 cd: Change Directory

```bash
cd /tmp                 # Absolute path
cd ../usr/lib           # Relative path
cd ~                    # Home directory
cd                      # Home directory (shortcut)
cd -                    # Previous directory
cd ..                   # Parent directory
```

The `cd ../usr/lib` above moves from `/tmp` to `/usr/lib` by way of the parent directory `/`.

### 5.3 ls: List Directory Contents

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

In addition, `-A` lists all files except `.` and `..`, and `-L` shows the information of the original file for a symbolic link. Given a directory name as an argument, as in `ls /tmp`, `ls` lists that directory; given a filename, as in `ls .bashrc`, it checks whether the file exists (if not, an error such as `ls: cannot access 'game': No such file or directory` appears). Several options can be combined, as in `ls -ld /`.

**Understanding `ls -l` output:**

```text
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

*Figure 2. Fields of the ls -l output*

### 5.4 mkdir: Create Directories

```bash
mkdir mydir                     # Create single directory
mkdir -p parent/child/grandchild  # Create nested directories
mkdir dir1 dir2 dir3            # Create multiple directories
```

Without `-p`, a path whose intermediate directories do not exist, such as `mkdir temp/mid/han`, fails with a `No such file or directory` error. With `-p`, `mkdir` automatically creates the missing intermediate directories and then the specified directory.

### 5.5 rmdir: Remove Empty Directories

```bash
rmdir mydir                     # Remove empty directory only
rmdir -p parent/child/grandchild  # Remove nested empty directories
```

`rmdir -p` removes the specified directory and then removes each parent directory in turn if it has become empty. A directory that is not empty cannot be removed with `rmdir` (`rmdir: failed to remove 'temp': Directory not empty`); use `rm -r`, covered in Week 4, instead.

### 5.6 Similar Commands: dir, vdir

```bash
dir                 # Similar to ls (no color by default)
vdir                # Similar to ls -l
```

---

<br>

## 6. File Content Commands

### 6.1 cat: Concatenate and Display

```bash
cat file.txt                    # Display entire file
cat -n file.txt                 # Show line numbers
cat file1.txt file2.txt         # Concatenate multiple files
cat > newfile.txt               # Create file from stdin (Ctrl+D to end)
cat >> existingfile.txt         # Append to file from stdin
```

### 6.2 more and less: Page Through Files

```bash
more file.txt                   # Page mainly forward
less file.txt                   # Page forward and backward (recommended)
```

`more` prints the contents screen by screen: `Space` shows the next screen, `Enter` scrolls one line, and a starting line number can be given, as in `more +20 file.txt`. When viewing a file, `b` goes back one screen, but input received through a pipe cannot be paged backward. Inside `less`, the following keys move and search.

| Key | Action |
|-----|--------|
| `Space` / `f` / `Ctrl + F` | Next page |
| `b` / `Ctrl + B` | Previous page |
| `j` / `↓` | Scroll down one line |
| `k` / `↑` | Scroll up one line |
| `g` | Go to beginning |
| `G` | Go to end |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next search result |
| `q` | Quit |

*Table 5. Navigation keys of less*

### 6.3 head and tail: View File Portions

```bash
head file.txt                   # First 10 lines (default)
head -n 20 file.txt             # First 20 lines
head -n -5 file.txt             # All lines except last 5

tail file.txt                   # Last 10 lines (default)
tail -n 20 file.txt             # Last 20 lines
tail -f /var/log/syslog         # Follow log in real-time
```

`head` and `tail` also accept a bare number as an option, such as `-20` instead of `-n 20`. Putting `+` before the count, as in `tail -n +20 file.txt`, prints from line 20 to the end. `tail -f` does not finish its output but keeps printing content newly appended to the file; stop it with `Ctrl + C`.

> **Key Point:** `tail -f` is useful for monitoring what content is being appended to a log file in real time.

---

<br>

## 7. Best Practices

### 7.1 Navigation Tips

- Use `Tab` completion to avoid typos in paths.
- Use `cd -` to toggle between two directories.
- Use `pushd` and `popd` to move around while managing a directory stack.
- In scripts, absolute paths are safer because they do not depend on the current directory.

### 7.2 Common Mistakes

| Mistake | Correct Approach |
|---------|-----------------|
| Using spaces in filenames | Use underscores or hyphens |
| Forgetting case sensitivity | Linux is case-sensitive |
| Confusing `/root` with `/` | `/root` is root's home; `/` is the root of the file system |
| Using `rm -rf /` | Never run it. The whole system can be deleted; GNU `rm` refuses to recursively delete `/` itself by default (`--preserve-root`) but does not stop `rm -rf /*` |

*Table 6. Common mistakes and correct approaches*

---

<br>

## Summary

| Concept | Key Summary |
|---------|-------------|
| File Types | There are regular files, directories, symbolic links, device files, and others, distinguished by the first character of `ls -l`. |
| Directory Tree | It is a hierarchical structure starting from `/`. |
| Absolute Path | It is the full path written from the root (`/home/user1/file.txt`). |
| Relative Path | It is a path written relative to the current directory (`../file.txt`). |
| Hidden Files | Their names start with `.`, and `ls -a` shows them. |
| `pwd` | It prints the absolute path of the current working directory. |
| `cd` | It changes the directory using an absolute path, a relative path, `~`, `-`, or `..`. |
| `ls` | It lists directory contents and has options such as `-l`, `-a`, `-R`, and `-F`. |
| `mkdir` / `rmdir` | They create directories and remove empty directories. |
| `cat` / `less` | They show file contents all at once or page by page. |
| `head` / `tail` | They show the first or last lines of a file. |

---

<br>

## Self-Check Questions

1. **Writing relative paths:** When the current directory is `/usr/lib`, write `/usr/bin/ls` and `/etc/hostname` as relative paths.

   <details>
   <summary>Answer</summary>

   `/usr/bin/ls` is `../bin/ls`, because `..` goes up to `/usr` and `bin/ls` goes down. `/etc/hostname` is `../../etc/hostname`, because two `..` go up to `/` and `etc/hostname` goes down.

   </details>

2. **Type indicators:** On Ubuntu, the output of `ls -F /` shows `bin@` and `boot/`. What do `@` and `/` mean, and what indicator is appended to an executable file?

   <details>
   <summary>Answer</summary>

   `@` means a symbolic link; it shows that `/bin` is a symbolic link to `/usr/bin`. `/` means a directory. An executable file has `*` appended to its name.

   </details>

3. **Behavior of rmdir:** There is an empty directory `a/b/c`, and `a` and `b` contain nothing else. What happens when you run `rmdir -p a/b/c`? What happens if `c` contains one file?

   <details>
   <summary>Answer</summary>

   First `a/b/c` is removed; then `b` becomes empty, so `a/b` is removed, and then `a` is removed too. If `c` contains a file, `c` is not empty, so nothing is removed and a `Directory not empty` error appears.

   </details>

4. **Navigating less:** With a file opened by `less /etc/services`, write in order the keystrokes that find the string `TCP`, move to the next search result, and quit `less`.

   <details>
   <summary>Answer</summary>

   Type `/TCP` and press `Enter` to search forward. Press `n` to move to the next search result. Press `q` to quit `less`.

   </details>

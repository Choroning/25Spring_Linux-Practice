# Week 3 Lecture — Directory and File Management I

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-11-19
>
> 우분투 리눅스, 이종원, Ch 2

> **Learning Objectives:**
> 1. Explain the types and characteristics of Linux files and check a file's type with the `file` command
> 2. Explain the directory hierarchy of the Linux file system and the purposes of the key directories
> 3. Write absolute and relative paths and distinguish between them
> 4. Use the directory commands (pwd, cd, ls, mkdir, rmdir)
> 5. Use the file content commands (cat, more, less, head, tail)
> 6. Apply the rules of path resolution and the detailed rules of `ls -l` output to predict the results of commands

---

## Table of Contents

- [1. Linux Files and Directories](#1-linux-files-and-directories)
  - [1.1 Everything is a File](#11-everything-is-a-file)
  - [1.2 File Types](#12-file-types)
  - [1.3 Identifying File Types](#13-identifying-file-types)
  - [1.4 What a Directory Is and Its Link Count](#14-what-a-directory-is-and-its-link-count)
  - [1.5 Device Files](#15-device-files)
- [2. Directory Hierarchy Structure](#2-directory-hierarchy-structure)
  - [2.1 The Directory Tree](#21-the-directory-tree)
  - [2.2 Key Directories](#22-key-directories)
  - [2.3 Filesystem Hierarchy Standard (FHS)](#23-filesystem-hierarchy-standard-fhs)
- [3. Absolute and Relative Paths](#3-absolute-and-relative-paths)
  - [3.1 Absolute Path](#31-absolute-path)
  - [3.2 Relative Path](#32-relative-path)
  - [3.3 Special Directory Symbols](#33-special-directory-symbols)
  - [3.4 Rules of Path Resolution](#34-rules-of-path-resolution)
  - [3.5 Paths Through Symbolic Links: Logical and Physical Paths](#35-paths-through-symbolic-links-logical-and-physical-paths)
- [4. File and Directory Naming Rules](#4-file-and-directory-naming-rules)
  - [4.1 Rules](#41-rules)
  - [4.2 Examples](#42-examples)
  - [4.3 Handling Names with Spaces and Special Characters](#43-handling-names-with-spaces-and-special-characters)
- [5. Directory Commands](#5-directory-commands)
  - [5.1 pwd: Print Working Directory](#51-pwd-print-working-directory)
  - [5.2 cd: Change Directory](#52-cd-change-directory)
  - [5.3 ls: List Directory Contents](#53-ls-list-directory-contents)
  - [5.4 mkdir: Create Directories](#54-mkdir-create-directories)
  - [5.5 rmdir: Remove Empty Directories](#55-rmdir-remove-empty-directories)
  - [5.6 Similar Commands: dir, vdir](#56-similar-commands-dir-vdir)
  - [5.7 Detailed Rules of ls -l Output](#57-detailed-rules-of-ls--l-output)
  - [5.8 Detailed Behavior of cd, mkdir, and rmdir](#58-detailed-behavior-of-cd-mkdir-and-rmdir)
- [6. File Content Commands](#6-file-content-commands)
  - [6.1 cat: Concatenate and Display](#61-cat-concatenate-and-display)
  - [6.2 more and less: Page Through Files](#62-more-and-less-page-through-files)
  - [6.3 head and tail: View File Portions](#63-head-and-tail-view-file-portions)
  - [6.4 Detailed Options of cat, head, and tail](#64-detailed-options-of-cat-head-and-tail)
- [7. Best Practices](#7-best-practices)
  - [7.1 Navigation Tips](#71-navigation-tips)
  - [7.2 Common Mistakes](#72-common-mistakes)
- [Concept Applications](#concept-applications)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)
- [References](#references)

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

`file` determines the type not by looking at the extension but by comparing the bytes at the beginning of the file with the markers of known formats (magic numbers). For example, an executable file begins with the four bytes `0x7F E L F`, so even if it is renamed to `photo.jpg`, `file` still identifies it as an ELF executable, and a text file renamed to `a.png` is still identified as `ASCII text`. This is what Section 1.1 meant by saying that an extension does not determine a file's type.

### 1.4 What a Directory Is and Its Link Count

The content of a directory file is a table that lists pairs of "name and inode number". An inode is the data structure holding a file's size, owner, permissions, times, and the location of its data blocks (Week 4), and the name of a file is stored not in its inode but in the table of the directory that contains the file. The table of every directory always contains `.`, which refers to the directory itself, and `..`, which refers to its parent directory; the `..` of the root directory refers to the root itself.

```text
Contents of directory /home/user1/ch2/d1 (name → inode number)
┌──────┬──────────┐
│ .    │ 1310722  │ ← d1 itself
│ ..   │ 1310721  │ ← parent ch2
│ a    │ 1310723  │
│ b    │ 1310724  │
│ c    │ 1310725  │
│ f    │ 1310726  │
└──────┴──────────┘
```

*Figure 1. Table of names and inode numbers stored in a directory file*

The link count, the second field of `ls -l`, is the number of names that refer to the inode. The names that refer to the directory `d1` are `d1` in the parent directory's table, `.` in its own table, and the `..` in the table of each of its subdirectories. On Linux file systems such as ext4, the link count of a directory is therefore as follows.

```math
\text{link count of a directory} = 2 + (\text{number of immediate subdirectories})
```

Checking `d1`, which contains the subdirectories `a`, `b`, and `c` and the regular file `f`, gives the following (Ubuntu 24.04, ext4).

```text
$ ls -la d1
total 20
drwxrwxr-x 5 user1 user1 4096 Mar 21 12:05 .
drwxrwxr-x 3 user1 user1 4096 Mar 21 12:05 ..
drwxrwxr-x 2 user1 user1 4096 Mar 21 12:05 a
drwxrwxr-x 2 user1 user1 4096 Mar 21 12:05 b
drwxrwxr-x 2 user1 user1 4096 Mar 21 12:05 c
-rw-rw-r-- 1 user1 user1    0 Mar 21 12:05 f
```

- The link count of `.` (that is, `d1`) is 2 + 3 = 5. The regular file `f` has no `..`, so it does not affect the link count.
- The link count of `a`, `b`, and `c`, which have no subdirectories, is 2 + 0 = 2.
- `..` (that is, `ch2`) has only `d1` as a subdirectory, so its count is 3.
- On ext4 the size of a directory is the size of the blocks holding its name table, so a directory with few entries occupies one block of 4096 bytes. The size of a directory is not the sum of the sizes of the files in it.

> **Caution:** "Link count of a directory = 2 + number of subdirectories" is a rule of Unix-like file systems such as ext4 that keep `.` and `..` as real entries. It does not hold on file systems that report link counts differently, such as APFS on macOS.

### 1.5 Device Files

A device file has no data blocks; it holds only two numbers that refer to a device driver in the kernel. The **major number** tells which driver handles the device, and the **minor number** tells which of the devices handled by that driver it is. `ls -l` prints `major, minor` in place of the size of a device file.

```text
$ ls -l /dev/sda /dev/sda1 /dev/null /dev/zero /dev/tty
brw-rw---- 1 root disk 8, 0 Mar 21 09:00 /dev/sda
brw-rw---- 1 root disk 8, 1 Mar 21 09:00 /dev/sda1
crw-rw-rw- 1 root root 1, 3 Mar 21 09:00 /dev/null
crw-rw-rw- 1 root root 1, 5 Mar 21 09:00 /dev/zero
crw-rw-rw- 1 root tty  5, 0 Mar 21 09:00 /dev/tty
```

- `/dev/sda` (the first SCSI or SATA disk) and its first partition `/dev/sda1` are block devices that share the major number 8 and distinguish the whole disk and the partition by the minor number. The naming rules of disk devices are covered in Week 10.
- `/dev/null` is a character device that discards everything written to it and immediately returns end of file when read; it is used to discard unwanted output (`command 2> /dev/null`, Week 4).
- `/dev/zero` returns zero bytes endlessly whenever it is read. It is used to create empty files of a given size (`dd` in Week 15).
- `/dev/tty` refers to the terminal to which the current process is attached.

A block device is one that the kernel buffers in blocks so that any position can be read and written, and a character device is one that is read and written sequentially as a stream of bytes. The permissions of a device file (Week 7) are the access permissions to the device itself, so the disk `/dev/sda` can be read and written only by root and the `disk` group, while every user can write to `/dev/null`.

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
├── proc/                  # Virtual file system for process/kernel info
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

*Figure 2. The Linux directory tree*

Ubuntu keeps `/bin`, `/sbin`, and `/lib` as symbolic links to `/usr/bin`, `/usr/sbin`, and `/usr/lib`, respectively. The `-> /usr/bin` in Figure 2 shows this relationship, and `ls -F /` lists such entries with an `@` after the name, as in `bin@`.

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

### 2.3 Filesystem Hierarchy Standard (FHS)

> **Definition:** The **Filesystem Hierarchy Standard (FHS)** is the standard that defines in which directory a Linux distribution should place each kind of file. The Linux manual page `hier(7)` describes each directory on the basis of version 3.0, published on March 19, 2015 [1].

To assign directories, the FHS classifies files by two criteria. One is whether several computers can share them (shareable or unshareable), and the other is whether they change while the system runs (static or variable) [2]. For example, `/usr` should hold only shareable, read-only data so that several Linux computers can mount it together, and `/var` holds files whose size changes, such as logs and spools [1]. Knowing these criteria makes it possible to guess the purpose of an unfamiliar directory.

| | Shareable | Unshareable |
|:-----|:-----|:-----|
| **Static** | `/usr`, `/opt` (programs and libraries) | `/etc`, `/boot` (the computer's own configuration and boot files) |
| **Variable** | `/var/mail` (users' mailboxes) | `/var/log`, `/run` (the computer's own logs and run-time state) |

*Table 3. Classification of directories by shareability and variability*

The purposes of directories not in Table 2 are as follows [1].

| Directory | Purpose |
|:-----|:-----|
| `/boot` | Static files used by the boot loader (kernel image, initrd) |
| `/dev` | Device files (Section 1.5) |
| `/media` | Mount points for removable media such as CDs, DVDs, and USB sticks. Ubuntu Desktop automatically mounts a USB stick at `/media/username/volumename` when it is plugged in |
| `/mnt` | A mount point where the administrator temporarily mounts a file system |
| `/opt` | Add-on software packages consisting of static files |
| `/run` | Files describing the state of the system since boot (PID files and the like). It replaces the former `/var/run` |
| `/srv` | Data of the services this system provides (files of web and FTP servers) |
| `/sys` | The mount point of sysfs, a virtual file system that presents kernel and device information in a structured way |
| `/usr/local` | Programs installed locally on that computer. The distribution's package manager does not touch it |
| `/var/tmp` | Holds temporary files like `/tmp`, but is not cleared on reboot, so it is used for temporary files kept for a long time |

*Table 4. Other key directories*

Files in `/tmp` may be deleted without notice by a regular job or at boot [1]. Ubuntu 24.04 empties `/tmp` at boot [3], so temporary files that must survive a reboot should be kept in `/var/tmp` or the home directory.

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

*Table 5. Special directory symbols*

### 3.4 Rules of Path Resolution

The process by which the kernel turns a path into a file is called **path resolution**. If the path starts with `/`, resolution starts at the root directory, and otherwise at the current working directory; each `/`-separated name is then looked up in the table (Section 1.4) of the current directory, and resolution moves to the next directory. The following rules apply in this process.

1. Several consecutive `/` characters count as one. `/usr//bin` is the same as `/usr/bin`.
2. `.` stays in the current directory, and `..` moves to the parent directory. The `..` of the root is the root, so `/..` and `/../..` are both `/`.
3. Every intermediate name must be a directory (or a symbolic link to a directory), and one must have execute permission (`x`) on that directory to pass through it (Week 7).
4. A trailing `/` means that the last name must be a directory. `ls file.txt/` gives a `Not a directory` error if `file.txt` is a regular file.

For example, `/usr/./lib/../bin//ls` is resolved in the order `/` → `usr` → `.` (still `/usr`) → `lib` (`/usr/lib`) → `..` (`/usr`) → `bin` (`/usr/bin`, the doubled `/` counts as one) → `ls`, which gives `/usr/bin/ls`. The `realpath` command prints the result of this resolution as an absolute path without `.`, `..`, or symbolic links.

```text
$ realpath /usr/./lib/../bin//ls
/usr/bin/ls
$ cd /usr/lib
$ realpath ../../etc/hostname
/etc/hostname
```

The tilde `~` is not part of the rules of path resolution. It is the shell, not the kernel, that replaces `~` with the home directory (Week 6), and the shell replaces only a `~` that is at the beginning of a word and not quoted. Therefore `cd "~"` tries to go not to the home directory but to a directory named `~` inside the current directory, and the `~` in `a~b` stays as it is.

### 3.5 Paths Through Symbolic Links: Logical and Physical Paths

On Ubuntu, `/bin` is a symbolic link to `usr/bin` (Section 2.1). In a directory entered through a symbolic link, "the path traveled" and "the actual location" differ.

- **Logical path:** The path formed by joining the names traveled, as they are. The `cd` and `pwd` of Bash use the logical path by default (`-L`).
- **Physical path:** The path obtained by following all symbolic links to the actual directories. `pwd -P` and `cd -P` use the physical path, and the kernel's path resolution always follows the physical path.

```text
$ cd /bin
$ pwd
/bin
$ pwd -P
/usr/bin
$ ls /bin/.. | head -3
bin
games
include
$ cd ..
$ pwd
/
```

`ls /bin/..` prints the contents of `/usr` (`bin`, `games`, `include`, ...) because the kernel follows `/bin` to `/usr/bin` and then goes to its parent. Bash's `cd ..`, on the other hand, deletes the last name from the logical path `/bin` and goes to `/`. The same `..` gives different results depending on whether the kernel or the shell interprets it.

> **Caution:** If a script moves with `cd` and then uses the relative path `..` as an argument of another command, `cd ..` and `ls ..` may refer to different directories. When the actual location matters, use `cd -P` or fix the path first with `realpath`.

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

*Table 6. Examples of good, bad, and invalid names*

### 4.3 Handling Names with Spaces and Special Characters

The shell splits the command line into arguments at spaces and interprets characters such as `*`, `?`, `&`, `>`, `|`, and `;` specially (Week 6). The bad names in Table 6 can therefore be created on the file system, but every time they are used on the command line, the shell must be prevented from interpreting them differently.

```text
$ touch 'my home'
$ ls my home
ls: cannot access 'my': No such file or directory
ls: cannot access 'home': No such file or directory
$ ls 'my home'
'my home'
$ ls my\ home
'my home'
```

- `ls my home` fails while looking for two files, because the shell splits at the space and passes the two arguments `my` and `home`. Enclosing the whole name in single quotes or putting `\` before the space makes it a single argument.
- When its output is a terminal, GNU `ls` prints names containing special characters such as spaces in a form that can be typed back into the shell (`'my home'`), and when its output is a pipe or a file, it prints names without quotes. The quotes are not part of the name.

If a name starts with `-`, it is the command, not the shell, that interprets the name as an option.

```text
$ touch -- -file
$ rm -file
rm: invalid option -- 'l'
Try 'rm ./-file' to remove the file '-file'.
Try 'rm --help' for more information.
$ rm -- -file
```

`rm -file` is interpreted as a bundle of four options `-f`, `-i`, `-l`, and `-e`, and because `rm` has no `-l` option, an error occurs. Most commands treat `--` as "the end of options" and handle every argument after it as a name, so the file can be removed with `rm -- -file`. As the error message suggests, another method is to prefix a path, as in `./-file`, so that the name no longer starts with `-`. The `--` in `touch -- -file` is needed for the same reason.

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

*Figure 3. Fields of the ls -l output*

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

### 5.7 Detailed Rules of ls -l Output

The fields of Figure 3 follow some rules that are confusing at first. The following are the rules of GNU `ls` (coreutils on Ubuntu 24.04).

- **Time display.** By default, `ls -l` prints the last modification time (mtime). If the time is less than six months old, it prints the month, day, and time, as in `Mar 21 12:05`; if it is six months old or more, or in the future, it prints the month, day, and year, as in `Mar 21  2024`. Within one listing, some lines may therefore show a time and others a year. With `--time-style=long-iso`, the format is always `2025-03-21 12:05`.
- **The `total` line.** The first line of `ls -l`, `total N`, is the sum of the disk blocks occupied by the listed files, in units of 1024 bytes by default. In `ls -la d1` of Section 1.4, five directories (`.`, `..`, `a`, `b`, `c`) occupy 4 KiB each and the empty file `f` occupies 0, so the line is `total 20`. This value is not the sum of the file sizes.
- **Size units.** `-h` abbreviates sizes in units of powers of 1024 (`K`, `M`, `G`), and `--si` in units of powers of 1000 [4]. 1,550,000 bytes is shown as `1.5M` with `-h` (1,550,000 / 1,048,576 ≈ 1.48, rounded up) and as `1.6M` with `--si` (1.55, rounded up). Both options round up to one decimal place.
- **Sorting.** The default is by name, in the order of the locale. In Korean or English UTF-8 locales, the order is a dictionary order that mostly ignores case, while in the C locale, as in `LC_ALL=C ls`, it is the order of byte values, so all names beginning with an uppercase letter come before names beginning with a lowercase letter. `-t` sorts from the most recently modified, `-S` from the largest, and `-r` reverses the order.
- **Directory arguments.** `ls -l dir` prints the list of files in `dir`, and `ls -ld dir` prints the information of `dir` itself. To check the permissions or owner of a directory, `-d` is needed.

```text
$ ls -l --time-style=long-iso /etc/hostname
-rw-r--r-- 1 root root 9 2025-03-11 14:20 /etc/hostname
$ ls -ld /tmp
drwxrwxrwt 18 root root 4096 Mar 21 12:30 /tmp
```

The size of 9 bytes of `/etc/hostname` is the eight characters of the computer name `myubuntu` plus one newline character. The `t` at the end of the permissions of `/tmp` is the sticky bit of Week 7.

### 5.8 Detailed Behavior of cd, mkdir, and rmdir

- **`cd`.** `cd` without arguments goes to the directory given by the environment variable `HOME`. `cd -` goes to the previous directory stored in the environment variable `OLDPWD` and prints its path. `cd` is a shell builtin. If it were run as a new program, only that program's working directory would change and the shell's would stay the same, so a command that changes the working directory must run inside the shell (Week 6).
- **`mkdir`.** `-p` not only creates intermediate directories but also raises no error when the directory to be created already exists. Scripts therefore use `mkdir -p` to mean "create it if it does not exist". `-v` prints each directory it creates, and permissions can be specified with `-m`, as in `-m 700` (Week 7).
- **`rmdir`.** It does not remove a directory that is not empty. When `rmdir -p` removes parents in turn and meets a parent that is not empty, it reports an error.

```text
$ mkdir temp/mid/han
mkdir: cannot create directory 'temp/mid/han': No such file or directory
$ mkdir -pv temp/mid/han
mkdir: created directory 'temp'
mkdir: created directory 'temp/mid'
mkdir: created directory 'temp/mid/han'
$ mkdir -p temp/mid/han
$ rmdir temp
rmdir: failed to remove 'temp': Directory not empty
$ rmdir -p temp/mid/han
$ ls -d temp
ls: cannot access 'temp': No such file or directory
```

The second `mkdir -p temp/mid/han` does nothing and finishes quietly because the directory already exists. `rmdir -p temp/mid/han` removes `han`, `mid`, and `temp` in turn.

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

*Table 7. Navigation keys of less*

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

### 6.4 Detailed Options of cat, head, and tail

The options of `cat` are useful for checking invisible characters. Applied to a file `t.txt` that contains tab characters, a trailing space, and consecutive blank lines, they give the following.

```text
$ cat -A t.txt
name^Iscore $
$
kim^I90$
$
$
lee^I85$
$ cat -n t.txt
     1	name	score
     2
     3	kim	90
     4
     5
     6	lee	85
$ cat -b t.txt
     1	name	score

     2	kim	90


     3	lee	85
$ cat -s t.txt
name	score

kim	90

lee	85
```

- `-A` shows tabs as `^I` and line ends as `$`, and turns other control characters into `^` notation as well. In `score $` on the first line, the space before `$` is a space left at the end of the line. It is used to find the cause when a shell script or a configuration file does not work because of invisible characters.
- `-n` numbers all lines, and `-b` numbers only lines that are not blank.
- `-s` squeezes consecutive blank lines into one. The two blank lines 4 and 5 have become one.

`head` and `tail` can also count bytes instead of lines. `head -c 100` prints the first 100 bytes, and `tail -c 100` the last 100 bytes. A negative number, as in `head -n -5`, means "all but the last five lines", and a `+`, as in `tail -n +5`, means "from line 5 to the end", so the two commands can be connected to extract a specific range of lines from a file.

```text
$ head -n 7 /etc/passwd | tail -n +5
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
```

The command prints from the fifth line among the first seven, so lines 5-7 appear. In general, lines m through n are extracted with `head -n n | tail -n +m`.

`tail -f` follows the file it first opened, not the file's name. When a log rotation program renames the log file and creates a new file with the same name, `tail -f` keeps watching the renamed old file and does not show the new log. `tail -F` is equivalent to `--follow=name --retry`, so when the file is removed or replaced, it reopens the file of the same name and keeps following it [5]. For a log watched for a long time, `tail -F` is the right choice.

> **Caution:** Printing a binary file such as an executable with `cat` can make its bytes be interpreted as terminal control characters, so the characters on the screen may become garbled or the input may look strange. In that case, reset the terminal with the `reset` command. If the type of a file is unknown, check it first with `file`, and view the contents of binary files with `less` or `od`.

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
| Removing a file whose name starts with `-` with `rm -file` | `rm -- -file` or `rm ./-file` |
| Writing a name with spaces without quotes | `'my home'` or `my\ home` |
| Trying to go home with `cd "~"` | `cd ~` without quotes, or `cd` without arguments |
| Checking a directory's own permissions with `ls -l dir` | `ls -ld dir` |
| Keeping files needed after a reboot in `/tmp` | Keep them in `/var/tmp` or the home directory |

*Table 8. Common mistakes and correct approaches*

---

<br>

## Concept Applications

**True/False Check:**

| Statement | Judgment and Reason |
|:-----|:-----|
| A file's name is stored in the file's inode. | **F.** The name is stored in the table of the containing directory as a pair of "name and inode number". |
| On ext4, a directory with four subdirectories and ten regular files has a link count of 6. | **T.** The link count is 2 + the number of subdirectories, and regular files do not affect it. |
| `/../../etc` is a nonexistent path and gives an error. | **F.** The `..` of the root is the root itself, so this path is `/etc`. |
| On Ubuntu, `pwd` after `cd /bin; cd ..` prints `/usr`. | **F.** Bash's `cd` uses the logical path, so `..` from `/bin` is `/`. With `ls /bin/..`, the contents of `/usr` would appear. |
| The `8, 1` shown in the size position of a device file in `ls -l` means 8.1 KB. | **F.** A device file shows the major number 8 and the minor number 1 instead of a size. |
| `total 20` means that the sizes of the listed files add up to 20 bytes. | **F.** It is the sum of the disk blocks occupied by the files, in units of 1024 bytes. |
| `tail -F` follows the new file even when the log file is rotated and a new file with the same name appears. | **T.** `-F` is `--follow=name --retry`, so it reopens the file by name. |

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
| What a directory is | A directory is a table of names and inode numbers, and on ext4 its link count is 2 + the number of subdirectories. |
| Device files | They hold major and minor numbers that refer to a driver instead of data, and are divided into block devices (`b`) and character devices (`c`). |
| FHS | It is the standard that assigns directory purposes by shareability and by whether data are static or variable; `/usr` holds shareable static data and `/var` variable data. |
| Path resolution | It starts at the root or the current directory and looks up names one by one, treating consecutive `/` as one and the root's `..` as the root. |
| Logical and physical paths | Bash's `cd` and `pwd` use the logical path of the names traveled, while the kernel and `pwd -P` use the physical path that follows symbolic links. |
| Special names | Names with spaces are handled with quotes or `\`, and names starting with `-` with `--` or `./`. |
| Time and `total` in `ls -l` | Times older than six months are shown with the year, and `total` is the sum of blocks in units of 1024 bytes. |

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

5. **Directory link count:** In an empty directory `p`, `mkdir a b; mkdir a/x; touch f1 f2` was run. Find the link counts of `p`, `a`, `b`, and `a/x` (ext4).

   <details>
   <summary>Answer</summary>

   The link count is 2 + the number of immediate subdirectories. `p` has the subdirectories `a` and `b`, so its count is 4; `a` has one, `x`, so 3; and `b` and `a/x` have no subdirectories, so 2. The regular files `f1` and `f2` do not affect the link counts.

   </details>

6. **Path resolution:** With `/home/user1` as the current directory, write the absolute path to which each path refers. (a) `./../user2//docs/.` (b) `/../../tmp/../etc` (c) `../../../..`

   <details>
   <summary>Answer</summary>

   (a) `.` is `/home/user1` and `..` is `/home`; then the path goes down to `user2` and `docs`, and the final `.` stays, so it is `/home/user2/docs`. (b) The `..` of the root is the root, so the path becomes `/tmp/../etc`, and going up from `tmp` with `..` gives `/etc`. (c) Going up twice from `/home/user1` gives `/`, and the further `..` stays at `/`, so it is `/`.

   </details>

7. **Logical and physical paths:** On Ubuntu, `pwd`, `pwd -P`, and `ls ..` were run in turn after `cd /bin`. Explain each output.

   <details>
   <summary>Answer</summary>

   `pwd` prints the logical path `/bin` that Bash remembers, and `pwd -P` prints the physical path `/usr/bin` obtained by following the symbolic link. The `..` of `ls ..` is resolved by the kernel on the physical path, so the contents of `/usr`, the parent of `/usr/bin`, appear.

   </details>

8. **Device files:** The output of `ls -l /dev/sdb2` is `brw-rw---- 1 root disk 8, 18 ...`. State the meaning of the first character `b` and of `8, 18`, and decide whether the ordinary user user1 can read this device directly.

   <details>
   <summary>Answer</summary>

   `b` means a block device, and `8, 18` is the major number 8 (the SCSI and SATA disk driver) and the minor number 18. The permissions are `rw-rw----` with owner root and group `disk`, so user1, who does not belong to the `disk` group, cannot read it.

   </details>

9. **Extracting a line range:** Write a command with `head` and `tail` that prints only lines 12 through 15 of the file `data.txt`.

   <details>
   <summary>Answer</summary>

   It is `head -n 15 data.txt | tail -n +12`. `head -n 15` passes the first 15 lines, and `tail -n +12` prints from the 12th of them to the end, so the four lines 12-15 appear.

   </details>

---

<br>

## References

1. M. Kerrisk et al., "hier(7), Linux manual page," *The Linux man-pages project*. [Online]. Available: https://man7.org/linux/man-pages/man7/hier.7.html
2. The Linux Foundation, "Filesystem Hierarchy Standard," version 3.0, Mar. 2015. [Online]. Available: https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.html
3. Canonical, "tmpfiles.d/tmp.conf," systemd source package for Ubuntu 24.04 LTS. [Online]. Available: https://git.launchpad.net/ubuntu/+source/systemd/plain/tmpfiles.d/tmp.conf?h=applied/ubuntu/noble
4. R. M. Stallman and D. MacKenzie, "ls(1), GNU coreutils manual page." [Online]. Available: https://man7.org/linux/man-pages/man1/ls.1.html
5. P. Rubin, D. MacKenzie, I. L. Taylor, and J. Meyering, "tail(1), GNU coreutils manual page." [Online]. Available: https://man7.org/linux/man-pages/man1/tail.1.html

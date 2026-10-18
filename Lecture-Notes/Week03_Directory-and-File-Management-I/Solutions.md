# Week 3 Solutions — Directory and File Management I

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 2

---

<br>

## Table of Contents

- [Exercise 1: File Type Identification](#exercise-1-file-type-identification)
- [Exercise 2: Directory Hierarchy](#exercise-2-directory-hierarchy)
- [Exercise 3: Absolute vs. Relative Paths](#exercise-3-absolute-vs-relative-paths)
- [Exercise 4: Creating Nested Directories](#exercise-4-creating-nested-directories)
- [Exercise 5: Viewing File Content](#exercise-5-viewing-file-content)
- [Exercise 6: Hidden Files](#exercise-6-hidden-files)
- [Exercise 7: Distinguishing /root from /](#exercise-7-distinguishing-root-from-)
- [Exercise 8: Interpreting ls -l Output](#exercise-8-interpreting-ls--l-output)

---

<br>

## Exercise 1: File Type Identification

**Problem:** Given the following `ls -l` output, what type of file is `mylink`?

```text
lrwxrwxrwx 1 user1 user1 16 Mar 21 10:00 mylink -> /home/user1/data
```

- A. Regular file
- B. Directory
- C. Symbolic link
- D. Block device

### Solution

**Answer:** C. Symbolic link

**Explanation:** The first character of the `ls -l` output indicates the file type. `l` denotes a symbolic link, `-` a regular file, `d` a directory, `b` a block device, `c` a character device, `p` a pipe, and `s` a socket. The `->` arrow after the name also shows the target the symbolic link points to. The size 16 of the symbolic link is the length of the target path `/home/user1/data` (16 bytes).

---

<br>

## Exercise 2: Directory Hierarchy

**Problem:** Which directory stores system-wide configuration files such as `hostname`, `passwd`, and `fstab`?

- A. `/home`
- B. `/var`
- C. `/etc`
- D. `/usr`

### Solution

**Answer:** C. `/etc`

**Explanation:** The `/etc` directory contains system-wide configuration files. For example, `/etc/hostname` stores the system hostname, `/etc/passwd` contains user account information, and `/etc/fstab` defines file system mount entries. `/home` holds user home directories, `/var` stores variable data like logs, and `/usr` contains system resources such as basic executables and libraries.

---

<br>

## Exercise 3: Absolute vs. Relative Paths

**Problem:** If your current working directory is `/home/user1/Documents`, which of the following correctly refers to `/home/user2/file.txt` using a relative path?

- A. `../user2/file.txt`
- B. `./user2/file.txt`
- C. `../../user2/file.txt`
- D. `~/user2/file.txt`

### Solution

**Answer:** C. `../../user2/file.txt`

**Explanation:** Starting from `/home/user1/Documents`, the first `..` goes up to `/home/user1`, the second `..` goes up to `/home`, and then `user2/file.txt` descends into `/home/user2/file.txt`. Option A would resolve to `/home/user1/user2/file.txt`. Option B points below the current directory, giving `/home/user1/Documents/user2/file.txt`. Option D uses `~`, which expands to the current user's home, so it is not a relative path and refers to `/home/user1/user2/file.txt`.

---

<br>

## Exercise 4: Creating Nested Directories

**Problem:** You need to create the directory structure `projects/2025/spring/` in one command, but none of the parent directories exist yet. Which command succeeds?

- A. `mkdir projects/2025/spring`
- B. `mkdir -p projects/2025/spring`
- C. `mkdir -r projects/2025/spring`
- D. `rmdir -p projects/2025/spring`

### Solution

**Answer:** B. `mkdir -p projects/2025/spring`

**Explanation:** The `-p` (parents) option creates all necessary parent directories along the path. Without `-p`, `mkdir` fails with a `No such file or directory` error if any intermediate directory does not exist. Option C uses a `-r` option that `mkdir` does not have, so it fails with an `invalid option` error. Option D removes directories instead of creating them.

---

<br>

## Exercise 5: Viewing File Content

**Problem:** You want to monitor a log file in real time as new entries are appended. Which command is most appropriate?

- A. `cat /var/log/syslog`
- B. `head -f /var/log/syslog`
- C. `tail -f /var/log/syslog`
- D. `less -f /var/log/syslog`

### Solution

**Answer:** C. `tail -f /var/log/syslog`

**Explanation:** `tail -f` (follow) displays the last 10 lines of the file and then continues to watch and display new lines as they are appended. This is invaluable for real-time log monitoring. `cat` dumps the entire file at once and exits. `head` has no `-f` option. The `-f` of `less` is an option that forces special files to open; to follow newly appended content, you must press `F` inside `less` or start it separately with `less +F`.

---

<br>

## Exercise 6: Hidden Files

**Problem:** How do you list all files in the current directory, including hidden files whose names start with `.`?

### Solution

**Answer:** `ls -a`

**Explanation:** The `-a` (all) option makes `ls` include hidden files and directories (those whose names begin with `.`). Without `-a`, files like `.bashrc`, `.profile`, and `.ssh/` are not displayed. You can combine it with other options, such as `ls -la` for the long format with hidden files. To leave out `.` and `..`, use `ls -A`.

---

<br>

## Exercise 7: Distinguishing /root from /

**Problem:** Explain the difference between `/` and `/root` in the Linux directory hierarchy.

### Solution

**Answer:** `/` is the root directory, the top-level directory of the entire file system hierarchy from which all other directories branch. `/root` is the home directory of the root (superuser) account, located at `/root` rather than `/home/root` for security and availability reasons.

**Explanation:** Regular users have their home directories under `/home/username`, but the root user's home is `/root`. This separation ensures that root can still log in and repair the system even if `/home` is a separate file system that fails to mount. The two directories share the name root but are entirely different directories.

---

<br>

## Exercise 8: Interpreting ls -l Output

**Problem:** Given the following output, how many hard links does the file `report.txt` have, and what is its size?

```text
-rw-r--r-- 3 user1 staff 2048 Mar 21 14:00 report.txt
```

### Solution

**Answer:** The file has 3 hard links and a size of 2048 bytes.

**Explanation:** In `ls -l` output, the number immediately after the permission string is the hard link count (3 in this case). The number after the owner and group, before the date, is the file size in bytes (2048). The hard link count of 3 means that three directory entries (filenames) point to the same inode.

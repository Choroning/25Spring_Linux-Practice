# Week 3 — Quiz

> **Last Updated:** 2026-03-21

---

## Q1. File Type Identification

**Question:** Given the following `ls -l` output, what type of file is `mylink`?

```
lrwxrwxrwx 1 user1 user1 15 Mar 21 10:00 mylink -> /home/user1/data
```

| Option | File Type |
|--------|-----------|
| A | Regular file |
| B | Directory |
| C | Symbolic link |
| D | Block device |

**Answer:** C. Symbolic link

**Explanation:** The first character of the `ls -l` output indicates the file type. `l` denotes a symbolic link, `-` a regular file, `d` a directory, `b` a block device, `c` a character device, `p` a pipe, and `s` a socket. The `->` arrow also indicates where the symbolic link points to.

---

## Q2. Directory Hierarchy

**Question:** Which directory stores system-wide configuration files such as `hostname`, `passwd`, and `fstab`?

| Option | Directory |
|--------|-----------|
| A | `/home` |
| B | `/var` |
| C | `/etc` |
| D | `/usr` |

**Answer:** C. `/etc`

**Explanation:** The `/etc` directory contains system-wide configuration files. For example, `/etc/hostname` stores the system hostname, `/etc/passwd` contains user account information, and `/etc/fstab` defines filesystem mount entries. `/home` holds user directories, `/var` stores variable data like logs, and `/usr` contains user system resources.

---

## Q3. Absolute vs. Relative Paths

**Question:** If your current working directory is `/home/user1/Documents`, which of the following correctly refers to `/home/user2/file.txt` using a relative path?

| Option | Path |
|--------|------|
| A | `../user2/file.txt` |
| B | `./user2/file.txt` |
| C | `../../user2/file.txt` |
| D | `~/user2/file.txt` |

**Answer:** C. `../../user2/file.txt`

**Explanation:** Starting from `/home/user1/Documents`, the first `..` goes up to `/home/user1`, the second `..` goes up to `/home`, and then `user2/file.txt` descends into `/home/user2/file.txt`. Option A would resolve to `/home/user1/user2/file.txt`. Option B looks in the current directory. Option D uses `~` which expands to the current user's home, not a relative path to another user.

---

## Q4. Creating Nested Directories

**Question:** You need to create the directory structure `projects/2025/spring/` in one command, but none of the parent directories exist yet. Which command succeeds?

| Option | Command |
|--------|---------|
| A | `mkdir projects/2025/spring` |
| B | `mkdir -p projects/2025/spring` |
| C | `mkdir -r projects/2025/spring` |
| D | `rmdir -p projects/2025/spring` |

**Answer:** B. `mkdir -p projects/2025/spring`

**Explanation:** The `-p` (parents) option creates all necessary parent directories along the path. Without `-p`, `mkdir` fails if any intermediate directory does not exist. Option C uses a nonexistent `-r` flag for `mkdir`. Option D removes directories instead of creating them.

---

## Q5. Viewing File Content

**Question:** You want to monitor a log file in real-time as new entries are appended. Which command is most appropriate?

| Option | Command |
|--------|---------|
| A | `cat /var/log/syslog` |
| B | `head -f /var/log/syslog` |
| C | `tail -f /var/log/syslog` |
| D | `less -f /var/log/syslog` |

**Answer:** C. `tail -f /var/log/syslog`

**Explanation:** `tail -f` (follow) displays the last 10 lines of the file and then continues to watch and display new lines as they are appended. This is invaluable for real-time log monitoring. `cat` dumps the entire file at once. `head` has no `-f` option. `less` can display a file but does not continuously follow new output in the same way.

---

## Q6. Hidden Files

**Question:** How do you list all files in the current directory, including hidden files whose names start with `.`?

**Answer:** `ls -a`

**Explanation:** The `-a` (all) option makes `ls` include hidden files and directories (those whose names begin with `.`). Without `-a`, files like `.bashrc`, `.profile`, and `.ssh/` are not displayed. You can combine it with other options such as `ls -la` for long format with hidden files.

---

## Q7. Distinguishing /root from /

**Question:** Explain the difference between `/` and `/root` in the Linux directory hierarchy.

**Answer:** `/` is the root directory, the top-level directory of the entire filesystem hierarchy from which all other directories branch. `/root` is the home directory of the root (superuser) account, located at `/root` rather than `/home/root` for security and availability reasons.

**Explanation:** Regular users have their home directories under `/home/username`, but the root user's home is `/root`. This separation ensures that root can still log in and operate even if the `/home` filesystem fails to mount. They are entirely different directories despite both containing the word "root."

---

## Q8. Interpreting ls -l Output

**Question:** Given the following output, how many hard links does the file `report.txt` have and what is its size?

```
-rw-r--r-- 3 user1 staff 2048 Mar 21 14:00 report.txt
```

**Answer:** The file has 3 hard links and a size of 2048 bytes.

**Explanation:** In `ls -l` output, the number immediately after the permission string is the hard link count (3 in this case). The number before the date is the file size in bytes (2048). The hard link count of 3 means there are three directory entries (filenames) pointing to the same inode.

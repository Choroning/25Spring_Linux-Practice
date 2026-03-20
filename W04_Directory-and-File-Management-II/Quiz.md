# Week 4 — Quiz

> **Last Updated:** 2026-03-21

---

## Q1. Copying Directories

**Question:** Which command correctly copies the entire `project/` directory and its contents to `/backup/`?

| Option | Command |
|--------|---------|
| A | `cp project/ /backup/` |
| B | `cp -r project/ /backup/` |
| C | `cp -f project/ /backup/` |
| D | `cp -l project/ /backup/` |

**Answer:** B. `cp -r project/ /backup/`

**Explanation:** The `-r` (recursive) option is required to copy directories and all their contents. Without `-r`, `cp` only copies regular files and will report an error when given a directory. The `-f` flag forces overwriting but does not enable recursive copying. The `-l` flag creates hard links instead of copies.

---

## Q2. Hard Links vs. Symbolic Links

**Question:** Which of the following statements about hard links is **incorrect**?

| Option | Statement |
|--------|-----------|
| A | A hard link shares the same inode number as the original file |
| B | Deleting the original file makes a hard link a dangling link |
| C | Hard links cannot span across different filesystems |
| D | Hard links cannot be created for directories |

**Answer:** B. Deleting the original file makes a hard link a dangling link

**Explanation:** Hard links share the same inode, so the file's data persists as long as at least one hard link remains. Deleting the "original" simply removes one directory entry and decrements the link count. The data is only freed when the link count reaches zero. It is symbolic links that become dangling (broken) when the target file is deleted.

---

## Q3. I/O Redirection

**Question:** What is the difference between `>` and `>>` when used for output redirection?

| Option | Description |
|--------|-------------|
| A | `>` appends to a file; `>>` overwrites a file |
| B | `>` overwrites a file; `>>` appends to a file |
| C | Both `>` and `>>` overwrite the file |
| D | `>` writes to stdout; `>>` writes to stderr |

**Answer:** B. `>` overwrites a file; `>>` appends to a file

**Explanation:** The `>` operator redirects output to a file, creating it if it does not exist or truncating (overwriting) it if it does. The `>>` operator also redirects output but appends to the end of the file, preserving existing content. For example, `echo "line1" > log.txt` creates the file, then `echo "line2" >> log.txt` adds a second line without erasing line1.

---

## Q4. Using grep with Regular Expressions

**Question:** Which command displays all lines in `/etc/passwd` that start with the string `root`?

| Option | Command |
|--------|---------|
| A | `grep "root$" /etc/passwd` |
| B | `grep "^root" /etc/passwd` |
| C | `grep "*root" /etc/passwd` |
| D | `grep "root" /etc/passwd` |

**Answer:** B. `grep "^root" /etc/passwd`

**Explanation:** The `^` anchor matches the beginning of a line, so `^root` matches lines that start with "root". Option A uses `$` which matches the end of a line. Option C uses `*` which in regex means "zero or more of the preceding character" (not a wildcard like in shell globbing). Option D would match "root" anywhere in the line, not just at the beginning.

---

## Q5. Using find to Locate Files

**Question:** Write a command to find all `.log` files under `/var` that are larger than 50 MB.

**Answer:** `find /var -name "*.log" -size +50M`

**Explanation:** The `find` command searches recursively from the specified path. The `-name "*.log"` option filters by filename pattern, and `-size +50M` filters for files larger than 50 megabytes. The `+` prefix means "greater than." You could also add `-type f` to restrict the search to regular files only.

---

## Q6. Pipe Usage

**Question:** What does the following command do?

```bash
cat /etc/passwd | sort | head -5
```

| Option | Description |
|--------|-------------|
| A | Displays the first 5 lines of `/etc/passwd` in original order |
| B | Displays the last 5 lines of `/etc/passwd` sorted alphabetically |
| C | Displays the first 5 lines of `/etc/passwd` sorted alphabetically |
| D | Sorts `/etc/passwd` and saves the first 5 lines to a file |

**Answer:** C. Displays the first 5 lines of `/etc/passwd` sorted alphabetically

**Explanation:** The pipe (`|`) passes stdout of one command to stdin of the next. First, `cat /etc/passwd` outputs the file contents. Then `sort` arranges all lines in alphabetical order. Finally, `head -5` takes only the first 5 lines from that sorted output and displays them on screen.

---

## Q7. Using tee

**Question:** You want to see the output of `ls -la` on screen while also saving it to `filelist.txt`. Which command accomplishes this?

**Answer:** `ls -la | tee filelist.txt`

**Explanation:** The `tee` command reads from standard input and writes to both standard output (the screen) and one or more files simultaneously. Without `tee`, you would have to choose between viewing the output (`ls -la`) or saving it (`ls -la > filelist.txt`). To append instead of overwrite, use `tee -a filelist.txt`.

---

## Q8. Redirecting stderr

**Question:** Which command redirects only error messages from `find / -name "*.conf"` to a file called `errors.txt` while displaying normal output on screen?

| Option | Command |
|--------|---------|
| A | `find / -name "*.conf" > errors.txt` |
| B | `find / -name "*.conf" 2> errors.txt` |
| C | `find / -name "*.conf" &> errors.txt` |
| D | `find / -name "*.conf" 1> errors.txt` |

**Answer:** B. `find / -name "*.conf" 2> errors.txt`

**Explanation:** File descriptor 2 represents stderr. Using `2>` redirects only error messages (such as "Permission denied") to the specified file, while normal output (stdout, file descriptor 1) continues to display on screen. Option A redirects stdout (not stderr). Option C redirects both stdout and stderr. Option D explicitly redirects stdout using file descriptor 1.

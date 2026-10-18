# Week 4 Solutions — Directory and File Management II

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 2

---

<br>

## Table of Contents

- [Exercise 1: Copying Directories](#exercise-1-copying-directories)
- [Exercise 2: Hard Links vs. Symbolic Links](#exercise-2-hard-links-vs-symbolic-links)
- [Exercise 3: I/O Redirection](#exercise-3-io-redirection)
- [Exercise 4: Using grep with Regular Expressions](#exercise-4-using-grep-with-regular-expressions)
- [Exercise 5: Using find to Locate Files](#exercise-5-using-find-to-locate-files)
- [Exercise 6: Pipe Usage](#exercise-6-pipe-usage)
- [Exercise 7: Using tee](#exercise-7-using-tee)
- [Exercise 8: Redirecting stderr](#exercise-8-redirecting-stderr)

---

<br>

## Exercise 1: Copying Directories

**Problem:** Which command correctly copies the entire `project/` directory and its contents to `/backup/`?

- A. `cp project/ /backup/`
- B. `cp -r project/ /backup/`
- C. `cp -f project/ /backup/`
- D. `cp -l project/ /backup/`

### Solution

**Answer:** B. `cp -r project/ /backup/`

**Explanation:** The `-r` (recursive) option is required to copy a directory and all its contents. Given a directory without `-r`, `cp` prints `cp: -r not specified; omitting directory 'project/'` and skips it. The `-f` option only forces overwriting of destination files and does not enable recursive copying. The `-l` option creates hard links instead of copying files, and it also skips directories without `-r`.

---

<br>

## Exercise 2: Hard Links vs. Symbolic Links

**Problem:** Which of the following statements about hard links is **incorrect**?

- A. A hard link shares the same inode number as the original file.
- B. Deleting the original file makes a hard link a dangling link.
- C. Hard links cannot span different file systems.
- D. Hard links cannot be created for directories.

### Solution

**Answer:** B. Deleting the original file makes a hard link a dangling link.

**Explanation:** Hard links share the same inode as the original, so the file's data persists as long as at least one hard link remains. Deleting the name called the original simply removes one directory entry and decrements the link count by 1; the data is freed only when the link count reaches zero. It is symbolic links that become dangling (broken) when the target file is deleted.

---

<br>

## Exercise 3: I/O Redirection

**Problem:** What is the difference between `>` and `>>` when used for output redirection?

- A. `>` appends to a file; `>>` overwrites a file.
- B. `>` overwrites a file; `>>` appends to a file.
- C. Both `>` and `>>` overwrite the file.
- D. `>` writes to stdout; `>>` writes to stderr.

### Solution

**Answer:** B. `>` overwrites a file; `>>` appends to a file.

**Explanation:** The `>` operator redirects output to a file, creating it if it does not exist or truncating (overwriting) it if it does. The `>>` operator also redirects output but appends to the end of the file, preserving existing content. For example, `echo "line1" > log.txt` creates the file, and then `echo "line2" >> log.txt` adds a second line without erasing line1.

---

<br>

## Exercise 4: Using grep with Regular Expressions

**Problem:** Which command displays all lines in `/etc/passwd` that start with the string `root`?

- A. `grep "root$" /etc/passwd`
- B. `grep "^root" /etc/passwd`
- C. `grep "*root" /etc/passwd`
- D. `grep "root" /etc/passwd`

### Solution

**Answer:** B. `grep "^root" /etc/passwd`

**Explanation:** The `^` anchor matches the beginning of a line, so `^root` matches lines that start with root. Option A uses `$`, which matches the end of a line, so it finds lines ending with root. The `*` in option C means zero or more of the preceding character in a regular expression, but at the very start of the pattern there is no preceding character to repeat, so a basic regular expression treats it as the literal character `*`. It therefore finds only lines containing the string `*root` and does not mean any string as the wildcard does in shell globbing. Option D matches root anywhere in the line, not just at the beginning.

---

<br>

## Exercise 5: Using find to Locate Files

**Problem:** Write a command to find all `.log` files under `/var` that are larger than 50 MB.

### Solution

**Answer:** `find /var -name "*.log" -size +50M`

**Explanation:** The `find` command searches recursively from the specified path. `-name "*.log"` filters by filename pattern, and `-size +50M` filters for files larger than 50 MiB (1 MiB = 1,048,576 bytes). The `+` prefix means greater than. The pattern must be quoted so that the shell does not expand `*.log` first. You could also add `-type f` to restrict the search to regular files.

---

<br>

## Exercise 6: Pipe Usage

**Problem:** What does the following command do?

```bash
cat /etc/passwd | sort | head -5
```

- A. It displays the first 5 lines of `/etc/passwd` in original order.
- B. It displays the last 5 lines of `/etc/passwd` sorted alphabetically.
- C. It sorts all lines of `/etc/passwd` alphabetically and then displays the first 5 lines.
- D. It sorts `/etc/passwd` and saves the first 5 lines to a file.

### Solution

**Answer:** C. It sorts all lines of `/etc/passwd` alphabetically and then displays the first 5 lines.

**Explanation:** The pipe (`|`) passes the stdout of one command to the stdin of the next. First, `cat /etc/passwd` outputs the file contents. Then `sort` arranges all lines in alphabetical order. Finally, `head -5` takes only the first 5 lines of that sorted output and displays them on screen. Note that it does not pick the first 5 lines of the file and sort them; it shows the first 5 lines of the fully sorted result. `sort /etc/passwd | head -5` gives the same result.

---

<br>

## Exercise 7: Using tee

**Problem:** You want to see the output of `ls -la` on screen while also saving it to `filelist.txt`. Which command accomplishes this?

### Solution

**Answer:** `ls -la | tee filelist.txt`

**Explanation:** The `tee` command reads from standard input and writes to both standard output (the screen) and one or more files simultaneously. Without `tee`, you would have to choose between viewing the output (`ls -la`) and saving it (`ls -la > filelist.txt`). To append instead of overwriting, use `tee -a filelist.txt`.

---

<br>

## Exercise 8: Redirecting stderr

**Problem:** Which command redirects only error messages from `find / -name "*.conf"` to a file called `errors.txt` while displaying normal output on screen?

- A. `find / -name "*.conf" > errors.txt`
- B. `find / -name "*.conf" 2> errors.txt`
- C. `find / -name "*.conf" &> errors.txt`
- D. `find / -name "*.conf" 1> errors.txt`

### Solution

**Answer:** B. `find / -name "*.conf" 2> errors.txt`

**Explanation:** File descriptor 2 represents stderr. Using `2>` redirects only error messages (such as `Permission denied`) to the specified file, while normal output (stdout, file descriptor 1) continues to display on screen. Option A redirects stdout, not stderr. Option C redirects both stdout and stderr. Option D explicitly redirects stdout using file descriptor 1, so it is the same as A.

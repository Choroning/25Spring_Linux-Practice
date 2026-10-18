# Week 4 Exercises — Directory and File Management II

[Repository Guide](../../README.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 2

---

<br>

## Exercise 1: Copying Directories

**Problem:** Which command correctly copies the entire `project/` directory and its contents to `/backup/`?

- A. `cp project/ /backup/`
- B. `cp -r project/ /backup/`
- C. `cp -f project/ /backup/`
- D. `cp -l project/ /backup/`

**[Solution](Solutions.md#exercise-1-copying-directories)**

---

<br>

## Exercise 2: Hard Links vs. Symbolic Links

**Problem:** Which of the following statements about hard links is **incorrect**?

- A. A hard link shares the same inode number as the original file.
- B. Deleting the original file makes a hard link a dangling link.
- C. Hard links cannot span different file systems.
- D. Hard links cannot be created for directories.

**[Solution](Solutions.md#exercise-2-hard-links-vs-symbolic-links)**

---

<br>

## Exercise 3: I/O Redirection

**Problem:** What is the difference between `>` and `>>` when used for output redirection?

- A. `>` appends to a file; `>>` overwrites a file.
- B. `>` overwrites a file; `>>` appends to a file.
- C. Both `>` and `>>` overwrite the file.
- D. `>` writes to stdout; `>>` writes to stderr.

**[Solution](Solutions.md#exercise-3-io-redirection)**

---

<br>

## Exercise 4: Using grep with Regular Expressions

**Problem:** Which command displays all lines in `/etc/passwd` that start with the string `root`?

- A. `grep "root$" /etc/passwd`
- B. `grep "^root" /etc/passwd`
- C. `grep "*root" /etc/passwd`
- D. `grep "root" /etc/passwd`

**[Solution](Solutions.md#exercise-4-using-grep-with-regular-expressions)**

---

<br>

## Exercise 5: Using find to Locate Files

**Problem:** Write a command to find all `.log` files under `/var` that are larger than 50 MB.

**[Solution](Solutions.md#exercise-5-using-find-to-locate-files)**

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

**[Solution](Solutions.md#exercise-6-pipe-usage)**

---

<br>

## Exercise 7: Using tee

**Problem:** You want to see the output of `ls -la` on screen while also saving it to `filelist.txt`. Which command accomplishes this?

**[Solution](Solutions.md#exercise-7-using-tee)**

---

<br>

## Exercise 8: Redirecting stderr

**Problem:** Which command redirects only error messages from `find / -name "*.conf"` to a file called `errors.txt` while displaying normal output on screen?

- A. `find / -name "*.conf" > errors.txt`
- B. `find / -name "*.conf" 2> errors.txt`
- C. `find / -name "*.conf" &> errors.txt`
- D. `find / -name "*.conf" 1> errors.txt`

**[Solution](Solutions.md#exercise-8-redirecting-stderr)**

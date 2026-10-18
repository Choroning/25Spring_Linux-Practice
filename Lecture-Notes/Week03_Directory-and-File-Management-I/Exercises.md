# Week 3 Exercises — Directory and File Management I

[Repository Guide](../../README.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 2

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

**[Solution](Solutions.md#exercise-1-file-type-identification)**

---

<br>

## Exercise 2: Directory Hierarchy

**Problem:** Which directory stores system-wide configuration files such as `hostname`, `passwd`, and `fstab`?

- A. `/home`
- B. `/var`
- C. `/etc`
- D. `/usr`

**[Solution](Solutions.md#exercise-2-directory-hierarchy)**

---

<br>

## Exercise 3: Absolute vs. Relative Paths

**Problem:** If your current working directory is `/home/user1/Documents`, which of the following correctly refers to `/home/user2/file.txt` using a relative path?

- A. `../user2/file.txt`
- B. `./user2/file.txt`
- C. `../../user2/file.txt`
- D. `~/user2/file.txt`

**[Solution](Solutions.md#exercise-3-absolute-vs-relative-paths)**

---

<br>

## Exercise 4: Creating Nested Directories

**Problem:** You need to create the directory structure `projects/2025/spring/` in one command, but none of the parent directories exist yet. Which command succeeds?

- A. `mkdir projects/2025/spring`
- B. `mkdir -p projects/2025/spring`
- C. `mkdir -r projects/2025/spring`
- D. `rmdir -p projects/2025/spring`

**[Solution](Solutions.md#exercise-4-creating-nested-directories)**

---

<br>

## Exercise 5: Viewing File Content

**Problem:** You want to monitor a log file in real time as new entries are appended. Which command is most appropriate?

- A. `cat /var/log/syslog`
- B. `head -f /var/log/syslog`
- C. `tail -f /var/log/syslog`
- D. `less -f /var/log/syslog`

**[Solution](Solutions.md#exercise-5-viewing-file-content)**

---

<br>

## Exercise 6: Hidden Files

**Problem:** How do you list all files in the current directory, including hidden files whose names start with `.`?

**[Solution](Solutions.md#exercise-6-hidden-files)**

---

<br>

## Exercise 7: Distinguishing /root from /

**Problem:** Explain the difference between `/` and `/root` in the Linux directory hierarchy.

**[Solution](Solutions.md#exercise-7-distinguishing-root-from-)**

---

<br>

## Exercise 8: Interpreting ls -l Output

**Problem:** Given the following output, how many hard links does the file `report.txt` have, and what is its size?

```text
-rw-r--r-- 3 user1 staff 2048 Mar 21 14:00 report.txt
```

**[Solution](Solutions.md#exercise-8-interpreting-ls--l-output)**

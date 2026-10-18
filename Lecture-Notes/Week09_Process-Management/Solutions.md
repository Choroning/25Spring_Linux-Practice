# Week 9 Solutions — Process Management

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 6

---

<br>

## Table of Contents

- [Exercise 1: Checking PPID of a Process](#exercise-1-checking-ppid-of-a-process)
- [Exercise 2: Viewing Processes of a Specific User](#exercise-2-viewing-processes-of-a-specific-user)
- [Exercise 3: Crontab Scheduling](#exercise-3-crontab-scheduling)
- [Exercise 4: Process Description](#exercise-4-process-description)
- [Exercise 5: Conditions for Using the `at` Command](#exercise-5-conditions-for-using-the-at-command)
- [Exercise 6: Finding Processes by Username](#exercise-6-finding-processes-by-username)
- [Exercise 7: Force Killing a Process](#exercise-7-force-killing-a-process)
- [Exercise 8: Terminating a Background Job](#exercise-8-terminating-a-background-job)
- [Exercise 9: Crontab for Weekly Task](#exercise-9-crontab-for-weekly-task)
- [Exercise 10: Removing a Scheduled `at` Job](#exercise-10-removing-a-scheduled-at-job)
- [Exercise 11: Allowing All Users to Use `at`](#exercise-11-allowing-all-users-to-use-at)

---

<br>

## Exercise 1: Checking PPID of a Process

**Problem:** Which command is correct for checking the PPID of a process?

- A. `ps`
- B. `ps -e`
- C. `ps a`
- D. `ps -f`

### Solution

**Answer:** D. `ps -f`

**Explanation:** The `ps -f` command displays processes in full format, which includes the PPID (Parent Process ID) column along with UID, PID, C, STIME, TTY, TIME, and CMD. The basic `ps` command only shows PID, TTY, TIME, and CMD without PPID information. `ps -e` shows all processes in the same short format, and `ps a` shows processes started from terminals in BSD format, but neither has a PPID column.

---

<br>

## Exercise 2: Viewing Processes of a Specific User

**Problem:** Which command is **incorrect** for checking process information related to user `han1`?

- A. `ps -u han1`
- B. `ps -fu han1`
- C. `ps -p $(pgrep -u han1)`
- D. `ps -pu han1`

### Solution

**Answer:** D. `ps -pu han1`

**Explanation:** Options A, B, and C are all valid ways to list processes owned by `han1`. The `-u` option filters by user, `-fu` combines full format with user filter, and `-p` with `pgrep` selects processes by PID. However, `ps -pu han1` is invalid because `-p` expects a PID list, not a username. The `u` right after `-p` is read as the PID list, which gives the error `error: process ID list syntax error`.

---

<br>

## Exercise 3: Crontab Scheduling

**Problem:** To schedule saving the file list of `/tmp` directory to `tmp.out` at 14:30 on December 30th, which crontab entry is correct?

- A. `12 30 14 30 * /usr/bin/ls -l /tmp > ~user1/tmp.out`
- B. `30 14 30 12 * /usr/bin/ls -l /tmp > ~user1/tmp.out`
- C. `14 30 12 30 * /usr/bin/ls -l /tmp > ~user1/tmp.out`
- D. `14 30 30 12 * /usr/bin/ls -l /tmp > ~user1/tmp.out`

### Solution

**Answer:** B. `30 14 30 12 * /usr/bin/ls -l /tmp > ~user1/tmp.out`

**Explanation:** The crontab format is `minute hour day month weekday command`. For 14:30 on December 30th: minute=30, hour=14, day=30, month=12, weekday=* (any). Thus the correct entry is `30 14 30 12 *`. The other options have the fields in the wrong order. A, C, and D all put 30 in the hour field, outside its range (0-23), and A and C also put 30 in the month field, outside its range (1-12).

---

<br>

## Exercise 4: Process Description

**Problem:** Which of the following descriptions about processes is **incorrect**?

- A. A process is a currently running program.
- B. Processes have parent-child relationships.
- C. A process has a PID number.
- D. A child process is always removed from the process table as soon as it finishes running.

### Solution

**Answer:** D. A child process is always removed from the process table as soon as it finishes running.

**Explanation:** Even after a child process finishes running, it remains in the process table until its parent collects its exit status; such a process is called a zombie process (`defunct`). D is therefore wrong. A, B, and C are all correct. A process is a running program, has a parent-child relationship in which a parent process creates child processes, and has a unique PID. Each process also has a PPID, the PID of its parent, and a UID that identifies the user who ran it, which can be checked in the UID and PPID columns of `ps -f`.

---

<br>

## Exercise 5: Conditions for Using the `at` Command

**Problem:** Which is **not** a valid condition for a user account to use the `at` command?

- A. `/etc/at.allow` exists and the user account is listed in it.
- B. Only `/etc/at.deny` exists and the user account is not listed in it.
- C. Both `/etc/at.allow` and `/etc/at.deny` exist and the user account is listed in both.
- D. Neither `/etc/cron.allow` nor `/etc/cron.deny` exists.

### Solution

**Answer:** D. Neither `/etc/cron.allow` nor `/etc/cron.deny` exists.

**Explanation:** The `at` command access control uses `/etc/at.allow` and `/etc/at.deny`, not the `cron` files. If `/etc/at.allow` exists, only users listed in it can use `at`. If only `/etc/at.deny` exists, users not in it can use `at`. If both exist, `/etc/at.allow` takes precedence, so a user listed in both files can also use `at`. If neither `at.allow` nor `at.deny` exists, only root can use `at`. The `cron.allow` and `cron.deny` files are irrelevant to `at` command access.

---

<br>

## Exercise 6: Finding Processes by Username

**Problem:** What command can be used to find all processes executed by a user named `guest`?

### Solution

**Answer:** `ps -u guest`

**Explanation:** The `ps -u` option filters processes by the effective user ID or name. Running `ps -u guest` displays all processes currently running under the `guest` user account. For more detail use `ps -fu guest`, and for PIDs only use `pgrep -u guest`.

---

<br>

## Exercise 7: Force Killing a Process

**Problem:** The process with PID 5000 cannot be terminated with `kill 5000`. How should you forcefully terminate this process?

### Solution

**Answer:** `kill -9 5000`

**Explanation:** The default `kill` command sends SIGTERM (signal 15), which allows the process to perform cleanup before exiting. If a process ignores SIGTERM, you can use `kill -9` (SIGKILL) to forcefully terminate it. SIGKILL cannot be caught or ignored by the process, guaranteeing termination. Writing `kill -KILL 5000` does the same.

---

<br>

## Exercise 8: Terminating a Background Job

**Problem:** Given three background jobs as shown below, write the command to terminate job number 3:

```bash
$ jobs
[1] + Running    sleep 100
[2] - Running    find / -name test
[3]   Running    sleep 300
```

### Solution

**Answer:** `kill %3`

**Explanation:** In bash, background jobs are referenced using `%` followed by the job number. `kill %3` sends SIGTERM to job number 3. This is different from `kill 3` which would attempt to kill the process with PID 3.

---

<br>

## Exercise 9: Crontab for Weekly Task

**Problem:** Set up a crontab entry that runs every Sunday at 11 PM to check the process list of user `user01` and save it to `ps.out` in the user's home directory.

### Solution

**Answer:** `0 23 * * 0 /bin/ps -u user01 > /home/user01/ps.out`

**Explanation:** The crontab format is `minute hour day month weekday command`. For every Sunday at 11 PM: minute=0, hour=23, day=* (any), month=* (any), weekday=0 (Sunday). The `ps -u user01` command lists processes owned by `user01`, and the output is redirected to the specified file. In the weekday field, 7 instead of 0 also means Sunday.

---

<br>

## Exercise 10: Removing a Scheduled `at` Job

**Problem:** Given the following scheduled `at` jobs, what command deletes the first job?

```bash
$ atq
8  Sun May 31 15:30:00 2020  a  user1
9  Sun May 31 16:00:00 2020  a  user1
```

### Solution

**Answer:** `atrm 8`

**Explanation:** The `atrm` command removes scheduled `at` jobs by their job number. `atq` lists pending jobs with their IDs, and `atrm 8` removes job number 8. Alternatively, `at -d 8` or `at -r 8` can also be used to delete the job.

---

<br>

## Exercise 11: Allowing All Users to Use `at`

**Problem:** How should Ubuntu Linux be configured so that all users can use the `at` command?

### Solution

**Answer:** Delete the `/etc/at.allow` file (or ensure it does not exist), and keep the `/etc/at.deny` file as an empty file instead of deleting it.

**Explanation:** The `at` access control logic works as follows: if `/etc/at.allow` exists, only users listed in it can use `at`. If `/etc/at.allow` does not exist, every user not listed in `/etc/at.deny` can use `at`, and if `/etc/at.deny` is empty, every user can use it. However, if neither file exists, only root can use `at`, so `/etc/at.deny` must not be deleted as well. Therefore, by removing `/etc/at.allow` and keeping `/etc/at.deny` empty, no users are denied access. The `/etc/at.deny` installed by default on Ubuntu lists only system accounts such as `daemon` and `bin`, so regular users can use `at` even with the default settings.

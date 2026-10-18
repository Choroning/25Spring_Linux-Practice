# Week 9 Exercises — Process Management

[Repository Guide](../../README.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 6

---

<br>

## Exercise 1: Checking PPID of a Process

**Problem:** Which command is correct for checking the PPID of a process?

- A. `ps`
- B. `ps -e`
- C. `ps a`
- D. `ps -f`

**[Solution](Solutions.md#exercise-1-checking-ppid-of-a-process)**

---

<br>

## Exercise 2: Viewing Processes of a Specific User

**Problem:** Which command is **incorrect** for checking process information related to user `han1`?

- A. `ps -u han1`
- B. `ps -fu han1`
- C. `ps -p $(pgrep -u han1)`
- D. `ps -pu han1`

**[Solution](Solutions.md#exercise-2-viewing-processes-of-a-specific-user)**

---

<br>

## Exercise 3: Crontab Scheduling

**Problem:** To schedule saving the file list of `/tmp` directory to `tmp.out` at 14:30 on December 30th, which crontab entry is correct?

- A. `12 30 14 30 * /usr/bin/ls -l /tmp > ~user1/tmp.out`
- B. `30 14 30 12 * /usr/bin/ls -l /tmp > ~user1/tmp.out`
- C. `14 30 12 30 * /usr/bin/ls -l /tmp > ~user1/tmp.out`
- D. `14 30 30 12 * /usr/bin/ls -l /tmp > ~user1/tmp.out`

**[Solution](Solutions.md#exercise-3-crontab-scheduling)**

---

<br>

## Exercise 4: Process Description

**Problem:** Which of the following descriptions about processes is **incorrect**?

- A. A process is a currently running program.
- B. Processes have parent-child relationships.
- C. A process has a PID number.
- D. A child process is always removed from the process table as soon as it finishes running.

**[Solution](Solutions.md#exercise-4-process-description)**

---

<br>

## Exercise 5: Conditions for Using the `at` Command

**Problem:** Which is **not** a valid condition for a user account to use the `at` command?

- A. `/etc/at.allow` exists and the user account is listed in it.
- B. Only `/etc/at.deny` exists and the user account is not listed in it.
- C. Both `/etc/at.allow` and `/etc/at.deny` exist and the user account is listed in both.
- D. Neither `/etc/cron.allow` nor `/etc/cron.deny` exists.

**[Solution](Solutions.md#exercise-5-conditions-for-using-the-at-command)**

---

<br>

## Exercise 6: Finding Processes by Username

**Problem:** What command can be used to find all processes executed by a user named `guest`?

**[Solution](Solutions.md#exercise-6-finding-processes-by-username)**

---

<br>

## Exercise 7: Force Killing a Process

**Problem:** The process with PID 5000 cannot be terminated with `kill 5000`. How should you forcefully terminate this process?

**[Solution](Solutions.md#exercise-7-force-killing-a-process)**

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

**[Solution](Solutions.md#exercise-8-terminating-a-background-job)**

---

<br>

## Exercise 9: Crontab for Weekly Task

**Problem:** Set up a crontab entry that runs every Sunday at 11 PM to check the process list of user `user01` and save it to `ps.out` in the user's home directory.

**[Solution](Solutions.md#exercise-9-crontab-for-weekly-task)**

---

<br>

## Exercise 10: Removing a Scheduled `at` Job

**Problem:** Given the following scheduled `at` jobs, what command deletes the first job?

```bash
$ atq
8  Sun May 31 15:30:00 2020  a  user1
9  Sun May 31 16:00:00 2020  a  user1
```

**[Solution](Solutions.md#exercise-10-removing-a-scheduled-at-job)**

---

<br>

## Exercise 11: Allowing All Users to Use `at`

**Problem:** How should Ubuntu Linux be configured so that all users can use the `at` command?

**[Solution](Solutions.md#exercise-11-allowing-all-users-to-use-at)**

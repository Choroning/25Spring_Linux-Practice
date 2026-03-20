# W09 — Quiz

> **Last Updated:** 2026-03-21

---

## Q1. Checking PPID of a Process

**Question:** Which command is correct for checking the PPID of a process?

| Option | Command |
|--------|---------|
| A | `ps` |
| B | `ps -e` |
| C | `ps a` |
| D | `ps -f` |

**Answer:** D. `ps -f`

**Explanation:** The `ps -f` command displays processes in full format, which includes the PPID (Parent Process ID) column along with UID, PID, C, STIME, TTY, TIME, and CMD. The basic `ps` command only shows PID, TTY, TIME, and CMD without PPID information.

---

## Q2. Viewing Processes of a Specific User

**Question:** Which command is **incorrect** for checking process information related to user `han1`?

| Option | Command |
|--------|---------|
| A | `ps -u han1` |
| B | `ps -fu han1` |
| C | `ps -p $(pgrep -u han1)` |
| D | `ps -pu han1` |

**Answer:** D. `ps -pu han1`

**Explanation:** Options A, B, and C are all valid ways to list processes owned by `han1`. The `-u` option filters by user, `-fu` combines full format with user filter, and `-p` with `pgrep` selects processes by PID. However, `ps -pu han1` is invalid because `-p` expects a PID list, not a username.

---

## Q3. Crontab Scheduling

**Question:** To schedule saving the file list of `/tmp` directory to `tmp.out` at 14:30 on December 30th, which crontab entry is correct?

| Option | Crontab Entry |
|--------|---------------|
| A | `12 30 14 30 * /usr/bin/ls -l /tmp > ~user1/tmp.out` |
| B | `30 14 30 12 * /usr/bin/ls -l /tmp > ~user1/tmp.out` |
| C | `14 30 12 30 * /usr/bin/ls -l /tmp > ~user1/tmp.out` |
| D | `14 30 30 12 * /usr/bin/ls -l /tmp > ~user1/tmp.out` |

**Answer:** B. `30 14 30 12 * /usr/bin/ls -l /tmp > ~user1/tmp.out`

**Explanation:** The crontab format is `minute hour day month weekday command`. For 14:30 on December 30th: minute=30, hour=14, day=30, month=12, weekday=* (any). Thus the correct entry is `30 14 30 12 *`.

---

## Q4. Process Description

**Question:** Which of the following descriptions about processes is **incorrect**?

| Option | Description |
|--------|-------------|
| A | A process is a currently running program. |
| B | Processes have parent-child relationships. |
| C | A process has a PID number. |
| D | A process has a UID number. |

**Answer:** D. A process has a UID number.

**Explanation:** While processes are associated with a UID (User ID) that identifies which user owns the process, the UID is not an inherent property of the process itself -- it belongs to the user. A process has its own PID (Process ID) and inherits a PPID (Parent PID) from its parent. Processes do not "have" a UID in the same way they have a PID; rather, the UID is an attribute of the user who launched the process.

---

## Q5. Conditions for Using the `at` Command

**Question:** Which is **NOT** a valid condition for a user account to use the `at` command?

| Option | Condition |
|--------|-----------|
| A | `/etc/at.allow` exists and the user account is listed in it. |
| B | Only `/etc/at.deny` exists and the user account is NOT listed in it. |
| C | Both `/etc/at.allow` and `/etc/at.deny` exist and the user account is listed in both. |
| D | Neither `/etc/cron.allow` nor `/etc/cron.deny` exists. |

**Answer:** D. Neither `/etc/cron.allow` nor `/etc/cron.deny` exists.

**Explanation:** The `at` command access control uses `/etc/at.allow` and `/etc/at.deny`, not the `cron` files. If `/etc/at.allow` exists, only users listed in it can use `at`. If only `/etc/at.deny` exists, users NOT in it can use `at`. If both exist, `/etc/at.allow` takes precedence. The `cron.allow` and `cron.deny` files are irrelevant to `at` command access.

---

## Q6. Finding Processes by Username

**Question:** What command can be used to find all processes executed by a user named `guest`?

**Answer:** `ps -u guest`

**Explanation:** The `ps -u` option filters processes by the effective user ID or name. Running `ps -u guest` displays all processes currently running under the `guest` user account.

---

## Q7. Force Killing a Process

**Question:** The process with PID 5000 cannot be terminated with `kill 5000`. How should you forcefully terminate this process?

**Answer:** `kill -9 5000`

**Explanation:** The default `kill` command sends SIGTERM (signal 15), which allows the process to perform cleanup before exiting. If a process ignores SIGTERM, you can use `kill -9` (SIGKILL) to forcefully terminate it. SIGKILL cannot be caught or ignored by the process, guaranteeing termination.

---

## Q8. Terminating a Background Job

**Question:** Given three background jobs as shown below, write the command to terminate job number 3:
```
$ jobs
[1] + Running    sleep 100
[2] - Running    find / -name test
[3]   Running    sleep 300
```

**Answer:** `kill %3`

**Explanation:** In bash, background jobs are referenced using `%` followed by the job number. `kill %3` sends SIGTERM to job number 3. This is different from `kill 3` which would attempt to kill the process with PID 3.

---

## Q9. Crontab for Weekly Task

**Question:** Set up a crontab entry that runs every Sunday at 11 PM to check the process list of user `user01` and save it to `ps.out` in the user's home directory.

**Answer:** `0 23 * * 0 /bin/ps -u user01 > /home/user01/ps.out`

**Explanation:** The crontab format is `minute hour day month weekday command`. For every Sunday at 11 PM: minute=0, hour=23, day=* (any), month=* (any), weekday=0 (Sunday). The `ps -u user01` command lists processes owned by `user01`, and the output is redirected to the specified file.

---

## Q10. Removing a Scheduled `at` Job

**Question:** Given the following scheduled `at` jobs, what command deletes the first job?
```
$ atq
8  Sun May 31 15:30:00 2020  a  user1
9  Sun May 31 16:00:00 2020  a  user1
```

**Answer:** `atrm 8`

**Explanation:** The `atrm` command removes scheduled `at` jobs by their job number. `atq` lists pending jobs with their IDs, and `atrm 8` removes job number 8. Alternatively, `at -d 8` can also be used to delete the job.

---

## Q11. Allowing All Users to Use `at`

**Question:** How should Ubuntu Linux be configured so that all users can use the `at` command?

**Answer:** Delete the `/etc/at.allow` file (or ensure it does not exist) and ensure the `/etc/at.deny` file is either empty or does not exist.

**Explanation:** The `at` access control logic works as follows: if `/etc/at.allow` exists, only users listed in it can use `at`. If `/etc/at.allow` does not exist and `/etc/at.deny` is empty or absent, all users are permitted to use the `at` command. By removing `/etc/at.allow` and keeping `/etc/at.deny` empty, no users are denied access.

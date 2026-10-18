# Week 9 Lecture — Process Management

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 6

> **Learning Objectives:**
> 1. Explain the concept of a process, parent-child relationships, and the kinds of processes
> 2. Monitor and manage processes using ps, top, and kill
> 3. Distinguish foreground and background process execution
> 4. Apply job control (bg, fg, jobs, nohup)
> 5. Schedule tasks with at and crontab

---

## Table of Contents

- [1. Understanding Processes](#1-understanding-processes)
  - [1.1 What is a Process?](#11-what-is-a-process)
  - [1.2 Process Types](#12-process-types)
  - [1.3 Process States](#13-process-states)
- [2. Viewing Processes](#2-viewing-processes)
  - [2.1 ps: Process Status](#21-ps-process-status)
  - [2.2 pgrep: Finding Processes by Pattern](#22-pgrep-finding-processes-by-pattern)
  - [2.3 top: Real-time Process Monitor](#23-top-real-time-process-monitor)
  - [2.4 pstree: Process Tree](#24-pstree-process-tree)
- [3. Foreground and Background Processes](#3-foreground-and-background-processes)
  - [3.1 Running Processes](#31-running-processes)
  - [3.2 Job Control](#32-job-control)
  - [3.3 nohup: No Hangup](#33-nohup-no-hangup)
- [4. Signals and Process Control](#4-signals-and-process-control)
  - [4.1 Common Signals](#41-common-signals)
  - [4.2 kill: Send Signals](#42-kill-send-signals)
  - [4.3 Process Priority](#43-process-priority)
- [5. Process Scheduling](#5-process-scheduling)
  - [5.1 Process Lifecycle](#51-process-lifecycle)
  - [5.2 /proc Filesystem](#52-proc-filesystem)
- [6. Scheduled Tasks (cron and at)](#6-scheduled-tasks-cron-and-at)
  - [6.1 crontab: Recurring Tasks](#61-crontab-recurring-tasks)
  - [6.2 at: One-time Tasks](#62-at-one-time-tasks)
- [7. System Monitoring](#7-system-monitoring)
  - [7.1 Resource Monitoring Commands](#71-resource-monitoring-commands)
  - [7.2 uptime and load average](#72-uptime-and-load-average)
- [8. Best Practices](#8-best-practices)
  - [8.1 Process Management Tips](#81-process-management-tips)
  - [8.2 Common Mistakes](#82-common-mistakes)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. Understanding Processes

### 1.1 What is a Process?

A **process** is a running instance of a program. Linux is a multi-process system that runs many processes at the same time. Each process has:
- **PID (Process ID):** A unique number that identifies the process.
- **PPID (Parent Process ID):** The PID of the parent process that created it.
- **UID/GID:** The user and group that ran the process.
- **State:** A state such as running, sleeping, stopped, or zombie.
- **Priority:** A priority value used for CPU scheduling.

Every process in Linux has a parent-child relationship. A parent process creates child processes; for example, when you run a command in the shell, the shell is the parent and the command is a child process. Process 1, the first process the kernel runs at boot, is `systemd` (`/sbin/init`), and process 2 is `kthreadd`, which manages kernel threads. All other processes are descendants of these two.

### 1.2 Process Types

| Type | Description | Example |
|------|-------------|---------|
| **Foreground** | Interactive, attached to terminal | `vi file.txt` |
| **Background** | Runs independently of terminal | `command &` |
| **Daemon** | System service running in background | `sshd`, `cron`, `nginx` |
| **Zombie** | Completed but not yet cleaned by parent | Defunct process |
| **Orphan** | Parent has terminated; adopted by init/systemd | |

*Table 1. Types of processes*

- A **daemon process** exists to provide a specific service; it is usually started by `systemd` at boot and keeps running regardless of any terminal.
- An **orphan process** is a child process that is still running after its parent has terminated. Process 1 (or another designated process) adopts the orphan as its new parent.
- A **zombie process** is a child process that has finished running but remains in the process table because its parent has not collected its exit status. It may be shown as `defunct` in the process list. A zombie uses almost no CPU or memory but occupies an entry in the process table, so if many accumulate, the table can run out and normal processes may fail to start.

### 1.3 Process States

| State | Symbol | Description |
|-------|--------|-------------|
| Running | `R` | Currently executing on CPU |
| Sleeping | `S` | Waiting for an event (interruptible) |
| Uninterruptible Sleep | `D` | Waiting for I/O (cannot be interrupted) |
| Stopped | `T` | Suspended (e.g., Ctrl+Z) |
| Zombie | `Z` | Terminated but parent has not collected exit status |

*Table 2. Process state symbols*

In the STAT column of `ps aux`, more characters may follow the state symbol, as in `Ss`, `S+`, and `I<`. `s` means a session leader, `+` the foreground process group, and `<` high priority, and `I` means an idle kernel thread.

---

<br>

## 2. Viewing Processes

### 2.1 ps: Process Status

The `ps` command prints information about the processes currently running, in the form `ps [options]`. Options of `ps` come in three types.

- **Unix (SVR4) options:** They can be grouped and start with `-` (e.g., `-ef`).
- **BSD options:** They can be grouped and do not start with `-` (e.g., `aux`).
- **GNU options:** They start with two dashes `--` (e.g., `--pid`).

```bash
ps                      # Current user's processes in current terminal
ps -e                   # All processes
ps -f                   # Full format
ps -ef                  # All processes, full format
ps aux                  # BSD-style all processes with details
ps -u username          # Processes for specific user
ps -p PID               # Specific process by PID
ps --forest             # Tree view of processes
```

| Option | Type | Function |
|--------|------|----------|
| `-e` | Unix | Prints information about all processes running on the system. |
| `-f` | Unix | Prints detailed information about processes (PPID, C, STIME, etc.). |
| `-u uid` | Unix | Prints information about all processes of a specific user. |
| `-p pid` | Unix | Prints information about the process with the given PID. |
| `a` | BSD | Prints information about processes started from terminals. |
| `u` | BSD | Prints details such as the process owner's name, CPU usage, and memory usage. |
| `x` | BSD | Prints information about all processes running on the system regardless of terminal. |
| `--pid PID list` | GNU | Prints information about the PIDs given in the list. |

*Table 3. Main options of ps*

Running `ps` without options prints only the PID, TTY, TIME, and CMD of the user processes started from the current shell or terminal. With the `-f` option, the PPID, C (CPU usage), start time, and other information are added as follows.

```text
$ ps -f
UID          PID    PPID  C STIME TTY          TIME CMD
user1       1584    1583  0 00:00 pts/0    00:00:00 -bash
user1       1660    1584  0 00:16 pts/0    00:00:00 ps -f
```

| Field | Meaning | Field | Meaning |
|-------|---------|-------|---------|
| UID | ID of the user who ran the process | STIME | Start date or time of the process |
| PID | Process number | TTY | Type and number of the terminal the process runs on |
| PPID | Parent process number | TIME | Execution time of the process |
| C | CPU usage (% value) | CMD | Name of the running program (command) |

*Table 4. Output fields of `ps -f`*

In the output above, the PPID of `ps -f`, 1584, equals the PID of `-bash`, which shows that `ps -f` is a child process of the shell.

**Understanding `ps aux` output:**

```text
USER  PID  %CPU  %MEM  VSZ    RSS   TTY  STAT  START  TIME  COMMAND
root    1   0.0   0.3  168K  12K    ?    Ss    10:00  0:01  /sbin/init
```

| Field | Meaning |
|-------|---------|
| USER | User account name |
| %CPU | CPU usage as a percentage |
| %MEM | Physical memory usage as a percentage |
| VSZ | Size of the virtual memory in use (KB) |
| RSS | Size of the physical memory in use (KB) |
| STAT | Process state (Section 1.3) |
| START | Process start time |

*Table 5. Additional output fields of `ps aux`*

Like `-ef`, `aux` prints detailed information about all processes on the system, and a process whose TTY is `?` is not attached to a terminal (a daemon, a kernel thread, etc.). To find the processes of a specific command, connect `ps` to `grep`, as in `ps -ef | grep command`.

> **Caution:** When grouping `-u` and `-f`, `-u` must come after `-f`, as in `ps -fu user1`. Writing `ps -uf user1` makes `ps` read the `f` right after `-u` as the user name, which gives the error `error: user name does not exist`.

### 2.2 pgrep: Finding Processes by Pattern

`pgrep` finds the processes that match a given pattern and prints their PIDs. The form is `pgrep [options] [pattern]`.

| Option | Function |
|--------|----------|
| `-x` | Prints the processes that match the pattern exactly. |
| `-n` | Prints the most recent process that contains the pattern. |
| `-u username` | Prints all processes of a specific user. |
| `-l` | Prints the PID and the process name. |
| `-t term` | Prints the processes associated with a specific terminal. |

*Table 6. Main options of pgrep*

```bash
$ pgrep -x bash                      # PID of processes named exactly bash
2096
$ pgrep -l bash                      # Print PID and command name
2096 bash
$ ps -fp $(pgrep -x bash)            # Pass the result of pgrep to ps for details
UID          PID    PPID  C STIME TTY          TIME CMD
user1       2096    2095  0 13:18 pts/0    00:00:00 -bash
$ ps -fp $(pgrep -u user1 bash)      # Only the bash processes of user1
```

### 2.3 top: Real-time Process Monitor

```bash
top                     # Interactive process monitor
```

`top` prints information about the running processes periodically. The upper part of the screen shows summary information such as the uptime, the number of users, the load average (Section 7.2), the number of processes in each state (Tasks), and CPU, memory, and swap usage, and the lower part shows information about each process.

| Field | Meaning | Field | Meaning |
|-------|---------|-------|---------|
| PID | Process ID | SHR | Size of the shared memory used by the process |
| USER | User account | %CPU | CPU usage as a percentage |
| PR | Priority | %MEM | Memory usage as a percentage |
| NI | Nice value | TIME+ | Cumulative CPU time |
| VIRT | Size of the virtual memory used by the process | COMMAND | Command name |
| RES | Size of the physical memory used by the process | | |

*Table 7. Output fields of top*

**top interactive commands:**

| Key | Action |
|-----|--------|
| `q` | Quit |
| `k` | Kill a process (enter PID) |
| `r` | Renice a process |
| `P` | Sort by CPU usage |
| `M` | Sort by memory usage |
| `u` | Show only the processes of a given user |
| `n` | Change the number of processes shown |
| `Enter`, `Space` | Redraw the screen immediately |
| `1` | Show individual CPU cores |
| `h` | Help |

*Table 8. Interactive commands of top*

### 2.4 pstree: Process Tree

```bash
pstree                  # Display process tree
pstree -p               # Show PIDs
pstree -u               # Show user transitions
pstree user1            # Show processes for specific user
```

In the GNOME desktop environment, the graphical System Monitor tool can also show the process list and resource usage and terminate processes.

---

<br>

## 3. Foreground and Background Processes

### 3.1 Running Processes

```bash
# Foreground (default)
command                          # Blocks terminal until complete

# Background
command &                        # Run in background
nohup command &                  # Run in background, persist after logout
```

A process handled by waiting until the command the user typed runs and prints its result is a **foreground process**. When a command is run in the background by adding `&` (ampersand) at its end, the prompt appears immediately regardless of whether the command has finished, so you can continue with other work. A process handled this way is a **background process**, and several processes can run at the same time in one terminal.

### 3.2 Job Control

**Job control** is the feature that runs and manages several processes at the same time in one terminal. It was first developed in the C shell and included in the 4.1BSD kernel, and it was later adopted by the Bourne shell family, so most Unix and Linux shells provide it. A process managed by job control is called a **job**; a foreground process becomes a foreground job and a background process a background job. Job control means switching jobs between foreground and background, suspending jobs, and terminating jobs.

```bash
jobs                             # List background jobs
jobs -l                          # List with PIDs
fg %1                            # Bring job 1 to foreground
bg %1                            # Resume job 1 in background
Ctrl+Z                           # Suspend foreground job
Ctrl+C                           # Terminate foreground job
```

`jobs [%job number]` shows all background jobs, and with a job number it shows only that job. Besides `%number`, the job number can be written as `%+` or `%%` (the job marked `+`) and `%-` (the job marked `-`).

| Field | Example | Meaning |
|-------|---------|---------|
| Job number | `[1]` | Increases by one for each job started in the background (`[1]`, `[2]`, `[3]`, ...). |
| Job order | `+` | `+` is the most recently accessed job, `-` is the job just before it, and a blank is any other job. |
| State | `Running` | Shows running (Running), finished normally (Done), terminated abnormally (Terminated, etc.), or suspended (Stopped). |
| Command | `sleep 100 &` | The command running in the background. |

*Table 9. Output fields of the jobs command*

| Command | Function |
|---------|----------|
| `Ctrl+Z` | Stops the foreground job (it suspends the job rather than terminating it). |
| `bg %job number` | Switches the job given by the job number to a background job. |
| `fg %job number` | Switches the job given by the job number to a foreground job. |

*Table 10. Job switching commands*

To send a foreground job to the background, suspend it with `Ctrl+Z` and then run `bg`. If the job number is omitted, the job marked `+` is the target.

```bash
$ sleep 100                      # Run in the foreground
^Z                               # Suspend with Ctrl+Z
[1]+  Stopped                 sleep 100
$ bg %1                          # Switch to the background
[1]+ sleep 100 &
$ jobs
[1]+  Running                 sleep 100 &
$ fg                             # Switch back to the foreground
sleep 100
```

Most foreground jobs terminate when you press `Ctrl+C`; if one does not, find its PID from another terminal and force it to terminate with the `kill` command. A background job is terminated with `kill %job number`.

### 3.3 nohup: No Hangup

When the terminal that started a background job closes or the user logs out, the running background job may be terminated too because of the SIGHUP signal delivered to it. If a job must keep running until it finishes even after logout, use the `nohup` command. `nohup` runs the command so that it ignores SIGHUP.

```bash
nohup long_running_script.sh &
# Output is written to nohup.out by default
nohup command > output.log 2>&1 &
```

> **Note:** With the `huponexit` option off, which is the default, bash does not send SIGHUP to background jobs when you log out with `exit`. However, closing the terminal window or losing the SSH connection delivers SIGHUP to the jobs, so use `nohup` to keep a job running for certain.

If no output file is given, the message `nohup: ignoring input and appending output to 'nohup.out'` is printed and the output is saved to the file `nohup.out` in the current directory. For example, after running `nohup find / -name passwd > pw.dat 2>&1 &` and logging out with `exit`, `find` keeps running, and both the search results and the error messages are saved to `pw.dat`.

---

<br>

## 4. Signals and Process Control

### 4.1 Common Signals

A **signal** is a simple message that tells a process that something has happened. What happened is expressed by a predefined constant, and signals are identified by numbers and have names. A process that receives a signal terminates by default, but depending on the signal it may stop or continue instead. `kill -l` prints the numbers and names of all signals.

| Signal | Number | Name | Default Action | Description |
|--------|--------|------|---------------|-------------|
| SIGHUP | 1 | Hangup | Terminate | Connection to the terminal is lost |
| SIGINT | 2 | Interrupt | Terminate | Ctrl+C |
| SIGQUIT | 3 | Quit | Core dump | Ctrl+\\ |
| SIGKILL | 9 | Kill | Terminate | Cannot be caught or ignored |
| SIGALRM | 14 | Alarm | Terminate | Raised by an alarm (timer) |
| SIGTERM | 15 | Terminate | Terminate | Graceful shutdown (default of `kill`) |
| SIGSTOP | 19 | Stop | Stop | Cannot be caught (like Ctrl+Z) |
| SIGTSTP | 20 | Terminal Stop | Stop | Signal sent by Ctrl+Z (can be caught) |
| SIGCONT | 18 | Continue | Continue | Resume stopped process |
| SIGUSR1 | 10 | User-defined | Terminate | Custom signal |
| SIGUSR2 | 12 | User-defined | Terminate | Custom signal |

*Table 11. Common signals*

> **Note:** The signal numbers are those of common Linux architectures such as x86 and ARM. On some architectures the numbers of SIGSTOP, SIGCONT, SIGUSR1, and others differ, so in scripts it is safer to use names such as `-STOP` and `-CONT` than numbers.

### 4.2 kill: Send Signals

The `kill` command sends the given signal to processes, in the form `kill [-signal] PID...`. Without a signal it sends signal 15 (SIGTERM). A process that receives SIGTERM cleans up its related files and terminates, but some processes do not terminate. In that case, force termination with signal 9 (SIGKILL).

```bash
kill PID                         # Send SIGTERM (15) - graceful
kill -9 PID                      # Send SIGKILL (9) - force kill
kill -HUP PID                    # Send SIGHUP (1) - reload config
kill -STOP PID                   # Suspend process
kill -CONT PID                   # Resume process
kill -l                          # List all signal names

# Kill by name
killall process_name             # Kill all processes with that name
pkill -f "pattern"               # Kill processes matching pattern
```

For example, if `man` is running in terminal 1, finding its PID in terminal 2 with `ps -fp $(pgrep -x man)` and running `kill -9 PID` terminates the `man` in terminal 1.

- **pkill** finds and terminates processes by their command name (CMD) rather than by PID. For example, `pkill man` terminates all processes named `man`, and `pgrep -x man` then prints nothing.
- **killall** also finds processes by command name and terminates all processes running under that name at once. A regular user can terminate only processes that the user owns.

### 4.3 Process Priority

```bash
# Run with adjusted priority (-20 to 19, lower = higher priority)
nice -n 10 command               # Run with lower priority
nice -n -5 command               # Run with higher priority (requires root)

# Change priority of running process
renice 10 -p PID                 # Set priority to 10
sudo renice -5 -p PID            # Set higher priority
```

The nice value is shown in the NI column of `top`. A regular user can only raise the nice value to lower the priority of the user's own processes, and only root can lower it (raise the priority).

---

<br>

## 5. Process Scheduling

### 5.1 Process Lifecycle

```text
Created (fork) --> Ready --> Running --> Terminated
                     ^          |
                     |          v
                     +-- Waiting/Sleeping
```

*Figure 1. Lifecycle of a process*

### 5.2 /proc Filesystem

```bash
ls /proc/                        # List all process directories
cat /proc/PID/status             # Process status information
cat /proc/PID/cmdline            # Command line that started process
cat /proc/cpuinfo                # CPU information
cat /proc/meminfo                # Memory information
cat /proc/uptime                 # System uptime
```

`/proc` is not a set of files stored on disk but a virtual filesystem through which the kernel presents process and system information as files. Every running process has a directory named after its PID.

---

<br>

## 6. Scheduled Tasks (cron and at)

### 6.1 crontab: Recurring Tasks

The `crontab` command manages each user's crontab file, which holds tasks to be run repeatedly at set times. The form is `crontab [-u user ID] [options] [filename]`.

```bash
crontab -e                       # Edit current user's crontab
crontab -l                       # List current user's crontab
crontab -r                       # Remove current user's crontab
sudo crontab -u user1 -e         # Edit another user's crontab
```

**Crontab Format:**

```text
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week (0-7, 0 and 7 = Sunday)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)
```

*Figure 2. The six fields of a crontab entry*

A crontab file can hold several tasks, one task per line. A line consists of six fields, minute, hour, day, month, weekday, and the task, separated by whitespace. For the weekday, 0 is Sunday, 1 is Monday, and 6 is Saturday, and Linux cron also accepts 7 as Sunday. A field value of `*` means every value of that field. For example, `30 23 1 * * /usr/bin/ls -l ~user1 > ~user1/cron.out` has `*` in the month and weekday fields, so it runs the task at 23:30 on the 1st of every month.

**Examples:**

```bash
# Run every minute
* * * * * /path/to/script.sh

# Run at 2:30 AM daily
30 2 * * * /path/to/backup.sh

# Run every Monday at 8:00 AM
0 8 * * 1 /path/to/weekly.sh

# Run on the 1st of every month at midnight
0 0 1 * * /path/to/monthly.sh

# Run every 5 minutes
*/5 * * * * /path/to/check.sh

# Run Mon-Fri at 9 AM
0 9 * * 1-5 /path/to/work.sh
```

- `crontab -e` uses the editor given in the environment variable `VISUAL` or `EDITOR` by default. To edit with vi, first run `EDITOR=vi; export EDITOR`.
- A user's crontab file is created in the `/var/spool/cron/crontabs` directory under the user's name. Its contents are shown with `crontab -l`.
- `crontab -r` deletes your own crontab file. To delete a specific user's crontab, the system administrator gives the user ID, as in `crontab -u user1 -r`.

Use of the `crontab` command is restricted with `/etc/cron.allow` and `/etc/cron.deny`.

- If `/etc/cron.allow` exists, only the users listed in it can use the `crontab` command.
- If `/etc/cron.allow` does not exist and `/etc/cron.deny` exists, only users not listed in `/etc/cron.deny` can use it.
- If neither file exists, depending on the system configuration, either only the system administrator or every user can use it.
- If both files exist, the contents of `/etc/cron.allow` apply and `/etc/cron.deny` is ignored.

### 6.2 at: One-time Tasks

The `at` command runs a scheduled command once at a set time. The form is `at [options] [time]`, and because it is not installed on Ubuntu by default, install it with `apt install at`. To receive the output by mail, a mail system must also be installed.

```bash
at 10:00                         # Schedule for 10:00 AM today
at now + 30 minutes              # Schedule 30 minutes from now
at 2:00 AM tomorrow              # Schedule for 2 AM tomorrow
atq                              # List pending at jobs
atrm job_number                  # Remove an at job
```

```bash
$ at now + 1 hour
at> /path/to/script.sh
at>                             # Press Ctrl+D to finish
```

Running `at` prints the message `warning: commands will be executed using /bin/sh` and shows the `at>` prompt. After you type the commands to run and press `Ctrl+D`, `<EOT>` is shown and the job number and run time are printed, as in `job 2 at Sun Dec 19 16:50:00 2021`, which completes the schedule. If only a time is given, as in `at 10:00`, and that time has already passed, the job is scheduled for the same time the next day. Times can be given in many ways, as follows.

- `at 4pm + 3 days` runs the job at 4 PM three days from now.
- `at 10am Jul 31` runs the job at 10 AM on July 31.
- `at 1am tomorrow` runs the job at 1 AM tomorrow.
- `at 10:00am today` runs the job at 10 AM today.

| Option | Function |
|--------|----------|
| `-l` | Prints the full list of commands waiting to run (same as `atq`). |
| `-r job number`, `-d job number` | Deletes the given job number from the commands waiting to run (same as `atrm`). |
| `-m` | Notifies the user by mail when the job completes even if there is no output. |
| `-f file` | Reads the commands to run from a file instead of standard input. |

*Table 12. Main options of at*

For example, you can write `at -m 0730 tomorrow`, `at 10:00 pm`, or `at 8:15 am May 30`. `atq` shows the jobs registered by the current user, and when run by root it shows the jobs of all users. Job files created by `at` are stored in the `/var/spool/cron/atjobs` directory by job number, and because only the daemon group can read this directory, viewing its contents requires `sudo`.

Use of the `at` command is restricted with `/etc/at.allow` and `/etc/at.deny`. `/etc/at.allow` stores the users allowed to use it and must be created when needed, and `/etc/at.deny` stores the users denied and exists by default.

- If `/etc/at.allow` exists, only the users listed in it can use the `at` command, and `/etc/at.deny` is ignored. Therefore, a user listed in both files can also use `at`.
- If `/etc/at.allow` does not exist, every user except those listed in `/etc/at.deny` can use the `at` command. If `/etc/at.deny` is an empty file, every user can use it.
- If neither file exists, only root can use the `at` command.

---

<br>

## 7. System Monitoring

### 7.1 Resource Monitoring Commands

```bash
# CPU and memory
top                              # Interactive process monitor
htop                             # Enhanced top (install: apt install htop)
vmstat 2 5                       # Virtual memory stats every 2 sec, 5 times
mpstat                           # CPU statistics

# Memory
free -h                          # Memory usage (human-readable)
free -m                          # Memory usage (MB)

# Disk
df -h                            # Disk space usage
du -sh /path                     # Directory size
iostat                           # I/O statistics

# Network
ss -tuln                         # Socket statistics
netstat -tuln                    # Network connections
```

### 7.2 uptime and load average

```bash
$ uptime
10:30:00 up 15 days, 3:22, 2 users, load average: 0.15, 0.10, 0.05
#                                                   ^^^^  ^^^^  ^^^^
#                                                   1min  5min  15min
```

The load average is the average number of processes that are running or waiting for the CPU, and on Linux it also includes processes in the `D` state waiting for disk I/O. On a single-core system, 1.0 means 100% CPU utilization, and with n cores, n.0 corresponds to 100% utilization.

---

<br>

## 8. Best Practices

### 8.1 Process Management Tips

- Always try `SIGTERM` (15) before `SIGKILL` (9).
- Use `nohup` for long-running tasks that should survive logout.
- Monitor system resources regularly with `top` or `htop`.
- Use `cron` for automated recurring tasks.
- Log the output of cron jobs for debugging.

### 8.2 Common Mistakes

| Mistake | Solution |
|---------|----------|
| Using `kill -9` as first resort | Try `kill PID` first (SIGTERM) |
| Zombie processes accumulating | Fix parent process or restart service |
| Cron job not running | Check paths, permissions, and cron logs |
| Forgetting `nohup` for SSH tasks | Use `nohup command &` or `screen`/`tmux` |

*Table 13. Common mistakes in process management and their solutions*

---

<br>

## Summary

| Concept | Key Summary |
|---------|-------------|
| Process | A process is a running instance of a program with a unique PID, and every process has a parent-child relationship. |
| Kinds of Processes | A daemon provides a service, an orphan is a child whose parent terminated first, and a zombie is a child that remains in the process table after terminating. |
| `ps` | `ps` shows process information with BSD, Unix, and GNU options, as in `ps aux` and `ps -ef`. |
| `pgrep` | `pgrep` finds the PIDs of processes matching a pattern and is used with `ps`, as in `ps -fp $(pgrep ...)`. |
| `top` | `top` is a real-time interactive monitor that refreshes process information periodically. |
| Background Jobs | Jobs are started with `command &` and controlled with `jobs`, `fg`, `bg`, and `Ctrl+Z`, and `nohup` keeps them running after logout. |
| Signals | `SIGTERM` (15) requests graceful termination, and `SIGKILL` (9) forces termination. |
| `kill` | Signals are sent with `kill PID`, `kill -9 PID`, and `kill %job number`, while `pkill` and `killall` find processes by name. |
| `nice`/`renice` | Process priority is adjusted with the nice value (-20 to 19). |
| `crontab` | Recurring tasks are scheduled in the minute hour day month weekday format, and use is restricted with `cron.allow` and `cron.deny`. |
| `at` | One-time tasks are scheduled, checked with `atq`, and removed with `atrm`, and use is restricted with `at.allow` and `at.deny`. |
| `/proc` | `/proc` is a virtual filesystem that provides process and system information. |

---

<br>

## Self-Check Questions

1. **ps option types:** What type are the options of `ps -ef`, `ps aux`, and `ps --pid 1`? Also, why does `ps -fu user1` work while `ps -uf user1` gives an error?

   <details>
   <summary>Answer</summary>

   `ps -ef` uses Unix (SVR4) options that start with `-`, `ps aux` uses BSD options written without `-`, and `ps --pid 1` uses a GNU option that starts with `--`. `-u` takes the user name right after it as its argument, so in `-fu user1` the user name is `user1`, but in `-uf user1` `f` is read as the user name, which gives the error `error: user name does not exist`.

   </details>

2. **Tracing job control:** You run `sleep 100`, press `Ctrl+Z`, and then run `bg %1`, `sleep 200 &`, and `jobs` in order. Write the output of `jobs`, and state which job comes to the foreground if you then run `fg` without arguments.

   <details>
   <summary>Answer</summary>

   `jobs` prints `[1]-  Running  sleep 100 &` and `[2]+  Running  sleep 200 &`. Job 2, started most recently, has the job order `+`, and job 1 before it has `-`. `fg` without arguments targets the job marked `+`, so `sleep 200` comes to the foreground.

   </details>

3. **Zombies and orphans:** Explain the difference between a zombie process and an orphan process, and state what problem arises when many zombie processes accumulate.

   <details>
   <summary>Answer</summary>

   A zombie process is a child process that has already finished running but remains in the process table because its parent has not collected its exit status, while an orphan process is a child process that is still running after its parent terminated first. An orphan is adopted by process 1 (`systemd`) and keeps running. A zombie uses almost no CPU or memory but occupies an entry in the process table, so if many accumulate, the table can run out and new processes may not be created.

   </details>

4. **Load average:** On a 4-core system, `uptime` prints `load average: 6.00, 3.50, 1.00`. Interpret the meaning of the three values and the state of the system.

   <details>
   <summary>Answer</summary>

   The three values are the load averages over the last 1, 5, and 15 minutes. With 4 cores, 4.00 corresponds to 100% utilization. The 1-minute value 6.00 means there are on average 2 more runnable processes than cores, so some are waiting, and since the average grew from 1.00 (15 minutes) to 3.50 (5 minutes) to 6.00 (1 minute), the load has been rising quickly in recent minutes.

   </details>

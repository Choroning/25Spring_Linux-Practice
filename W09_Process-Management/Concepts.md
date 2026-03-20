# W09 -- Process Management

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Understanding Processes](#1-understanding-processes)
2. [Viewing Processes](#2-viewing-processes)
3. [Foreground and Background Processes](#3-foreground-and-background-processes)
4. [Signals and Process Control](#4-signals-and-process-control)
5. [Process Scheduling](#5-process-scheduling)
6. [Scheduled Tasks (cron and at)](#6-scheduled-tasks-cron-and-at)
7. [System Monitoring](#7-system-monitoring)
8. [Best Practices](#8-best-practices)
9. [Summary](#summary)

---

## 1. Understanding Processes

### 1.1 What is a Process?

A **process** is a running instance of a program. Each process has:
- **PID (Process ID):** Unique identifier
- **PPID (Parent Process ID):** PID of the parent that created it
- **UID/GID:** Owner and group of the process
- **State:** Running, sleeping, stopped, zombie, etc.
- **Priority:** Scheduling priority value

### 1.2 Process Types

| Type | Description | Example |
|------|-------------|---------|
| **Foreground** | Interactive, attached to terminal | `vi file.txt` |
| **Background** | Runs independently of terminal | `command &` |
| **Daemon** | System service running in background | `sshd`, `cron`, `nginx` |
| **Zombie** | Completed but not yet cleaned by parent | Defunct process |
| **Orphan** | Parent has terminated; adopted by init/systemd | |

### 1.3 Process States

| State | Symbol | Description |
|-------|--------|-------------|
| Running | `R` | Currently executing on CPU |
| Sleeping | `S` | Waiting for an event (interruptible) |
| Uninterruptible Sleep | `D` | Waiting for I/O (cannot be interrupted) |
| Stopped | `T` | Suspended (e.g., Ctrl+Z) |
| Zombie | `Z` | Terminated but parent has not collected exit status |

---

## 2. Viewing Processes

### 2.1 ps -- Process Status

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

**Understanding `ps aux` output:**

```
USER  PID  %CPU  %MEM  VSZ    RSS   TTY  STAT  START  TIME  COMMAND
root    1   0.0   0.3  168K  12K    ?    Ss    10:00  0:01  /sbin/init
```

### 2.2 top -- Real-time Process Monitor

```bash
top                     # Interactive process monitor
```

**top interactive commands:**

| Key | Action |
|-----|--------|
| `q` | Quit |
| `k` | Kill a process (enter PID) |
| `r` | Renice a process |
| `P` | Sort by CPU usage |
| `M` | Sort by memory usage |
| `1` | Show individual CPU cores |
| `h` | Help |

### 2.3 pstree -- Process Tree

```bash
pstree                  # Display process tree
pstree -p               # Show PIDs
pstree -u               # Show user transitions
pstree user1            # Show processes for specific user
```

---

## 3. Foreground and Background Processes

### 3.1 Running Processes

```bash
# Foreground (default)
command                          # Blocks terminal until complete

# Background
command &                        # Run in background
nohup command &                  # Run in background, persist after logout
```

### 3.2 Job Control

```bash
jobs                             # List background jobs
jobs -l                          # List with PIDs
fg %1                            # Bring job 1 to foreground
bg %1                            # Resume job 1 in background
Ctrl+Z                           # Suspend foreground job
Ctrl+C                           # Terminate foreground job
```

### 3.3 nohup -- No Hangup

```bash
nohup long_running_script.sh &
# Output is written to nohup.out by default
nohup command > output.log 2>&1 &
```

---

## 4. Signals and Process Control

### 4.1 Common Signals

| Signal | Number | Name | Default Action | Description |
|--------|--------|------|---------------|-------------|
| SIGHUP | 1 | Hangup | Terminate | Terminal closed |
| SIGINT | 2 | Interrupt | Terminate | Ctrl+C |
| SIGQUIT | 3 | Quit | Core dump | Ctrl+\\ |
| SIGKILL | 9 | Kill | Terminate | Cannot be caught or ignored |
| SIGTERM | 15 | Terminate | Terminate | Graceful shutdown (default) |
| SIGSTOP | 19 | Stop | Stop | Cannot be caught (like Ctrl+Z) |
| SIGCONT | 18 | Continue | Continue | Resume stopped process |
| SIGUSR1 | 10 | User-defined | Terminate | Custom signal |
| SIGUSR2 | 12 | User-defined | Terminate | Custom signal |

### 4.2 kill -- Send Signals

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

### 4.3 Process Priority

```bash
# Run with adjusted priority (-20 to 19, lower = higher priority)
nice -n 10 command               # Run with lower priority
nice -n -5 command               # Run with higher priority (requires root)

# Change priority of running process
renice 10 -p PID                 # Set priority to 10
sudo renice -5 -p PID            # Set higher priority
```

---

## 5. Process Scheduling

### 5.1 Process Lifecycle

```
Created (fork) --> Ready --> Running --> Terminated
                     ^          |
                     |          v
                     +-- Waiting/Sleeping
```

### 5.2 /proc Filesystem

```bash
ls /proc/                        # List all process directories
cat /proc/PID/status             # Process status information
cat /proc/PID/cmdline            # Command line that started process
cat /proc/cpuinfo                # CPU information
cat /proc/meminfo                # Memory information
cat /proc/uptime                 # System uptime
```

---

## 6. Scheduled Tasks (cron and at)

### 6.1 crontab -- Recurring Tasks

```bash
crontab -e                       # Edit current user's crontab
crontab -l                       # List current user's crontab
crontab -r                       # Remove current user's crontab
sudo crontab -u user1 -e         # Edit another user's crontab
```

**Crontab Format:**

```
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week (0-7, 0 and 7 = Sunday)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)
```

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

### 6.2 at -- One-time Tasks

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

---

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

Load average: number of processes in the run queue. On a single-core system, 1.0 means 100% utilization.

---

## 8. Best Practices

### 8.1 Process Management Tips

- Always try `SIGTERM` (15) before `SIGKILL` (9)
- Use `nohup` for long-running tasks that should survive logout
- Monitor system resources regularly with `top` or `htop`
- Use `cron` for automated recurring tasks
- Log cron job output for debugging

### 8.2 Common Mistakes

| Mistake | Solution |
|---------|----------|
| Using `kill -9` as first resort | Try `kill PID` first (SIGTERM) |
| Zombie processes accumulating | Fix parent process or restart service |
| Cron job not running | Check paths, permissions, and cron logs |
| Forgetting `nohup` for SSH tasks | Use `nohup command &` or `screen`/`tmux` |

---

## Summary

| Concept | Key Point |
|---------|-----------|
| Process | Running instance of a program with unique PID |
| `ps` | View process information (`ps aux`, `ps -ef`) |
| `top` | Real-time interactive process monitor |
| Background Jobs | `command &`, `nohup`, `fg`, `bg`, `jobs` |
| Signals | `SIGTERM` (15, graceful), `SIGKILL` (9, force) |
| `kill` | Send signals to processes (`kill PID`, `kill -9 PID`) |
| `nice`/`renice` | Adjust process priority (-20 to 19) |
| `crontab` | Schedule recurring tasks (minute hour day month weekday) |
| `at` | Schedule one-time tasks |
| `/proc` | Virtual filesystem with process and system information |

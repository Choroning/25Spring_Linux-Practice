# Week 2 — Quiz

> **Last Updated:** 2026-03-21

---

## Q1. Terminal Prompt Symbols

**Question:** What does the prompt symbol indicate about the user's privilege level?

| Option | Description |
|--------|-------------|
| A | `$` indicates root user, `#` indicates regular user |
| B | `$` indicates regular user, `#` indicates root user |
| C | Both `$` and `#` indicate regular users |
| D | The prompt symbol has no relation to user privileges |

**Answer:** B. `$` indicates regular user, `#` indicates root user

**Explanation:** In Linux, the shell prompt displays `$` for regular (non-root) users and `#` for the root (superuser). This visual cue helps users recognize their current privilege level, which is important for preventing accidental execution of destructive commands with root privileges.

---

## Q2. Checking the Kernel Version

**Question:** Which command correctly displays the currently running Linux kernel version?

| Option | Command |
|--------|---------|
| A | `kernel -v` |
| B | `uname -r` |
| C | `version --kernel` |
| D | `cat /etc/kernel` |

**Answer:** B. `uname -r`

**Explanation:** The `uname -r` command prints the kernel release version (e.g., `5.15.0-56-generic`). The `-r` flag specifically requests the kernel release. Using `uname -a` would display all system information including kernel name, hostname, version, architecture, and OS.

---

## Q3. Purpose of sudo

**Question:** Which of the following best describes the purpose of `sudo`?

| Option | Description |
|--------|-------------|
| A | It permanently switches the current session to root |
| B | It executes a single command with superuser privileges |
| C | It creates a new root user account |
| D | It disables the root account |

**Answer:** B. It executes a single command with superuser privileges

**Explanation:** `sudo` (superuser do) allows a permitted user to execute a single command as root without switching to the root account. After the command completes, the user returns to their normal privilege level. This is safer than logging in as root because it limits the scope of elevated privileges and provides an audit trail.

---

## Q4. Shutting Down the System

**Question:** Which command schedules a system shutdown 10 minutes from now?

| Option | Command |
|--------|---------|
| A | `sudo shutdown -h 10` |
| B | `sudo shutdown -h +10` |
| C | `sudo shutdown -r +10` |
| D | `sudo shutdown -c +10` |

**Answer:** B. `sudo shutdown -h +10`

**Explanation:** `shutdown -h +10` schedules a halt (shutdown) 10 minutes from the current time. The `-h` flag means halt/power off, and `+10` specifies the delay in minutes. Option A is incorrect because `10` without `+` is interpreted differently. Option C would reboot (`-r`) instead of shutting down. Option D uses `-c`, which cancels a scheduled shutdown.

---

## Q5. VMware Snapshot Purpose

**Question:** What is the primary purpose of VMware's snapshot feature?

**Answer:** A snapshot saves the current state of the virtual machine at a specific point in time, allowing the user to restore the VM to that exact state later if something goes wrong during experimentation.

**Explanation:** Snapshots are critical for safe experimentation in lab environments. Before performing risky operations (such as modifying system files or installing untested software), taking a snapshot ensures you can revert to a known good state. This is different from cloning (which duplicates the entire VM) and suspending (which pauses the VM temporarily).

---

## Q6. SSH Remote Access

**Question:** After installing `openssh-server`, you want SSH to start automatically on every boot. Which command achieves this?

**Answer:** `sudo systemctl enable ssh`

**Explanation:** The `systemctl enable` command configures a service to start automatically at boot time by creating the necessary symlinks in the systemd startup directories. This is different from `systemctl start ssh`, which only starts the service immediately for the current session without enabling it at boot. To both enable and start immediately, you could run `sudo systemctl enable --now ssh`.

---

## Q7. Linux Features

**Question:** Which of the following is NOT a standard feature of Linux?

| Option | Feature |
|--------|---------|
| A | Multi-user support |
| B | Open source under GPL |
| C | Single-tasking (one process at a time) |
| D | POSIX compliance |

**Answer:** C. Single-tasking (one process at a time)

**Explanation:** Linux is a multi-tasking operating system, meaning it can run multiple processes concurrently. All other options are correct features of Linux: it supports multiple simultaneous users (multi-user), its source code is freely available under the GPL license (open source), and it is fully POSIX-compliant for Unix compatibility.

---

## Q8. Command Line Shortcuts

**Question:** You have typed a long command but realize you need to discard it entirely and start over. Which keyboard shortcut deletes the entire line from the cursor to the beginning?

| Option | Shortcut |
|--------|----------|
| A | `Ctrl + K` |
| B | `Ctrl + U` |
| C | `Ctrl + L` |
| D | `Ctrl + C` |

**Answer:** B. `Ctrl + U`

**Explanation:** `Ctrl + U` deletes everything from the cursor position to the beginning of the line. `Ctrl + K` deletes from the cursor to the end of the line. `Ctrl + L` clears the screen but keeps the current command. `Ctrl + C` cancels the current command/process entirely and gives a fresh prompt.

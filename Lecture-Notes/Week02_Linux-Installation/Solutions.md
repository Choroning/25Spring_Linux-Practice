# Week 2 Solutions — Linux Installation and Basic Usage

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 1

---

<br>

## Table of Contents

- [Exercise 1: Terminal Prompt Symbols](#exercise-1-terminal-prompt-symbols)
- [Exercise 2: Checking the Kernel Version](#exercise-2-checking-the-kernel-version)
- [Exercise 3: Purpose of sudo](#exercise-3-purpose-of-sudo)
- [Exercise 4: Shutting Down the System](#exercise-4-shutting-down-the-system)
- [Exercise 5: VMware Snapshot Purpose](#exercise-5-vmware-snapshot-purpose)
- [Exercise 6: SSH Remote Access](#exercise-6-ssh-remote-access)
- [Exercise 7: Linux Features](#exercise-7-linux-features)
- [Exercise 8: Command Line Shortcuts](#exercise-8-command-line-shortcuts)

---

<br>

## Exercise 1: Terminal Prompt Symbols

**Problem:** What does the prompt symbol indicate about the user's privilege level?

- A. `$` indicates the root user, and `#` indicates a regular user.
- B. `$` indicates a regular user, and `#` indicates the root user.
- C. Both `$` and `#` indicate regular users.
- D. The prompt symbol has no relation to user privileges.

### Solution

**Answer:** B. `$` indicates a regular user, and `#` indicates the root user.

**Explanation:** In Linux, the shell prompt displays `$` for regular (non-root) users and `#` for the root (superuser). This visual cue helps users recognize their current privilege level, which is important for preventing accidental execution of destructive commands with root privileges.

---

<br>

## Exercise 2: Checking the Kernel Version

**Problem:** Which command correctly displays the currently running Linux kernel version?

- A. `kernel -v`
- B. `uname -r`
- C. `version --kernel`
- D. `cat /etc/kernel`

### Solution

**Answer:** B. `uname -r`

**Explanation:** The `uname -r` command prints the kernel release version (e.g., `5.15.0-56-generic`). The `-r` option specifically requests the kernel release. Using `uname -a` displays all system information, including the kernel name, hostname, kernel release and version, architecture, and OS.

---

<br>

## Exercise 3: Purpose of sudo

**Problem:** Which of the following best describes the purpose of `sudo`?

- A. It permanently switches the current session to root.
- B. It executes a single command with superuser privileges.
- C. It creates a new root user account.
- D. It disables the root account.

### Solution

**Answer:** B. It executes a single command with superuser privileges.

**Explanation:** `sudo` (superuser do) allows a permitted user to execute a single command as root without switching to the root account. After the command completes, the user returns to their normal privilege level. This is safer than logging in as root because it limits the scope of elevated privileges and leaves an audit trail of who ran which command.

---

<br>

## Exercise 4: Shutting Down the System

**Problem:** Using the time format documented in the manual of `shutdown`, which command schedules a system shutdown 10 minutes from now?

- A. `sudo shutdown -h 10`
- B. `sudo shutdown -h +10`
- C. `sudo shutdown -r +10`
- D. `sudo shutdown -c +10`

### Solution

**Answer:** B. `sudo shutdown -h +10`

**Explanation:** `shutdown -h +10` schedules a halt (shutdown) 10 minutes from the current time. `-h` is the option that halts the system and powers it off (in systemd it is equivalent to `--poweroff`), and `+10` specifies the delay in minutes. The time formats documented in the manual are `hh:mm`, `+m`, and `now`. Option C would reboot (`-r`) instead of shutting down. Option D uses `-c`, which cancels a scheduled shutdown; the remaining argument is then treated as a message to users, not as a time.

> **Note:** The `10` in option A is not a documented format, but the systemd `shutdown` used by Ubuntu interprets a number without `:` as minutes with or without `+`, so in practice A also schedules a shutdown in 10 minutes. To make the intent clear without relying on the implementation, use the documented form in B.

---

<br>

## Exercise 5: VMware Snapshot Purpose

**Problem:** What is the primary purpose of VMware's snapshot feature?

### Solution

**Answer:** A snapshot saves the state of the virtual machine at a specific point in time, allowing the user to restore the VM to that exact state later if something goes wrong during experimentation.

**Explanation:** Snapshots are critical for safe experimentation in lab environments. Taking a snapshot before performing risky operations (such as modifying system files or installing untested software) ensures you can revert to a known good state. This is different from Clone, which duplicates the entire VM, and Suspend, which saves the current state so that the VM can continue from it later.

---

<br>

## Exercise 6: SSH Remote Access

**Problem:** After installing `openssh-server`, you want SSH to start automatically on every boot. Which command achieves this?

### Solution

**Answer:** `sudo systemctl enable ssh`

**Explanation:** The `systemctl enable` command configures a service to start automatically at boot time by creating the necessary symlinks in the systemd startup directories. This is different from `systemctl start ssh`, which only starts the service immediately without enabling it at boot. To both enable it at boot and start it immediately, run `sudo systemctl enable --now ssh`.

---

<br>

## Exercise 7: Linux Features

**Problem:** Which of the following is NOT a standard feature of Linux?

- A. Multi-user support
- B. Open source under the GPL
- C. Single-tasking (one process at a time)
- D. POSIX compliance

### Solution

**Answer:** C. Single-tasking (one process at a time)

**Explanation:** Linux is a multi-tasking operating system, meaning it can run multiple processes concurrently. All other options are correct features of Linux: it supports multiple simultaneous users (multi-user), its source code is freely available under the GPL license (open source), and it follows most of the POSIX standard for Unix compatibility.

---

<br>

## Exercise 8: Command Line Shortcuts

**Problem:** You have typed a long command but need to discard it entirely and start over. With the cursor at the end of the line, which keyboard shortcut deletes everything from the cursor to the beginning of the line?

- A. `Ctrl + K`
- B. `Ctrl + U`
- C. `Ctrl + L`
- D. `Ctrl + C`

### Solution

**Answer:** B. `Ctrl + U`

**Explanation:** `Ctrl + U` deletes everything from the cursor position to the beginning of the line. `Ctrl + K` deletes from the cursor to the end of the line. `Ctrl + L` clears the screen but keeps the current command. `Ctrl + C` cancels the command being typed or the running process and gives a fresh prompt.

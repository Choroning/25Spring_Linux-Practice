# Week 14 Solutions — Boot and Shutdown

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 8

---

<br>

## Table of Contents

- [Exercise 1: Replacement for init](#exercise-1-replacement-for-init)
- [Exercise 2: Checking Current Target](#exercise-2-checking-current-target)
- [Exercise 3: System Shutdown Commands](#exercise-3-system-shutdown-commands)
- [Exercise 4: Linux Boot Sequence](#exercise-4-linux-boot-sequence)
- [Exercise 5: Reboot Runlevel](#exercise-5-reboot-runlevel)
- [Exercise 6: Scheduled Reboot](#exercise-6-scheduled-reboot)
- [Exercise 7: Role of the Bootloader](#exercise-7-role-of-the-bootloader)
- [Exercise 8: Listing Device Units](#exercise-8-listing-device-units)
- [Exercise 9: Checking Service Active Status](#exercise-9-checking-service-active-status)
- [Exercise 10: Switching to Single-User Mode](#exercise-10-switching-to-single-user-mode)

---

<br>

## Exercise 1: Replacement for init

**Problem:** What is the name of the service that replaced the traditional PID 1 process `init`?

- A. system
- B. systemd
- C. systemctl
- D. sysinit

### Solution

**Answer:** B. systemd

**Explanation:** `systemd` is the modern init system that replaced the traditional SysVinit (`init`) in most major Linux distributions. It runs as PID 1 and manages system services, mount points, timers, and more. `/sbin/init` still exists, but it is a symbolic link to `/lib/systemd/systemd`. `systemctl` is the command-line tool used to interact with `systemd`, not the service itself.

---

<br>

## Exercise 2: Checking Current Target

**Problem:** What command is used to check the current (default) target?

- A. `systemctl set-default`
- B. `systemctl status`
- C. `systemctl start`
- D. `systemctl get-default`

### Solution

**Answer:** D. `systemctl get-default`

**Explanation:** `systemctl get-default` displays the default target unit that the system boots into (e.g., `multi-user.target` or `graphical.target`). `set-default` changes the default target, `status` shows the status of a specific unit, and `start` starts a unit. Targets in systemd replace the concept of runlevels from SysVinit. The default target is the value used at boot, so if the target was changed with `isolate` after booting, the current state is checked with `runlevel` or `systemctl list-units --type=target`.

---

<br>

## Exercise 3: System Shutdown Commands

**Problem:** Which of the following is **NOT** a command that shuts down the system?

- A. `reboot`
- B. `halt`
- C. `kill`
- D. `poweroff`

### Solution

**Answer:** C. `kill`

**Explanation:** `kill` sends signals to individual processes but does not shut down the system. `reboot` restarts the system, `halt` stops the CPU, and `poweroff` shuts down and powers off the machine. All three are symbolic links to `/bin/systemctl`. While `kill` can terminate processes, it is not a system shutdown command.

---

<br>

## Exercise 4: Linux Boot Sequence

**Problem:** What is the correct order of the Linux boot stages?

- A. Boot loader -> BIOS -> Kernel init -> systemd -> Login prompt
- B. BIOS -> Kernel init -> Boot loader -> systemd -> Login prompt
- C. Boot loader -> Kernel init -> BIOS -> systemd -> Login prompt
- D. BIOS -> Boot loader -> Kernel init -> systemd -> Login prompt

### Solution

**Answer:** D. BIOS -> Boot loader -> Kernel init -> systemd -> Login prompt

**Explanation:** The Linux boot process follows this sequence: (1) BIOS/UEFI performs POST and hardware initialization, (2) the bootloader (e.g., GRUB2) loads the kernel into memory, (3) the kernel initializes hardware drivers and mounts the root file system, (4) systemd (PID 1) starts system services based on the default target, and (5) the login prompt is displayed. Since the bootloader is what loads the kernel into memory, kernel initialization cannot come before the bootloader, and since the BIOS is what finds and runs the bootloader, the BIOS comes first.

---

<br>

## Exercise 5: Reboot Runlevel

**Problem:** Which runlevel indicates a system reboot?

- A. 0
- B. 3
- C. 5
- D. 6

### Solution

**Answer:** D. 6

**Explanation:** In the SysVinit runlevel scheme, runlevel 0 is halt or shutdown, runlevel 1 is single-user mode, runlevel 3 is multi-user with networking (no GUI), runlevel 5 is multi-user with GUI, and runlevel 6 is reboot. In systemd, runlevel 6 corresponds to `reboot.target`, and the system can be rebooted with `init 6` or `systemctl isolate runlevel6.target`.

---

<br>

## Exercise 6: Scheduled Reboot

**Problem:** What command sets the system to reboot in 1 minute?

- A. `shutdown -h +1`
- B. `shutdown -r +1`
- C. `shutdown -c +1`
- D. `shutdown -k +1`

### Solution

**Answer:** B. `shutdown -r +1`

**Explanation:** `shutdown -r +1` schedules a system reboot in 1 minute. The `-r` flag means reboot, `-h` means halt or power off, `-c` cancels a pending shutdown, and `-k` only sends warning messages without actually shutting down. The `+1` specifies the delay in minutes. So A shuts down after 1 minute, C cancels the schedule (the time argument has no meaning), and D only sends the message.

---

<br>

## Exercise 7: Role of the Bootloader

**Problem:** Explain the role of the bootloader.

### Solution

**Answer:** The bootloader loads the kernel into memory.

**Explanation:** The bootloader (e.g., GRUB2, LILO) is responsible for loading the Linux kernel image (`/boot/vmlinuz-version`) from disk into RAM and transferring control to it. It also provides a menu for selecting between multiple operating systems or kernel versions, passes boot parameters to the kernel, and can load an initial RAM disk (initrd/initramfs) for early-stage hardware initialization.

---

<br>

## Exercise 8: Listing Device Units

**Problem:** What command is used to check what device units exist?

### Solution

**Answer:** `systemctl -t device`

**Explanation:** The `systemctl -t device` command lists the device units managed by systemd. The `-t` (type) option filters units by their type. Other unit types include `service`, `socket`, `mount`, `timer`, and `target`. Device units are automatically created by systemd based on udev device events. To include inactive device units, add `-a`.

---

<br>

## Exercise 9: Checking Service Active Status

**Problem:** What command checks whether the `abc.service` unit is active (running)?

### Solution

**Answer:** `systemctl is-active abc.service`

**Explanation:** `systemctl is-active abc.service` checks and prints the active state of the specified unit. It prints `active` if the service is running, `inactive` if stopped, or `failed` if it encountered an error. This command is useful as a condition command in scripts because it also returns an appropriate exit code (0 for active, non-zero otherwise). Whether the unit starts automatically at boot is checked separately with `systemctl is-enabled abc.service`.

---

<br>

## Exercise 10: Switching to Single-User Mode

**Problem:** What command switches the system to single-user (rescue) mode for troubleshooting?

### Solution

**Answer:** `systemctl isolate rescue`

**Explanation:** `systemctl isolate rescue.target` (or the shorthand `rescue`) switches the system to rescue mode, which is equivalent to the traditional single-user mode (runlevel 1). `systemctl isolate runlevel1`, `init 1`, and `telinit S` do the same. In rescue mode, only essential services are running, the root file system is mounted, and only the root user can log in. This mode is used for system maintenance and troubleshooting when the normal multi-user mode is not functioning properly. To return to multi-user mode, run `reboot` or `systemctl default`.

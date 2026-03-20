# W14 — Quiz

> **Last Updated:** 2026-03-21

---

## Q1. Replacement for init

**Question:** What is the name of the service that replaced the traditional PID 1 process `init`?

| Option | Answer |
|--------|--------|
| A | system |
| B | systemd |
| C | systemctl |
| D | sysinit |

**Answer:** B. systemd

**Explanation:** `systemd` is the modern init system that replaced the traditional SysVinit (`init`) in most major Linux distributions. It runs as PID 1 and manages system services, mount points, timers, and more. `systemctl` is the command-line tool used to interact with `systemd`, not the service itself.

---

## Q2. Checking Current Target

**Question:** What command is used to check the current (default) target?

| Option | Command |
|--------|---------|
| A | `systemctl set-default` |
| B | `systemctl status` |
| C | `systemctl start` |
| D | `systemctl get-default` |

**Answer:** D. `systemctl get-default`

**Explanation:** `systemctl get-default` displays the default target unit that the system boots into (e.g., `multi-user.target` or `graphical.target`). `set-default` changes the default target, `status` shows the status of a specific unit, and `start` starts a unit. Targets in systemd replace the concept of runlevels from SysVinit.

---

## Q3. System Shutdown Commands

**Question:** Which of the following is **NOT** a command that shuts down the system?

| Option | Command |
|--------|---------|
| A | `reboot` |
| B | `halt` |
| C | `kill` |
| D | `poweroff` |

**Answer:** C. `kill`

**Explanation:** `kill` sends signals to individual processes but does not shut down the system. `reboot` restarts the system, `halt` stops the CPU, and `poweroff` shuts down and powers off the machine. While `kill` can terminate processes, it is not a system shutdown command.

---

## Q4. Linux Boot Sequence

**Question:** What is the correct order of the Linux boot stages?

| Option | Boot Sequence |
|--------|--------------|
| A | Boot loader -> BIOS -> Kernel init -> systemd -> Login prompt |
| B | BIOS -> Kernel init -> Boot loader -> systemd -> Login prompt |
| C | Boot loader -> Kernel init -> BIOS -> systemd -> Login prompt |
| D | BIOS -> Boot loader -> Kernel init -> systemd -> Login prompt |

**Answer:** D. BIOS -> Boot loader -> Kernel init -> systemd -> Login prompt

**Explanation:** The Linux boot process follows this sequence: (1) BIOS/UEFI performs POST and hardware initialization, (2) the boot loader (e.g., GRUB2) loads the kernel into memory, (3) the kernel initializes hardware drivers and mounts the root file system, (4) systemd (PID 1) starts system services based on the default target, and (5) the login prompt is displayed.

---

## Q5. Reboot Runlevel

**Question:** Which runlevel indicates a system reboot?

| Option | Runlevel |
|--------|----------|
| A | 0 |
| B | 3 |
| C | 5 |
| D | 6 |

**Answer:** D. 6

**Explanation:** In the SysVinit runlevel scheme: runlevel 0 is halt/shutdown, runlevel 1 is single-user mode, runlevel 3 is multi-user with networking (no GUI), runlevel 5 is multi-user with GUI, and runlevel 6 is reboot. In systemd, runlevel 6 corresponds to `reboot.target`.

---

## Q6. Scheduled Reboot

**Question:** What command sets the system to reboot in 1 minute?

| Option | Command |
|--------|---------|
| A | `shutdown -h +1` |
| B | `shutdown -r +1` |
| C | `shutdown -c +1` |
| D | `shutdown -k +1` |

**Answer:** B. `shutdown -r +1`

**Explanation:** `shutdown -r +1` schedules a system reboot in 1 minute. The `-r` flag means reboot, `-h` means halt/poweroff, `-c` cancels a pending shutdown, and `-k` only sends warning messages without actually shutting down. The `+1` specifies the delay in minutes.

---

## Q7. Role of the Boot Loader

**Question:** Explain the role of the boot loader.

**Answer:** The boot loader loads the kernel into memory.

**Explanation:** The boot loader (e.g., GRUB2, LILO) is responsible for loading the Linux kernel image from disk into RAM and transferring control to it. It also provides a menu for selecting between multiple operating systems or kernel versions, passes boot parameters to the kernel, and can load an initial RAM disk (initrd/initramfs) for early-stage hardware initialization.

---

## Q8. Listing Device Units

**Question:** What command is used to check what device units exist?

**Answer:** `systemctl -t device`

**Explanation:** The `systemctl -t device` command lists all device units managed by systemd. The `-t` (type) option filters units by their type. Other unit types include `service`, `socket`, `mount`, `timer`, and `target`. Device units are automatically created by systemd based on udev device events.

---

## Q9. Checking Service Active Status

**Question:** What command checks whether the `abc.service` unit is active (running)?

**Answer:** `systemctl is-active abc.service`

**Explanation:** `systemctl is-active abc.service` checks and prints the active state of the specified unit. It returns "active" if the service is running, "inactive" if stopped, or "failed" if it encountered an error. This command is useful in scripts as it also returns an appropriate exit code (0 for active, non-zero otherwise).

---

## Q10. Switching to Single-User Mode

**Question:** What command switches the system to single-user (rescue) mode for troubleshooting?

**Answer:** `systemctl isolate rescue`

**Explanation:** `systemctl isolate rescue.target` (or shorthand `rescue`) switches the system to rescue mode, which is equivalent to the traditional single-user mode (runlevel 1). In rescue mode, only essential services are running, the root file system is mounted, and only the root user can log in. This mode is used for system maintenance and troubleshooting when the normal multi-user mode is not functioning properly.

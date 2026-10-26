# Week 14 Lecture — Boot and Shutdown

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-10-26
>
> 우분투 리눅스, 이종원, Ch 8

> **Learning Objectives:**
> 1. Describe the Linux boot process (BIOS/UEFI, GRUB, init/systemd) and the role of the bootloader
> 2. Configure GRUB bootloader settings
> 3. Manage system services with systemctl
> 4. Understand and change runlevels and systemd targets
> 5. Explain how to shut down the system and the roles of daemons and the super daemon
> 6. Recover the password of the root account

---

## Table of Contents

- [1. Linux Boot Process](#1-linux-boot-process)
  - [1.1 Boot Sequence Overview](#11-boot-sequence-overview)
  - [1.2 Detailed Boot Steps](#12-detailed-boot-steps)
  - [1.3 BIOS Stage](#13-bios-stage)
  - [1.4 Bootloader Stage](#14-bootloader-stage)
  - [1.5 Kernel Initialization Stage](#15-kernel-initialization-stage)
  - [1.6 systemd Service Stage](#16-systemd-service-stage)
  - [1.7 Checking Boot Messages: dmesg](#17-checking-boot-messages-dmesg)
  - [1.8 Process 1](#18-process-1)
- [2. BIOS/UEFI and Bootloader](#2-biosuefi-and-bootloader)
  - [2.1 BIOS vs. UEFI](#21-bios-vs-uefi)
  - [2.2 Boot Disk Structure (MBR)](#22-boot-disk-structure-mbr)
- [3. GRUB Bootloader](#3-grub-bootloader)
  - [3.1 GRUB Overview](#31-grub-overview)
  - [3.2 GRUB2 Configuration](#32-grub2-configuration)
  - [3.3 Common GRUB Settings](#33-common-grub-settings)
  - [3.4 GRUB Boot Menu](#34-grub-boot-menu)
- [4. systemd and Init System](#4-systemd-and-init-system)
  - [4.1 systemd Overview](#41-systemd-overview)
  - [4.2 systemd Units](#42-systemd-units)
  - [4.3 systemctl: Service Management](#43-systemctl-service-management)
  - [4.4 Viewing Services](#44-viewing-services)
  - [4.5 journalctl: System Logs](#45-journalctl-system-logs)
- [5. Runlevels and Targets](#5-runlevels-and-targets)
  - [5.1 SysV Runlevels vs. systemd Targets](#51-sysv-runlevels-vs-systemd-targets)
  - [5.2 Managing Targets](#52-managing-targets)
  - [5.3 init and telinit](#53-init-and-telinit)
  - [5.4 Single-User Mode](#54-single-user-mode)
- [6. System Shutdown and Reboot](#6-system-shutdown-and-reboot)
  - [6.1 Ways to Shut Down](#61-ways-to-shut-down)
  - [6.2 The shutdown Command](#62-the-shutdown-command)
  - [6.3 Shutdown Commands](#63-shutdown-commands)
- [7. Daemon Processes](#7-daemon-processes)
  - [7.1 Daemons and How They Run](#71-daemons-and-how-they-run)
  - [7.2 Ancestors of Daemons](#72-ancestors-of-daemons)
  - [7.3 Main Daemons](#73-main-daemons)
- [8. Root Password Recovery](#8-root-password-recovery)
  - [8.1 Recovery Steps (Ubuntu/GRUB2)](#81-recovery-steps-ubuntugrub2)
  - [8.2 Booting into Recovery Mode](#82-booting-into-recovery-mode)
- [9. Best Practices](#9-best-practices)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. Linux Boot Process

### 1.1 Boot Sequence Overview

**Booting** is the process from turning on the computer's power until the operating system runs and a user can log in. As Figure 1 shows, Linux boots through the BIOS (or UEFI) stage, the bootloader stage, the kernel initialization stage, and the systemd service stage, and ends by printing the login prompt. Of these, the BIOS stage is the **PC boot** that every PC performs regardless of the installed operating system, and the part from the bootloader stage to the login prompt is the **Linux boot**.

```text
Power On
    |
    v
+--------+     +-----------+     +--------+     +---------+
|  BIOS/ | --> | Bootloader| --> | Kernel | --> | systemd |
|  UEFI  |     |  (GRUB)   |     | (init) |     | services|
+--------+     +-----------+     +--------+     +---------+
    |                |                |               |
    v                v                v               v
POST &          Load kernel      Mount root      Start services
find boot       + initramfs      filesystem      (network, ssh,
device                                            login, etc.)
```

*Figure 1. Linux boot sequence and the work of each stage*

### 1.2 Detailed Boot Steps

1. **BIOS/UEFI POST:** Performs the hardware self-test (POST, Power-On Self-Test) and initializes devices.
2. **Boot device selection:** Finds a bootable device (HDD, USB, network).
3. **Bootloader (GRUB):** Loads the kernel and the initial RAM disk (initramfs) into memory.
4. **Kernel initialization:** Detects hardware, loads drivers, and mounts the root file system.
5. **systemd (PID 1):** Starts system services in parallel.
6. **Login prompt:** Displays the login screen (GUI or text).

The **initial RAM disk (initramfs)** is a small file system image that the kernel uses as a temporary root before mounting the real root file system. It contains the drivers and tools needed to read the disk holding the root file system. Sections 1.3-1.6 describe each stage in detail.

### 1.3 BIOS Stage

The BIOS checks the state of the basic hardware installed in the PC (keyboard, disks, and so on), selects a boot device, and reads 512 bytes from the first sector of the boot disk into memory. These 512 bytes are called the **Master Boot Record (MBR)**, and they store information about which partition of the disk holds the bootloader, the second-stage boot program (Section 2.2). The MBR code loaded into memory goes as far as finding the bootloader and loading it into memory. On a system using UEFI, the firmware itself reads and runs a bootloader program stored in the EFI System Partition (ESP) of the disk instead of the MBR code.

### 1.4 Bootloader Stage

The **bootloader** loads the Linux kernel into memory. It usually offers a menu for choosing which of several operating systems or kernel versions to boot, and Ubuntu uses GRUB as its bootloader (Section 3). The Linux kernel is provided under the `/boot` directory as a file named `vmlinuz-version` (for example, `/boot/vmlinuz-5.13.0-22-generic`).

By default, Ubuntu hides the GRUB menu and boots immediately. To print the GRUB menu at boot, edit `/etc/default/grub` as follows and run `sudo update-grub` to apply the change (Section 3.3). The GRUB menu is then printed when Ubuntu restarts.

- Add `#` before `GRUB_TIMEOUT_STYLE=hidden` to comment it out.
- Change `GRUB_TIMEOUT=0` to `GRUB_TIMEOUT=10`.

### 1.5 Kernel Initialization Stage

The kernel loaded into memory by the bootloader first checks the devices connected to the system, such as memory, disks, keyboard, and mouse, and initializes the required drivers. When basic initialization such as the device check is done, the kernel creates kernel threads (Section 7.2), mounts the root file system, and runs systemd as process 1, the first user process.

### 1.6 systemd Service Stage

Once systemd starts, Linux begins to operate in earnest. systemd starts the services needed by the configured default target (Section 5) in parallel, and meanwhile a boot splash screen is displayed. Removing `quiet splash` from the kernel parameters prints detailed boot messages instead of the splash screen (Section 3.3). When all services have started, booting is complete and the login screen is displayed.

### 1.7 Checking Boot Messages: dmesg

`dmesg` prints the kernel ring buffer, which stores the messages the kernel printed during booting. Since the messages are long, they are viewed one screen at a time with `more`. The number inside `[ ]` at the start of each line is the time (in seconds) since the kernel started.

```text
user1@myubuntu:~$ sudo dmesg | more
[    0.000000] Linux version 5.13.0-22-generic (buildd@lgw01-amd64-012) (gcc (Ubuntu 11.2.0-7ubuntu2) 11.2.0, GNU ld (GNU Binutils for Ubuntu) 2.37) #22-Ubuntu SMP Fri Nov 5 13:21:36 UTC 2021 (Ubuntu 5.13.0-22.22-generic 5.13.19)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.13.0-22-generic root=UUID=265c8913-ee1e-4034-885f-207969b0a23b ro splash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000]   zhaoxin   Shanghai
[    0.000000] Disabled fast string operations
(omitted)
```

The first line shows the kernel version, and `Command line` on the second line shows the parameters the bootloader passed to the kernel (the kernel image, the UUID of the root file system, `ro`, and `splash`).

### 1.8 Process 1

The first user process the kernel runs receives PID 1 and becomes the ancestor of every other user process. Traditionally, process 1 was `init`, and `ps -ef` still shows process 1 as `/sbin/init`.

```text
user1@myubuntu:~$ ps -ef | more
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 12:26 ?        00:00:01 /sbin/init splash
root           2       0  0 12:26 ?        00:00:00 [kthreadd]
root           3       2  0 12:26 ?        00:00:00 [rcu_gp]
root           4       2  0 12:26 ?        00:00:00 [rcu_par_gp]
(omitted)
```

Process 1 still seems to be `init`, but `/sbin/init` is actually a symbolic link to the systemd executable. So the program actually running as process 1 is systemd.

```text
user1@myubuntu:~$ ls -l /sbin/init
lrwxrwxrwx 1 root root 20 Nov 21 11:10 /sbin/init -> /lib/systemd/systemd
```

---

<br>

## 2. BIOS/UEFI and Bootloader

### 2.1 BIOS vs. UEFI

The **BIOS (Basic Input/Output System)** is the traditional firmware stored in the ROM of the mainboard, and **UEFI (Unified Extensible Firmware Interface)** is a modern firmware specification created to replace the BIOS. Their features are as follows.

| Feature | BIOS | UEFI |
|---------|------|------|
| Partition Table | MBR | GPT |
| Max Boot Disk | 2 TB | 9.4 ZB |
| Boot Speed | Slower | Faster |
| Interface | Text-based | Graphical |
| Secure Boot | No | Yes |
| Architecture | 16-bit | 32/64-bit |

*Table 1. Comparison of BIOS and UEFI*

The partition table in the table is the format each firmware is usually paired with. UEFI can also boot an MBR disk in compatibility mode, and with GRUB a BIOS can boot a GPT disk. The difference in maximum boot disk size comes from the partition table. MBR stores sector numbers in 32 bits, so with 512-byte sectors it can address only $2^{32} \times 512$ bytes, about 2 TB, while GPT stores them in 64 bits and can address $2^{64} \times 512$ bytes, about 9.4 ZB. **Secure Boot** is a UEFI feature that runs only bootloaders and kernels whose signatures are verified, preventing malicious code from slipping into the boot process.

### 2.2 Boot Disk Structure (MBR)

```text
+---+-----------------------------------+
|MBR| Partition 1 | Partition 2 | ...   |
+---+-----------------------------------+
 |
 +-- 446 bytes: Bootloader code
 +-- 64 bytes: Partition table (4 entries)
 +-- 2 bytes: Magic number (0x55AA)
```

*Figure 2. Structure of an MBR boot disk and layout of the MBR*

The MBR occupies the first 512-byte sector of the disk (446 + 64 + 2). The first 446 bytes hold the first-stage code of the bootloader, and the 64-byte partition table consists of four 16-byte entries, recording at most four primary partitions. The last 2 bytes are the boot signature (magic number) `0x55AA`, which marks the sector as a valid boot sector.

---

<br>

## 3. GRUB Bootloader

### 3.1 GRUB Overview

**GRUB (GRand Unified Bootloader)** is the bootloader Ubuntu supports by default. Its features are as follows.

- It can boot Windows as well as Linux and supports multi-boot, choosing one of several operating systems to boot.
- Boot entries can be modified with commands at boot time, so it can be used for root password recovery and safe-mode booting (Section 8).
- The latest version of GRUB is GRUB2. Compared with GRUB, GRUB2 has better portability and modularity and loads the modules it needs dynamically, and Ubuntu uses GRUB2 as its default bootloader.

### 3.2 GRUB2 Configuration

```text
# Main configuration file (auto-generated)
/boot/grub/grub.cfg

# Custom settings
/etc/default/grub

# Custom menu entries
/etc/grub.d/
```

- **`/boot/grub/grub.cfg`:** The main configuration file of GRUB2. It is generated automatically by reading `/etc/default/grub` and the scripts under the `/etc/grub.d` directory, so users do not edit it directly. Direct edits are overwritten the next time it is regenerated.
- **`/etc/default/grub`:** Stores the settings of the GRUB menu. The GRUB scripts read this file and write the settings into `grub.cfg`.
- **`/etc/grub.d/`:** The directory holding the GRUB scripts. When the command that builds `grub.cfg` runs, these scripts run in the numeric order of their file names and generate each part of `grub.cfg`. Custom menu entries are added to `40_custom`.

```text
user1@myubuntu:~$ ls /etc/grub.d
00_header        10_linux      20_linux_xen    30_os-prober      40_custom  README
05_debian_theme  10_linux_zfs  20_memtest86+   30_uefi-firmware  41_custom
```

### 3.3 Common GRUB Settings

```bash
# /etc/default/grub
GRUB_DEFAULT=0                    # Default boot entry
GRUB_TIMEOUT=5                    # Timeout in seconds
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"  # Kernel parameters
GRUB_CMDLINE_LINUX=""             # Additional kernel parameters
```

`GRUB_DEFAULT=0` means booting the first menu entry (counted from 0) by default, and `GRUB_TIMEOUT` is the time (in seconds) to show the menu before booting the default entry. The parameters in `GRUB_CMDLINE_LINUX_DEFAULT` are passed as kernel parameters only to normal boot entries, and those in `GRUB_CMDLINE_LINUX` to every entry, including recovery mode. `quiet` reduces boot messages, and `splash` displays the boot splash screen. The following is an example of the file edited so that the GRUB menu is printed, as in Section 1.4.

```text
user1@myubuntu:~$ cat /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'
GRUB_DEFAULT=0
#GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="splash"
#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""
(omitted)
```

```bash
# After editing, regenerate grub.cfg
sudo update-grub
# or
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

`grub-mkconfig` generates a `grub.cfg` file and prints the result to standard output unless an output file is given with `-o`. `update-grub` is the Ubuntu command that runs `grub-mkconfig -o /boot/grub/grub.cfg`. After editing `/etc/default/grub`, one of the two must be run for the change to reach `grub.cfg`.

### 3.4 GRUB Boot Menu

Pressing `Shift` (BIOS) or `Esc` (UEFI) at boot opens the GRUB menu, where the following can be done.

- Select a different kernel.
- Boot into recovery mode (Section 8.2).
- Edit boot parameters temporarily with the `e` key. The edits apply only to that boot and are not saved (Section 8.1).

---

<br>

## 4. systemd and Init System

### 4.1 systemd Overview

`systemd` is the init system and service manager for modern Linux (PID 1). It takes over the work of the Unix init process, starting various service daemons, maintaining the state of processes, and managing the state of the system. In current Ubuntu the init service has been replaced by the systemd service, and `man init` prints the description of systemd.

- Parallel service startup for faster boot
- Socket and D-Bus activation
- On-demand starting of daemons
- Snapshot and restore of system state
- Log management via `journald`

systemd also has the following advantages.

- It works on a socket basis and keeps compatibility with inetd (Section 7.1).
- It can boot independently of the shell.
- It can control mounting and fsck (file system checks).
- It can deliver signals to services.
- It can end user sessions safely before shutdown.

> **Note:** **The snapshot feature.** The snapshot unit, which saved snapshots of the system state, was a feature of early systemd and was removed in systemd 228 (2015). It is not available in current distributions.

### 4.2 systemd Units

systemd starts and manages the whole system using components called **units**. A managed object is named in the form `name.unit_type`; for example, `cron.service` is the cron service unit and `multi-user.target` is a target unit. The unit types are as follows.

| Unit | Function | Example |
|------|----------|---------|
| service | A system service unit that starts, stops, restarts, and loads daemons. | `atd.service` |
| target | Groups units. For example, `multi-user.target` is the group of units corresponding to runlevel 3. | `basic.target` |
| automount | Manages automount points in the directory hierarchy. | `proc-sys-fs-binfmt_misc.automount` |
| device | Manages devices in the Linux device tree. | `sys-module-fuse.device` |
| mount | Manages mount points in the directory hierarchy. | `boot.mount` |
| path | Manages paths such as files and directories in the file system. | `cups.path` |
| scope | Manages processes created externally. | `init.scope` |
| slice | Manages the processes of the system hierarchically. | `system-getty.slice` |
| socket | A unit that manages sockets, supporting AF_INET, AF_INET6, and AF_UNIX socket streams and datagrams, and FIFOs. | `dbus.socket` |
| swap | Manages swap devices. | `dev-mapper-fedora\x2dswap.swap` |
| timer | Manages timer-related functions. | `dnf-makecache.timer` |

*Table 2. Types of systemd units*

### 4.3 systemctl: Service Management

`systemctl` is the command that controls systemd services, in the form `systemctl [options] [command] [unit_name]`. `.service` can be omitted from a unit name.

```bash
# Service control
sudo systemctl start service          # Start service
sudo systemctl stop service           # Stop service
sudo systemctl restart service        # Restart service
sudo systemctl reload service         # Reload configuration
sudo systemctl status service         # Check status
sudo systemctl enable service         # Enable at boot
sudo systemctl disable service        # Disable at boot
sudo systemctl is-active service      # Check if running
sudo systemctl is-enabled service     # Check if enabled

# Examples
sudo systemctl status ssh
sudo systemctl restart nginx
sudo systemctl enable docker
```

| Option, Command | Function |
|-----------------|----------|
| `-a` | Prints all units regardless of their state. |
| `-t unit_type` | Prints only units of the given type (e.g., `systemctl -t service`). |
| `start`, `stop` | Starts or stops a unit. |
| `reload` | Rereads the configuration file of a unit. |
| `restart` | Restarts a unit. |
| `status` | Prints the state of a unit. |
| `enable`, `disable` | Sets a unit to start, or not to start, at boot. |
| `is-active` | Checks whether a unit is running. |
| `is-enabled` | Checks whether a unit is set to start at boot. |
| `isolate` | Starts only the given unit and the units related to it, and stops the rest. |
| `kill` | Sends a signal to the processes of a unit. |

*Table 3. Main options and commands of systemctl*

`start` and `stop` change only the current running state, and `enable` and `disable` change only whether the unit starts automatically from the next boot on. So to start a service now and at every boot, run both or use `systemctl enable --now`. `reload` makes a service reread its configuration without restarting the process, and some services do not support it. The following example starts the cron service and checks whether it is running. Its state is shown in detail with `systemctl status cron`, and it is stopped with `sudo systemctl stop cron`.

```text
user1@myubuntu:~$ sudo systemctl start cron
user1@myubuntu:~$ systemctl is-active cron
active
```

### 4.4 Viewing Services

```bash
systemctl list-units --type=service              # Active services
systemctl list-units --type=service --all         # All services
systemctl list-unit-files --type=service          # All unit files
```

Running `systemctl` alone, with no options, prints the units currently loaded in memory and running. Adding `-a` includes inactive units, and adding `-t service` or `--type=service` prints only service units.

```text
user1@myubuntu:~$ systemctl
  UNIT                   LOAD   ACTIVE SUB    DESCRIPTION
(omitted)
  basic.target           loaded active active Basic System
  bluetooth.target       loaded active active Bluetooth
  cryptsetup.target      loaded active active Local Encrypted Volumes
  getty.target           loaded active active Login Prompts
  graphical.target       loaded active active Graphical Interface
  local-fs-pre.target    loaded active active Local File Systems (Pre)
  local-fs.target        loaded active active Local File Systems
  multi-user.target      loaded active active Multi-User System
  network-online.target  loaded active active Network is Online
  network.target         loaded active active Network
(omitted)
LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.
229 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
```

`LOAD` shows whether the unit definition was loaded properly, `ACTIVE` the generalized activation state of the unit (`active`, `inactive`, `failed`, and so on), and `SUB` the detailed state that depends on the unit type (`running`, `exited`, and so on for services).

### 4.5 journalctl: System Logs

`journalctl` queries the logs collected by journald, the logging service of systemd.

```bash
journalctl                           # All logs
journalctl -b                        # Logs since last boot
journalctl -u ssh                    # Logs for specific service
journalctl -f                        # Follow logs (like tail -f)
journalctl --since "2025-03-21"      # Logs since date
journalctl -p err                    # Only error-level logs
```

`-u` filters logs by unit name, and `-p err` shows only logs whose priority is err or higher (err, crit, alert, emerg). An ordinary user can see only their own logs, so viewing the logs of the whole system requires `sudo` or membership in the `adm` or `systemd-journal` group.

---

<br>

## 5. Runlevels and Targets

### 5.1 SysV Runlevels vs. systemd Targets

A **runlevel** is a number or letter that distinguishes system states. SysV init defined the services to run for each runlevel, and systemd defines system states with target units instead of runlevels. For compatibility, the target files `runlevel0.target` through `runlevel6.target` are provided as symbolic links to the actual target units.

| Runlevel | Target File (Symbolic Link) | systemd Target | Description |
|----------|-----------------------------|---------------|-------------|
| 0 | `runlevel0.target` | `poweroff.target` | Halt / Power off |
| 1, S, s | `runlevel1.target` | `rescue.target` | Single-user / Rescue mode |
| 2 | `runlevel2.target` | `multi-user.target` | Multi-user (no network) |
| 3 | `runlevel3.target` | `multi-user.target` | Multi-user with network |
| 4 | `runlevel4.target` | `multi-user.target` | Unused / Custom |
| 5 | `runlevel5.target` | `graphical.target` | GUI with network |
| 6 | `runlevel6.target` | `reboot.target` | Reboot |

*Table 4. Correspondence between SysV runlevels and systemd targets*

> **Note:** **Runlevels 2-4.** In systemd, runlevels 2, 3, and 4 are all linked to `multi-user.target`, so the three are the same multi-user mode. The distinction in the table between 2 (no network), 3 (with network), and 4 (unused) is a convention of Red Hat style SysV init; the SysV init of Debian and Ubuntu used runlevels 2-5 as the same multi-user mode.

### 5.2 Managing Targets

```bash
# View current target
systemctl get-default

# Set default target
sudo systemctl set-default graphical.target    # Boot to GUI
sudo systemctl set-default multi-user.target   # Boot to CLI

# Switch target immediately
sudo systemctl isolate multi-user.target       # Switch to CLI now
sudo systemctl isolate graphical.target        # Switch to GUI now
```

`systemctl get-default` prints the default target used at boot, and `runlevel` prints the previous and current runlevels. `N 5` in the following output means there is no previous runlevel (N) and the system booted into runlevel 5.

```text
user1@myubuntu:~$ systemctl get-default
graphical.target
user1@myubuntu:~$ runlevel
N 5
```

The default target is set with `systemctl set-default <target name>.target`. The default target is the one the symbolic link `/etc/systemd/system/default.target` points to, so `set-default` recreates this link.

```text
user1@myubuntu:~$ sudo systemctl set-default multi-user.target
Created symlink /etc/systemd/system/default.target → /lib/systemd/system/multi-user.target.
user1@myubuntu:~$ ls -l /etc/systemd/system/default.target
lrwxrwxrwx 1 root root 37 Jan  1 13:31 /etc/systemd/system/default.target -> /lib/systemd/system/multi-user.target
user1@myubuntu:~$ sudo systemctl set-default graphical.target
Removed /etc/systemd/system/default.target.
Created symlink /etc/systemd/system/default.target → /lib/systemd/system/graphical.target.
```

`set-default` takes effect from the next boot. To change the target right away, use `isolate`; `.target` may be omitted, and runlevel-named targets may be used. For example, `systemctl isolate multi-user` and `systemctl isolate runlevel3` change to `multi-user.target` (runlevel 3), and `systemctl isolate graphical` and `systemctl isolate runlevel5` change to `graphical.target` (runlevel 5).

### 5.3 init and telinit

The traditional `init` and `telinit` commands can also change the runlevel. Today `/sbin/telinit` is a symbolic link to `/bin/systemctl`, and `init number` is handled as a request to switch to the corresponding `runlevelX.target`.

```text
user1@myubuntu:~$ init --help
init [OPTIONS...] COMMAND

Send control commands to the init daemon.

Commands:
  0              Power-off the machine
  6              Reboot the machine
  2, 3, 4, 5     Start runlevelX.target unit
  1, s, S        Enter rescue mode
  q, Q           Reload init daemon configuration
  u, U           Reexecute init daemon

Options:
     --help      Show this help
     --no-wall   Don't send wall message before halt/power-off/reboot

See the telinit(8) man page for details.
user1@myubuntu:~$ ls -l /sbin/telinit
lrwxrwxrwx 1 root root 14 Nov 21 11:10 /sbin/telinit -> /bin/systemctl
```

```text
# init 0       // shutdown
# telinit 0
# init 3       // multi-user target
# init 5       // graphical-user target
# init 6       // reboot
```

### 5.4 Single-User Mode

When the system has a problem, it is switched to the `rescue.target` unit (runlevel 1, runlevel S) for inspection. This state is called **single-user mode**: only essential services run, and only root can log in and work. The following four commands all switch to single-user mode.

```text
systemctl isolate rescue
systemctl isolate runlevel1
init 1
telinit S
```

To return from single-user mode to multi-user mode, restart with the `reboot` command or switch to the default target with the `systemctl default` command.

---

<br>

## 6. System Shutdown and Reboot

### 6.1 Ways to Shut Down

Linux can be shut down in the following ways.

- Use the `shutdown` command.
- Use the `halt` command.
- Use the `poweroff` command.
- Switch the runlevel to 0 or 6.
- Use the `reboot` command.
- Turn off the power.

Linux collects data to be written to disk in memory before writing it, so turning off the power without the normal shutdown procedure can lose unwritten data or damage the file system. Cutting the power is used only when the system does not respond.

### 6.2 The shutdown Command

`shutdown` is the most proper way to shut down a Linux system. It sends a shutdown message to every logged-in user, blocks new logins, and shuts the system down at the given time. Its form is `shutdown [options] [time] [message]`.

| Item | Meaning |
|------|---------|
| `-k` | Does not actually shut down the system; only sends the message to users. |
| `-r` | Restarts after shutting down. |
| `-h` | Shuts down the system. Traditionally it goes to the halt state; with systemd's `shutdown`, it also powers off unless `--halt` is given. |
| `-f` | A fast restart that may skip fsck. This is an option of SysV init's `shutdown` and does not exist in systemd's `shutdown`. |
| `-c` | Cancels a previously issued `shutdown` command. |
| Time | When to shut down, given as `hh:mm` (clock time), `+m` (after m minutes), or `now` (immediately). |
| Message | The message to send to all users. |

*Table 5. Options and arguments of shutdown*

```text
user1@myubuntu:~$ sudo shutdown -h now
user1@myubuntu:~$ sudo shutdown -h +2 "System is going down in 2 min"
user1@myubuntu:~$ sudo shutdown -r +3
user1@myubuntu:~$ sudo shutdown -c
user1@myubuntu:~$ sudo shutdown -k 2
```

The commands above, in order, shut down the system immediately, send a message that the system will go down in 2 minutes and then shut down, restart after 3 minutes, cancel the scheduled command, and only send a message that the system will go down in 2 minutes.

### 6.3 Shutdown Commands

```bash
sudo shutdown -h now                 # Shutdown immediately
sudo shutdown -h +10                 # Shutdown in 10 minutes
sudo shutdown -h 22:00               # Shutdown at 10 PM
sudo shutdown -r now                 # Reboot immediately
sudo shutdown -c                     # Cancel scheduled shutdown
sudo poweroff                        # Power off
sudo halt                            # Halt system
sudo reboot                          # Reboot
sudo init 0                          # Shutdown (SysV)
sudo init 6                          # Reboot (SysV)
```

`halt` stops the operating system but may not turn off the power, while `poweroff` stops it and also turns off the power. Changing the runlevel to 0 shuts down the system, and changing it to 6 restarts it. With systemd, the same can be done by naming the target directly.

```text
user1@myubuntu:~$ sudo systemctl isolate poweroff.target
user1@myubuntu:~$ sudo systemctl isolate runlevel0.target
user1@myubuntu:~$ sudo systemctl isolate reboot.target
user1@myubuntu:~$ sudo systemctl isolate runlevel6.target
```

The first two commands shut down the system, and the last two restart it. `halt`, `poweroff`, and `reboot` are all symbolic links to the `systemctl` command. `systemctl` checks the name it was run under and performs the corresponding action.

```text
user1@myubuntu:~$ ls -l /sbin/halt
lrwxrwxrwx 1 root root 14 Nov 21 11:10 /sbin/halt -> /bin/systemctl
user1@myubuntu:~$ ls -l /sbin/poweroff
lrwxrwxrwx 1 root root 14 Nov 21 11:10 /sbin/poweroff -> /bin/systemctl
user1@myubuntu:~$ ls -l /sbin/reboot
lrwxrwxrwx 1 root root 14 Nov 21 11:10 /sbin/reboot -> /bin/systemctl
```

---

<br>

## 7. Daemon Processes

### 7.1 Daemons and How They Run

A **daemon** is a process that runs in the background of Linux and provides a particular service. Daemons run in two ways.

- **Stand-alone daemon:** Runs continuously from system startup and receives and handles service requests itself. It can respond immediately, but it occupies memory even when there are no requests.
- **Running through the super daemon:** The daemon normally does not run; when a request arrives, the super daemon runs it.

A **super daemon** is a daemon that manages daemons. When a user requests a network service, the super daemon receives the request and starts the corresponding service daemon. The Unix super daemon was inetd, and later xinetd, which includes security features, was used. In current distributions using systemd, systemd takes over this role by receiving requests with socket units and starting the services (socket activation), and xinetd is installed separately when needed.

### 7.2 Ancestors of Daemons

- **systemd daemon:** The ancestor of most processes, responsible for managing the state of the system comprehensively.
- **Kernel thread daemons:** Daemons that manage part of the kernel's functions as if they were processes. They are the processes whose names appear in brackets (`[ ]`) in the output of `ps`, and as the output in Section 1.8 shows, most are children of `kthreadd`, PID 2. Kernel daemons mostly perform I/O, memory management, disk synchronization, and so on.

### 7.3 Main Daemons

| Daemon | Function |
|--------|----------|
| atd | Runs commands scheduled to run at a specific time (scheduled with the `at` command). |
| cron | Runs commands scheduled to run periodically. |
| dhcpd | Provides the service that assigns IP addresses dynamically. |
| httpd | Provides the web service. |
| lpd | Provides the print service. |
| nfs | Provides the network file system service. |
| named | Provides the DNS service. |
| sendmail | Provides the e-mail service. |
| smtpd | The mail transfer daemon. |
| popd | Provides the basic mailbox service. |
| routed | Provides the automatic IP routing table service. |
| smb | Provides the Samba service. |
| syslogd | Provides the logging service. |
| sshd | Provides the secure remote access service. |
| in.telnetd | Provides the remote access service. |
| ftpd | Provides the file transfer service. |
| ntpd | Provides the time synchronization service. |

*Table 6. Main daemons of Linux*

A daemon is usually named by appending `d`, for daemon, to the service name.

---

<br>

## 8. Root Password Recovery

### 8.1 Recovery Steps (Ubuntu/GRUB2)

When the root password is forgotten, the kernel parameters are changed temporarily in GRUB to obtain a root shell without a password check, and the password is then changed.

1. Reboot and access the GRUB menu (hold `Shift` during boot).
2. Select the kernel entry and press `e` to edit.
3. Find the line starting with `linux` and append `init=/bin/bash`.
4. Press `Ctrl+X` or `F10` to boot.
5. Remount the root file system as read-write: `mount -o remount,rw /`
6. Change the root password: `passwd root`
7. Reboot: `exec /sbin/init` or `reboot -f`

`init=/bin/bash` makes the kernel run bash instead of systemd as process 1, so a shell with root privileges opens without any login procedure. The root file system is then mounted read-only because of the `ro` parameter on the `linux` line, so it must be remounted read-write, as in step 5, before the password file can be modified. Since systemd is not running, the ordinary `reboot` (`systemctl`) does not work; reboot forcibly with `reboot -f`, or run systemd with `exec /sbin/init` to continue booting. Since `reboot -f` does not unmount the file systems properly, it is safer to run `sync` first to write the changes to disk.

Steps 2, 3, and 5 can also be handled at once as follows.

1. Restart the system.
2. Quickly press `e` when the GRUB boot menu appears to switch to edit mode.
3. On the line with the Linux kernel information, change `ro splash $vt_handoff` to `rw init=/bin/bash` and press `F10` to restart.
4. The system runs as the root account.
5. Change the password with `passwd root`.
6. When done, reboot with `reboot -f`.

```text
linux  /boot/vmlinuz-5.13.0-22-generic root=UUID=265c8913-ee1e-4034-885f-207969b0a23b ro splash $vt_handoff
linux  /boot/vmlinuz-5.13.0-22-generic root=UUID=265c8913-ee1e-4034-885f-207969b0a23b rw init=/bin/bash
```

The first line is the `linux` line before editing, and the second is the line edited to boot into single-user mode. Since `rw` mounts the root read-write from the start, the `mount -o remount,rw /` step is unnecessary.

> **Caution:** This method means that anyone with physical access to the system can obtain root privileges. Systems where security matters, such as servers, set a GRUB password to prevent editing of boot entries (Section 9).

### 8.2 Booting into Recovery Mode

**Recovery mode** is a way of booting that provides only the most basic services and allows working in command mode. The procedure for booting into recovery mode is as follows.

1. On the initial GRUB menu screen, select `Advanced options for Ubuntu`, and when the menu appears, select the entry marked `recovery mode`.
2. When the Recovery Menu appears, select the `root` item.
3. Selecting the `root` item immediately prints a root prompt.
4. Remount the root file system in read-write mode: `mount -o remount,rw /`
5. After performing the recovery work, restart with `reboot -f`.

| Item | Function |
|------|----------|
| resume | Continues normal booting (Resume normal boot). |
| clean | Frees space on the disk (Try to make free space). |
| dpkg | Repairs broken packages (Repair broken packages). |
| fsck | Checks all file systems (Check all file systems). |
| grub | Updates the GRUB bootloader (Update grub bootloader). |
| network | Enables networking (Enable networking). |
| root | Enters a root shell prompt (Drop to root shell prompt). |
| system-summary | Prints a summary of the system (System summary). |

*Table 7. Items of the Ubuntu recovery menu*

As `filesystem state: read-only` in the title of the recovery menu indicates, recovery mode also mounts the root file system read-only at first. That is why the remount in step 4 is needed. Selecting the `root` item prints `Press Enter for maintenance (or press Control-D to continue):`, and pressing `Enter` brings up the root prompt (`root@myubuntu:~#`).

---

<br>

## 9. Best Practices

- Keep the GRUB timeout reasonable (3-5 seconds).
- Understand the boot process for troubleshooting.
- Use `systemctl` for all service management.
- Monitor boot time with `systemd-analyze` and `systemd-analyze blame`. `blame` shows the startup time of each service, longest first.
- Set a GRUB password for physical security.
- Document any custom boot parameters.

---

<br>

## Summary

| Concept | Key Summary |
|---------|-------------|
| Boot process | Booting proceeds through BIOS/UEFI, GRUB, the kernel, systemd, and services, and prints the login prompt. |
| MBR | The first 512-byte sector of the boot disk, consisting of 446 bytes of bootloader code, a 64-byte partition table, and a 2-byte magic number. |
| GRUB | The bootloader that loads the kernel into memory; after editing `/etc/default/grub`, `update-grub` regenerates `grub.cfg`. |
| systemd | The modern init system running as PID 1, which starts and manages services in parallel as units. |
| systemctl | Units are managed with `start`, `stop`, `enable`, `disable`, `status`, `is-active`, `isolate`, and so on. |
| journalctl | It shows the systemd logs collected by journald, filtered by boot, unit, priority, and so on. |
| Targets | systemd boot targets (graphical, multi-user, rescue, and so on) replace SysV runlevels; `set-default` changes the default and `isolate` the current state. |
| Shutdown | `shutdown -h now`, `poweroff`, `reboot`, and `init 0`/`init 6` shut down or restart the system, and `halt`, `poweroff`, and `reboot` are symbolic links to `systemctl`. |
| Daemons | Processes that provide services in the background, running stand-alone or started through a super daemon (inetd, xinetd). |
| Password recovery | Adding `init=/bin/bash` to the `linux` line of a GRUB entry boots into a root shell, where `passwd root` changes the password. |

---

<br>

## Self-Check Questions

1. **Layout of the MBR:** Write the layout of the 512-byte MBR and explain why an MBR disk can have at most four primary partitions.

   <details>
   <summary>Answer</summary>

   The MBR consists of 446 bytes of bootloader code, a 64-byte partition table, and the 2-byte magic number (boot signature) `0x55AA`, for 446 + 64 + 2 = 512 bytes. Each partition table entry is 16 bytes, so only 64 / 16 = 4 entries fit. Therefore there are at most four primary partitions.

   </details>

2. **Changing GRUB settings:** You want the GRUB menu to be shown for 10 seconds. Explain why `/boot/grub/grub.cfg` is not edited directly and give the correct procedure.

   <details>
   <summary>Answer</summary>

   `grub.cfg` is generated automatically from `/etc/default/grub` and the scripts in `/etc/grub.d`, so direct edits are overwritten the next time it is regenerated. The correct procedure is to comment out `GRUB_TIMEOUT_STYLE=hidden` and change the value to `GRUB_TIMEOUT=10` in `/etc/default/grub`, then run `sudo update-grub` (or `sudo grub-mkconfig -o /boot/grub/grub.cfg`).

   </details>

3. **start and enable:** Explain the difference between `sudo systemctl start cron` and `sudo systemctl enable cron`. What is needed for cron to be running after a reboot?

   <details>
   <summary>Answer</summary>

   `start` only starts the cron service now and does not affect the next boot. `enable` only sets cron to start automatically at boot and does not change the current running state. For cron to be running after a reboot, `enable` is needed; to start it now and also set automatic start, run both commands or use `systemctl enable --now cron`.

   </details>

4. **Commands that are symbolic links:** `ls -l /sbin/reboot` shows `/sbin/reboot -> /bin/systemctl`. Explain what this means and why `reboot -f` is used instead of `reboot` after booting with `init=/bin/bash`.

   <details>
   <summary>Answer</summary>

   `reboot` is not a separate program but `systemctl`, and when `systemctl` runs under the name `reboot`, it asks systemd to restart. After booting with `init=/bin/bash`, process 1 is bash and systemd is not running, so this request cannot be handled. `reboot -f` restarts forcibly without the procedure that stops services properly, and when systemd is not running it asks the kernel directly to restart, so the system reboots even in this state.

   </details>

5. **How daemons run:** Compare a stand-alone daemon and running through the super daemon in terms of response speed and resource use.

   <details>
   <summary>Answer</summary>

   A stand-alone daemon is always running, so it responds to requests immediately but occupies resources such as memory even when there are no requests. With the super daemon, the daemon is run when a request arrives, so it uses no resources normally, but the response is slower by the time needed to start the daemon for each request. So frequently requested services run stand-alone, and rarely used services run through a super daemon or systemd socket activation.

   </details>

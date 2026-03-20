# W14 -- Boot and Shutdown

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Linux Boot Process](#1-linux-boot-process)
2. [BIOS/UEFI and Bootloader](#2-biosuefi-and-bootloader)
3. [GRUB Bootloader](#3-grub-bootloader)
4. [systemd and Init System](#4-systemd-and-init-system)
5. [Runlevels and Targets](#5-runlevels-and-targets)
6. [System Shutdown and Reboot](#6-system-shutdown-and-reboot)
7. [Root Password Recovery](#7-root-password-recovery)
8. [Best Practices](#8-best-practices)
9. [Summary](#summary)

---

## 1. Linux Boot Process

### 1.1 Boot Sequence Overview

```
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

### 1.2 Detailed Boot Steps

1. **BIOS/UEFI POST:** Hardware self-test, initialize devices
2. **Boot device selection:** Find bootable device (HDD, USB, network)
3. **Bootloader (GRUB):** Load kernel and initial RAM disk
4. **Kernel initialization:** Detect hardware, load drivers, mount root
5. **systemd (PID 1):** Start system services in parallel
6. **Login prompt:** Display login screen (GUI or text)

---

## 2. BIOS/UEFI and Bootloader

### 2.1 BIOS vs. UEFI

| Feature | BIOS | UEFI |
|---------|------|------|
| Partition Table | MBR | GPT |
| Max Boot Disk | 2 TB | 9.4 ZB |
| Boot Speed | Slower | Faster |
| Interface | Text-based | Graphical |
| Secure Boot | No | Yes |
| Architecture | 16-bit | 32/64-bit |

### 2.2 Boot Disk Structure (MBR)

```
+---+-----------------------------------+
|MBR| Partition 1 | Partition 2 | ...   |
+---+-----------------------------------+
 |
 +-- 446 bytes: Bootloader code
 +-- 64 bytes: Partition table (4 entries)
 +-- 2 bytes: Magic number (0x55AA)
```

---

## 3. GRUB Bootloader

### 3.1 GRUB2 Configuration

```bash
# Main configuration file (auto-generated)
/boot/grub/grub.cfg

# Custom settings
/etc/default/grub

# Custom menu entries
/etc/grub.d/
```

### 3.2 Common GRUB Settings

```bash
# /etc/default/grub
GRUB_DEFAULT=0                    # Default boot entry
GRUB_TIMEOUT=5                    # Timeout in seconds
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"  # Kernel parameters
GRUB_CMDLINE_LINUX=""             # Additional kernel parameters
```

```bash
# After editing, regenerate grub.cfg
sudo update-grub
# or
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 3.3 GRUB Boot Menu

At boot, press `Shift` (BIOS) or `Esc` (UEFI) to access GRUB menu:
- Select different kernels
- Boot into recovery mode
- Edit boot parameters temporarily with `e`

---

## 4. systemd and Init System

### 4.1 systemd Overview

`systemd` is the init system and service manager for modern Linux (PID 1):
- Parallel service startup for faster boot
- Socket and D-Bus activation
- On-demand starting of daemons
- Snapshot and restore of system state
- Log management via `journald`

### 4.2 systemctl -- Service Management

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

### 4.3 Viewing Services

```bash
systemctl list-units --type=service              # Active services
systemctl list-units --type=service --all         # All services
systemctl list-unit-files --type=service          # All unit files
```

### 4.4 journalctl -- System Logs

```bash
journalctl                           # All logs
journalctl -b                        # Logs since last boot
journalctl -u ssh                    # Logs for specific service
journalctl -f                        # Follow logs (like tail -f)
journalctl --since "2025-03-21"      # Logs since date
journalctl -p err                    # Only error-level logs
```

---

## 5. Runlevels and Targets

### 5.1 SysV Runlevels vs. systemd Targets

| Runlevel | systemd Target | Description |
|----------|---------------|-------------|
| 0 | `poweroff.target` | Halt / Power off |
| 1 | `rescue.target` | Single-user / Rescue mode |
| 2 | `multi-user.target` | Multi-user (no network) |
| 3 | `multi-user.target` | Multi-user with network |
| 4 | `multi-user.target` | Unused / Custom |
| 5 | `graphical.target` | GUI with network |
| 6 | `reboot.target` | Reboot |

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

---

## 6. System Shutdown and Reboot

### 6.1 Shutdown Commands

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

---

## 7. Root Password Recovery

### 7.1 Recovery Steps (Ubuntu/GRUB2)

1. Reboot and access GRUB menu (hold `Shift` during boot)
2. Select the kernel entry and press `e` to edit
3. Find the line starting with `linux` and append `init=/bin/bash`
4. Press `Ctrl+X` or `F10` to boot
5. Remount root filesystem as read-write: `mount -o remount,rw /`
6. Change the root password: `passwd root`
7. Reboot: `exec /sbin/init` or `reboot -f`

---

## 8. Best Practices

- Keep GRUB timeout reasonable (3-5 seconds)
- Understand the boot process for troubleshooting
- Use `systemctl` for all service management
- Monitor boot time with `systemd-analyze` and `systemd-analyze blame`
- Set GRUB password for physical security
- Document any custom boot parameters

---

## Summary

| Concept | Key Point |
|---------|-----------|
| Boot Process | BIOS/UEFI -> GRUB -> Kernel -> systemd -> Services |
| GRUB | Bootloader; configured via `/etc/default/grub` |
| systemd | Modern init system (PID 1); parallel service startup |
| systemctl | Service management (`start/stop/enable/disable`) |
| journalctl | View systemd logs |
| Targets | systemd boot targets (graphical, multi-user, rescue) |
| Shutdown | `shutdown -h now`, `poweroff`, `reboot` |
| Password Recovery | Edit GRUB entry, boot to bash, change password |

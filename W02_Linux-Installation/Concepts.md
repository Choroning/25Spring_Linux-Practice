# Week 2 -- Linux Installation and Basic Usage

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Linux Basics](#1-linux-basics)
2. [Setting Up the Lab Environment](#2-setting-up-the-lab-environment)
3. [Installing Ubuntu Linux](#3-installing-ubuntu-linux)
4. [Linux Desktop Environment](#4-linux-desktop-environment)
5. [Basic Linux Commands](#5-basic-linux-commands)
6. [Remote Access Setup](#6-remote-access-setup)
7. [Best Practices](#7-best-practices)
8. [Summary](#summary)

---

## 1. Linux Basics

### 1.1 Linux Kernel and Applications

The Linux system consists of two major components:

```
+---------------------------+
|    Application Programs   |  <-- Text editors, compilers, web servers
|  (User Space)             |
+---------------------------+
|       Linux Kernel        |  <-- Process mgmt, filesystem, memory, devices
|  (Kernel Space)           |
+---------------------------+
|        Hardware           |  <-- CPU, RAM, Disk, NIC
+---------------------------+
```

- **Kernel:** Manages process scheduling, memory management, filesystem operations, and device I/O
- **Applications:** User-facing programs that run on top of the kernel
- Latest kernel version (as of March 2025): **6.13.5** (https://kernel.org)

### 1.2 Linux Features

| Feature | Description |
|---------|-------------|
| Open Source | Source code freely available under GPL |
| Unix Compatible | Full POSIX compliance |
| Multi-user | Multiple users can use the system simultaneously |
| Multi-tasking | Run multiple processes concurrently |
| Stability | Systems can run for years without rebooting |
| Security | Built-in access control, SELinux, AppArmor |
| GUI Support | GNOME, KDE, XFCE desktop environments |

---

## 2. Setting Up the Lab Environment

### 2.1 Virtual Machine Installation

VMware Workstation is used to create virtual machines for the lab.

**Download:** https://www.vmware.com/ (version 17.6.2 as of March 2025)

### 2.2 VM Configuration for Ubuntu

| Parameter | Recommended Value |
|-----------|-------------------|
| Memory | 2 GB (minimum 1 GB) |
| Disk | 20 GB (dynamic allocation) |
| CPU | 2 cores |
| Network | NAT mode |
| Guest OS | Ubuntu 22.04 LTS |

### 2.3 VMware Convenient Features

```bash
# Key shortcuts
Ctrl + Alt         # Release mouse from VM to host
Ctrl + Alt + Enter  # Toggle full-screen mode
```

- **Clone:** Duplicate a VM for parallel testing
- **Suspend:** Save current VM state and resume later
- **Snapshot:** Create restore points for safe experimentation

---

## 3. Installing Ubuntu Linux

### 3.1 Download Ubuntu

- **Desktop** (with GUI): Suitable for beginners, includes GNOME desktop
- **Server** (CLI only): Lightweight, for production servers

Download from: https://ubuntu.com/download

### 3.2 Installation Steps

1. Create a new virtual machine in VMware
2. Select the Ubuntu ISO image
3. Configure VM settings (memory, disk, network)
4. Boot from the ISO and follow the installer
5. Set hostname, username, and password
6. Complete installation and reboot

### 3.3 Post-Installation Setup

```bash
# Update package lists and upgrade installed packages
sudo apt update && sudo apt upgrade -y

# Install essential build tools
sudo apt install -y build-essential

# Install VMware Tools for better VM integration
sudo apt install -y open-vm-tools open-vm-tools-desktop

# Check Ubuntu version
lsb_release -a

# Check kernel version
uname -r
```

---

## 4. Linux Desktop Environment

### 4.1 GNOME Desktop

Ubuntu uses the **GNOME** desktop environment by default, which provides:
- **Activities Overview:** Access applications and workspaces
- **Application Menu:** Launch installed programs
- **System Tray:** Network, sound, power settings
- **File Manager (Nautilus):** GUI file management

### 4.2 Terminal Emulator

The terminal is the most important tool for Linux administration:

```bash
# Open terminal
Ctrl + Alt + T    # Keyboard shortcut in Ubuntu GNOME

# Terminal prompt format
username@hostname:~$    # Regular user
root@hostname:~#        # Root user
```

> **Key Point:** The `$` prompt indicates a regular user; `#` indicates the root (superuser).

---

## 5. Basic Linux Commands

### 5.1 System Information Commands

```bash
# Display current date and time
date
# Output: Tue Mar 21 14:30:00 KST 2025

# Display calendar
cal
cal 2025           # Full year calendar

# Display logged-in users
who
w                   # More detailed information

# Display system uptime
uptime

# Display hostname
hostname

# Display kernel information
uname -a
```

### 5.2 User Commands

```bash
# Display current username
whoami

# Switch user
su - username       # Switch to another user
su -                # Switch to root

# Execute as superuser
sudo command        # Run a single command as root
sudo -i             # Open root shell
```

### 5.3 Help and Manual Pages

```bash
# Display command manual
man ls              # Manual page for ls
man -k keyword      # Search man pages by keyword

# Quick help
ls --help           # Built-in help for most commands
info ls             # GNU info documentation

# Display command type
type ls             # Shows if command is built-in, alias, or external
which ls            # Shows the path of the command binary
```

### 5.4 System Control

```bash
# Shutdown the system
sudo shutdown -h now          # Shutdown immediately
sudo shutdown -h +10          # Shutdown in 10 minutes
sudo poweroff                 # Alternative shutdown

# Reboot the system
sudo shutdown -r now          # Reboot immediately
sudo reboot                   # Alternative reboot

# Cancel scheduled shutdown
sudo shutdown -c
```

### 5.5 Command Line Editing Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl + A` | Move cursor to beginning of line |
| `Ctrl + E` | Move cursor to end of line |
| `Ctrl + U` | Delete from cursor to beginning |
| `Ctrl + K` | Delete from cursor to end |
| `Ctrl + L` | Clear screen |
| `Ctrl + C` | Cancel current command |
| `Ctrl + D` | Logout / EOF signal |
| `Tab` | Auto-complete command or filename |
| `Up/Down` | Navigate command history |

---

## 6. Remote Access Setup

### 6.1 SSH (Secure Shell)

```bash
# Install SSH server on Ubuntu
sudo apt install -y openssh-server

# Check SSH service status
sudo systemctl status ssh

# Enable SSH to start on boot
sudo systemctl enable ssh

# Connect from another machine
ssh username@ip_address
ssh -p 2222 username@ip_address    # Custom port
```

### 6.2 Finding Your IP Address

```bash
# Display network interface information
ip addr show
ip a                # Short form

# Legacy command
ifconfig            # May need: sudo apt install net-tools
```

---

## 7. Best Practices

### 7.1 Security

- Always use strong passwords for user accounts
- Use `sudo` instead of logging in as root
- Keep the system updated with `apt update && apt upgrade`
- Disable root SSH login in production environments

### 7.2 Common Mistakes to Avoid

| Mistake | Consequence | Prevention |
|---------|-------------|------------|
| Running everything as root | Security risk, accidental damage | Use `sudo` for specific commands |
| Skipping updates | Vulnerability exposure | Regular `apt update && upgrade` |
| Weak passwords | Easy unauthorized access | Use strong, unique passwords |
| Ignoring backups | Data loss | Use snapshots and regular backups |

---

## Summary

| Concept | Key Point |
|---------|-----------|
| Linux Components | Kernel (resource management) + Applications (user programs) |
| VMware | Virtual machine software for running multiple OSes |
| Ubuntu | Debian-based distribution, most popular for beginners |
| Terminal | Primary interface for system administration (`Ctrl+Alt+T`) |
| Prompt | `$` = regular user, `#` = root user |
| SSH | Secure remote access protocol (port 22) |
| sudo | Execute commands with superuser privileges safely |
| man pages | Built-in documentation system (`man command`) |

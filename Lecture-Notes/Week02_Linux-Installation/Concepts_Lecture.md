# Week 2 Lecture — Linux Installation and Basic Usage

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-10-26
>
> 우분투 리눅스, 이종원, Ch 1

> **Learning Objectives:**
> 1. Explain the relationship between the Linux kernel and applications, and the main features of Linux
> 2. Create a virtual machine with VMware and install Ubuntu Linux, configuring basic system settings during installation
> 3. Navigate the Ubuntu desktop environment and open and close a terminal
> 4. Understand the structure of a command (command, options, arguments) and use basic commands
> 5. Set up SSH remote access and find the IP address

---

## Table of Contents

- [1. Linux Basics](#1-linux-basics)
  - [1.1 Linux Kernel and Applications](#11-linux-kernel-and-applications)
  - [1.2 Linux Features](#12-linux-features)
- [2. Setting Up the Lab Environment](#2-setting-up-the-lab-environment)
  - [2.1 Virtual Machine Installation](#21-virtual-machine-installation)
  - [2.2 VM Configuration for Ubuntu](#22-vm-configuration-for-ubuntu)
  - [2.3 VMware Convenient Features](#23-vmware-convenient-features)
- [3. Installing Ubuntu Linux](#3-installing-ubuntu-linux)
  - [3.1 Download Ubuntu](#31-download-ubuntu)
  - [3.2 Installation Steps](#32-installation-steps)
  - [3.3 Post-Installation Setup](#33-post-installation-setup)
- [4. Linux Desktop Environment](#4-linux-desktop-environment)
  - [4.1 GNOME Desktop](#41-gnome-desktop)
  - [4.2 Terminal Emulator](#42-terminal-emulator)
- [5. Basic Linux Commands](#5-basic-linux-commands)
  - [5.1 Structure of a Command](#51-structure-of-a-command)
  - [5.2 System Information Commands](#52-system-information-commands)
  - [5.3 User Commands](#53-user-commands)
  - [5.4 Help and Manual Pages](#54-help-and-manual-pages)
  - [5.5 System Control](#55-system-control)
  - [5.6 Command Line Editing Shortcuts](#56-command-line-editing-shortcuts)
- [6. Remote Access Setup](#6-remote-access-setup)
  - [6.1 SSH (Secure Shell)](#61-ssh-secure-shell)
  - [6.2 Finding Your IP Address](#62-finding-your-ip-address)
- [7. Best Practices](#7-best-practices)
  - [7.1 Security](#71-security)
  - [7.2 Common Mistakes to Avoid](#72-common-mistakes-to-avoid)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. Linux Basics

### 1.1 Linux Kernel and Applications

The Linux system consists of two major components, the kernel and the applications, with the hardware beneath them. The area where applications run is called **user space**, and the area where the kernel runs is called **kernel space**.

```text
+---------------------------+
|    Application Programs   |  <-- Text editors, compilers, web servers
|  (User Space)             |
+---------------------------+
|       Linux Kernel        |  <-- Process mgmt, file system, memory, devices
|  (Kernel Space)           |
+---------------------------+
|        Hardware           |  <-- CPU, RAM, Disk, NIC
+---------------------------+
```

*Figure 1. Relationship among the Linux kernel, applications, and hardware*

- **Kernel:** It manages process scheduling, memory management, file system operations, and device I/O.
- **Applications:** They run on top of the kernel and are the programs that users use directly. The shell, which interprets user commands, sits between the kernel and the applications (Week 1, Section 5).
- As of March 2025, the latest kernel version is **6.13.5** (https://kernel.org).

### 1.2 Linux Features

| Feature | Description |
|---------|-------------|
| Open Source | Source code freely available under the GPL |
| Unix Compatible | High compatibility with Unix, following most of the POSIX standard |
| Multi-user | Multiple users can use the system simultaneously |
| Multi-tasking | Run multiple processes concurrently |
| Stability | Systems can run for years without rebooting |
| Security | Built-in access control, SELinux, AppArmor |
| Server OS | Widely used as a server operating system |
| GUI Support | GNOME, KDE, XFCE desktop environments |

*Table 1. Main features of Linux*

---

<br>

## 2. Setting Up the Lab Environment

### 2.1 Virtual Machine Installation

VMware Workstation (Player or Pro) is used to create virtual machines for the lab. The concept of a virtual machine is covered in Week 1, Section 7.

**Download:** https://www.vmware.com/ (version 17.6.2 as of March 2025)

A virtual machine is created in the following order.

1. Run VMware Workstation Player and select Create a New Virtual Machine.
2. As the guest OS installation method, choose I will install the operating system later so that only an empty hard disk is created first, and select Linux as the guest OS type.
3. Specify the name of the virtual machine and the location of the disk file.
4. Specify the disk size (20GB) and the storage method (Split virtual disk into multiple files).

### 2.2 VM Configuration for Ubuntu

| Parameter | Recommended Value |
|-----------|-------------------|
| Memory | 4 GB |
| Disk | 20 GB (dynamic allocation, split into multiple files) |
| CPU | 2 cores |
| Network | NAT mode |
| Guest OS | Ubuntu 24.04 LTS (Desktop, Server) |

*Table 2. Recommended configuration of an Ubuntu virtual machine*

### 2.3 VMware Convenient Features

```text
# Key shortcuts
Ctrl + Alt         # Release mouse from VM to host
Ctrl + Alt + Enter  # Toggle full-screen mode
```

- **Clone:** Duplicate a VM for parallel testing.
- **Suspend:** Save the current VM state and resume later.
- **Snapshot:** Create restore points for safe experimentation.

---

<br>

## 3. Installing Ubuntu Linux

### 3.1 Download Ubuntu

- **Desktop** (with GUI): It includes the GNOME desktop and is suitable for beginners.
- **Server** (CLI only): It is lightweight and used for production servers.

Download from: https://ubuntu.com/download

### 3.2 Installation Steps

1. Create a new virtual machine in VMware.
2. Assign the Ubuntu ISO image to the CD/DVD device of the virtual machine.
3. Configure the VM settings (memory, disk, network).
4. Boot from the ISO and follow the installer.
5. Set the hostname (computer name), username, and password.
6. Reboot when the installation completes.

In the lab, the following choices are made at each step of the installer.

| Installer Step | Choice |
|----------------|--------|
| Language and installation method | Korean, Install Ubuntu |
| Keyboard layout | Korean |
| Software and updates to install | Minimal installation, uncheck downloading updates |
| Installation type | Erase disk and install Ubuntu |
| Time zone | Seoul |
| User account | Username user1 (with a password), computer name myubuntu |

*Table 3. Ubuntu installation choices used in the lab*

> **Caution:** Erasing the disk inside a virtual machine erases only the virtual disk, but choosing the same option on a real PC erases the existing operating system and all its data.

After installation, the system reboots to a login screen; log in and choose the initial setup options.

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

<br>

## 4. Linux Desktop Environment

### 4.1 GNOME Desktop

Ubuntu uses the **GNOME** desktop environment by default, and its main components are as follows.

- **Activities Overview:** Opened from the top left of the screen, it shows the icons of frequently used programs, the running programs, and the workspaces.
- **Dock:** It lines up program icons such as Firefox, Thunderbird, Files, Software, Help, and Trash on the left of the screen.
- **Application Menu:** Opened with the Show Apps button at the bottom of the dock, it launches installed programs.
- **Date and Time:** At the top center of the screen, it manages the date, time, and notifications.
- **System Tray:** At the top right of the screen, it sets sound, network, Bluetooth, and power (power off, log out).
- **File Manager (Nautilus):** It manages files through the GUI.

### 4.2 Terminal Emulator

The terminal is a window for operating the system by typing commands, and it is the most important tool for Linux administration. Open it by choosing Terminal in Show Apps or with the following shortcut.

```text
# Open terminal
Ctrl + Alt + T    # Keyboard shortcut in Ubuntu GNOME

# Terminal prompt format
username@hostname:~$    # Regular user
root@hostname:~#        # Root user
```

The **prompt** is the indicator that the shell is waiting for the user to enter a command. The `~` in the prompt denotes the **home directory**, the default directory of a user account and the place where you start when you open a terminal. Check the current location with the `pwd` command. Close the terminal by clicking the window's close button, typing `exit`, or pressing `Ctrl + D` on an empty command line.

> **Key Point:** The `$` prompt indicates a regular user; `#` indicates the root (superuser).

---

<br>

## 5. Basic Linux Commands

### 5.1 Structure of a Command

A Linux command is entered in the form `command [options] [arguments]`. Square brackets mean that the part may be omitted.

- **Command:** The name of the program the user wants to run; there are hundreds, such as `date`, `man`, `ls`, `cp`, and `mv`.
- **Options:** They select detailed functions of the command. They start with `-` or `--` and consist of lowercase or uppercase letters. Which options exist and what they do differ by command, so consult the usage of that command.
- **Arguments:** Values passed to the command, usually file or directory names. Some commands take no arguments, and the required arguments differ by command.

```bash
ls              # Command only: list the current directory
ls -a           # Command and option: include hidden files
ls /tmp         # Command and argument: list the /tmp directory
ls -a /tmp      # Command, option, and argument: list /tmp including hidden files
```

### 5.2 System Information Commands

```bash
# Display current date and time
date
# Output: Fri Mar 21 14:30:00 KST 2025

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

In a Korean locale, `date` prints in the form `2025. 03. 21. (금) 14:30:00 KST`. To clear the screen, type `clear`.

### 5.3 User Commands

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

`passwd` changes the password of a user account. Run without arguments, it first asks for the current password and then takes the new password twice.

### 5.4 Help and Manual Pages

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

A manual page is divided into sections such as NAME (a brief description of the command), SYNOPSIS (a usage summary), and DESCRIPTION (a detailed description); press `q` to exit.

### 5.5 System Control

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

The time argument documented in the manual of `shutdown` takes one of three forms: `hh:mm` (a time on the 24-hour clock), `+m` (m minutes from now), and `now` (immediately).

### 5.6 Command Line Editing Shortcuts

| Shortcut | Action |
|----------|--------|
| `Backspace`, `Delete` | Delete the character before or at the cursor |
| `Ctrl + A` | Move cursor to beginning of line |
| `Ctrl + E` | Move cursor to end of line |
| `Ctrl + W` | Delete one word before the cursor |
| `Ctrl + U` | Delete from cursor to beginning |
| `Ctrl + K` | Delete from cursor to end |
| `Ctrl + L` | Clear screen |
| `Ctrl + C` | Cancel current command |
| `Ctrl + D` | Signal end of input (EOF); on an empty command line, exit the shell (log out) |
| `Tab` | Auto-complete command or filename |
| `Up/Down` | Navigate command history |

*Table 4. Command line editing shortcuts*

---

<br>

## 6. Remote Access Setup

### 6.1 SSH (Secure Shell)

**SSH (Secure Shell)** is a protocol for logging in to another computer over the network through an encrypted connection, and its default port is 22. Install the SSH server on the Ubuntu machine that accepts connections.

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

In the output, the address next to `inet` is the IPv4 address of that interface. After finding this address on Ubuntu Desktop and on Ubuntu Server, run `ssh username@IP_address` in a terminal on the host (for example, Terminal on macOS) to connect to each virtual machine.

> **[Computer Networks]** In terms of the TCP/IP layers taught in Computer Networks, SSH is an application-layer protocol that runs over TCP. The IP address is used to find the destination host on the network (here, the virtual machine), and the port number identifies the process on that host that accepts the connection. So `ssh username@IP_address` finds the VM by its IP address and opens a TCP connection to the default port 22 on which the SSH server is waiting, and if the server uses another port, the port number is given with `-p`.

---

<br>

## 7. Best Practices

### 7.1 Security

- Always use strong passwords for user accounts.
- Use `sudo` instead of logging in as root.
- Keep the system updated with `sudo apt update && sudo apt upgrade`.
- Disable SSH login for root in production environments.

### 7.2 Common Mistakes to Avoid

| Mistake | Consequence | Prevention |
|---------|-------------|------------|
| Running everything as root | Security risk, accidental damage | Use `sudo` for specific commands |
| Skipping updates | Vulnerability exposure | Regular `sudo apt update && sudo apt upgrade` |
| Weak passwords | Easy unauthorized access | Use strong, unique passwords |
| Ignoring backups | Data loss | Use snapshots and regular backups |

*Table 5. Common mistakes and their prevention*

---

<br>

## Summary

| Concept | Key Summary |
|---------|-------------|
| Linux Components | The kernel manages resources, and applications carry out user tasks on top of it. |
| VMware | It is virtual machine software for running multiple operating systems on one PC. |
| Ubuntu | It is a Debian-based distribution widely used by beginners. |
| Terminal | It is the primary interface for system administration and opens with `Ctrl+Alt+T`. |
| Prompt | `$` indicates a regular user, and `#` indicates the root user. |
| Command Structure | A command has the form `command [options] [arguments]`, and options start with `-` or `--`. |
| SSH | It is a secure remote access protocol that uses default port 22. |
| sudo | It safely runs only the commands that need superuser privileges. |
| man pages | It is the built-in documentation system, opened with `man command`. |

---

<br>

## Self-Check Questions

1. **Command structure:** In `ls -a /tmp`, identify the command, the option, and the argument, and explain what this command prints.

   <details>
   <summary>Answer</summary>

   The command is `ls`, the option is `-a`, and the argument is `/tmp`. `ls` prints the contents of a directory, the argument `/tmp` specifies the target directory, and the option `-a` makes it include hidden files whose names start with `.`. It therefore prints all files and directories in `/tmp`, including hidden ones.

   </details>

2. **Command types:** On Ubuntu, `type cd` prints `cd is a shell builtin`, but `which cd` prints nothing. Explain why.

   <details>
   <summary>Answer</summary>

   `cd` is not a separate executable file but a command built into the shell. `type` distinguishes shell builtins, aliases, and external commands, whereas `which` searches only for executable files in the directories of PATH. Since there is no executable named `cd`, `which cd` prints nothing and fails.

   </details>

3. **Remote access procedure:** You want to connect with SSH from a terminal on the host PC to the Ubuntu installed in a VM. List in order what must be done on Ubuntu and the command to run on the host.

   <details>
   <summary>Answer</summary>

   On Ubuntu, install the SSH server with `sudo apt install -y openssh-server`, check that the service is running with `sudo systemctl status ssh`, and if needed make it start automatically at boot with `sudo systemctl enable ssh`. Next, find the IP address in the `inet` entry of `ip addr show`. Finally, run `ssh user1@IP_address` in a terminal on the host and enter the password of user1.

   </details>

4. **User space and kernel space:** When you save a file with a text editor, explain what the editor and the kernel each do, following the layers of Figure 1.

   <details>
   <summary>Answer</summary>

   The editor is an application running in user space; it holds the user's input in memory and asks the kernel to write it to a file. The kernel receives the request in kernel space, updates the file system, and writes the actual data to the disk (hardware) through device I/O. Applications do not handle the hardware directly but go through the kernel.

   </details>

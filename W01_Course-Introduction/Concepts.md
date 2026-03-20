# W01 -- Course Introduction

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [What is Linux?](#1-what-is-linux)
2. [History of Linux](#2-history-of-linux)
3. [GNU Project and Free Software](#3-gnu-project-and-free-software)
4. [Linux Distributions](#4-linux-distributions)
5. [Linux Architecture](#5-linux-architecture)
6. [Linux Usage in the Real World](#6-linux-usage-in-the-real-world)
7. [Course Overview](#7-course-overview)
8. [Summary](#summary)

---

## 1. What is Linux?

Linux is a **free and open-source operating system** based on the Unix operating system.

### 1.1 Key Characteristics

- **Open Source:** The source code is freely available for anyone to view, modify, and distribute
- **Unix-compatible:** Maintains full compatibility with Unix standards
- **Multi-user and Multi-tasking:** Supports multiple users and processes simultaneously
- **Stability and Security:** Renowned for robust security and system stability
- **Flexibility:** Runs on a wide range of devices from servers to smartphones

### 1.2 Why Learn Linux?

- Over **80%** of smartphones worldwide run Android (Linux-based)
- Over **95%** of cloud servers run Linux
- **100%** of the world's top 500 supercomputers run Linux
- Most of the world's top 25 websites run on Linux
- Critical for 5G infrastructure, IoT devices, drones, and autonomous vehicles

> **Key Point:** Linux is not just a server OS -- it is the foundation of modern computing infrastructure.

---

## 2. History of Linux

### 2.1 Linus Torvalds

- **Born:** December 28, 1969, in Helsinki, Finland
- **Education:** University of Helsinki
- **1991:** Created Linux by referencing Minix (an educational OS)
- **August 26, 1991:** The official birthday of Linux

```
"Hello everybody out there using minix -
I'm doing a (free) operating system (just a hobby, won't be big
and professional like gnu) for 386(486) AT clones."
-- Linus Torvalds (1991)
```

### 2.2 Richard Stallman

- Born in 1953, Manhattan, New York
- Started computer work at age 16 as an intern at IBM
- Developed **Emacs** editor in 1974 at MIT AI Lab
- Opposed software commercialization and advocated for cooperative development culture
- Founded the **Free Software Foundation (FSF)** in 1985
- Created the **GNU General Public License (GPL)**
- Initiated the **Copyleft** movement

### 2.3 Timeline

| Year | Event |
|------|-------|
| 1969 | Unix developed at AT&T Bell Labs |
| 1983 | GNU Project announced by Richard Stallman |
| 1985 | Free Software Foundation (FSF) established |
| 1991 | Linux kernel 0.01 released by Linus Torvalds |
| 1993 | Debian and Slackware distributions released |
| 1994 | Red Hat Linux released |
| 2004 | Ubuntu released (Debian-based) |
| 2025 | Latest kernel version: 6.13.5 |

---

## 3. GNU Project and Free Software

### 3.1 What is the GNU Project?

GNU stands for **"GNU's Not Unix"** -- a recursive acronym. It is a project to develop free software compatible with Unix.

### 3.2 The Four Freedoms of Free Software

| Freedom | Description |
|---------|-------------|
| Freedom 0 | Run the program for any purpose |
| Freedom 1 | Study how the program works and modify it (requires source code access) |
| Freedom 2 | Redistribute copies to help others |
| Freedom 3 | Distribute modified versions so the community can benefit |

### 3.3 GPL (GNU General Public License)

- **Copyleft** license that ensures derivatives remain free
- Versions: GPLv1, GPLv2, GPLv3
- The Linux kernel is licensed under **GPLv2**

> **Key Point:** "Free software" refers to freedom, not price. Think "free speech," not "free beer."

---

## 4. Linux Distributions

A Linux distribution consists of the **Linux kernel** plus **application programs** bundled together.

### 4.1 Major Distribution Families

```
Linux Kernel (1991)
    |
    +-- Debian (1993)
    |       +-- Ubuntu (2004) --> Linux Mint (2006)
    |
    +-- Slackware (1993)
    |       +-- S.u.S.E (1994) --> SuSE (1998) --> openSUSE (2006)
    |
    +-- Red Hat (1994)
            +-- RHEL 2.1 (2003) --> RHEL 9 (2022)
            +-- Fedora Core (2003) --> Fedora 36 (2022)
            +-- CentOS (2003) --> CentOS Stream 9 (2021)
```

### 4.2 Popular Distributions

| Distribution | Base | Use Case | Website |
|-------------|------|----------|---------|
| **Ubuntu** | Debian | Desktop, Server | https://ubuntu.com |
| **CentOS/RHEL** | Red Hat | Enterprise Server | https://centos.org |
| **Fedora** | Red Hat | Development | https://getfedora.org |
| **Arch Linux** | Independent | Advanced Users | https://archlinux.org |

> **Key Point:** Ubuntu is the most popular distribution for beginners and is used in this course.

---

## 5. Linux Architecture

### 5.1 System Structure

```
+-----------------------------------+
|       Application Programs        |
|  (text editors, compilers, etc.)  |
+-----------------------------------+
|            Shell                   |
|   (command interpreter: bash)     |
+-----------------------------------+
|          Linux Kernel              |
|  (process, filesystem, memory,    |
|   device, network management)     |
+-----------------------------------+
|           Hardware                 |
|  (CPU, Memory, Disk, NIC, etc.)   |
+-----------------------------------+
```

### 5.2 Component Roles

- **Kernel:** Core of the OS; manages hardware resources, processes, memory, and filesystems
- **Shell:** Interface between user and kernel; interprets and executes commands
- **Applications:** Programs that users interact with (editors, compilers, web servers)

---

## 6. Linux Usage in the Real World

### 6.1 Linux in Industry

| Domain | Examples |
|--------|----------|
| Cloud Computing | AWS, Google Cloud, Azure all run on Linux |
| Mobile | Android (Linux-based) powers 80%+ of smartphones |
| Supercomputing | All top 500 supercomputers run Linux |
| Embedded Systems | IoT devices, automotive systems, smart TVs |
| DevOps | Docker, Kubernetes, CI/CD pipelines |
| Networking | Routers, switches, firewalls |

### 6.2 Linux Certification

- **Linux Master Level 2** (KAIT - Korea Association for ICT Promotion)
  - Organized by: http://www.ihd.or.kr/
  - Recognized national certification in Korea
  - Covers system administration, networking, security

---

## 7. Course Overview

### 7.1 Course Information

- **Course Code:** DCCS209 Linux Practice
- **Textbook:** Lee Jong-won, "IT CookBook: Ubuntu Linux" (3rd ed.), Hanbit Academy, 2022
- **Reference:** Woo Jae-nam, "IT CookBook: Linux Practice for Beginner," Hanbit Academy, 2022
- **Lab Environment:** Ubuntu Linux on VMware Workstation

### 7.2 Virtual Machine Setup

A **Virtual Machine (VM)** creates a virtual system on a host OS, allowing you to install and run a guest OS.

| VM Software | Host OS | Guest OS |
|------------|---------|----------|
| VMware | Windows, Linux, macOS | Windows, Linux, Solaris, macOS |
| VirtualBox | Windows, Linux, macOS, Solaris | Windows, Linux, Solaris, macOS, OpenBSD |
| Hyper-V | Windows | Windows, some Linux, Solaris |

**VMware useful features:**
- **Clone:** Duplicate an entire VM for testing
- **Suspend:** Save and restore VM state
- **Snapshot:** Save a checkpoint to revert to later

### 7.3 Grading

| Component | Weight |
|-----------|--------|
| Attendance | 10% |
| Lab Assignments (~10) | 30% |
| Midterm Exam | 30% |
| Final Exam | 30% |

---

## Summary

| Concept | Key Point |
|---------|-----------|
| Linux | Free, open-source OS based on Unix, created by Linus Torvalds in 1991 |
| GNU Project | Free software movement by Richard Stallman; ensures software freedom |
| GPL | Copyleft license ensuring derivative works remain free |
| Distributions | Kernel + applications bundled; Ubuntu, RHEL, Fedora, etc. |
| Architecture | Hardware -> Kernel -> Shell -> Applications |
| Virtual Machine | Allows running multiple OSes on one physical machine |
| Real-world Usage | Dominates servers, cloud, mobile, supercomputing, IoT |

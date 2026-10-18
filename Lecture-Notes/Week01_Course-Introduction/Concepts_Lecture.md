# Week 1 Lecture — Course Introduction

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-10-19

> **Learning Objectives:**
> 1. Explain the history of Linux and UNIX and the philosophy of free software
> 2. Explain the families and use cases of major Linux distributions and the real-world domains of Linux
> 3. Explain the layered structure of a Linux system (hardware, kernel, shell, applications)
> 4. Explain the concept of a virtual machine and the main features of VMware

---

## Table of Contents

- [1. What is Linux?](#1-what-is-linux)
  - [1.1 Key Characteristics](#11-key-characteristics)
  - [1.2 Why Learn Linux?](#12-why-learn-linux)
- [2. History of Linux](#2-history-of-linux)
  - [2.1 Linus Torvalds](#21-linus-torvalds)
  - [2.2 Richard Stallman](#22-richard-stallman)
  - [2.3 Timeline](#23-timeline)
- [3. GNU Project and Free Software](#3-gnu-project-and-free-software)
  - [3.1 What is the GNU Project?](#31-what-is-the-gnu-project)
  - [3.2 The Four Freedoms of Free Software](#32-the-four-freedoms-of-free-software)
  - [3.3 GPL (GNU General Public License)](#33-gpl-gnu-general-public-license)
- [4. Linux Distributions](#4-linux-distributions)
  - [4.1 Major Distribution Families](#41-major-distribution-families)
  - [4.2 Popular Distributions](#42-popular-distributions)
- [5. Linux Architecture](#5-linux-architecture)
  - [5.1 System Structure](#51-system-structure)
  - [5.2 Component Roles](#52-component-roles)
- [6. Linux Usage in the Real World](#6-linux-usage-in-the-real-world)
  - [6.1 Linux in Industry](#61-linux-in-industry)
  - [6.2 Linux Certification](#62-linux-certification)
- [7. Virtual Machines](#7-virtual-machines)
  - [7.1 Virtual Machine Setup](#71-virtual-machine-setup)
  - [7.2 Useful Features of VMware](#72-useful-features-of-vmware)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. What is Linux?

Linux is a **free and open-source operating system** based on the Unix operating system. Linus Torvalds first created it in 1991, and it is one of the most widely used operating systems in the world. It is distributed under the GNU General Public License (GPL), so anyone can modify and distribute the source code, and it has a large and active community of developers and users.

### 1.1 Key Characteristics

- **Open Source:** Anyone can freely view, modify, and distribute the source code.
- **Unix-compatible:** It maintains a high degree of compatibility with Unix and follows most of POSIX, the standard for Unix-like operating systems.
- **Multi-user and Multi-tasking:** It supports multiple users and multiple processes simultaneously.
- **Stability and Security:** It is widely known for robust security and system stability.
- **Flexibility:** It runs on a wide range of devices, from servers and supercomputers to smartphones, smartwatches, IoT devices, drones, and autonomous vehicles.

### 1.2 Why Learn Linux?

- Over **80%** of smartphones worldwide run Android, which is Linux-based.
- Over **95%** of cloud servers run Linux.
- **100%** of the world's top 500 supercomputers run Linux.
- Most of the world's top 25 websites run on Linux.
- Linux is critical for 5G mobile infrastructure, IoT devices, drones, and autonomous vehicles.

> **Key Point:** Linux is not just a server OS; it is the foundation of modern computing infrastructure.

---

<br>

## 2. History of Linux

### 2.1 Linus Torvalds

- **Born:** December 28, 1969, in Helsinki, Finland
- **Education:** University of Helsinki
- **1991:** He created a new operating system, Linux, by referencing Minix, an educational OS.
- **August 26, 1991:** The official birthday of Linux. It is the day Torvalds posted the message below to the comp.os.minix newsgroup; in Coordinated Universal Time (UTC) it was August 25.

```text
"Hello everybody out there using minix -
I'm doing a (free) operating system (just a hobby, won't be big
and professional like gnu) for 386(486) AT clones."
-- Linus Torvalds (1991)
```

### 2.2 Richard Stallman

- He was born in 1953 in Manhattan, New York, USA.
- He started computer work at age 16 as an intern at IBM.
- He developed the **Emacs** editor in 1976 at the MIT AI Lab.
- He opposed software commercialization and advocated a cooperative development culture.
- He founded the **Free Software Foundation (FSF)** in 1985.
- He wrote the **GNU General Public License (GPL)**.
- He initiated the **Copyleft** movement.

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
| 2025 | Latest kernel version 6.13.5 (as of March) |

*Table 1. Major milestones of Unix, GNU, and Linux*

---

<br>

## 3. GNU Project and Free Software

### 3.1 What is the GNU Project?

GNU stands for **GNU's Not Unix**, a recursive acronym, that is, an acronym whose expansion contains the acronym itself. The GNU Project develops **free software** compatible with Unix, with the goal that all software can be used freely.

### 3.2 The Four Freedoms of Free Software

| Freedom | Description |
|---------|-------------|
| Freedom 0 | Run the program for any purpose |
| Freedom 1 | Study how the program works and modify it to suit one's needs (requires source code access) |
| Freedom 2 | Redistribute copies to help others |
| Freedom 3 | Improve the program and distribute the improved version so the whole community can benefit (requires source code access) |

*Table 2. The four freedoms of free software*

### 3.3 GPL (GNU General Public License)

- It is a **Copyleft** license that ensures derivative works remain free software. Copyleft uses copyright to guarantee freedom: whoever distributes a modified version must give the recipients the same freedoms.
- Its versions are GPLv1, GPLv2, and GPLv3.
- The Linux kernel is licensed under **GPLv2**.

> **Key Point:** The English word free can refer to price or to liberty; the free in free software refers to liberty, not price. Think of free as in free speech, not as in free beer.

---

<br>

## 4. Linux Distributions

A Linux distribution is a version that bundles the **Linux kernel** with suitable **application programs**. Since anyone can assemble and distribute one as they wish, many distributions exist.

### 4.1 Major Distribution Families

```text
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

*Figure 1. Lineage of the major Linux distribution families*

### 4.2 Popular Distributions

| Distribution | Base | Use Case | Website |
|-------------|------|----------|---------|
| **Ubuntu** | Debian | Desktop, Server | https://ubuntu.com |
| **CentOS/RHEL** | Red Hat | Enterprise Server | https://centos.org |
| **Fedora** | Red Hat | Development | https://getfedora.org |
| **Arch Linux** | Independent | Advanced Users | https://archlinux.org |

*Table 3. Base and use case of representative Linux distributions*

> **Note:** CentOS Linux was a free rebuild of RHEL, but its support has ended (the last one, CentOS Linux 7, in June 2024); it continues as CentOS Stream, which receives changes before they enter RHEL.

> **Key Point:** Ubuntu is a Debian-family distribution that is widely used because it is easy for beginners, and it is used in the labs of this course.

---

<br>

## 5. Linux Architecture

### 5.1 System Structure

```text
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

*Figure 2. Layered structure of a Linux system*

### 5.2 Component Roles

- **Kernel:** The core of the OS; it manages hardware resources, processes, memory, and file systems.
- **Shell:** The interface between the user and the kernel; it interprets and executes the commands the user enters. The default shell of Ubuntu is bash.
- **Applications:** Programs that users interact with directly (editors, compilers, web servers, etc.).

---

<br>

## 6. Linux Usage in the Real World

### 6.1 Linux in Industry

| Domain | Examples |
|--------|----------|
| Cloud Computing | Most servers running on AWS, Google Cloud, and Azure use Linux |
| Mobile | Android (Linux-based) powers 80%+ of smartphones |
| Supercomputing | All top 500 supercomputers run Linux |
| Embedded Systems | IoT devices, automotive systems, smart TVs |
| DevOps | Docker, Kubernetes, CI/CD pipelines |
| Networking | Routers, switches, firewalls |

*Table 4. Examples of Linux use by industry*

### 6.2 Linux Certification

- **Linux Master Level 2**
  - It is administered by the Korea Association for ICT Promotion (KAIT, http://www.ihd.or.kr/).
  - It is a recognized national certification in Korea.
  - It covers system administration, networking, and security.

---

<br>

## 7. Virtual Machines

### 7.1 Virtual Machine Setup

A **Virtual Machine (VM)** is an application that creates a virtual machine (hardware) on top of the operating system installed on a PC (the host OS), so that another operating system (the guest OS) can be installed and run on it.

| VM Software | Host OS | Guest OS |
|------------|---------|----------|
| VMware | Windows, Linux, macOS | Windows, Linux, Solaris, macOS |
| VirtualBox | Windows, Linux, macOS, Solaris | Windows, Linux, Solaris, macOS, OpenBSD |
| Hyper-V | Windows | Windows, some Linux, Solaris |

*Table 5. Host and guest operating systems supported by each VM software*

### 7.2 Useful Features of VMware

- **Adding hardware:** You can attach as many hardware devices, such as hard disks, as you like for testing.
- **Clone:** When the same operating system is needed, duplicate the entire VM for testing.
- **Suspend:** Save the current state of the VM and later start it again in exactly that state.
- **Snapshot:** Save a specific point in time as a checkpoint, and revert to it if something goes wrong during an experiment.

---

<br>

## Summary

| Concept | Key Summary |
|---------|-------------|
| Linux | It is a free, open-source OS based on Unix, created by Linus Torvalds in 1991. |
| GNU Project | It is the free software movement started by Richard Stallman, and it guarantees software freedom. |
| GPL | It is a Copyleft license that keeps derivative works free software. |
| Distributions | A distribution bundles the kernel with applications; examples are Ubuntu, RHEL, and Fedora. |
| Architecture | The kernel, the shell, and applications form successive layers on top of the hardware. |
| Virtual Machine | It allows multiple operating systems to run on one physical machine. |
| Real-world Usage | Linux dominates servers, cloud, mobile, supercomputing, and IoT. |

---

<br>

## Self-Check Questions

1. **Free software:** List the four freedoms of free software, and identify the freedoms that require access to the source code.

   <details>
   <summary>Answer</summary>

   Freedom 0 is the freedom to run the program for any purpose, Freedom 1 to study how it works and modify it, Freedom 2 to redistribute copies, and Freedom 3 to distribute improved versions so the community benefits. Studying, modifying, or improving a program requires its source code, so Freedoms 1 and 3 presuppose source code access.

   </details>

2. **GPL and Copyleft:** You want to modify the Linux kernel, which is distributed under GPLv2, and distribute it to others. What condition must you follow, and what is this licensing approach called?

   <details>
   <summary>Answer</summary>

   You must also distribute the modified kernel under GPLv2 so that recipients can obtain the source code and run, modify, and redistribute it again. This approach, which requires derivative works to carry the same freedoms, is called Copyleft.

   </details>

3. **Layered structure:** When a user types `ls` in a terminal to view a directory's contents, list in order the layers of the Linux system that the request passes through before it reaches the hardware, and explain what each layer does.

   <details>
   <summary>Answer</summary>

   The shell (bash) interprets the entered command and runs the `ls` program. The application `ls` asks the kernel for the directory's contents. The kernel reads the information from the disk (hardware) through the file system and returns it to `ls`, which prints the result on the screen. The request therefore goes down through the shell, the application, the kernel, and the hardware.

   </details>

4. **VMware features:** Before an experiment that modifies system configuration files, which VMware feature should you use so that you can return to the state just before the experiment if something goes wrong? Explain in comparison with Clone and Suspend.

   <details>
   <summary>Answer</summary>

   Use Snapshot. A snapshot saves the VM state at a specific point as a checkpoint, so you can revert to that point if a problem occurs during the experiment. Clone duplicates the entire VM to create one more identical environment, and Suspend saves the current state to continue from it later, so neither is meant for reverting to the point before an experiment.

   </details>

5. **Distribution families:** Classify Ubuntu, Linux Mint, Fedora, and CentOS Stream according to the distribution families in Figure 1.

   <details>
   <summary>Answer</summary>

   Ubuntu and Linux Mint, which is derived from Ubuntu, belong to the Debian family. Fedora and CentOS Stream belong to the Red Hat family.

   </details>

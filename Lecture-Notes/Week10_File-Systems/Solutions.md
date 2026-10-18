# Week 10 Solutions — File Systems

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 7

---

<br>

## Table of Contents

- [Exercise 1: Mounting a Windows USB Drive](#exercise-1-mounting-a-windows-usb-drive)
- [Exercise 2: Viewing Partition Information](#exercise-2-viewing-partition-information)
- [Exercise 3: Creating an ext3 File System](#exercise-3-creating-an-ext3-file-system)
- [Exercise 4: Non-Disk-Based File System](#exercise-4-non-disk-based-file-system)
- [Exercise 5: Disk Setup Procedure](#exercise-5-disk-setup-procedure)
- [Exercise 6: Boot-Time Mount Configuration](#exercise-6-boot-time-mount-configuration)
- [Exercise 7: Mount Point](#exercise-7-mount-point)
- [Exercise 8: Mounting a CD-ROM](#exercise-8-mounting-a-cd-rom)
- [Exercise 9: Creating a File System on a Partition](#exercise-9-creating-a-file-system-on-a-partition)
- [Exercise 10: Purpose of LVM](#exercise-10-purpose-of-lvm)

---

<br>

## Exercise 1: Mounting a Windows USB Drive

**Problem:** Which command is correct for mounting a Windows USB drive?

- A. `mount -t ext3 /dev/sdb1 /mnt`
- B. `mount -t xfs /dev/sdb1 /mnt`
- C. `mount -t vfat /dev/sdb1 /mnt`
- D. `mount -t iso9660 /dev/sdb1 /mnt`

### Solution

**Answer:** C. `mount -t vfat /dev/sdb1 /mnt`

**Explanation:** Windows USB drives typically use the FAT32 file system, which corresponds to `vfat` in Linux. `ext3` and `xfs` are Linux-native file systems, and `iso9660` is the file system for CD/DVD media. The `vfat` driver in Linux supports both FAT16 and FAT32, making it the correct choice for Windows-formatted USB drives. Large USB drives are sometimes formatted as exFAT or NTFS, in which case `-t exfat` or `-t ntfs` is used.

---

<br>

## Exercise 2: Viewing Partition Information

**Problem:** What command is used to view partition information for all disks installed on the system?

- A. `fdisk -a`
- B. `fdisk -l`
- C. `fdisk -v`
- D. `fdisk -d`

### Solution

**Answer:** B. `fdisk -l`

**Explanation:** The `fdisk -l` command lists the partition table for all disks in the system. It displays information such as device name, boot flag, start and end sectors, size, and partition type, and it is usually run with `sudo` because it must read the disk devices. The other options are either invalid or serve different purposes (`-v` shows version information).

---

<br>

## Exercise 3: Creating an ext3 File System

**Problem:** Which command is **incorrect** for creating an ext3 file system?

- A. `mkfs -t ext3 /dev/sdb1`
- B. `mke2fs -t ext3 /dev/sdb1`
- C. `mkfs.ext3 /dev/sdb1`
- D. `mke2fs.ext3 /dev/sdb1`

### Solution

**Answer:** D. `mke2fs.ext3 /dev/sdb1`

**Explanation:** Options A, B, and C are all valid ways to create an ext3 file system. `mkfs -t ext3` specifies the type with the `-t` flag, `mke2fs -t ext3` uses the ext2/3/4 specific tool, and `mkfs.ext3` is a shorthand command. However, `mke2fs.ext3` is not a valid command; there is no such binary on the system.

---

<br>

## Exercise 4: Non-Disk-Based File System

**Problem:** Which of the following is **not** a disk-based file system?

- A. proc
- B. ext
- C. ext4
- D. xfs

### Solution

**Answer:** A. proc

**Explanation:** The `proc` file system (procfs) is a virtual (pseudo) file system that provides an interface to kernel data structures. It does not reside on any disk but exists only in memory, providing information about processes and system status through `/proc`. In contrast, `ext`, `ext4`, and `xfs` are all disk-based file systems that store data on physical storage devices.

---

<br>

## Exercise 5: Disk Setup Procedure

**Problem:** What is the correct order of operations when setting up a newly installed disk?

- A. Create partition -> Mount disk -> Format disk
- B. Create partition -> Format disk -> Mount disk
- C. Mount disk -> Create partition -> Format disk
- D. Format disk -> Create partition -> Mount disk

### Solution

**Answer:** B. Create partition -> Format disk -> Mount disk

**Explanation:** The correct procedure for setting up a new disk is to (1) create partitions using `fdisk` or `parted`, (2) create a file system on the partition (format it) using `mkfs`, and (3) mount the formatted partition to a directory using `mount`. In this procedure the partition created in the first step is what gets formatted, so partitioning must come first, and mounting requires a formatted file system. A file system can also be created directly on a whole disk (`/dev/sdb`), but that is not the usual procedure.

---

<br>

## Exercise 6: Boot-Time Mount Configuration

**Problem:** Which file stores information for mounting file systems at boot time?

- A. `/etc/mtab`
- B. `/etc/mount`
- C. `/etc/fstab`
- D. `/etc/ftab`

### Solution

**Answer:** C. `/etc/fstab`

**Explanation:** The `/etc/fstab` (File System Table) file contains static information about file systems to be mounted at boot time. Each entry specifies the device, mount point, file system type, mount options, dump setting, and fsck check order. `/etc/mtab` tracks currently mounted file systems but is not used for boot-time configuration, and on recent distributions it is a symbolic link to `/proc/self/mounts`.

---

<br>

## Exercise 7: Mount Point

**Problem:** In the directory hierarchy, what is the directory where a file system is connected called?

### Solution

**Answer:** Mount point

**Explanation:** A mount point is a directory in the existing file system hierarchy where an additional file system is attached (mounted). When a file system is mounted at a directory, the contents of that file system become accessible through that directory path, and the files originally in that directory are hidden until it is unmounted. Common mount points include `/`, `/home`, `/mnt`, and `/media`.

---

<br>

## Exercise 8: Mounting a CD-ROM

**Problem:** What command mounts a CD-ROM to the `/cdrom` directory?

### Solution

**Answer:** `sudo mount -t iso9660 /dev/cdrom /cdrom`

**Explanation:** CD-ROMs use the ISO 9660 file system standard. The `-t iso9660` option specifies this file system type. `/dev/cdrom` is the device file representing the CD-ROM drive (`/dev/sr0` on some systems), and `/cdrom` is the mount point directory, which must exist beforehand. `sudo` is required because mounting typically needs root privileges.

---

<br>

## Exercise 9: Creating a File System on a Partition

**Problem:** What command is used to create a file system on a partition?

### Solution

**Answer:** `sudo mkfs -t <filesystem-type> /dev/sdXN`

**Explanation:** The `mkfs` (make file system) command creates a file system on a specified partition. The `-t` option specifies the file system type (e.g., ext4, xfs, vfat), and without it ext2 is created. The device path `/dev/sdXN` refers to a specific partition where `X` is the disk letter and `N` is the partition number (e.g., `/dev/sdb1`).

---

<br>

## Exercise 10: Purpose of LVM

**Problem:** Explain why functionality like LVM (Logical Volume Manager) is needed.

### Solution

**Answer:** LVM provides flexible disk management, dynamic expansion and shrinking of volumes, snapshot capabilities, and disk replacement and recovery features.

**Explanation:** LVM abstracts the physical storage layer, allowing administrators to grow volumes while they are mounted (ext4, xfs), shrink them after unmounting when needed (ext4; xfs cannot be shrunk), create snapshots for backups, span volumes across multiple physical disks, and migrate data between disks without stopping services. Without LVM, resizing partitions requires unmounting and potentially losing data, making storage management rigid and error-prone.

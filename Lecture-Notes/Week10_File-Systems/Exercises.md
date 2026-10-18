# Week 10 Exercises — File Systems

[Repository Guide](../../README.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 7

---

<br>

## Exercise 1: Mounting a Windows USB Drive

**Problem:** Which command is correct for mounting a Windows USB drive?

- A. `mount -t ext3 /dev/sdb1 /mnt`
- B. `mount -t xfs /dev/sdb1 /mnt`
- C. `mount -t vfat /dev/sdb1 /mnt`
- D. `mount -t iso9660 /dev/sdb1 /mnt`

**[Solution](Solutions.md#exercise-1-mounting-a-windows-usb-drive)**

---

<br>

## Exercise 2: Viewing Partition Information

**Problem:** What command is used to view partition information for all disks installed on the system?

- A. `fdisk -a`
- B. `fdisk -l`
- C. `fdisk -v`
- D. `fdisk -d`

**[Solution](Solutions.md#exercise-2-viewing-partition-information)**

---

<br>

## Exercise 3: Creating an ext3 File System

**Problem:** Which command is **incorrect** for creating an ext3 file system?

- A. `mkfs -t ext3 /dev/sdb1`
- B. `mke2fs -t ext3 /dev/sdb1`
- C. `mkfs.ext3 /dev/sdb1`
- D. `mke2fs.ext3 /dev/sdb1`

**[Solution](Solutions.md#exercise-3-creating-an-ext3-file-system)**

---

<br>

## Exercise 4: Non-Disk-Based File System

**Problem:** Which of the following is **not** a disk-based file system?

- A. proc
- B. ext
- C. ext4
- D. xfs

**[Solution](Solutions.md#exercise-4-non-disk-based-file-system)**

---

<br>

## Exercise 5: Disk Setup Procedure

**Problem:** What is the correct order of operations when setting up a newly installed disk?

- A. Create partition -> Mount disk -> Format disk
- B. Create partition -> Format disk -> Mount disk
- C. Mount disk -> Create partition -> Format disk
- D. Format disk -> Create partition -> Mount disk

**[Solution](Solutions.md#exercise-5-disk-setup-procedure)**

---

<br>

## Exercise 6: Boot-Time Mount Configuration

**Problem:** Which file stores information for mounting file systems at boot time?

- A. `/etc/mtab`
- B. `/etc/mount`
- C. `/etc/fstab`
- D. `/etc/ftab`

**[Solution](Solutions.md#exercise-6-boot-time-mount-configuration)**

---

<br>

## Exercise 7: Mount Point

**Problem:** In the directory hierarchy, what is the directory where a file system is connected called?

**[Solution](Solutions.md#exercise-7-mount-point)**

---

<br>

## Exercise 8: Mounting a CD-ROM

**Problem:** What command mounts a CD-ROM to the `/cdrom` directory?

**[Solution](Solutions.md#exercise-8-mounting-a-cd-rom)**

---

<br>

## Exercise 9: Creating a File System on a Partition

**Problem:** What command is used to create a file system on a partition?

**[Solution](Solutions.md#exercise-9-creating-a-file-system-on-a-partition)**

---

<br>

## Exercise 10: Purpose of LVM

**Problem:** Explain why functionality like LVM (Logical Volume Manager) is needed.

**[Solution](Solutions.md#exercise-10-purpose-of-lvm)**

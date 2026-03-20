# Week 10 — Quiz

> **Last Updated:** 2026-03-21

---

## Q1. Mounting a Windows USB Drive

**Question:** Which command is correct for mounting a Windows USB drive?

| Option | Command |
|--------|---------|
| A | `mount -t ext3 /dev/sdb1 /mnt` |
| B | `mount -t xfs /dev/sdb1 /mnt` |
| C | `mount -t vfat /dev/sdb1 /mnt` |
| D | `mount -t iso9660 /dev/sdb1 /mnt` |

**Answer:** C. `mount -t vfat /dev/sdb1 /mnt`

**Explanation:** Windows USB drives typically use the FAT32 file system, which corresponds to `vfat` in Linux. `ext3` and `xfs` are Linux-native file systems, and `iso9660` is the file system for CD/DVD media. The `vfat` driver in Linux supports both FAT16 and FAT32, making it the correct choice for Windows-formatted USB drives.

---

## Q2. Viewing Partition Information

**Question:** What command is used to view partition information for all disks installed on the system?

| Option | Command |
|--------|---------|
| A | `fdisk -a` |
| B | `fdisk -l` |
| C | `fdisk -v` |
| D | `fdisk -d` |

**Answer:** B. `fdisk -l`

**Explanation:** The `fdisk -l` command lists the partition table for all disks in the system. It displays information such as device name, boot flag, start/end sectors, size, and partition type. The other options are either invalid or serve different purposes (`-v` shows version information).

---

## Q3. Creating an ext3 File System

**Question:** Which command is **incorrect** for creating an ext3 file system?

| Option | Command |
|--------|---------|
| A | `mkfs -t ext3 /dev/sdb1` |
| B | `mke2fs -t ext3 /dev/sdb1` |
| C | `mkfs.ext3 /dev/sdb1` |
| D | `mke2fs.ext3 /dev/sdb1` |

**Answer:** D. `mke2fs.ext3 /dev/sdb1`

**Explanation:** Options A, B, and C are all valid ways to create an ext3 file system. `mkfs -t ext3` specifies the type with the `-t` flag, `mke2fs -t ext3` uses the ext2/3/4 specific tool, and `mkfs.ext3` is a shorthand command. However, `mke2fs.ext3` does not exist as a valid command — there is no such binary in the system.

---

## Q4. Non-Disk-Based File System

**Question:** Which of the following is NOT a disk-based file system?

| Option | File System |
|--------|-------------|
| A | proc |
| B | ext |
| C | ext4 |
| D | xfs |

**Answer:** A. proc

**Explanation:** The `proc` file system (procfs) is a virtual/pseudo file system that provides an interface to kernel data structures. It does not reside on any disk but exists only in memory, providing information about processes and system status through `/proc`. In contrast, `ext`, `ext4`, and `xfs` are all disk-based file systems that store data on physical storage devices.

---

## Q5. Disk Setup Procedure

**Question:** What is the correct order of operations when setting up a newly installed disk?

| Option | Order |
|--------|-------|
| A | Create partition -> Mount disk -> Format disk |
| B | Create partition -> Format disk -> Mount disk |
| C | Mount disk -> Create partition -> Format disk |
| D | Format disk -> Create partition -> Mount disk |

**Answer:** B. Create partition -> Format disk -> Mount disk

**Explanation:** The correct procedure for setting up a new disk is: (1) create partitions using `fdisk` or `parted`, (2) format the partition with a file system using `mkfs`, and (3) mount the formatted partition to a directory using `mount`. You cannot format without a partition, and mounting requires a formatted file system.

---

## Q6. Boot-Time Mount Configuration

**Question:** Which file stores information for mounting file systems at boot time?

| Option | File |
|--------|------|
| A | `/etc/mtab` |
| B | `/etc/mount` |
| C | `/etc/fstab` |
| D | `/etc/ftab` |

**Answer:** C. `/etc/fstab`

**Explanation:** The `/etc/fstab` (File System Table) file contains static information about file systems to be mounted at boot time. Each entry specifies the device, mount point, file system type, mount options, dump frequency, and fsck pass number. `/etc/mtab` tracks currently mounted file systems but is not used for boot-time configuration.

---

## Q7. Mount Point

**Question:** In the directory hierarchy, what is the directory where a file system is connected called?

**Answer:** Mount point

**Explanation:** A mount point is a directory in the existing file system hierarchy where an additional file system is attached (mounted). When a file system is mounted at a directory, the contents of that file system become accessible through that directory path. Common mount points include `/`, `/home`, `/mnt`, and `/media`.

---

## Q8. Mounting a CD-ROM

**Question:** What command mounts a CD-ROM to the `/cdrom` directory?

**Answer:** `sudo mount -t iso9660 /dev/cdrom /cdrom`

**Explanation:** CD-ROMs use the ISO 9660 file system standard. The `-t iso9660` option specifies this file system type. `/dev/cdrom` is the device file representing the CD-ROM drive, and `/cdrom` is the mount point directory. `sudo` is required because mounting typically needs root privileges.

---

## Q9. Creating a File System on a Partition

**Question:** What command is used to create a file system on a partition?

**Answer:** `sudo mkfs -t <filesystem-type> /dev/sdXN`

**Explanation:** The `mkfs` (make file system) command creates a file system on a specified partition. The `-t` option specifies the file system type (e.g., ext4, xfs, vfat). The device path `/dev/sdXN` refers to a specific partition where `X` is the disk letter and `N` is the partition number (e.g., `/dev/sdb1`).

---

## Q10. Purpose of LVM

**Question:** Explain why functionality like LVM (Logical Volume Manager) is needed.

**Answer:** LVM provides flexible disk management, dynamic expansion/shrinking of volumes, snapshot capabilities, and disk replacement/recovery features.

**Explanation:** LVM abstracts the physical storage layer, allowing administrators to resize volumes without unmounting, create snapshots for backups, span volumes across multiple physical disks, and migrate data between disks with zero downtime. Without LVM, resizing partitions requires unmounting and potentially losing data, making storage management rigid and error-prone.

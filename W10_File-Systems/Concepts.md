# Week 10 — File Systems

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Linux File Systems Overview](#1-linux-file-systems-overview)
2. [Disk Partitioning](#2-disk-partitioning)
3. [File System Types](#3-file-system-types)
4. [Creating and Managing File Systems](#4-creating-and-managing-file-systems)
5. [Mounting and Unmounting](#5-mounting-and-unmounting)
6. [Disk Usage Monitoring](#6-disk-usage-monitoring)
7. [Swap Space](#7-swap-space)
8. [Best Practices](#8-best-practices)
9. [Summary](#summary)

---

## 1. Linux File Systems Overview

### 1.1 What is a File System?

A file system is a method of organizing and storing files on a storage device. It defines:
- How data is stored and retrieved
- Directory structure and naming
- Metadata (permissions, timestamps, ownership)
- Space allocation and management

### 1.2 Disk Device Naming

| Device | Description |
|--------|-------------|
| `/dev/sda` | First SCSI/SATA disk |
| `/dev/sdb` | Second SCSI/SATA disk |
| `/dev/sda1` | First partition on first disk |
| `/dev/sda2` | Second partition on first disk |
| `/dev/nvme0n1` | First NVMe SSD |
| `/dev/nvme0n1p1` | First partition on NVMe SSD |

### 1.3 Inodes and Data Blocks

```
+--------+     +---------+     +------------+
| Inode  | --> | Direct  | --> | Data Block |
| Table  |     | Pointers|     | (4KB)      |
+--------+     +---------+     +------------+
                    |
               +---------+     +------------+
               | Indirect| --> | Data Block |
               | Pointer |     +------------+
               +---------+
```

- **Inode:** Stores file metadata (size, permissions, timestamps, data block pointers)
- **Data blocks:** Store actual file content
- **Directory entries:** Map filenames to inode numbers

---

## 2. Disk Partitioning

### 2.1 Partition Types

| Type | Description |
|------|-------------|
| **Primary** | Maximum 4 per disk (MBR) |
| **Extended** | Container for logical partitions (counts as 1 primary) |
| **Logical** | Created inside an extended partition |

### 2.2 Partitioning Tools

```bash
# fdisk - MBR partition tool (up to 2TB disks)
sudo fdisk /dev/sdb
# Commands: n (new), d (delete), p (print), w (write), q (quit)

# gdisk - GPT partition tool (over 2TB disks)
sudo gdisk /dev/sdb

# parted - Works with both MBR and GPT
sudo parted /dev/sdb

# List all partitions
sudo fdisk -l
lsblk
```

### 2.3 MBR vs. GPT

| Feature | MBR | GPT |
|---------|-----|-----|
| Max disk size | 2 TB | 9.4 ZB |
| Max partitions | 4 primary (or 3 primary + 1 extended) | 128 |
| Boot mode | BIOS | UEFI |
| Backup | None | Backup at end of disk |

---

## 3. File System Types

### 3.1 Linux File Systems

| File System | Description | Max File Size | Max Volume |
|-------------|-------------|---------------|------------|
| **ext4** | Default on most Linux; journaling | 16 TB | 1 EB |
| **ext3** | Previous default; journaling | 2 TB | 32 TB |
| **ext2** | No journaling; fast for flash storage | 2 TB | 32 TB |
| **xfs** | High-performance; default on RHEL/CentOS | 8 EB | 8 EB |
| **btrfs** | Copy-on-write; snapshots, compression | 16 EB | 16 EB |
| **tmpfs** | RAM-based filesystem | (RAM size) | (RAM size) |

### 3.2 Non-Linux File Systems

| File System | Description |
|-------------|-------------|
| **FAT32** | Cross-platform; 4 GB file size limit |
| **exFAT** | Extended FAT; good for USB drives |
| **NTFS** | Windows default; read/write support via ntfs-3g |
| **NFS** | Network File System; file sharing over network |

### 3.3 Journaling

A **journal** logs changes before writing them to the main filesystem, enabling crash recovery.

```
Write request --> Journal (log) --> Main filesystem --> Journal cleared
                    |
            Power failure? --> Replay journal on boot
```

---

## 4. Creating and Managing File Systems

### 4.1 mkfs — Create File System

```bash
# Create ext4 filesystem
sudo mkfs.ext4 /dev/sdb1
sudo mkfs -t ext4 /dev/sdb1     # Alternative syntax

# Create XFS filesystem
sudo mkfs.xfs /dev/sdb1

# Create FAT32 filesystem (for USB drives)
sudo mkfs.vfat /dev/sdb1

# Check filesystem
sudo fsck /dev/sdb1              # File system check
sudo e2fsck -f /dev/sdb1         # Force ext filesystem check
```

### 4.2 Viewing File System Information

```bash
# Show filesystem type
sudo blkid                        # Show block device IDs and types
df -Th                            # Show mounted filesystems with types
lsblk -f                          # Show filesystem info in tree format

# Show ext filesystem details
sudo dumpe2fs /dev/sdb1 | head -30
sudo tune2fs -l /dev/sdb1
```

---

## 5. Mounting and Unmounting

### 5.1 mount — Attach File System

```bash
# Manual mounting
sudo mount /dev/sdb1 /mnt/data
sudo mount -t ext4 /dev/sdb1 /mnt/data    # Specify filesystem type
sudo mount -o ro /dev/sdb1 /mnt/data       # Mount read-only

# Mount ISO image
sudo mount -o loop image.iso /mnt/iso

# Mount USB drive
sudo mount /dev/sdb1 /media/usb

# Show all mounted filesystems
mount
df -h
findmnt
```

### 5.2 umount — Detach File System

```bash
sudo umount /mnt/data              # Unmount by mount point
sudo umount /dev/sdb1              # Unmount by device
sudo umount -l /mnt/data           # Lazy unmount (if busy)
```

### 5.3 /etc/fstab — Persistent Mounts

```bash
# /etc/fstab format:
# device          mount-point   type   options         dump  pass
/dev/sda1         /             ext4   defaults        0     1
/dev/sda2         /home         ext4   defaults        0     2
/dev/sdb1         /data         ext4   defaults        0     2
UUID=xxxx-xxxx    /backup       ext4   defaults,noauto 0     0
tmpfs             /tmp          tmpfs  defaults        0     0
```

**Mount options:**
| Option | Description |
|--------|-------------|
| `defaults` | rw, suid, dev, exec, auto, nouser, async |
| `ro` | Read-only |
| `rw` | Read-write |
| `noexec` | Prevent execution of binaries |
| `nosuid` | Ignore SUID/SGID bits |
| `noauto` | Do not mount at boot |
| `user` | Allow non-root users to mount |

```bash
# Apply fstab changes without reboot
sudo mount -a
```

---

## 6. Disk Usage Monitoring

### 6.1 df — Disk Free Space

```bash
df                      # Show all mounted filesystems
df -h                   # Human-readable sizes
df -T                   # Show filesystem type
df -i                   # Show inode usage
df /home                # Show specific mount point
```

### 6.2 du — Disk Usage

```bash
du -sh /home/user1                # Summary of directory size
du -h --max-depth=1 /home         # One level deep
du -sh *                          # Size of each item in current directory
du -ah /var/log | sort -rh | head -10   # Top 10 largest files
```

---

## 7. Swap Space

### 7.1 What is Swap?

Swap space is used when physical RAM is full. The kernel moves inactive pages from RAM to swap.

### 7.2 Managing Swap

```bash
# View swap usage
free -h
swapon --show

# Create swap file
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Make permanent (add to /etc/fstab)
# /swapfile none swap sw 0 0

# Disable swap
sudo swapoff /swapfile
```

---

## 8. Best Practices

- Separate `/home`, `/var`, `/tmp` on different partitions for security and management
- Use `ext4` for general use; `xfs` for large files and high performance
- Monitor disk usage regularly with `df -h`
- Always unmount before removing devices
- Use UUIDs in `/etc/fstab` instead of device names for reliability

---

## Summary

| Concept | Key Point |
|---------|-----------|
| File System | Method of organizing data on storage devices |
| Partitioning | Divide disk into sections (`fdisk`, `gdisk`) |
| ext4 | Default Linux filesystem with journaling |
| Inodes | Store file metadata; mapped to filenames via directories |
| `mount`/`umount` | Attach/detach filesystems to directory tree |
| `/etc/fstab` | Persistent mount configuration |
| `df` | Show disk free space |
| `du` | Show disk usage by directory |
| Swap | Virtual memory extension on disk |

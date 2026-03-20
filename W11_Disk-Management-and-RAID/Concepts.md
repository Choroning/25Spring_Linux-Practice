# Week 11 — Disk Management and RAID

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Advanced Disk Management](#1-advanced-disk-management)
2. [LVM (Logical Volume Manager)](#2-lvm-logical-volume-manager)
3. [RAID Overview](#3-raid-overview)
4. [RAID Levels](#4-raid-levels)
5. [Software RAID with mdadm](#5-software-raid-with-mdadm)
6. [Disk Quotas](#6-disk-quotas)
7. [Best Practices](#7-best-practices)
8. [Summary](#summary)

---

## 1. Advanced Disk Management

### 1.1 Adding New Disks

```bash
# 1. Identify new disk
lsblk
sudo fdisk -l

# 2. Partition the disk
sudo fdisk /dev/sdb
# n -> new partition
# p -> primary
# 1 -> partition number
# Enter -> default first sector
# Enter -> default last sector
# w -> write and exit

# 3. Create filesystem
sudo mkfs.ext4 /dev/sdb1

# 4. Create mount point and mount
sudo mkdir /data
sudo mount /dev/sdb1 /data

# 5. Add to fstab for persistence
echo '/dev/sdb1 /data ext4 defaults 0 2' | sudo tee -a /etc/fstab
```

### 1.2 USB/External Drive Management

```bash
# Identify USB device
lsblk
dmesg | tail -20          # Check kernel messages

# Mount USB
sudo mount /dev/sdb1 /media/usb

# Safely remove
sync                       # Flush buffers
sudo umount /media/usb
```

---

## 2. LVM (Logical Volume Manager)

### 2.1 LVM Architecture

```
+----------+  +----------+  +----------+
| /dev/sda1|  | /dev/sdb1|  | /dev/sdc1|   Physical Volumes (PV)
+----+-----+  +----+-----+  +----+-----+
     |             |              |
     +------+------+------+------+
            |             |
     +------+------+ +----+-----+
     | Volume Group| | Volume   |          Volume Groups (VG)
     | (vg_data)   | | Group 2  |
     +------+------+ +----------+
            |
     +------+------+------+
     |             |      |
+----+----+ +-----+---+ +-+--------+
| Logical | | Logical  | | Logical  |  Logical Volumes (LV)
| Volume  | | Volume   | | Volume   |
| (lv_home| | (lv_var) | | (lv_tmp) |
+---------+ +----------+ +----------+
     |            |           |
  /home        /var        /tmp               Mount Points
```

### 2.2 LVM Commands

```bash
# Physical Volume (PV)
sudo pvcreate /dev/sdb1 /dev/sdc1       # Create PVs
sudo pvdisplay                            # Display PV info
sudo pvs                                  # Summary

# Volume Group (VG)
sudo vgcreate vg_data /dev/sdb1 /dev/sdc1  # Create VG
sudo vgdisplay                              # Display VG info
sudo vgextend vg_data /dev/sdd1             # Add disk to VG

# Logical Volume (LV)
sudo lvcreate -L 10G -n lv_home vg_data    # Create 10GB LV
sudo lvcreate -l 100%FREE -n lv_data vg_data  # Use all free space
sudo lvdisplay                               # Display LV info

# Format and mount
sudo mkfs.ext4 /dev/vg_data/lv_home
sudo mount /dev/vg_data/lv_home /home

# Resize LV (extend)
sudo lvextend -L +5G /dev/vg_data/lv_home   # Add 5GB
sudo resize2fs /dev/vg_data/lv_home          # Resize filesystem
```

### 2.3 LVM Advantages

- **Dynamic resizing:** Grow or shrink volumes without unmounting (ext4/xfs)
- **Spanning disks:** Create volumes larger than a single disk
- **Snapshots:** Create point-in-time copies for backups
- **Striping:** Improve I/O performance across multiple disks

---

## 3. RAID Overview

### 3.1 What is RAID?

**RAID** (Redundant Array of Independent Disks) combines multiple physical disks into a single logical unit for:
- **Performance:** Parallel reads/writes across disks
- **Redundancy:** Data survives disk failures
- **Capacity:** Combine multiple smaller disks

### 3.2 Hardware vs. Software RAID

| Feature | Hardware RAID | Software RAID |
|---------|--------------|---------------|
| Controller | Dedicated RAID card | CPU/OS manages |
| Performance | Better (dedicated processor) | Slightly lower |
| Cost | Higher (RAID controller) | Free (built into OS) |
| Flexibility | Limited to controller features | Full OS control |
| Tool | Controller BIOS | `mdadm` on Linux |

---

## 4. RAID Levels

### 4.1 RAID 0 (Striping)

```
     Data: ABCDEFGH

     Disk 1: A C E G    Disk 2: B D F H
```

| Property | Value |
|----------|-------|
| Min Disks | 2 |
| Redundancy | None |
| Capacity | N x disk size |
| Read Speed | N x single disk |
| Write Speed | N x single disk |
| Fault Tolerance | None (any disk failure = total loss) |

### 4.2 RAID 1 (Mirroring)

```
     Data: ABCD

     Disk 1: A B C D    Disk 2: A B C D  (exact copy)
```

| Property | Value |
|----------|-------|
| Min Disks | 2 |
| Redundancy | Full mirror |
| Capacity | 1 disk size (50% efficiency) |
| Read Speed | Up to 2x |
| Write Speed | 1x (writes to both) |
| Fault Tolerance | 1 disk can fail |

### 4.3 RAID 5 (Striping with Distributed Parity)

```
     Disk 1    Disk 2    Disk 3
     A1        A2        Ap (parity)
     Bp        B1        B2
     C1        Cp        C2
```

| Property | Value |
|----------|-------|
| Min Disks | 3 |
| Redundancy | Distributed parity |
| Capacity | (N-1) x disk size |
| Read Speed | (N-1) x single disk |
| Write Speed | Slower (parity calculation) |
| Fault Tolerance | 1 disk can fail |

### 4.4 RAID Level Comparison

| Level | Min Disks | Redundancy | Capacity | Use Case |
|-------|-----------|-----------|----------|----------|
| RAID 0 | 2 | None | 100% | Performance (temp data) |
| RAID 1 | 2 | Mirror | 50% | Boot drives, critical data |
| RAID 5 | 3 | 1 parity | (N-1)/N | General purpose servers |
| RAID 6 | 4 | 2 parity | (N-2)/N | High reliability |
| RAID 10 | 4 | Mirror + stripe | 50% | Databases, high I/O |

---

## 5. Software RAID with mdadm

### 5.1 Creating RAID Arrays

```bash
# Install mdadm
sudo apt install mdadm

# Create RAID 1 (mirror)
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

# Create RAID 5
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1

# Format and mount
sudo mkfs.ext4 /dev/md0
sudo mkdir /mnt/raid
sudo mount /dev/md0 /mnt/raid
```

### 5.2 Managing RAID

```bash
# Check RAID status
cat /proc/mdstat
sudo mdadm --detail /dev/md0

# Add spare disk
sudo mdadm --add /dev/md0 /dev/sde1

# Remove failed disk
sudo mdadm --remove /dev/md0 /dev/sdb1

# Stop RAID array
sudo mdadm --stop /dev/md0

# Save configuration
sudo mdadm --detail --scan >> /etc/mdadm/mdadm.conf
```

---

## 6. Disk Quotas

### 6.1 Setting Up Quotas

```bash
# Install quota tools
sudo apt install quota

# Enable quotas in /etc/fstab
# /dev/sda2 /home ext4 defaults,usrquota,grpquota 0 2

# Remount and initialize
sudo mount -o remount /home
sudo quotacheck -cugm /home
sudo quotaon /home

# Set user quota
sudo edquota -u user1
# Set soft limit, hard limit for blocks and inodes

# Set group quota
sudo edquota -g developers

# View quota usage
sudo repquota /home
quota -u user1
```

---

## 7. Best Practices

- Use RAID 1 for boot/OS drives and RAID 5/6 for data storage
- RAID is NOT a backup — always maintain separate backups
- Use LVM on top of RAID for flexible volume management
- Monitor RAID health regularly with `mdadm --detail`
- Keep hot spare disks for automatic rebuilds
- Test disk recovery procedures before they are needed

---

## Summary

| Concept | Key Point |
|---------|-----------|
| LVM | Flexible volume management (PV -> VG -> LV) |
| RAID 0 | Striping; performance but no redundancy |
| RAID 1 | Mirroring; full redundancy, 50% capacity |
| RAID 5 | Distributed parity; good balance of performance/redundancy |
| mdadm | Linux software RAID management tool |
| Disk Quotas | Limit disk usage per user/group |
| fstab | Persistent mount and quota configuration |

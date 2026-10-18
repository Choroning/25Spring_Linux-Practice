# Week 11 Lecture — Disk Management and RAID

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 7

> **Learning Objectives:**
> 1. Partition disks using fdisk and parted
> 2. Manage the Logical Volume Manager (LVM)
> 3. Compare the storage layout, capacity, and fault tolerance of RAID levels (0, 1, 5, 6, 10)
> 4. Explain how RAID 5 recovers the data of a failed disk using parity
> 5. Configure RAID levels (0, 1, 5, 6, 10) with mdadm and replace a failed disk
> 6. Set up disk quotas

---

## Table of Contents

- [1. Advanced Disk Management](#1-advanced-disk-management)
  - [1.1 Adding New Disks](#11-adding-new-disks)
  - [1.2 USB/External Drive Management](#12-usbexternal-drive-management)
- [2. LVM (Logical Volume Manager)](#2-lvm-logical-volume-manager)
  - [2.1 LVM Architecture](#21-lvm-architecture)
  - [2.2 LVM Commands](#22-lvm-commands)
  - [2.3 LVM Advantages](#23-lvm-advantages)
- [3. RAID Overview](#3-raid-overview)
  - [3.1 What is RAID?](#31-what-is-raid)
  - [3.2 Hardware vs. Software RAID](#32-hardware-vs-software-raid)
  - [3.3 Comparison of Storage Layouts](#33-comparison-of-storage-layouts)
- [4. RAID Levels](#4-raid-levels)
  - [4.1 RAID 0 (Striping)](#41-raid-0-striping)
  - [4.2 RAID 1 (Mirroring)](#42-raid-1-mirroring)
  - [4.3 RAID 5 (Striping with Distributed Parity)](#43-raid-5-striping-with-distributed-parity)
  - [4.4 RAID 6 (Double Distributed Parity)](#44-raid-6-double-distributed-parity)
  - [4.5 RAID 10 (Mirroring then Striping)](#45-raid-10-mirroring-then-striping)
  - [4.6 RAID Level Comparison](#46-raid-level-comparison)
- [5. Software RAID with mdadm](#5-software-raid-with-mdadm)
  - [5.1 Creating RAID Arrays](#51-creating-raid-arrays)
  - [5.2 Managing RAID](#52-managing-raid)
  - [5.3 Failure Testing and Recovery](#53-failure-testing-and-recovery)
- [6. Disk Quotas](#6-disk-quotas)
  - [6.1 Setting Up Quotas](#61-setting-up-quotas)
- [7. Best Practices](#7-best-practices)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. Advanced Disk Management

### 1.1 Adding New Disks

The process of adding and using a new disk (Week 10, Section 2.3) can be summarized in commands as follows.

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

Device names can change when disks are added or removed, so in step 5 it is safer to use the `UUID=...` shown by `blkid` instead of `/dev/sdb1` (Week 10, Section 5.4).

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

`sync` writes data still held in memory buffers to the disk. `umount` also flushes the buffers before unmounting, so always unmount a device before unplugging it.

---

<br>

## 2. LVM (Logical Volume Manager)

### 2.1 LVM Architecture

LVM combines physical volumes (PVs) into volume groups (VGs) and carves logical volumes (LVs) out of a VG to mount them. The terms of LVM (PV, VG, LV, PE) and the creation procedure are covered in Week 10, Section 6.

```text
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

*Figure 1. Hierarchy of physical volumes, volume groups, and logical volumes in LVM*

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

In `lvcreate`, `-L` gives the size as a capacity, and `-l` as a number of PEs or a percentage such as `100%FREE`. After an LV is extended, the file system inside it must be grown as well: `resize2fs` for the ext family and `xfs_growfs` for xfs.

### 2.3 LVM Advantages

- **Dynamic resizing:** A volume can be grown while it is mounted (ext4, xfs). Shrinking is possible for ext4 after unmounting, and xfs cannot be shrunk.
- **Spanning disks:** Volumes larger than a single disk can be created.
- **Snapshots:** Point-in-time copies can be created for backups.
- **Striping:** Spreading data across multiple disks can improve I/O performance.

---

<br>

## 3. RAID Overview

### 3.1 What is RAID?

**RAID** (Redundant Array of Independent Disks) combines multiple physical disks into a single logical unit for the following purposes.

- **Performance:** Reads and writes run in parallel across disks.
- **Redundancy:** Data survives disk failures.
- **Capacity:** Multiple smaller disks are combined into one.

The name RAID was first proposed as Redundant Array of Inexpensive Disks. It meant using several cheap disks as one to cut cost while improving both reliability and performance, and today the letter I is often expanded as Independent.

### 3.2 Hardware vs. Software RAID

| Feature | Hardware RAID | Software RAID |
|---------|--------------|---------------|
| Controller | Dedicated RAID card | CPU/OS manages |
| Performance | Better (dedicated processor) | Slightly lower |
| Cost | Higher (RAID controller) | Free (built into OS) |
| Flexibility | Limited to controller features | Full OS control |
| Tool | Controller BIOS | `mdadm` on Linux |

*Table 1. Comparison of hardware RAID and software RAID*

Hardware RAID is supplied as equipment that a manufacturer builds from several hard disks; it is more stable but considerably more expensive. Software RAID is provided by the operating system; it is an alternative to expensive hardware RAID and stores data more safely at low cost. Section 5 covers software RAID on Linux.

### 3.3 Comparison of Storage Layouts

The following compares storage layouts built from N disks of 1GB each. A simple volume and LVM are not RAID, but they are listed together to compare their storage layout with RAID.

| Layout | Disks | Usable capacity | Storage method and characteristics |
|:-----|:-----|:-----|:-----|
| Simple volume | 1 | 1GB | Uses one hard disk as one volume |
| LVM (linear) | 2 or more | N GB | Fills the disks in order starting from the first, and disks can be added |
| RAID 0 | 2 or more | N GB | Stores data split across all disks at once and is the fastest (striping) |
| RAID 1 | 2 or more | 1GB (one disk's worth) | Stores the same data on all disks at once and provides fault tolerance (mirroring) |
| RAID 5 | 3 or more | (N-1) GB | Provides fault tolerance using parity information with good space efficiency |
| RAID 6 | 4 or more | (N-2) GB | Improves on RAID 5 with two parities and provides fault tolerance |

*Table 2. Comparison of storage layouts built from N disks of 1GB*

---

<br>

## 4. RAID Levels

### 4.1 RAID 0 (Striping)

```text
     Data: ABCDEFGH

     Disk 1: A C E G    Disk 2: B D F H
```

*Figure 2. RAID 0 striping that stores data blocks alternately on two disks*

| Property | Value |
|----------|-------|
| Min Disks | 2 |
| Redundancy | None |
| Capacity | N x disk size |
| Read Speed | N x single disk |
| Write Speed | N x single disk |
| Fault Tolerance | None (any disk failure = total loss) |

*Table 3. Properties of RAID 0*

RAID 0 looks similar to LVM but stores data differently. LVM (linear) fills the first disk before writing to the next, whereas RAID 0 splits data across all disks at once. Storage speed therefore improves greatly and space efficiency is 100%, but losing a single disk loses all data, so reliability is low. It suits data that needs high speed and whose total loss would not be a serious problem.

### 4.2 RAID 1 (Mirroring)

```text
     Data: ABCD

     Disk 1: A B C D    Disk 2: A B C D  (exact copy)
```

*Figure 3. RAID 1 mirroring that copies the same data to two disks*

| Property | Value |
|----------|-------|
| Min Disks | 2 |
| Redundancy | Full mirror |
| Capacity | 1 disk size (50% efficiency) |
| Read Speed | Up to 2x |
| Write Speed | 1x (writes to both) |
| Fault Tolerance | 1 disk can fail |

*Table 4. Properties of RAID 1*

RAID 1 needs twice the capacity to store data, so it costs twice as much and has poor space efficiency, but it provides **fault tolerance**, keeping the data when one disk fails, so its reliability is high. Every write must go to both disks, so storage speed equals that of a single disk. It is suitable for storing important data. The 50% efficiency in the table is for two disks; adding more disks still leaves one disk's worth of usable capacity.

| Item | RAID 0 | RAID 1 |
|:-----|:-----|:-----|
| Performance (write speed) | Excellent | Unchanged |
| Data safety (fault tolerance) | Not guaranteed | Guaranteed |
| Space efficiency | Good | Poor |

*Table 5. Comparison of RAID 0 and RAID 1*

### 4.3 RAID 5 (Striping with Distributed Parity)

```text
     Disk 1    Disk 2    Disk 3
     A1        A2        Ap (parity)
     Bp        B1        B2
     C1        Cp        C2
```

*Figure 4. RAID 5 distributed parity layout that rotates the parity block across disks*

| Property | Value |
|----------|-------|
| Min Disks | 3 |
| Redundancy | Distributed parity |
| Capacity | (N-1) x disk size |
| Read Speed | (N-1) x single disk |
| Write Speed | Slower (parity calculation) |
| Fault Tolerance | 1 disk can fail |

*Table 6. Properties of RAID 5*

RAID 5 aims to combine the data safety of RAID 1 with the space efficiency of RAID 0 and needs at least three disks. For each row (stripe), a **parity** bit is chosen so that the number of 1s, counting the data bits, is even (equal to the XOR of the data bits), and the disk that stores the parity changes from row to row. When one disk fails, the missing values are computed from the remaining disks.

For example, storing the 12-bit data 000 111 010 011 three bits at a time on four disks (sda, sdb, sdc, sdd) gives the following.

| Row | sda | sdb | sdc | sdd | Data | Parity location and value |
|:-----|:-----|:-----|:-----|:-----|:-----|:-----|
| 1 | 0 | 0 | 0 | **0** | 000 | sdd, 0 |
| 2 | 1 | 1 | **1** | 1 | 111 | sdc, 1 |
| 3 | 0 | **1** | 1 | 0 | 010 | sdb, 1 |
| 4 | **0** | 0 | 1 | 1 | 011 | sda, 0 |

*Table 7. Data 000 111 010 011 stored with RAID 5 (bold values are parity)*

If sdb fails, its value in each row is chosen so that, together with the three remaining values, the number of 1s is even. Row 1 has 0, 0, 0, giving 0; row 2 has 1, 1, 1, giving 1; row 3 has 0, 1, 0, giving 1; and row 4 has 0, 1, 1, giving 0, which restores the original values 0, 1, 1, 0 exactly. In this way RAID 5 provides some fault tolerance with good space efficiency (it uses the space of the number of disks minus 1). If two disks fail at the same time, however, a row has two unknown values and cannot be recovered.

### 4.4 RAID 6 (Double Distributed Parity)

```text
     Disk 1    Disk 2    Disk 3    Disk 4
     A1        A2        Ap        Aq
     B1        Bp        Bq        B2
     Cp        Cq        C1        C2
```

*Figure 5. Example of RAID 6 with the two parities P and Q distributed*

RAID 6 improves on RAID 5 by storing, in a distributed way, two parities (P and Q) computed differently for each stripe. P is the same XOR parity as in RAID 5, and Q is produced by a different computation such as a Reed-Solomon code so that the values of two disks can both be restored. It needs at least four disks, and the usable capacity is (N-2) x disk size. Its space efficiency and performance (speed) are slightly lower than RAID 5, but the data stays intact even when two disks fail at once, so its reliability is higher.

### 4.5 RAID 10 (Mirroring then Striping)

```text
                RAID 0 (striping)
          +-----------+-----------+
          |                       |
   RAID 1 (mirror)         RAID 1 (mirror)
   Disk 1   Disk 2         Disk 3   Disk 4
   A1       A1             A2       A2
   B1       B1             B2       B2
```

*Figure 6. Structure of RAID 10 striping two mirrored pairs*

RAID 10 (RAID 1+0) mirrors disks in pairs with RAID 1 and then stripes the mirrored pairs with RAID 0. It is excellent in both reliability (safety) and performance (speed), but its space efficiency is 50% (usable capacity N/2 x disk size), and it needs at least four disks.

> **Caution:** RAID 10 keeps the data safe when two disks fail if they belong to different mirrored pairs, but if both disks of the same pair fail, the data of that pair is lost. The fault tolerance guaranteed in every case is therefore one disk.

### 4.6 RAID Level Comparison

| Level | Min Disks | Redundancy | Capacity | Use Case |
|-------|-----------|-----------|----------|----------|
| RAID 0 | 2 | None | 100% | Performance (temp data) |
| RAID 1 | 2 | Mirror | 50% | Boot drives, critical data |
| RAID 5 | 3 | 1 parity | (N-1)/N | General purpose servers |
| RAID 6 | 4 | 2 parity | (N-2)/N | High reliability |
| RAID 10 | 4 | Mirror + stripe | 50% | Databases, high I/O |

*Table 8. Minimum disks, redundancy, capacity, and use cases of RAID levels*

---

<br>

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

The practice procedure for building RAID 0 from scratch is as follows.

1. Create one partition on each disk used for RAID and change its partition type to fd (Linux RAID autodetect) with the `t` command. Run `fdisk /dev/sdb` and enter `n`, `p`, `1`, Enter, Enter, `t`, `fd`, `p`, `w` in that order.
2. Create the RAID device file with `mknod`. `mknod /dev/md0 b 9 0` creates the block (`b`) device `/dev/md0` with major number 9 (the md driver) and minor number 0. On recent distributions mdadm and udev create device files automatically, so this step can be skipped.
3. Create the array with `mdadm --create` and check the result with `mdadm --detail --scan` and `mdadm --query --detail`.
4. Create a file system with `mkfs.ext4` and mount it on a mount point.

```bash
sudo fdisk /dev/sdb                 # n, p, 1, Enter, Enter, t, fd, p, w
sudo mknod /dev/md0 b 9 0           # Can be skipped on recent distributions
sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb1 /dev/sdc1
sudo mdadm --detail --scan
sudo mdadm --query --detail /dev/md0
sudo mkfs.ext4 /dev/md0
sudo mkdir /mnt/raid0data
sudo mount /dev/md0 /mnt/raid0data
```

In the same way, RAID 1 is created with `--level=1 --raid-devices=2`, RAID 5 with `--level=5 --raid-devices=3`, RAID 6 with `--level=6 --raid-devices=4`, and RAID 10 with `--level=10 --raid-devices=4`.

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

`--remove` can remove only failed or spare disks. To remove a disk that is working normally, first mark it as failed with `sudo mdadm /dev/md0 --fail /dev/sdb1`. The `>>` in the save command is a redirection that needs root privileges, so run it from a root shell or write `sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf`.

### 5.3 Failure Testing and Recovery

RAID 1, 5, 6, and 10 have fault tolerance, so the array keeps working when some disks are removed. Running with a disk missing is called the **degraded** state. RAID 1 and RAID 5 keep the data safe after losing one disk, and RAID 6 after losing any two disks.

In a degraded RAID 5, reading the data of the missing disk requires computing it from the remaining disks every time, so reads can slow down somewhat. When the failed disk is replaced with a new one and added to the array, mdadm performs a **rebuild**, regenerating the data and writing it to the new disk, and once the rebuild finishes no computation is needed and the slowdown disappears. For RAID 1, the data of the remaining disk is copied to the new disk, so both disks again hold the same files.

```bash
sudo mdadm --query --detail /dev/md1      # Check status (degraded or not)
sudo mdadm /dev/md1 --add /dev/sdj1       # Add a new disk and rebuild
sudo mdadm /dev/md5 --add /dev/sdk1
```

To remove a RAID array, unmount it, stop the array, and erase the RAID metadata (superblock) left on the member disks. An array that is not registered in the configuration file may be assembled automatically at boot under a high number such as `/dev/md127`.

```bash
sudo umount /dev/md127
sudo mdadm --stop /dev/md127
sudo mdadm --zero-superblock /dev/sdb1 /dev/sdc1
```

---

<br>

## 6. Disk Quotas

### 6.1 Setting Up Quotas

Disk quotas limit the disk space and the number of files that a user or group can use. The concepts of quotas (hard limit, soft limit) and the detailed use of each command are covered in Week 12, Section 8.

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

<br>

## 7. Best Practices

- Use RAID 1 for boot/OS drives and RAID 5 or RAID 6 for data storage.
- RAID is not a backup, so always maintain separate backups.
- Use LVM on top of RAID for flexible volume management.
- Monitor RAID health regularly with `mdadm --detail`.
- Keep hot spare disks for automatic rebuilds.
- Test disk recovery procedures before they are needed.

---

<br>

## Summary

| Concept | Key Summary |
|---------|-----------|
| LVM | It is a flexible volume management scheme that combines PVs into a VG and carves LVs out of the VG (PV -> VG -> LV). |
| RAID 0 | It uses striping for performance but has no redundancy. |
| RAID 1 | It provides full redundancy by mirroring, with 50% capacity efficiency for two disks. |
| RAID 5 | It balances performance and redundancy with distributed parity and tolerates one disk failure. |
| RAID 6 | It distributes two parities and tolerates two simultaneous disk failures. |
| RAID 10 | It stripes mirrored pairs for both performance and reliability, with 50% capacity efficiency. |
| mdadm | It is the tool for creating and managing Linux software RAID. |
| Disk Quotas | They limit disk usage per user or group. |
| fstab | It is the file that configures persistent mounts and quota options. |

---

<br>

## Self-Check Questions

1. **RAID 5 parity recovery:** In one row of a RAID 5 with four disks (sda, sdb, sdc, sdd), sda=1, sdc=0, the parity on sdd is 0, and sdb has failed. Assuming even parity, find the value of sdb, and explain why the row cannot be recovered if sdc in the same row also fails.

   <details>
   <summary>Answer</summary>

   The number of 1s among the four values must be even, so x = 1 makes 1 + x + 0 + 0 even (1 XOR 0 XOR 0 = 1). If sdc also fails, the values x and y of sdb and sdc are constrained only by x + y being odd, which cannot distinguish (0, 1) from (1, 0), so the row cannot be recovered.

   </details>

2. **RAID 6 vs. RAID 10:** For six 2TB disks configured as RAID 6 and as RAID 10, find the usable capacity of each and the number of disk failures tolerated no matter which disks fail.

   <details>
   <summary>Answer</summary>

   RAID 6 has (6 - 2) × 2TB = 8TB, and the data is safe when any two disks fail. RAID 10 has 6 / 2 × 2TB = 6TB, and the guaranteed fault tolerance is one disk. RAID 10 can survive up to three failures if every failed disk belongs to a different mirrored pair, but it loses data if both disks of one pair fail.

   </details>

3. **Two disk failures in RAID 10:** In a RAID 10 whose four disks form the mirrored pairs (D1, D2) and (D3, D4), two disks fail at random at the same time. Find the probability that the data survives.

   <details>
   <summary>Answer</summary>

   There are $\binom{4}{2} = 6$ ways to choose the two failed disks. Data is lost only when both disks of a pair fail, which happens in 2 cases, (D1, D2) and (D3, D4), so the probability of survival is 4 / 6 = 2/3.

   </details>

4. **Degraded state and rebuild:** Explain why reads can slow down in a RAID 5 after one disk fails and before it is replaced, and what happens when `sudo mdadm /dev/md5 --add /dev/sdk1` is run.

   <details>
   <summary>Answer</summary>

   Reading a data block that was on the failed disk requires reading all the other disks in the same row and computing the XOR, which is slower. Adding a new disk with `--add` makes mdadm start a rebuild, computing each row's value from the other disks and writing it to the new disk, and when the rebuild finishes the array returns to the normal state and reads need no computation.

   </details>

5. **Arguments of mknod:** Give the meaning of each argument of `mknod /dev/md1 b 9 1`, and explain why the command can be skipped on recent distributions.

   <details>
   <summary>Answer</summary>

   `/dev/md1` is the name of the device file to create, `b` means a block device, 9 is the major number of the md (software RAID) driver, and 1 is the minor number identifying the device within that driver. On recent distributions, when `mdadm --create` builds an array, the kernel and udev create device files such as `/dev/md1` automatically, so the command can be skipped.

   </details>

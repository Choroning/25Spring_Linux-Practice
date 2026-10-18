# Week 11 Solutions — Disk Management and RAID

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 7

---

<br>

## Table of Contents

- [Exercise 1: RAID Level Identification](#exercise-1-raid-level-identification)
- [Exercise 2: RAID 5 Capacity Calculation](#exercise-2-raid-5-capacity-calculation)
- [Exercise 3: LVM Architecture](#exercise-3-lvm-architecture)
- [Exercise 4: Creating a RAID 1 Array](#exercise-4-creating-a-raid-1-array)
- [Exercise 5: RAID vs. Backup](#exercise-5-raid-vs-backup)
- [Exercise 6: Extending a Logical Volume](#exercise-6-extending-a-logical-volume)
- [Exercise 7: Disk Quota Configuration](#exercise-7-disk-quota-configuration)
- [Exercise 8: RAID Level Selection](#exercise-8-raid-level-selection)

---

<br>

## Exercise 1: RAID Level Identification

**Problem:** Which RAID level provides striping for performance but offers **no redundancy**, meaning a single disk failure results in total data loss?

- A. RAID 0
- B. RAID 1
- C. RAID 5
- D. RAID 10

### Solution

**Answer:** A. RAID 0

**Explanation:** RAID 0 distributes (stripes) data across two or more disks without any parity or mirroring. This maximizes performance and capacity (100% of all disks is usable) but provides zero fault tolerance. If any single disk fails, all data in the array is lost because each disk holds only fragments of the data.

---

<br>

## Exercise 2: RAID 5 Capacity Calculation

**Problem:** You create a RAID 5 array using 4 disks, each 1 TB in size. What is the usable storage capacity?

- A. 4 TB
- B. 3 TB
- C. 2 TB
- D. 1 TB

### Solution

**Answer:** B. 3 TB

**Explanation:** RAID 5 uses distributed parity, consuming the equivalent of one disk's capacity for parity data. The formula is `(N-1) x disk size`, so with 4 x 1 TB disks, `(4-1) x 1 TB = 3 TB` of usable space. The parity information is spread across all disks (not stored on a single dedicated disk), and the array can tolerate the failure of any one disk.

---

<br>

## Exercise 3: LVM Architecture

**Problem:** What is the correct order of the LVM hierarchy from lowest to highest level?

- A. Logical Volume -> Volume Group -> Physical Volume
- B. Volume Group -> Physical Volume -> Logical Volume
- C. Physical Volume -> Volume Group -> Logical Volume
- D. Physical Volume -> Logical Volume -> Volume Group

### Solution

**Answer:** C. Physical Volume -> Volume Group -> Logical Volume

**Explanation:** In LVM, Physical Volumes (PVs) are created from disk partitions using `pvcreate`. PVs are then combined into Volume Groups (VGs) using `vgcreate`. Finally, Logical Volumes (LVs) are carved out from VGs using `lvcreate`. This layered abstraction allows flexible storage management, such as resizing volumes and spanning multiple disks.

---

<br>

## Exercise 4: Creating a RAID 1 Array

**Problem:** Which `mdadm` command creates a RAID 1 (mirror) array named `/dev/md0` using `/dev/sdb1` and `/dev/sdc1`?

- A. `sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb1 /dev/sdc1`
- B. `sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1`
- C. `sudo mdadm --add /dev/md0 --level=1 /dev/sdb1 /dev/sdc1`
- D. `sudo mdadm --assemble /dev/md0 --level=1 /dev/sdb1 /dev/sdc1`

### Solution

**Answer:** B. `sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1`

**Explanation:** `--create` initializes a new RAID array, `--level=1` specifies RAID 1 (mirroring), and `--raid-devices=2` indicates two disks in the array. Option A creates RAID 0 (striping, no redundancy). Option C uses `--add`, which adds a disk to an existing array. Option D uses `--assemble`, which reassembles a previously created array.

---

<br>

## Exercise 5: RAID vs. Backup

**Problem:** A colleague says, "We have RAID 1 mirroring, so we do not need backups." Why is this statement **incorrect**?

### Solution

**Answer:** RAID provides hardware fault tolerance (surviving disk failures) but does not protect against accidental deletion, file corruption, ransomware, software bugs, or catastrophic events affecting all disks simultaneously. Backups provide point-in-time recovery of data regardless of how it was lost.

**Explanation:** RAID 1 mirrors data in real time, which means any accidental deletion, corruption, or malicious modification is immediately replicated to the mirror. RAID protects against physical disk failure only. A proper backup strategy stores separate copies of data at different points in time, often at a different location, enabling recovery from a wide range of data loss scenarios.

---

<br>

## Exercise 6: Extending a Logical Volume

**Problem:** An LVM logical volume `/dev/vg_data/lv_home` is running out of space. Describe the two commands needed to add 10 GB to this volume and make the filesystem recognize the new space.

### Solution

**Answer:**

1. `sudo lvextend -L +10G /dev/vg_data/lv_home`: extends the logical volume by 10 GB.
2. `sudo resize2fs /dev/vg_data/lv_home`: resizes the ext4 filesystem to fill the expanded volume.

**Explanation:** `lvextend` increases the logical volume size but does not automatically resize the filesystem within it. `resize2fs` is needed to grow the ext2/ext3/ext4 filesystem to use the newly available space. For XFS filesystems, use `xfs_growfs` instead. Alternatively, `lvextend -r` can perform both operations in a single step. Both commands can be run while the volume is mounted.

---

<br>

## Exercise 7: Disk Quota Configuration

**Problem:** Which mount options must be added to `/etc/fstab` to enable user and group disk quotas on the `/home` partition?

- A. `defaults,quota`
- B. `defaults,usrquota,grpquota`
- C. `defaults,limit,quota`
- D. `defaults,diskquota`

### Solution

**Answer:** B. `defaults,usrquota,grpquota`

**Explanation:** To enable disk quotas, the `usrquota` and `grpquota` mount options must be specified in `/etc/fstab` for the target partition. After adding these options, the filesystem must be remounted (`mount -o remount /home`), quota files initialized (`quotacheck -cugm /home`), and quotas activated (`quotaon /home`). Individual user limits are then set with `edquota -u username`.

---

<br>

## Exercise 8: RAID Level Selection

**Problem:** You need to set up storage for a database server that requires both high read/write performance and the ability to survive a single disk failure. Which RAID level is most appropriate and why?

### Solution

**Answer:** RAID 10 (also called RAID 1+0) is most appropriate. It combines mirroring (RAID 1) for redundancy with striping (RAID 0) for performance, providing both fast I/O and fault tolerance.

**Explanation:** RAID 10 requires a minimum of 4 disks, arranged as mirrored pairs that are then striped. It always survives one disk failure, and more if the failed disks belong to different mirrored pairs. Read and write speeds are excellent because striping distributes I/O across multiple mirrored pairs. The trade-off is 50% capacity efficiency. RAID 5 offers better capacity but slower write performance due to parity calculations, so RAID 10 is a common choice for databases.

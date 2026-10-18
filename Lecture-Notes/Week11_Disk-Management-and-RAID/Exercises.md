# Week 11 Exercises — Disk Management and RAID

[Repository Guide](../../README.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 7

---

<br>

## Exercise 1: RAID Level Identification

**Problem:** Which RAID level provides striping for performance but offers **no redundancy**, meaning a single disk failure results in total data loss?

- A. RAID 0
- B. RAID 1
- C. RAID 5
- D. RAID 10

**[Solution](Solutions.md#exercise-1-raid-level-identification)**

---

<br>

## Exercise 2: RAID 5 Capacity Calculation

**Problem:** You create a RAID 5 array using 4 disks, each 1 TB in size. What is the usable storage capacity?

- A. 4 TB
- B. 3 TB
- C. 2 TB
- D. 1 TB

**[Solution](Solutions.md#exercise-2-raid-5-capacity-calculation)**

---

<br>

## Exercise 3: LVM Architecture

**Problem:** What is the correct order of the LVM hierarchy from lowest to highest level?

- A. Logical Volume -> Volume Group -> Physical Volume
- B. Volume Group -> Physical Volume -> Logical Volume
- C. Physical Volume -> Volume Group -> Logical Volume
- D. Physical Volume -> Logical Volume -> Volume Group

**[Solution](Solutions.md#exercise-3-lvm-architecture)**

---

<br>

## Exercise 4: Creating a RAID 1 Array

**Problem:** Which `mdadm` command creates a RAID 1 (mirror) array named `/dev/md0` using `/dev/sdb1` and `/dev/sdc1`?

- A. `sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb1 /dev/sdc1`
- B. `sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1`
- C. `sudo mdadm --add /dev/md0 --level=1 /dev/sdb1 /dev/sdc1`
- D. `sudo mdadm --assemble /dev/md0 --level=1 /dev/sdb1 /dev/sdc1`

**[Solution](Solutions.md#exercise-4-creating-a-raid-1-array)**

---

<br>

## Exercise 5: RAID vs. Backup

**Problem:** A colleague says, "We have RAID 1 mirroring, so we do not need backups." Why is this statement **incorrect**?

**[Solution](Solutions.md#exercise-5-raid-vs-backup)**

---

<br>

## Exercise 6: Extending a Logical Volume

**Problem:** An LVM logical volume `/dev/vg_data/lv_home` is running out of space. Describe the two commands needed to add 10 GB to this volume and make the filesystem recognize the new space.

**[Solution](Solutions.md#exercise-6-extending-a-logical-volume)**

---

<br>

## Exercise 7: Disk Quota Configuration

**Problem:** Which mount options must be added to `/etc/fstab` to enable user and group disk quotas on the `/home` partition?

- A. `defaults,quota`
- B. `defaults,usrquota,grpquota`
- C. `defaults,limit,quota`
- D. `defaults,diskquota`

**[Solution](Solutions.md#exercise-7-disk-quota-configuration)**

---

<br>

## Exercise 8: RAID Level Selection

**Problem:** You need to set up storage for a database server that requires both high read/write performance and the ability to survive a single disk failure. Which RAID level is most appropriate and why?

**[Solution](Solutions.md#exercise-8-raid-level-selection)**

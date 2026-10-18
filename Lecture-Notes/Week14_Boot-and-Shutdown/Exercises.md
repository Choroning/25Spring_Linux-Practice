# Week 14 Exercises — Boot and Shutdown

[Repository Guide](../../README.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 8

---

<br>

## Exercise 1: Replacement for init

**Problem:** What is the name of the service that replaced the traditional PID 1 process `init`?

- A. system
- B. systemd
- C. systemctl
- D. sysinit

**[Solution](Solutions.md#exercise-1-replacement-for-init)**

---

<br>

## Exercise 2: Checking Current Target

**Problem:** What command is used to check the current (default) target?

- A. `systemctl set-default`
- B. `systemctl status`
- C. `systemctl start`
- D. `systemctl get-default`

**[Solution](Solutions.md#exercise-2-checking-current-target)**

---

<br>

## Exercise 3: System Shutdown Commands

**Problem:** Which of the following is **NOT** a command that shuts down the system?

- A. `reboot`
- B. `halt`
- C. `kill`
- D. `poweroff`

**[Solution](Solutions.md#exercise-3-system-shutdown-commands)**

---

<br>

## Exercise 4: Linux Boot Sequence

**Problem:** What is the correct order of the Linux boot stages?

- A. Boot loader -> BIOS -> Kernel init -> systemd -> Login prompt
- B. BIOS -> Kernel init -> Boot loader -> systemd -> Login prompt
- C. Boot loader -> Kernel init -> BIOS -> systemd -> Login prompt
- D. BIOS -> Boot loader -> Kernel init -> systemd -> Login prompt

**[Solution](Solutions.md#exercise-4-linux-boot-sequence)**

---

<br>

## Exercise 5: Reboot Runlevel

**Problem:** Which runlevel indicates a system reboot?

- A. 0
- B. 3
- C. 5
- D. 6

**[Solution](Solutions.md#exercise-5-reboot-runlevel)**

---

<br>

## Exercise 6: Scheduled Reboot

**Problem:** What command sets the system to reboot in 1 minute?

- A. `shutdown -h +1`
- B. `shutdown -r +1`
- C. `shutdown -c +1`
- D. `shutdown -k +1`

**[Solution](Solutions.md#exercise-6-scheduled-reboot)**

---

<br>

## Exercise 7: Role of the Bootloader

**Problem:** Explain the role of the bootloader.

**[Solution](Solutions.md#exercise-7-role-of-the-bootloader)**

---

<br>

## Exercise 8: Listing Device Units

**Problem:** What command is used to check what device units exist?

**[Solution](Solutions.md#exercise-8-listing-device-units)**

---

<br>

## Exercise 9: Checking Service Active Status

**Problem:** What command checks whether the `abc.service` unit is active (running)?

**[Solution](Solutions.md#exercise-9-checking-service-active-status)**

---

<br>

## Exercise 10: Switching to Single-User Mode

**Problem:** What command switches the system to single-user (rescue) mode for troubleshooting?

**[Solution](Solutions.md#exercise-10-switching-to-single-user-mode)**

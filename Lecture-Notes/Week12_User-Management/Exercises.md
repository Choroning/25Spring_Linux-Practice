# Week 12 Exercises — User Management

[Repository Guide](../../README.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 10

---

<br>

## Exercise 1: Commands Supporting Duplicate UID/GID

**Problem:** Which command related to user account groups does **not** allow setting duplicate UID or GID?

- A. `usermod`
- B. `useradd`
- C. `userdel`
- D. `groupadd`

**[Solution](Solutions.md#exercise-1-commands-supporting-duplicate-uidgid)**

---

<br>

## Exercise 2: Creating a User with a Specific UID

**Problem:** How do you create the user account `han01` with UID 1010 using the `adduser` command?

- A. `adduser 1010 han01`
- B. `adduser -u 1010 han01`
- C. `adduser -uid 1010 han01`
- D. `adduser --uid 1010 han01`

**[Solution](Solutions.md#exercise-2-creating-a-user-with-a-specific-uid)**

---

<br>

## Exercise 3: Locking a User Password

**Problem:** What command locks the password for the `han01` account?

- A. `passwd -d han01`
- B. `passwd -u han01`
- C. `passwd -l han01`
- D. `passwd -x han01`

**[Solution](Solutions.md#exercise-3-locking-a-user-password)**

---

<br>

## Exercise 4: Assigning Disk Quota

**Problem:** What command assigns a disk quota to user account `han01`?

- A. `quotaon han01`
- B. `edquota -u han01`
- C. `edquota han01`
- D. `quotacheck -u han01`

**[Solution](Solutions.md#exercise-4-assigning-disk-quota)**

---

<br>

## Exercise 5: Specifying Login Shell

**Problem:** What command creates user account `han01` with the Bourne shell as the login shell?

- A. `useradd -b sh han01`
- B. `useradd -s sh han01`
- C. `useradd -b /bin/sh han01`
- D. `useradd -s /bin/sh han01`

**[Solution](Solutions.md#exercise-5-specifying-login-shell)**

---

<br>

## Exercise 6: Setting Maximum Password Age

**Problem:** What command sets the maximum password usage period for `han01` to 200 days?

- A. `useradd -x 200 han01`
- B. `usermod -x 200 han01`
- C. `chage -M 200 han01`
- D. `chage -m 200 han01`

**[Solution](Solutions.md#exercise-6-setting-maximum-password-age)**

---

<br>

## Exercise 7: Checking EUID

**Problem:** What commands can be used to check the EUID (Effective User ID)?

**[Solution](Solutions.md#exercise-7-checking-euid)**

---

<br>

## Exercise 8: Password Storage File

**Problem:** In which file are user passwords stored?

**[Solution](Solutions.md#exercise-8-password-storage-file)**

---

<br>

## Exercise 9: Default Group Information

**Problem:** In which file can a user's default (primary) group be confirmed?

**[Solution](Solutions.md#exercise-9-default-group-information)**

---

<br>

## Exercise 10: The `-r` Option in User Deletion

**Problem:** What is the meaning of the `-r` option when deleting a user account?

**[Solution](Solutions.md#exercise-10-the--r-option-in-user-deletion)**

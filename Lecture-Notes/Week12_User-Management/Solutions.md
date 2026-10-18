# Week 12 Solutions — User Management

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 10

---

<br>

## Table of Contents

- [Exercise 1: Commands Supporting Duplicate UID/GID](#exercise-1-commands-supporting-duplicate-uidgid)
- [Exercise 2: Creating a User with a Specific UID](#exercise-2-creating-a-user-with-a-specific-uid)
- [Exercise 3: Locking a User Password](#exercise-3-locking-a-user-password)
- [Exercise 4: Assigning Disk Quota](#exercise-4-assigning-disk-quota)
- [Exercise 5: Specifying Login Shell](#exercise-5-specifying-login-shell)
- [Exercise 6: Setting Maximum Password Age](#exercise-6-setting-maximum-password-age)
- [Exercise 7: Checking EUID](#exercise-7-checking-euid)
- [Exercise 8: Password Storage File](#exercise-8-password-storage-file)
- [Exercise 9: Default Group Information](#exercise-9-default-group-information)
- [Exercise 10: The `-r` Option in User Deletion](#exercise-10-the--r-option-in-user-deletion)

---

<br>

## Exercise 1: Commands Supporting Duplicate UID/GID

**Problem:** Which command related to user account groups does **not** allow setting duplicate UID or GID?

- A. `usermod`
- B. `useradd`
- C. `userdel`
- D. `groupadd`

### Solution

**Answer:** C. `userdel`

**Explanation:** The `userdel` command is used to delete user accounts and does not involve setting UID or GID values at all. Commands like `usermod`, `useradd`, and `groupadd` support the `-o` option which allows non-unique (duplicate) UID or GID assignments (as does `groupmod`), and `-o` is used together with `-u` or `-g` when a number is given. Since `userdel` only removes accounts, the concept of duplicate UID/GID does not apply.

---

<br>

## Exercise 2: Creating a User with a Specific UID

**Problem:** How do you create the user account `han01` with UID 1010 using the `adduser` command?

- A. `adduser 1010 han01`
- B. `adduser -u 1010 han01`
- C. `adduser -uid 1010 han01`
- D. `adduser --uid 1010 han01`

### Solution

**Answer:** D. `adduser --uid 1010 han01`

**Explanation:** The `adduser` command on Debian/Ubuntu uses the long option `--uid` to specify a custom UID. Note that `adduser` (a higher-level wrapper on Debian-based systems) differs from `useradd` (low-level, standard). For `useradd`, the short option `-u` works, but `adduser` requires the full `--uid` flag.

---

<br>

## Exercise 3: Locking a User Password

**Problem:** What command locks the password for the `han01` account?

- A. `passwd -d han01`
- B. `passwd -u han01`
- C. `passwd -l han01`
- D. `passwd -x han01`

### Solution

**Answer:** C. `passwd -l han01`

**Explanation:** The `-l` (lock) option of `passwd` disables a user's password by prepending a `!` to the encrypted password in `/etc/shadow`, making password authentication impossible. `-d` deletes the password, `-u` unlocks a locked password, and `-x` sets the maximum password age (a number of days must be given with it).

---

<br>

## Exercise 4: Assigning Disk Quota

**Problem:** What command assigns a disk quota to user account `han01`?

- A. `quotaon han01`
- B. `edquota -u han01`
- C. `edquota han01`
- D. `quotacheck -u han01`

### Solution

**Answer:** B. `edquota -u han01`

**Explanation:** The `edquota` command opens an editor to set disk quota limits for a user. The `-u` option explicitly specifies that the quota is for a user (as opposed to `-g` for groups). Because `-u` is the default, `edquota han01` in option C opens the same user quota editor, but B, which states the target explicitly, is the answer the question intends. `quotaon` enables quota enforcement per file system and does not take a user name as an argument, and `quotacheck` likewise scans a file system, not a user, to build the quota database.

---

<br>

## Exercise 5: Specifying Login Shell

**Problem:** What command creates user account `han01` with the Bourne shell as the login shell?

- A. `useradd -b sh han01`
- B. `useradd -s sh han01`
- C. `useradd -b /bin/sh han01`
- D. `useradd -s /bin/sh han01`

### Solution

**Answer:** D. `useradd -s /bin/sh han01`

**Explanation:** The `-s` option in `useradd` sets the login shell for the new user. The shell must be specified with its full absolute path (`/bin/sh`), not just the name, and `useradd` rejects a shell name that is not an absolute path as an invalid shell. The `-b` option sets the base directory for home directories, not the shell. Therefore, `-s /bin/sh` is the correct combination.

---

<br>

## Exercise 6: Setting Maximum Password Age

**Problem:** What command sets the maximum password usage period for `han01` to 200 days?

- A. `useradd -x 200 han01`
- B. `usermod -x 200 han01`
- C. `chage -M 200 han01`
- D. `chage -m 200 han01`

### Solution

**Answer:** C. `chage -M 200 han01`

**Explanation:** The `chage` command manages password aging policies. The `-M` (uppercase) option sets the maximum number of days a password remains valid. The `-m` (lowercase) option sets the minimum number of days between password changes. `useradd` and `usermod` do not use `-x` for this purpose in standard implementations. Although it is not among the options, `passwd -x 200 han01` makes the same setting.

---

<br>

## Exercise 7: Checking EUID

**Problem:** What commands can be used to check the EUID (Effective User ID)?

### Solution

**Answer:** `whoami`, `id`

**Explanation:** The `whoami` command prints the effective user name associated with the current EUID. The `id` command displays the user and group IDs, showing a separate `euid=` item when the real and effective IDs differ. Both can be used to verify the effective user identity, which is particularly useful when using `su` or `sudo` to switch user contexts. In contrast, `who am i` (`who -m`) shows the account logged in on the terminal, so it still prints the originally logged-in user after switching with `su`.

---

<br>

## Exercise 8: Password Storage File

**Problem:** In which file are user passwords stored?

### Solution

**Answer:** `/etc/shadow`

**Explanation:** User passwords are stored in hashed form in `/etc/shadow`. Only root can read and write this file and the shadow group can only read it (on Ubuntu), so regular users cannot read it, which provides better security than the older method of storing password hashes in the world-readable `/etc/passwd`. Each line in `/etc/shadow` contains the username, hashed password, and various password aging fields.

---

<br>

## Exercise 9: Default Group Information

**Problem:** In which file can a user's default (primary) group be confirmed?

### Solution

**Answer:** `/etc/passwd`

**Explanation:** The `/etc/passwd` file contains basic user account information with seven colon-separated fields (`username:password:UID:GID:GECOS:home:shell`). The fourth field (GID) specifies the user's primary group ID. The group name corresponding to this GID can be looked up in `/etc/group`.

---

<br>

## Exercise 10: The `-r` Option in User Deletion

**Problem:** What is the meaning of the `-r` option when deleting a user account?

### Solution

**Answer:** It deletes the user's home directory (and its contents) along with the user account.

**Explanation:** When using `userdel -r username`, the `-r` option ensures that the user's home directory and mail spool are removed along with the account entry. Without `-r`, only the user account is deleted from `/etc/passwd` and `/etc/shadow`, but the home directory and files remain on the system. Files owned by the user outside the home directory are not deleted even with `-r`.

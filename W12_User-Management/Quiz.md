# W12 — Quiz

> **Last Updated:** 2026-03-21

---

## Q1. Commands Supporting Duplicate UID/GID

**Question:** Which command related to user account groups does **NOT** allow setting duplicate UID or GID?

| Option | Command |
|--------|---------|
| A | `usermod` |
| B | `useradd` |
| C | `userdel` |
| D | `groupadd` |

**Answer:** C. `userdel`

**Explanation:** The `userdel` command is used to delete user accounts and does not involve setting UID or GID values at all. Commands like `usermod`, `useradd`, and `groupadd` support the `-o` option which allows non-unique (duplicate) UID or GID assignments. Since `userdel` only removes accounts, the concept of duplicate UID/GID does not apply.

---

## Q2. Creating a User with a Specific UID

**Question:** How do you create the user account `han01` with UID 1010 using the `adduser` command?

| Option | Command |
|--------|---------|
| A | `adduser 1010 han01` |
| B | `adduser -u 1010 han01` |
| C | `adduser -uid 1010 han01` |
| D | `adduser --uid 1010 han01` |

**Answer:** D. `adduser --uid 1010 han01`

**Explanation:** The `adduser` command on Debian/Ubuntu uses the long option `--uid` to specify a custom UID. Note that `adduser` (Debian-specific, higher-level wrapper) differs from `useradd` (low-level, standard). For `useradd`, the short option `-u` works, but `adduser` requires the full `--uid` flag.

---

## Q3. Locking a User Password

**Question:** What command locks the password for the `han01` account?

| Option | Command |
|--------|---------|
| A | `passwd -d han01` |
| B | `passwd -u han01` |
| C | `passwd -l han01` |
| D | `passwd -x han01` |

**Answer:** C. `passwd -l han01`

**Explanation:** The `-l` (lock) option of `passwd` disables a user's password by prepending a `!` to the encrypted password in `/etc/shadow`, making it impossible to authenticate. `-d` deletes the password, `-u` unlocks a locked password, and `-x` sets the maximum password age.

---

## Q4. Assigning Disk Quota

**Question:** What command assigns a disk quota to user account `han01`?

| Option | Command |
|--------|---------|
| A | `quotaon han01` |
| B | `edquota -u han01` |
| C | `edquota han01` |
| D | `quotacheck -u han01` |

**Answer:** B. `edquota -u han01`

**Explanation:** The `edquota` command opens an editor to set disk quota limits for a user. The `-u` option explicitly specifies that the quota is for a user (as opposed to `-g` for groups). `quotaon` enables quota enforcement, `quotacheck` scans a file system for disk usage, and `edquota` without `-u` may be ambiguous.

---

## Q5. Specifying Login Shell

**Question:** What command creates user account `han01` with the Bourne shell as the login shell?

| Option | Command |
|--------|---------|
| A | `useradd -b sh han01` |
| B | `useradd -s sh han01` |
| C | `useradd -b /bin/sh han01` |
| D | `useradd -s /bin/sh han01` |

**Answer:** D. `useradd -s /bin/sh han01`

**Explanation:** The `-s` option in `useradd` sets the login shell for the new user. The shell must be specified with its full absolute path (`/bin/sh`), not just the name. The `-b` option sets the base directory for home directories, not the shell. Therefore, `-s /bin/sh` is the correct combination.

---

## Q6. Setting Maximum Password Age

**Question:** What command sets the maximum password usage period for `han01` to 200 days?

| Option | Command |
|--------|---------|
| A | `useradd -x 200 han01` |
| B | `usermod -x 200 han01` |
| C | `chage -M 200 han01` |
| D | `chage -m 200 han01` |

**Answer:** C. `chage -M 200 han01`

**Explanation:** The `chage` command manages password aging policies. The `-M` (uppercase) option sets the maximum number of days a password remains valid. The `-m` (lowercase) option sets the minimum number of days between password changes. `useradd` and `usermod` do not use `-x` for this purpose in standard implementations.

---

## Q7. Checking EUID

**Question:** What commands can be used to check the EUID (Effective User ID)?

**Answer:** `whoami`, `id`

**Explanation:** The `whoami` command prints the effective user name associated with the current EUID. The `id` command displays the real and effective user and group IDs. Both can be used to verify the effective user identity, which is particularly useful when using `su` or `sudo` to switch user contexts.

---

## Q8. Password Storage File

**Question:** In which file are user passwords stored?

**Answer:** `/etc/shadow`

**Explanation:** User passwords are stored in hashed form in `/etc/shadow`. This file is readable only by root, providing better security than the older method of storing password hashes in `/etc/passwd`. Each line in `/etc/shadow` contains the username, hashed password, and various password aging fields.

---

## Q9. Default Group Information

**Question:** In which file can a user's default (primary) group be confirmed?

**Answer:** `/etc/passwd`

**Explanation:** The `/etc/passwd` file contains basic user account information with seven colon-separated fields: `username:password:UID:GID:GECOS:home:shell`. The fourth field (GID) specifies the user's primary group ID. The group name corresponding to this GID can be looked up in `/etc/group`.

---

## Q10. The `-r` Option in User Deletion

**Question:** What is the meaning of the `-r` option when deleting a user account?

**Answer:** It deletes the user's home directory (and its contents) along with the user account.

**Explanation:** When using `userdel -r username`, the `-r` option ensures that the user's home directory and mail spool are removed along with the account entry. Without `-r`, only the user account is deleted from `/etc/passwd` and `/etc/shadow`, but the home directory and files remain on the system.

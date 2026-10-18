# Week 7 Solutions — File Access Permissions

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 5

---

<br>

## Table of Contents

- [Exercise 1: Interpreting Permission Strings](#exercise-1-interpreting-permission-strings)
- [Exercise 2: Octal Permission Conversion](#exercise-2-octal-permission-conversion)
- [Exercise 3: Using chmod with Symbolic Mode](#exercise-3-using-chmod-with-symbolic-mode)
- [Exercise 4: Understanding umask](#exercise-4-understanding-umask)
- [Exercise 5: Changing Ownership](#exercise-5-changing-ownership)
- [Exercise 6: Special Permissions (Sticky Bit)](#exercise-6-special-permissions-sticky-bit)
- [Exercise 7: SetUID Permission](#exercise-7-setuid-permission)
- [Exercise 8: Finding World-Writable Files](#exercise-8-finding-world-writable-files)

---

<br>

## Exercise 1: Interpreting Permission Strings

**Problem:** What does the permission string `drwxr-x---` indicate?

- A. A regular file with full access for everyone
- B. A directory where the owner has full access, the group can read and enter, and others have no access
- C. A directory where everyone can read and execute
- D. A symbolic link with restricted permissions

### Solution

**Answer:** B. A directory where the owner has full access, the group can read and enter, and others have no access

**Explanation:** The first character `d` indicates a directory. The owner permissions `rwx` (read, write, execute) allow full access including listing, creating/deleting files, and entering the directory. Group permissions `r-x` allow listing contents and entering but not creating or deleting files. Others `---` have no access at all. A symbolic link would have `l` as the first character.

---

<br>

## Exercise 2: Octal Permission Conversion

**Problem:** What is the octal representation of the permission `rw-r-xr--`?

- A. `654`
- B. `645`
- C. `754`
- D. `544`

### Solution

**Answer:** A. `654`

**Explanation:** Each permission set converts to octal by adding: r=4, w=2, x=1. Owner `rw-` = 4+2+0 = 6. Group `r-x` = 4+0+1 = 5. Others `r--` = 4+0+0 = 4. Combined: `654`.

---

<br>

## Exercise 3: Using chmod with Symbolic Mode

**Problem:** Which command adds execute permission for the owner and removes write permission for others on `script.sh`?

- A. `chmod u+x,o+w script.sh`
- B. `chmod u+x,o-w script.sh`
- C. `chmod a+x,o-w script.sh`
- D. `chmod u-x,o+w script.sh`

### Solution

**Answer:** B. `chmod u+x,o-w script.sh`

**Explanation:** `u+x` adds execute permission for the owner (user), and `o-w` removes write permission for others. Multiple permission changes can be combined with commas. Option A adds write for others instead of removing it. Option C adds execute for all users, not just the owner. Option D reverses both operations.

---

<br>

## Exercise 4: Understanding umask

**Problem:** If the umask is set to `027`, what permissions will a newly created regular file have?

- A. `750` (`rwxr-x---`)
- B. `640` (`rw-r-----`)
- C. `027` (`----w-rwx`)
- D. `666` (`rw-rw-rw-`)

### Solution

**Answer:** B. `640` (`rw-r-----`)

**Explanation:** The default permission for new files is `666` (files never get execute by default). The umask turns off every bit of this permission that is 1 in the mask. `666` is binary `110 110 110` and `027` is `000 010 111`, so `110 110 110` AND (NOT `000 010 111`) = `110 100 000` = `640`. Owner gets `rw-` (6), group gets `r--` (4), others get `---` (0). Computing 666 - 027 in octal gives 637, which is why the umask is not computed by subtraction. For directories, the base is `777`, so a new directory would get `750` (option A). Option C is the mask value itself, and D is the result when the umask is `000`.

---

<br>

## Exercise 5: Changing Ownership

**Problem:** Which command changes the owner of `data/` and all its contents to `admin` and the group to `staff`?

- A. `sudo chown admin:staff data/`
- B. `sudo chown -R admin:staff data/`
- C. `sudo chgrp -R admin:staff data/`
- D. `sudo chmod -R admin:staff data/`

### Solution

**Answer:** B. `sudo chown -R admin:staff data/`

**Explanation:** `chown` changes ownership, the `user:group` syntax sets both owner and group simultaneously, and `-R` applies the change recursively to all files and subdirectories. Option A lacks `-R` so it only affects the directory itself, not its contents. `chgrp` only changes the group. `chmod` changes permissions, not ownership.

---

<br>

## Exercise 6: Special Permissions (Sticky Bit)

**Problem:** The `/tmp` directory has the following permissions:

```text
drwxrwxrwt 15 root root 4096 Mar 21 10:00 /tmp
```

What does the `t` at the end of the permission string mean?

### Solution

**Answer:** The `t` indicates the sticky bit is set. When the sticky bit is set on a directory, only the file's owner, the directory's owner, or root can delete or rename files within that directory, even if others have write permission.

**Explanation:** Without the sticky bit, anyone with write permission on a directory can delete any file in it. The sticky bit on `/tmp` is essential because `/tmp` is world-writable (`rwxrwxrwx`), and without it, any user could delete other users' temporary files. The `t` appears in the execute position for others; lowercase `t` means execute is also set, and uppercase `T` would mean sticky is set but execute for others is not.

---

<br>

## Exercise 7: SetUID Permission

**Problem:** Why does the `/usr/bin/passwd` command have the SUID bit set, and what would happen if it were removed?

### Solution

**Answer:** The SUID bit allows the `passwd` command to run with root privileges regardless of which user executes it. This is necessary because changing a password requires writing to `/etc/shadow`, which is only writable by root. If the SUID bit were removed, regular users could not modify `/etc/shadow` and therefore could not change their passwords. On Ubuntu, `passwd: Authentication token manipulation error` and `passwd: password unchanged` are printed.

**Explanation:** When SUID (`s` in the owner's execute position) is set on an executable, it runs with the file owner's permissions instead of the caller's. Since `/usr/bin/passwd` is owned by root, any user running it temporarily gains root-level access to modify `/etc/shadow`. The SUID bit is shown as `s` in `ls -l` output: `-rwsr-xr-x`.

---

<br>

## Exercise 8: Finding World-Writable Files

**Problem:** Write a command that finds all world-writable regular files on the system while suppressing "Permission denied" errors.

### Solution

**Answer:** `find / -type f -perm -o+w 2>/dev/null`

**Explanation:** `-type f` restricts the search to regular files, and `-perm -o+w` matches files where others have write permission (`-perm -002` in octal). The `2>/dev/null` redirects stderr (which would contain "Permission denied" messages from restricted directories) to `/dev/null`, keeping the output clean. This is a common security audit command to identify files that any user on the system can modify.

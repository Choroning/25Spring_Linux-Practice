# Week 7 Exercises — File Access Permissions

[Repository Guide](../../README.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 5

---

<br>

## Exercise 1: Interpreting Permission Strings

**Problem:** What does the permission string `drwxr-x---` indicate?

- A. A regular file with full access for everyone
- B. A directory where the owner has full access, the group can read and enter, and others have no access
- C. A directory where everyone can read and execute
- D. A symbolic link with restricted permissions

**[Solution](Solutions.md#exercise-1-interpreting-permission-strings)**

---

<br>

## Exercise 2: Octal Permission Conversion

**Problem:** What is the octal representation of the permission `rw-r-xr--`?

- A. `654`
- B. `645`
- C. `754`
- D. `544`

**[Solution](Solutions.md#exercise-2-octal-permission-conversion)**

---

<br>

## Exercise 3: Using chmod with Symbolic Mode

**Problem:** Which command adds execute permission for the owner and removes write permission for others on `script.sh`?

- A. `chmod u+x,o+w script.sh`
- B. `chmod u+x,o-w script.sh`
- C. `chmod a+x,o-w script.sh`
- D. `chmod u-x,o+w script.sh`

**[Solution](Solutions.md#exercise-3-using-chmod-with-symbolic-mode)**

---

<br>

## Exercise 4: Understanding umask

**Problem:** If the umask is set to `027`, what permissions will a newly created regular file have?

- A. `750` (`rwxr-x---`)
- B. `640` (`rw-r-----`)
- C. `027` (`----w-rwx`)
- D. `666` (`rw-rw-rw-`)

**[Solution](Solutions.md#exercise-4-understanding-umask)**

---

<br>

## Exercise 5: Changing Ownership

**Problem:** Which command changes the owner of `data/` and all its contents to `admin` and the group to `staff`?

- A. `sudo chown admin:staff data/`
- B. `sudo chown -R admin:staff data/`
- C. `sudo chgrp -R admin:staff data/`
- D. `sudo chmod -R admin:staff data/`

**[Solution](Solutions.md#exercise-5-changing-ownership)**

---

<br>

## Exercise 6: Special Permissions (Sticky Bit)

**Problem:** The `/tmp` directory has the following permissions:

```text
drwxrwxrwt 15 root root 4096 Mar 21 10:00 /tmp
```

What does the `t` at the end of the permission string mean?

**[Solution](Solutions.md#exercise-6-special-permissions-sticky-bit)**

---

<br>

## Exercise 7: SetUID Permission

**Problem:** Why does the `/usr/bin/passwd` command have the SUID bit set, and what would happen if it were removed?

**[Solution](Solutions.md#exercise-7-setuid-permission)**

---

<br>

## Exercise 8: Finding World-Writable Files

**Problem:** Write a command that finds all world-writable regular files on the system while suppressing "Permission denied" errors.

**[Solution](Solutions.md#exercise-8-finding-world-writable-files)**

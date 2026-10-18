# Week 7 Lecture — File Access Permissions

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 5

> **Learning Objectives:**
> 1. Check and interpret file attributes with `ls -l` and `stat`
> 2. Interpret file permission notation (rwx, octal)
> 3. Apply chmod, chown, and chgrp commands
> 4. Configure default permissions with umask
> 5. Explain the effects of SetUID, SetGID, and the sticky bit

---

## Table of Contents

- [1. Understanding File Permissions](#1-understanding-file-permissions)
  - [1.1 File Attributes](#11-file-attributes)
  - [1.2 User Categories](#12-user-categories)
  - [1.3 Permission Types](#13-permission-types)
- [2. Permission Representation](#2-permission-representation)
  - [2.1 Symbolic Notation](#21-symbolic-notation)
  - [2.2 Octal (Numeric) Notation](#22-octal-numeric-notation)
- [3. Changing Permissions with chmod](#3-changing-permissions-with-chmod)
  - [3.1 Symbolic Mode](#31-symbolic-mode)
  - [3.2 Octal Mode](#32-octal-mode)
- [4. Changing Ownership](#4-changing-ownership)
  - [4.1 chown: Change Owner](#41-chown-change-owner)
  - [4.2 chgrp: Change Group](#42-chgrp-change-group)
  - [4.3 Viewing Ownership](#43-viewing-ownership)
- [5. Default Permissions and umask](#5-default-permissions-and-umask)
  - [5.1 How umask Works](#51-how-umask-works)
  - [5.2 Common umask Values](#52-common-umask-values)
- [6. Special Permissions](#6-special-permissions)
  - [6.1 SetUID (SUID)](#61-setuid-suid)
  - [6.2 SetGID (SGID)](#62-setgid-sgid)
  - [6.3 Sticky Bit](#63-sticky-bit)
  - [6.4 Special Permission Summary](#64-special-permission-summary)
- [7. Best Practices](#7-best-practices)
  - [7.1 Security Guidelines](#71-security-guidelines)
  - [7.2 Common Security Checks](#72-common-security-checks)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. Understanding File Permissions

### 1.1 File Attributes

The `ls -l` command prints **file attributes** such as the file type, access permissions, and owner on one line.

```bash
$ ls -l /etc/hosts
-rw-r--r-- 1 root root 172 Oct 18 14:53 /etc/hosts
```

| No. | Value | Meaning |
|-----|-------|---------|
| 1 | `-` | File type (`-` is a regular file, `d` is a directory) |
| 2 | `rw-r--r--` | Access permissions for reading, writing, and executing the file |
| 3 | `1` | Number of hard links |
| 4 | `root` | Login ID of the file owner |
| 5 | `root` | Name of the group the file belongs to |
| 6 | `172` | File size (in bytes) |
| 7 | `Oct 18 14:53` | Date of the last modification |
| 8 | `/etc/hosts` | File name |

*Table 1. File attributes in the output of `ls -l`*

The `stat` command shows the same attributes in more detail. It displays the access permissions in both octal and symbolic form, shows the owner and group by both number (UID, GID) and name, and prints the times of the last access (Access), modification (Modify), and attribute change (Change) separately.

```bash
$ stat /etc/hosts
  File: /etc/hosts
  Size: 172       	Blocks: 8          IO Block: 4096   regular file
Device: 253,17	Inode: 1076018     Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2026-10-18 14:53:38.599276403 +0000
Modify: 2026-10-18 14:53:38.655276264 +0000
Change: 2026-10-18 14:53:38.655276264 +0000
 Birth: 2026-10-18 14:53:38.599276403 +0000
```

### 1.2 User Categories

Every file has three categories of users:

| Category | Symbol | Description |
|----------|--------|-------------|
| **Owner (User)** | `u` | The user who owns the file (by default, the user who created it) |
| **Group** | `g` | Users belonging to the file's group |
| **Others** | `o` | All other users on the system |
| **All** | `a` | All three categories combined |

*Table 2. User categories of permissions*

### 1.3 Permission Types

| Permission | Symbol | For Files | For Directories |
|-----------|--------|-----------|-----------------|
| **Read** | `r` (4) | View file contents | List directory contents (`ls`) |
| **Write** | `w` (2) | Modify file contents | Create/delete files in directory |
| **Execute** | `x` (1) | Run as program | Enter directory (`cd`) |

*Table 3. Meaning of permissions for files and directories*

```bash
$ ls -l myfile.txt
-rw-r--r-- 1 user1 group1 1024 Mar 21 10:00 myfile.txt
```

With read permission on a file you can read or copy it, and with execute permission you can run it as a shell script or executable. On a directory, the three permissions work together.

- With only **read** permission on a directory, `ls` shows the names inside, but options that check each file's information, such as `ls -l`, require execute permission.
- **Execute** permission on a directory is required to enter it with `cd`, to access the files inside, and to move or copy files into it.
- **Write** permission on a directory allows creating and deleting files in it. Actually creating and deleting also requires execute permission.

> **Caution:** Deleting or renaming a file requires write permission on the **directory that contains the file**, not on the file itself. Therefore, even a read-only (`r--r--r--`) file can be deleted if it is in a directory with write permission, and conversely, without write permission on the directory, the file cannot be deleted regardless of its own permissions.

---

<br>

## 2. Permission Representation

### 2.1 Symbolic Notation

```text
-  rwx  r-x  r--
│  └┬┘  └┬┘  └┬┘
│   │    │    └── Others: read only
│   │    └── Group: read + execute
│   └── Owner: read + write + execute
└── File type: regular file
```

*Figure 1. Structure of a symbolic permission string*

A permission string writes, after the first character for the file type, three characters each for the permissions of the owner, the group, and others. Each position holds `r`, `w`, or `x` if the permission is granted and `-` if not. For example, `rw-r--r--` means the owner can read and write, and the group and others can read.

### 2.2 Octal (Numeric) Notation

Writing 1 for a granted permission and 0 for a missing one turns a three-character permission into a 3-bit binary number, which converts to a single number from 0 to 7. For example, `r-x` is binary `101`, and $1 \times 2^2 + 0 \times 2^1 + 1 \times 2^0 = 4 + 0 + 1 = 5$. Writing the numbers of the owner, the group, and others in a row gives a three-digit octal number, so `rwxr-xr--` becomes `754`.

| Permission | Binary | Octal |
|-----------|--------|-------|
| `---` | 000 | 0 |
| `--x` | 001 | 1 |
| `-w-` | 010 | 2 |
| `-wx` | 011 | 3 |
| `r--` | 100 | 4 |
| `r-x` | 101 | 5 |
| `rw-` | 110 | 6 |
| `rwx` | 111 | 7 |

*Table 4. Permissions and their binary and octal values*

**Common Permission Values:**

| Octal | Symbolic | Typical Use |
|-------|----------|-------------|
| `755` | `rwxr-xr-x` | Executable files, directories |
| `644` | `rw-r--r--` | Regular files |
| `700` | `rwx------` | Private directories/scripts |
| `600` | `rw-------` | Private files (e.g., SSH keys) |
| `777` | `rwxrwxrwx` | Full access (AVOID in production) |
| `666` | `rw-rw-rw-` | Everyone can read and write |
| `555` | `r-xr-xr-x` | Everyone can only read and execute |
| `640` | `rw-r-----` | Owner can read and write, group can only read |
| `400` | `r--------` | Only the owner can read |
| `000` | `----------` | No access |

*Table 5. Common permission values and their uses*

---

<br>

## 3. Changing Permissions with chmod

The `chmod` command changes access permissions. It has a **symbolic mode**, which expresses permissions with letters and symbols, and a **numeric mode**, which uses numbers. Only the owner of a file or root can change its permissions.

### 3.1 Symbolic Mode

The form of symbolic mode is `chmod [user category][operator][permission] filename`. The user category is written as `u`, `g`, `o`, or `a` (Table 2), and the permission as `r`, `w`, or `x` (Table 3).

```bash
chmod u+x file.sh            # Add execute for owner
chmod g+rw file.txt           # Add read+write for group
chmod o-w file.txt            # Remove write for others
chmod a+r file.txt            # Add read for all
chmod u=rwx,g=rx,o=r file     # Set exact permissions
chmod u+x,g-w file            # Multiple changes
chmod -R 755 directory/       # Recursive permission change
```

**Operators:**
- `+` adds a permission.
- `-` removes a permission.
- `=` sets exactly the given permissions.

| Notation | Meaning |
|----------|---------|
| `u+w` | Grant (+) write (w) to the owner (u) |
| `u-x` | Remove (-) execute (x) from the owner (u) |
| `g+w` | Grant (+) write (w) to the group (g) |
| `o-r` | Remove (-) read (r) from others (o) |
| `g+wx` | Grant (+) write (w) and execute (x) to the group (g) |
| `+wx` | Grant (+) write (w) and execute (x) to all users, except permissions set in the umask |
| `a+rwx` | Grant (+) read (r), write (w), and execute (x) to all users |
| `u=rwx` | Set (=) the owner's (u) permissions to read (r), write (w), and execute (x) |
| `go+w` | Grant (+) write (w) to the group (g) and others (o) |
| `u+x,go+w` | Grant execute (x) to the owner (u) and grant (+) write (w) to the group (g) and others (o) |

*Table 6. Examples of setting permissions in symbolic mode*

For example, running `chmod u-w test.txt` on `test.txt` with permissions `rw-r--r--` removes the owner's write permission and gives `r--r--r--`.

> **Caution:** If the user category is omitted, as in `chmod +wx`, all users are targeted much as with `a`, but permissions set in the current umask (Section 5) are not changed. For example, with umask `022`, running `chmod +wx` on a file with permissions `rw-------` gives `rwx--x--x`, and write permission is not added for the group and others. To grant to all users for certain, write `a+wx`.

### 3.2 Octal Mode

The form of numeric mode is `chmod number filename`, where the number is three digits from 0 to 7 for the permissions of the owner, the group, and others.

```bash
chmod 755 script.sh           # rwxr-xr-x
chmod 644 document.txt        # rw-r--r--
chmod 700 private/            # rwx------
chmod 600 id_rsa              # rw-------
chmod -R 755 /var/www/html/   # Recursive
```

For example, running `chmod 444` on a file with permissions `644` (`rw-r--r--`) gives `r--r--r--`, and running `chmod 474` next gives `r--rwxr--`. Numeric mode sets the permissions of all three categories at once to the given value, so it is not affected by the umask.

---

<br>

## 4. Changing Ownership

### 4.1 chown: Change Owner

```bash
sudo chown newuser file.txt               # Change owner
sudo chown newuser:newgroup file.txt      # Change owner and group
sudo chown :newgroup file.txt             # Change group only
sudo chown -R newuser:newgroup directory/ # Recursive
```

### 4.2 chgrp: Change Group

```bash
sudo chgrp newgroup file.txt              # Change group
sudo chgrp -R newgroup directory/         # Recursive
```

> **Note:** Only root can give a file to another user, so `chown` usually needs `sudo`. On the other hand, the owner of a file can run `chgrp` without `sudo` to change its group to a group the owner belongs to.

### 4.3 Viewing Ownership

```bash
ls -l file.txt
# -rw-r--r-- 1 user1 group1 1024 Mar 21 10:00 file.txt
#               ^^^^^  ^^^^^^
#               owner  group

# Check your groups
groups
id
```

---

<br>

## 5. Default Permissions and umask

### 5.1 How umask Works

The **umask** (user file-creation mask) determines default permissions for new files and directories.

```text
Default file permission:      666 (rw-rw-rw-)
Default directory permission: 777 (rwxrwxrwx)

Actual permission = Default - umask
```

The maximum permissions requested when files and directories are created are `666` for regular files and `777` for directories. The mask value specifies the **permissions not to grant** when a file or directory is created. For example, the mask value `002` means that write permission is not granted to others. The actual permission is the requested permission with every bit that is 1 in the mask turned off, that is, requested AND (NOT mask).

| Requested bit | 1 | 1 | 0 | 0 |
|---------------|---|---|---|---|
| Mask bit | 1 | 0 | 1 | 0 |
| Granted bit | 0 | 1 | 0 | 0 |

*Table 7. Truth table for applying the umask*

```text
                 Regular file           Directory
Maximum          rw-rw-rw- (666)        rwxrwxrwx (777)
Binary           110 110 110            111 111 111
Mask (002)       000 000 010            000 000 010
Masked result    110 110 100            111 111 101
Granted          rw-rw-r-- (664)        rwxrwxr-x (775)
```

*Figure 2. Computing default permissions by applying the mask value 002*

> **Caution:** The "Default - umask" written in the text block above is digit-wise subtraction and is correct only when every bit of the mask is set in the default. For example, with umask `033`, 666 - 033 gives `633` for a regular file, but the execute bits absent from the default cannot be turned off, so the actual result is `644` (`rw-r--r--`), and a directory gets `744`. In general, compute with AND NOT.

### 5.2 Common umask Values

| umask | File Result | Directory Result | Meaning |
|-------|-------------|-----------------|---------|
| `022` | `644` (rw-r--r--) | `755` (rwxr-xr-x) | The group and others can only read (read and enter for directories). |
| `002` | `664` (rw-rw-r--) | `775` (rwxrwxr-x) | Only write permission for others is removed. |
| `077` | `600` (rw-------) | `700` (rwx------) | All access for the group and others is removed. |
| `027` | `640` (rw-r-----) | `750` (rwxr-x---) | The group can only read (read and enter for directories), and all access for others is removed. |
| `000` | `666` (rw-rw-rw-) | `777` (rwxrwxrwx) | The maximum permissions are granted as they are. |

*Table 8. Common umask values and the resulting permissions*

```bash
# View current umask
umask              # Octal format
umask -S           # Symbolic format

# Set umask
umask 022          # Standard for most systems
umask 077          # Restrictive (private files)

# Make permanent (add to ~/.bashrc)
echo "umask 022" >> ~/.bashrc
```

The form of the `umask` command is `umask [option] [mask value]`. Without arguments it prints four digits such as `0022` or `0002`, where the first digit is the mask for the special permissions of Section 6. The `-S` option prints the permissions that will be granted rather than the mask value, so with umask `002` it prints `u=rwx,g=rwx,o=rx`. For example, a file created with `touch` after running `umask 077` gets `rw-------`, giving no permission to the group or others. The umask applies only to files created afterwards and does not change the permissions of existing files.

---

<br>

## 6. Special Permissions

Special permissions are set by adding one more digit in front of the octal permission, making four digits (`4***` for SetUID, `2***` for SetGID, and `1***` for the sticky bit).

### 6.1 SetUID (SUID)

When set on an executable, the program runs with the **owner's privileges** instead of the caller's.

```bash
# Set SUID
chmod u+s program           # Symbolic
chmod 4755 program          # Octal (4 prefix)

# Example: passwd command
$ ls -l /usr/bin/passwd
-rwsr-xr-x 1 root root 68208 Mar 14 2022 /usr/bin/passwd
#   ^
#   s = SUID is set (runs as root)
```

`passwd` needs SetUID because passwords are stored in `/etc/shadow`, which only root can write. When a regular user runs `passwd`, SetUID applies the privileges of the owner, root, while it runs, so the user can change their own password. For example, running `chmod 4755 set.exe` on `set.exe` with permissions `rwxr-xr-x` makes `ls -l` show `-rwsr-xr-x`.

### 6.2 SetGID (SGID)

- **Files:** The program runs with the privileges of the file's group while it runs.
- **Directories:** Files newly created in the directory inherit the directory's group.

```bash
# Set SGID
chmod g+s directory/        # Symbolic
chmod 2755 directory/       # Octal (2 prefix)
```

For example, running `chmod 2755 set.exe` shows `s` in the group's execute position, giving `-rwxr-sr-x`.

### 6.3 Sticky Bit

When set on a directory, a file in that directory can be deleted or renamed only by the file's owner, the directory's owner, or root.

```bash
# Set sticky bit
chmod +t directory/         # Symbolic
chmod 1755 directory/       # Octal (1 prefix)

# Example: /tmp directory
$ ls -ld /tmp
drwxrwxrwt 15 root root 4096 Mar 21 10:00 /tmp
#         ^
#         t = sticky bit (only owner can delete their files)
```

Anyone can create files in a directory with permissions `777` such as `/tmp`, and without the sticky bit anyone could also delete other users' files. The sticky bit keeps creation allowed while restricting deletion to owners. For example, running `chmod 1755 temp` shows `t` in the execute position for others, giving `drwxr-xr-t`.

> **Note:** The `s` and `t` of special permissions are shown in the execute (`x`) position. If execute permission is also set in that position, they appear in lowercase (`s`, `t`); if not, in uppercase (`S`, `T`). For example, `chmod 4644 file` gives `-rwSr--r--`, and `chmod 1770 dir` gives `drwxrwx--T`.

### 6.4 Special Permission Summary

| Permission | Octal | Effect on Files | Effect on Directories |
|-----------|-------|-----------------|----------------------|
| SUID | 4000 | Run as file owner | (no effect) |
| SGID | 2000 | Run as file group | New files inherit group |
| Sticky | 1000 | (no effect) | Only the file owner, directory owner, or root can delete |

*Table 9. Effects of special permissions*

---

<br>

## 7. Best Practices

### 7.1 Security Guidelines

- Do not use `chmod 777` in production.
- Keep sensitive files at `600` (e.g., SSH private keys, config files with passwords).
- Use `755` for directories and `644` for regular files as defaults.
- Keep SUID/SGID programs to a minimum because they are potential security risks.
- Use groups to share access rather than granting broad permissions.

### 7.2 Common Security Checks

```bash
# Find all SUID files on the system
find / -perm -4000 -type f 2>/dev/null

# Find all SGID files
find / -perm -2000 -type f 2>/dev/null

# Find world-writable files
find / -perm -o+w -type f 2>/dev/null

# Find files with no owner
find / -nouser 2>/dev/null
```

`-perm -mode` in `find` matches files that have all the given permission bits set. `2>/dev/null` discards the `Permission denied` error messages from directories that cannot be accessed (error redirection in Week 6).

---

<br>

## Summary

| Concept | Key Summary |
|---------|-------------|
| File Attributes | `ls -l` prints the type, permissions, link count, owner, group, size, modification date, and name, and `stat` shows them in more detail. |
| Permission Types | There are three permissions, read (4), write (2), and execute (1), which on a directory mean listing, creating and deleting files, and entering. |
| User Categories | Permissions are set for the owner (u), group (g), and others (o), and all (a) refers to all three categories. |
| chmod | Permissions are changed in symbolic mode (`u+x`) or octal mode (`755`). |
| chown/chgrp | `chown` changes the file owner and group, and `chgrp` changes the group. |
| umask | The umask specifies permissions to remove from new files and directories, and with `022` files get `644` and directories `755`. |
| SUID (4000) | It makes an executable run with the owner's privileges (e.g., `passwd`). |
| SGID (2000) | It makes an executable run with the group's privileges, and in a directory it makes new files inherit the group. |
| Sticky Bit (1000) | In a directory, it allows only the file owner, directory owner, or root to delete files (e.g., `/tmp`). |

---

<br>

## Self-Check Questions

1. **umask calculation:** With umask `033`, write the permissions of a newly created regular file and directory in octal and symbolic form, and explain why digit-wise subtraction such as 666 - 033 is wrong.

   <details>
   <summary>Answer</summary>

   A regular file gets `644` (`rw-r--r--`) and a directory gets `744` (`rwxr--r--`). The mask `033` is binary `000 011 011`, which turns off the write and execute bits of the group and others. The maximum permission of a regular file, `666` (`110 110 110`), has no execute bits to begin with, so only the write bits are turned off, giving `110 100 100` = `644`. Digit-wise subtraction gives 6 - 3 = 3 and the wrong value `633`, because subtracting the absent execute bits wrongly turns off the read bits.

   </details>

2. **Directory permissions:** A directory `d3` has permissions `rw-r--r--` (644) and contains a file `f`. What happens when the owner runs `ls d3`, `ls -l d3`, and `cd d3`?

   <details>
   <summary>Answer</summary>

   `ls d3` prints the file name `f` because read permission is set. `ls -l d3` needs execute permission on the directory to access each file's information, so it shows a `Permission denied` error and displays the attributes of `f` as `?`. `cd d3` fails because execute permission is missing.

   </details>

3. **Tracing symbolic mode:** On a file with permissions `rw-r--r--`, you run `chmod g+wx`, `chmod o+x`, `chmod go-x`, `chmod a+x`, and `chmod u+w,g-w` in order. Write the permissions after each step and the final octal value.

   <details>
   <summary>Answer</summary>

   After `g+wx` it is `rw-rwxr--` (674), after `o+x` it is `rw-rwxr-x` (675), after `go-x` it is `rw-rw-r--` (664), after `a+x` it is `rwxrwxr-x` (775), and after `u+w,g-w` it is `rwxr-xr-x`. The owner already has write permission, so `u+w` changes nothing. The final value is `755`.

   </details>

4. **Deleting a read-only file:** In a directory `d` (permissions `755`) created by user `u1`, there is a file `d/f` with permissions `444`. Can `u1` delete this file? What if the permissions of `d` are `555`?

   <details>
   <summary>Answer</summary>

   Yes, it can be deleted. Deletion removes a directory entry, so it needs write and execute permission on the directory, not on the file. `rm` asks once whether to remove the write-protected file, and `rm -f` removes it without asking. If the permissions of `d` are `555`, there is no write permission on the directory, so the error `rm: cannot remove 'd/f': Permission denied` occurs.

   </details>

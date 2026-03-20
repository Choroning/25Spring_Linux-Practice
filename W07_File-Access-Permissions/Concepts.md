# Week 7 -- File Access Permissions

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Understanding File Permissions](#1-understanding-file-permissions)
2. [Permission Representation](#2-permission-representation)
3. [Changing Permissions with chmod](#3-changing-permissions-with-chmod)
4. [Changing Ownership](#4-changing-ownership)
5. [Default Permissions and umask](#5-default-permissions-and-umask)
6. [Special Permissions](#6-special-permissions)
7. [Best Practices](#7-best-practices)
8. [Summary](#summary)

---

## 1. Understanding File Permissions

### 1.1 User Categories

Every file has three categories of users:

| Category | Symbol | Description |
|----------|--------|-------------|
| **Owner (User)** | `u` | The user who created the file |
| **Group** | `g` | Users belonging to the file's group |
| **Others** | `o` | All other users on the system |
| **All** | `a` | All three categories combined |

### 1.2 Permission Types

| Permission | Symbol | For Files | For Directories |
|-----------|--------|-----------|-----------------|
| **Read** | `r` (4) | View file contents | List directory contents (`ls`) |
| **Write** | `w` (2) | Modify file contents | Create/delete files in directory |
| **Execute** | `x` (1) | Run as program | Enter directory (`cd`) |

```bash
$ ls -l myfile.txt
-rw-r--r-- 1 user1 group1 1024 Mar 21 10:00 myfile.txt
```

---

## 2. Permission Representation

### 2.1 Symbolic Notation

```
-  rwx  r-x  r--
│  └┬┘  └┬┘  └┬┘
│   │    │    └── Others: read only
│   │    └── Group: read + execute
│   └── Owner: read + write + execute
└── File type: regular file
```

### 2.2 Octal (Numeric) Notation

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

**Common Permission Values:**

| Octal | Symbolic | Typical Use |
|-------|----------|-------------|
| `755` | `rwxr-xr-x` | Executable files, directories |
| `644` | `rw-r--r--` | Regular files |
| `700` | `rwx------` | Private directories/scripts |
| `600` | `rw-------` | Private files (e.g., SSH keys) |
| `777` | `rwxrwxrwx` | Full access (AVOID in production) |
| `000` | `----------` | No access |

---

## 3. Changing Permissions with chmod

### 3.1 Symbolic Mode

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
- `+` : Add permission
- `-` : Remove permission
- `=` : Set exact permission

### 3.2 Octal Mode

```bash
chmod 755 script.sh           # rwxr-xr-x
chmod 644 document.txt        # rw-r--r--
chmod 700 private/            # rwx------
chmod 600 id_rsa              # rw-------
chmod -R 755 /var/www/html/   # Recursive
```

---

## 4. Changing Ownership

### 4.1 chown -- Change Owner

```bash
sudo chown newuser file.txt               # Change owner
sudo chown newuser:newgroup file.txt      # Change owner and group
sudo chown :newgroup file.txt             # Change group only
sudo chown -R newuser:newgroup directory/ # Recursive
```

### 4.2 chgrp -- Change Group

```bash
sudo chgrp newgroup file.txt              # Change group
sudo chgrp -R newgroup directory/         # Recursive
```

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

## 5. Default Permissions and umask

### 5.1 How umask Works

The **umask** (user file-creation mask) determines default permissions for new files and directories.

```
Default file permission:      666 (rw-rw-rw-)
Default directory permission: 777 (rwxrwxrwx)

Actual permission = Default - umask
```

### 5.2 Common umask Values

| umask | File Result | Directory Result |
|-------|-------------|-----------------|
| `022` | `644` (rw-r--r--) | `755` (rwxr-xr-x) |
| `002` | `664` (rw-rw-r--) | `775` (rwxrwxr-x) |
| `077` | `600` (rw-------) | `700` (rwx------) |
| `000` | `666` (rw-rw-rw-) | `777` (rwxrwxrwx) |

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

---

## 6. Special Permissions

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

### 6.2 SetGID (SGID)

- On **files:** Program runs with the group's privileges
- On **directories:** New files inherit the directory's group

```bash
# Set SGID
chmod g+s directory/        # Symbolic
chmod 2755 directory/       # Octal (2 prefix)
```

### 6.3 Sticky Bit

When set on a directory, only the file owner (or root) can delete files within it.

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

### 6.4 Special Permission Summary

| Permission | Octal | Effect on Files | Effect on Directories |
|-----------|-------|-----------------|----------------------|
| SUID | 4000 | Run as file owner | (no effect) |
| SGID | 2000 | Run as file group | New files inherit group |
| Sticky | 1000 | (no effect) | Only owner can delete |

---

## 7. Best Practices

### 7.1 Security Guidelines

- Never use `chmod 777` in production
- Keep sensitive files at `600` (e.g., SSH private keys, config files with passwords)
- Use `755` for directories, `644` for regular files as defaults
- Minimize SUID/SGID programs (potential security risks)
- Use groups to share access rather than granting broad permissions

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

---

## Summary

| Concept | Key Point |
|---------|-----------|
| Permission Types | Read (4), Write (2), Execute (1) |
| User Categories | Owner (u), Group (g), Others (o), All (a) |
| chmod | Change permissions (symbolic: `u+x`, octal: `755`) |
| chown/chgrp | Change file owner and group |
| umask | Default permission mask (`022` = files `644`, dirs `755`) |
| SUID (4000) | Execute file as owner (e.g., `passwd`) |
| SGID (2000) | Execute as group / inherit group in directories |
| Sticky Bit (1000) | Only owner can delete files in directory (e.g., `/tmp`) |

# Week 12 — User Management

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [User and Group Concepts](#1-user-and-group-concepts)
2. [User Account Files](#2-user-account-files)
3. [Managing Users](#3-managing-users)
4. [Managing Groups](#4-managing-groups)
5. [Password Management](#5-password-management)
6. [sudo Configuration](#6-sudo-configuration)
7. [Best Practices](#7-best-practices)
8. [Summary](#summary)

---

## 1. User and Group Concepts

### 1.1 User Types

| Type | UID Range | Description |
|------|-----------|-------------|
| **Root** | 0 | Superuser with full system access |
| **System Users** | 1-999 | Service accounts (daemon, www-data) |
| **Regular Users** | 1000+ | Normal human users |

### 1.2 Groups

- Every user belongs to at least one **primary group**
- Users can also belong to **supplementary groups**
- Groups control shared file access

---

## 2. User Account Files

### 2.1 /etc/passwd

```
username:x:UID:GID:comment:home_directory:login_shell
```

```bash
root:x:0:0:root:/root:/bin/bash
user1:x:1001:1001::/home/user1:/bin/bash
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
```

### 2.2 /etc/shadow

```
username:encrypted_password:lastchange:min:max:warn:inactive:expire:reserved
```

- Stores encrypted passwords (accessible only by root)
- Password aging information

### 2.3 /etc/group

```
groupname:x:GID:member_list
```

```bash
sudo:x:27:user1
developers:x:1002:user1,user2,user3
```

---

## 3. Managing Users

### 3.1 useradd — Create Users

```bash
sudo useradd username                        # Create user (minimal)
sudo useradd -m username                     # Create with home directory
sudo useradd -m -s /bin/bash username        # Specify shell
sudo useradd -m -G sudo,developers username  # Add to groups
sudo useradd -m -c "John Doe" -s /bin/bash -G sudo john
```

### 3.2 adduser — Interactive User Creation (Debian/Ubuntu)

```bash
sudo adduser username    # Interactive: prompts for password, name, etc.
```

### 3.3 usermod — Modify Users

```bash
sudo usermod -aG sudo username            # Add to supplementary group
sudo usermod -s /bin/zsh username          # Change shell
sudo usermod -d /new/home username         # Change home directory
sudo usermod -l newname oldname            # Rename user
sudo usermod -L username                   # Lock account
sudo usermod -U username                   # Unlock account
sudo usermod -e 2025-12-31 username        # Set expiry date
```

### 3.4 userdel — Delete Users

```bash
sudo userdel username                      # Delete user (keep home)
sudo userdel -r username                   # Delete user and home directory
```

---

## 4. Managing Groups

```bash
# Create group
sudo groupadd developers

# Delete group
sudo groupdel developers

# Modify group
sudo groupmod -n newname oldname           # Rename group

# Add user to group
sudo usermod -aG groupname username        # -a = append (important!)
sudo gpasswd -a username groupname         # Alternative

# Remove user from group
sudo gpasswd -d username groupname

# View group membership
groups username
id username
getent group groupname
```

> **Key Point:** Always use `-aG` (append + group) with `usermod`. Without `-a`, the user's supplementary groups will be replaced!

---

## 5. Password Management

### 5.1 Setting Passwords

```bash
sudo passwd username               # Set password for user
passwd                             # Change own password
sudo passwd -l username            # Lock account
sudo passwd -u username            # Unlock account
sudo passwd -d username            # Delete password (no password login)
sudo passwd -e username            # Force password change on next login
```

### 5.2 Password Aging

```bash
sudo chage -l username             # View password aging info
sudo chage -M 90 username          # Max days between changes
sudo chage -m 7 username           # Min days between changes
sudo chage -W 14 username          # Warning days before expiry
sudo chage -E 2025-12-31 username  # Account expiration date
```

---

## 6. sudo Configuration

### 6.1 /etc/sudoers

```bash
# Edit sudoers file safely
sudo visudo

# Allow user full sudo access
username ALL=(ALL:ALL) ALL

# Allow group sudo access
%developers ALL=(ALL:ALL) ALL

# Allow specific commands without password
username ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/systemctl
```

---

## 7. Best Practices

- Follow principle of least privilege
- Use groups for access management rather than individual permissions
- Set password aging policies
- Disable unused accounts (`usermod -L`)
- Audit user accounts regularly
- Use `nologin` shell for service accounts

---

## Summary

| Concept | Key Point |
|---------|-----------|
| `/etc/passwd` | User account info (username:UID:GID:home:shell) |
| `/etc/shadow` | Encrypted passwords and aging info |
| `/etc/group` | Group definitions and membership |
| `useradd`/`adduser` | Create new user accounts |
| `usermod` | Modify user properties (groups, shell, home) |
| `userdel` | Delete user accounts |
| `groupadd`/`groupdel` | Create/delete groups |
| `passwd` | Set and manage passwords |
| `chage` | Configure password aging policies |
| `sudo`/`visudo` | Privilege escalation configuration |

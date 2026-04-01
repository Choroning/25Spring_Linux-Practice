# Week 6 — Shell Usage

> **Last Updated:** 2026-04-01

> **Prerequisites**: Vi editor and command line basics (Week 1-5).
>
> **Learning Objectives**:
> 1. Customize the shell environment with variables and aliases
> 2. Apply I/O redirection and piping
> 3. Use command history and tab completion effectively

---

## Table of Contents

1. [What is a Shell?](#1-what-is-a-shell)
2. [Types of Shells](#2-types-of-shells)
3. [Shell Environment Variables](#3-shell-environment-variables)
4. [Shell Initialization Files](#4-shell-initialization-files)
5. [Aliases](#5-aliases)
6. [Command History](#6-command-history)
7. [Shell Metacharacters](#7-shell-metacharacters)
8. [Quoting Rules](#8-quoting-rules)
9. [Job Control](#9-job-control)
10. [Best Practices](#10-best-practices)
11. [Summary](#summary)

---

<br>

## 1. What is a Shell?

The **shell** is a command-line interpreter that acts as an interface between the user and the Linux kernel.

```
User Input --> Shell (interprets) --> Kernel (executes) --> Hardware
           <-- Shell (displays)  <-- Kernel (returns)  <--
```

### 1.1 Shell Responsibilities

- Read and parse user commands
- Expand wildcards, aliases, and variables
- Handle I/O redirection and pipes
- Manage background processes
- Execute external programs by forking child processes
- Provide scripting capabilities

---

<br>

## 2. Types of Shells

### 2.1 Common Shells

| Shell | Path | Description |
|-------|------|-------------|
| **bash** | `/bin/bash` | Bourne Again Shell; default on most Linux distributions |
| **sh** | `/bin/sh` | Bourne Shell; original Unix shell |
| **csh** | `/bin/csh` | C Shell; C-like syntax |
| **tcsh** | `/bin/tcsh` | Enhanced C Shell |
| **ksh** | `/bin/ksh` | Korn Shell; combines features of sh and csh |
| **zsh** | `/bin/zsh` | Z Shell; extended bash with many improvements |
| **fish** | `/usr/bin/fish` | Friendly Interactive Shell |

### 2.2 Checking and Changing Your Shell

```bash
# Check current shell
echo $SHELL

# List available shells
cat /etc/shells

# Change default shell
chsh -s /bin/zsh

# Temporarily switch shell
bash            # Start bash session
zsh             # Start zsh session
exit            # Return to previous shell
```

---

<br>

## 3. Shell Environment Variables

### 3.1 Common Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `HOME` | User's home directory | `/home/user1` |
| `PATH` | Command search path | `/usr/bin:/usr/local/bin` |
| `SHELL` | Current shell path | `/bin/bash` |
| `USER` | Current username | `user1` |
| `HOSTNAME` | System hostname | `myubuntu` |
| `PWD` | Current working directory | `/home/user1` |
| `OLDPWD` | Previous working directory | `/tmp` |
| `PS1` | Primary prompt string | `\u@\h:\w\$` |
| `PS2` | Secondary prompt (continuation) | `>` |
| `LANG` | System locale | `en_US.UTF-8` |
| `TERM` | Terminal type | `xterm-256color` |
| `EDITOR` | Default text editor | `/usr/bin/vim` |
| `HISTSIZE` | Number of commands in history | `1000` |
| `HISTFILE` | History file location | `~/.bash_history` |

### 3.2 Working with Variables

```bash
# Display a variable
echo $HOME
echo $PATH

# Set a local variable (current shell only)
MY_VAR="Hello World"
echo $MY_VAR

# Export as environment variable (available to child processes)
export MY_VAR="Hello World"

# Unset a variable
unset MY_VAR

# View all environment variables
env
printenv
export

# Modify PATH
export PATH=$PATH:/opt/myapp/bin
```

### 3.3 PS1 Prompt Customization

| Escape Code | Meaning |
|-------------|---------|
| `\u` | Username |
| `\h` | Hostname (short) |
| `\H` | Hostname (full) |
| `\w` | Current working directory (full) |
| `\W` | Current directory (basename) |
| `\d` | Date |
| `\t` | Time (24h) |
| `\$` | `$` for user, `#` for root |
| `\n` | Newline |

```bash
# Custom prompt examples
export PS1="\u@\h:\w\$ "         # user@host:/path$
export PS1="[\t] \u:\W\$ "      # [14:30:00] user:dir$
```

---

<br>

## 4. Shell Initialization Files

### 4.1 Bash Startup Files

| File | When Read | Scope |
|------|-----------|-------|
| `/etc/profile` | Login shell | System-wide |
| `/etc/bash.bashrc` | Every interactive shell | System-wide |
| `~/.profile` | Login shell | User-specific |
| `~/.bash_profile` | Login shell | User-specific |
| `~/.bashrc` | Every interactive shell | User-specific |
| `~/.bash_logout` | On logout | User-specific |

### 4.2 Loading Order (Login Shell)

```
/etc/profile
    └── /etc/bash.bashrc
    └── ~/.bash_profile (or ~/.profile)
            └── ~/.bashrc
```

```bash
# Reload configuration without logging out
source ~/.bashrc
# or
. ~/.bashrc
```

---

<br>

## 5. Aliases

### 5.1 Creating and Managing Aliases

```bash
# Create alias
alias ll='ls -la'
alias grep='grep --color=auto'
alias rm='rm -i'
alias ..='cd ..'
alias ...='cd ../..'

# View all aliases
alias

# Remove an alias
unalias ll

# Make aliases persistent (add to ~/.bashrc)
echo "alias ll='ls -la'" >> ~/.bashrc
```

### 5.2 Useful Aliases

```bash
alias la='ls -la'
alias lt='ls -lt'
alias mkdir='mkdir -pv'
alias ports='netstat -tulanp'
alias df='df -h'
alias du='du -sh'
alias free='free -m'
alias update='sudo apt update && sudo apt upgrade -y'
```

---

<br>

## 6. Command History

### 6.1 History Commands

```bash
history                 # Show command history
history 20              # Show last 20 commands
!n                      # Execute command number n
!!                      # Execute last command
!string                 # Execute last command starting with string
!?string                # Execute last command containing string
^old^new                # Replace old with new in last command

# History search
Ctrl+r                  # Reverse search (type to search)
Ctrl+s                  # Forward search
```

### 6.2 History Configuration

```bash
# In ~/.bashrc
export HISTSIZE=10000           # Commands in memory
export HISTFILESIZE=20000       # Commands in history file
export HISTCONTROL=ignoredups   # Ignore duplicate commands
export HISTTIMEFORMAT="%F %T "  # Add timestamps
```

---

<br>

## 7. Shell Metacharacters

### 7.1 Special Characters

| Character | Meaning |
|-----------|---------|
| `~` | Home directory |
| `#` | Comment |
| `$` | Variable expansion |
| `&` | Run command in background |
| `*` | Wildcard: any characters |
| `?` | Wildcard: single character |
| `;` | Command separator |
| `\|` | Pipe |
| `>` `>>` | Output redirection |
| `<` `<<` | Input redirection |
| `\` | Escape character |
| `` ` `` | Command substitution (backtick) |
| `$()` | Command substitution (preferred) |
| `()` | Subshell execution |
| `{}` | Brace expansion |
| `[]` | Character class in wildcards |

### 7.2 Command Execution Control

```bash
# Sequential execution
command1 ; command2              # Run both regardless of success

# Conditional execution
command1 && command2             # Run command2 only if command1 succeeds
command1 || command2             # Run command2 only if command1 fails

# Grouping commands
{ command1; command2; }          # Run in current shell
( command1; command2 )           # Run in subshell
```

---

<br>

## 8. Quoting Rules

### 8.1 Types of Quoting

| Quote | Type | Variable Expansion | Example |
|-------|------|-------------------|---------|
| `' '` | Single quotes | No | `echo '$HOME'` prints `$HOME` |
| `" "` | Double quotes | Yes | `echo "$HOME"` prints `/home/user1` |
| `` ` ` `` | Backticks | Command substitution | `` echo `date` `` prints current date |
| `$()` | Command substitution | Yes | `echo $(date)` prints current date |
| `\` | Escape | Escapes next character | `echo \$HOME` prints `$HOME` |

```bash
name="Linux"
echo 'Hello $name'      # Output: Hello $name
echo "Hello $name"      # Output: Hello Linux
echo "Today is $(date)" # Output: Today is Fri Mar 21 ...
echo "Files: $(ls)"     # Output: Files: file1 file2 ...
```

---

<br>

## 9. Job Control

### 9.1 Foreground and Background Jobs

```bash
# Run command in background
command &

# List jobs
jobs
jobs -l                         # With PID

# Bring background job to foreground
fg %1                           # Job number 1

# Send foreground job to background
Ctrl+Z                          # Suspend current job
bg %1                           # Resume job 1 in background

# Terminate a job
kill %1                         # Send SIGTERM to job 1
kill -9 %1                      # Send SIGKILL (force kill)
```

### 9.2 Process Priority

```bash
nice -n 10 command              # Run with lower priority
renice -n 5 -p PID              # Change priority of running process
```

---

<br>

## 10. Best Practices

### 10.1 Shell Efficiency

- Master `Tab` completion for speed
- Use `Ctrl+R` for history search instead of typing full commands
- Create aliases for frequently used commands
- Use command substitution `$()` instead of backticks for readability
- Use double quotes around variables to prevent word splitting

### 10.2 Security Considerations

- Never put passwords in environment variables that might be logged
- Be cautious with `PATH` modifications (avoid prepending `.` to PATH)
- Use `export -n` to un-export sensitive variables
- Review shell history for sensitive information

---

<br>

## Summary

| Concept | Key Point |
|---------|-----------|
| Shell | Command interpreter between user and kernel |
| Bash | Default shell on most Linux systems (`/bin/bash`) |
| Environment Variables | `$HOME`, `$PATH`, `$SHELL`, `$USER`, `$PS1` |
| Initialization Files | `/etc/profile`, `~/.bashrc`, `~/.profile` |
| Aliases | Shortcuts for commands (`alias ll='ls -la'`) |
| History | `history`, `!!`, `!n`, `Ctrl+R` for search |
| Metacharacters | `*`, `?`, `\|`, `>`, `>>`, `&`, `;`, `$` |
| Quoting | Single quotes (literal), double quotes (expand vars) |
| Job Control | `&` (background), `fg`/`bg`, `Ctrl+Z` (suspend) |

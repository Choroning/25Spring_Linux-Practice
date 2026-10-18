# Week 6 Solutions — Shell Usage

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 4

---

<br>

## Table of Contents

- [Exercise 1: Shell Role](#exercise-1-shell-role)
- [Exercise 2: Checking the Default Shell](#exercise-2-checking-the-default-shell)
- [Exercise 3: Environment Variables vs. Local Variables](#exercise-3-environment-variables-vs-local-variables)
- [Exercise 4: Shell Initialization Files](#exercise-4-shell-initialization-files)
- [Exercise 5: Alias Management](#exercise-5-alias-management)
- [Exercise 6: Quoting Rules](#exercise-6-quoting-rules)
- [Exercise 7: Command History](#exercise-7-command-history)
- [Exercise 8: Modifying PATH](#exercise-8-modifying-path)

---

<br>

## Exercise 1: Shell Role

**Problem:** Which of the following best describes the role of the shell in Linux?

- A. A program that manages hardware resources directly
- B. A command-line interpreter between the user and the kernel
- C. The Linux kernel itself
- D. A graphical desktop environment

### Solution

**Answer:** B. A command-line interpreter between the user and the kernel

**Explanation:** The shell acts as an intermediary between the user and the Linux kernel. It reads user commands, interprets them (expanding variables, wildcards, aliases, etc.), and passes them to the kernel for execution. The shell also displays results back to the user. It is not the kernel itself, nor does it directly manage hardware.

---

<br>

## Exercise 2: Checking the Default Shell

**Problem:** Which command shows the current user's default login shell?

- A. `echo $HOME`
- B. `echo $SHELL`
- C. `echo $PATH`
- D. `echo $USER`

### Solution

**Answer:** B. `echo $SHELL`

**Explanation:** The `$SHELL` environment variable stores the path to the user's default login shell (e.g., `/bin/bash`). `$HOME` shows the home directory, `$PATH` shows the command search path, and `$USER` shows the username. Note that `$SHELL` shows the default shell, which may differ from the currently active shell if the user switched manually. The shell currently running is shown by `echo $0`.

---

<br>

## Exercise 3: Environment Variables vs. Local Variables

**Problem:** What is the difference between `MY_VAR="hello"` and `export MY_VAR="hello"`?

- A. There is no difference; both create environment variables
- B. `export` makes the variable available to child processes; without `export`, it is local to the current shell
- C. `export` makes the variable read-only
- D. Without `export`, the variable is permanent; `export` makes it temporary

### Solution

**Answer:** B. `export` makes the variable available to child processes; without `export`, it is local to the current shell

**Explanation:** Without `export`, a variable is a local (shell) variable visible only within the current shell session. Using `export` promotes it to an environment variable, which is inherited by any child processes (scripts, subshells, programs launched from the shell). For example, a script executed from the shell can access exported variables but not local ones. In both cases the variable disappears when the shell exits, so D is wrong, and a read-only variable is made with `readonly`.

---

<br>

## Exercise 4: Shell Initialization Files

**Problem:** Which file is executed every time a new interactive bash shell session starts (including opening a new terminal window)?

- A. `~/.bash_profile`
- B. `~/.bash_logout`
- C. `~/.bashrc`
- D. `/etc/hostname`

### Solution

**Answer:** C. `~/.bashrc`

**Explanation:** `~/.bashrc` is sourced for every new interactive non-login shell, which includes opening a new terminal window in a desktop environment. `~/.bash_profile` (or `~/.profile`) is read only for login shells (e.g., SSH login, tty login). On Ubuntu, `~/.profile`, which login shells read, runs `~/.bashrc`, so the settings in `~/.bashrc` also apply to login shells. `~/.bash_logout` runs when a login shell exits. This is why aliases and custom settings are typically placed in `~/.bashrc`.

---

<br>

## Exercise 5: Alias Management

**Problem:** You created an alias `alias rm='rm -i'` in the current shell. After rebooting, the alias is gone. How do you make it permanent?

### Solution

**Answer:** Add the line `alias rm='rm -i'` to the `~/.bashrc` file, then run `source ~/.bashrc` (or open a new terminal) to apply it.

**Explanation:** Aliases created in the current shell are lost when the session ends. To make them persistent across sessions, they must be defined in a shell initialization file. `~/.bashrc` is the standard location because it is sourced for every new interactive shell. Ubuntu's default `~/.bashrc` reads `~/.bash_aliases` if it exists, so aliases can also be collected in that file. After editing `~/.bashrc`, running `source ~/.bashrc` applies the changes without requiring a logout.

---

<br>

## Exercise 6: Quoting Rules

**Problem:** Given `name="Linux"`, what is the output of each command?

```bash
echo 'Hello $name'
echo "Hello $name"
```

- A. `Hello Linux` / `Hello Linux`
- B. `Hello $name` / `Hello $name`
- C. `Hello $name` / `Hello Linux`
- D. `Hello Linux` / `Hello $name`

### Solution

**Answer:** C. `Hello $name` / `Hello Linux`

**Explanation:** Single quotes (`' '`) preserve the literal value of every character inside them, so `$name` is printed as-is. Double quotes (`" "`) allow variable expansion, so `$name` is replaced with its value `Linux`. This distinction is critical when writing shell scripts that need to control when variables are expanded.

---

<br>

## Exercise 7: Command History

**Problem:** Which command or shortcut lets you interactively search through your command history by typing a keyword?

- A. `history | grep keyword`
- B. `Ctrl + R`
- C. `!keyword`
- D. `Ctrl + Z`

### Solution

**Answer:** B. `Ctrl + R`

**Explanation:** `Ctrl + R` activates reverse incremental search in bash, where you type characters and the shell dynamically finds the most recent matching command from history. Option A works but is not interactive; it outputs matching lines without letting you select or edit. `!keyword` immediately executes the last command starting with `keyword` without preview. `Ctrl + Z` suspends the current foreground process.

---

<br>

## Exercise 8: Modifying PATH

**Problem:** You installed a custom application in `/opt/myapp/bin` and want its commands to be available from any directory. Write the command to add this directory to your `PATH`.

### Solution

**Answer:** `export PATH=$PATH:/opt/myapp/bin`

**Explanation:** This appends `/opt/myapp/bin` to the existing `PATH` variable. The shell searches directories listed in `PATH` (separated by colons) when looking for commands. By appending, existing commands remain accessible. To make this permanent, add the `export` line to `~/.bashrc`. Prepending (`PATH=/opt/myapp/bin:$PATH`) would give the custom directory priority over system directories, so a program in that directory with the same name as a system command such as `ls` would run instead, which can be a security risk.

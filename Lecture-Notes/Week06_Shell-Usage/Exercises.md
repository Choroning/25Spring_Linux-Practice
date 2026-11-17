# Week 6 Exercises — Shell Usage

[Repository Guide](../../README.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **Last Updated:** 2026-11-18
>
> 우분투 리눅스, 이종원, Ch 1, 4

---

<br>

## Exercise 1: Shell Role

**Problem:** Which of the following best describes the role of the shell in Linux?

- A. A program that manages hardware resources directly
- B. A command-line interpreter between the user and the kernel
- C. The Linux kernel itself
- D. A graphical desktop environment

**[Solution](Solutions.md#exercise-1-shell-role)**

---

<br>

## Exercise 2: Checking the Default Shell

**Problem:** Which command shows the current user's default login shell?

- A. `echo $HOME`
- B. `echo $SHELL`
- C. `echo $PATH`
- D. `echo $USER`

**[Solution](Solutions.md#exercise-2-checking-the-default-shell)**

---

<br>

## Exercise 3: Environment Variables vs. Local Variables

**Problem:** What is the difference between `MY_VAR="hello"` and `export MY_VAR="hello"`?

- A. There is no difference; both create environment variables
- B. `export` makes the variable available to child processes; without `export`, it is local to the current shell
- C. `export` makes the variable read-only
- D. Without `export`, the variable is permanent; `export` makes it temporary

**[Solution](Solutions.md#exercise-3-environment-variables-vs-local-variables)**

---

<br>

## Exercise 4: Shell Initialization Files

**Problem:** Which file is executed every time a new interactive bash shell session starts (including opening a new terminal window)?

- A. `~/.bash_profile`
- B. `~/.bash_logout`
- C. `~/.bashrc`
- D. `/etc/hostname`

**[Solution](Solutions.md#exercise-4-shell-initialization-files)**

---

<br>

## Exercise 5: Alias Management

**Problem:** You created an alias `alias rm='rm -i'` in the current shell. After rebooting, the alias is gone. How do you make it permanent?

**[Solution](Solutions.md#exercise-5-alias-management)**

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

**[Solution](Solutions.md#exercise-6-quoting-rules)**

---

<br>

## Exercise 7: Command History

**Problem:** Which command or shortcut lets you interactively search through your command history by typing a keyword?

- A. `history | grep keyword`
- B. `Ctrl + R`
- C. `!keyword`
- D. `Ctrl + Z`

**[Solution](Solutions.md#exercise-7-command-history)**

---

<br>

## Exercise 8: Modifying PATH

**Problem:** You installed a custom application in `/opt/myapp/bin` and want its commands to be available from any directory. Write the command to add this directory to your `PATH`.

**[Solution](Solutions.md#exercise-8-modifying-path)**

---

<br>

## Exercise 9: Terminal Prompt Symbols

**Problem:** What does the prompt symbol indicate about the user's privilege level?

- A. `$` indicates the root user, and `#` indicates a regular user.
- B. `$` indicates a regular user, and `#` indicates the root user.
- C. Both `$` and `#` indicate regular users.
- D. The prompt symbol has no relation to user privileges.

**[Solution](Solutions.md#exercise-9-terminal-prompt-symbols)**

---

<br>

## Exercise 10: Checking the Kernel Version

**Problem:** Which command correctly displays the currently running Linux kernel version?

- A. `kernel -v`
- B. `uname -r`
- C. `version --kernel`
- D. `cat /etc/kernel`

**[Solution](Solutions.md#exercise-10-checking-the-kernel-version)**

---

<br>

## Exercise 11: Command Line Shortcuts

**Problem:** You have typed a long command but need to discard it entirely and start over. With the cursor at the end of the line, which keyboard shortcut deletes everything from the cursor to the beginning of the line?

- A. `Ctrl + K`
- B. `Ctrl + U`
- C. `Ctrl + L`
- D. `Ctrl + C`

**[Solution](Solutions.md#exercise-11-command-line-shortcuts)**

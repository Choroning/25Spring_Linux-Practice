# Week 5 Solutions — Vi Editor

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 3

---

<br>

## Table of Contents

- [Exercise 1: Vi Operating Modes](#exercise-1-vi-operating-modes)
- [Exercise 2: Saving and Exiting Vi](#exercise-2-saving-and-exiting-vi)
- [Exercise 3: Deleting Lines](#exercise-3-deleting-lines)
- [Exercise 4: Search and Replace](#exercise-4-search-and-replace)
- [Exercise 5: Cursor Navigation](#exercise-5-cursor-navigation)
- [Exercise 6: Copy and Paste in Vi](#exercise-6-copy-and-paste-in-vi)
- [Exercise 7: Vi Environment Settings](#exercise-7-vi-environment-settings)
- [Exercise 8: Executing Shell Commands from Vi](#exercise-8-executing-shell-commands-from-vi)

---

<br>

## Exercise 1: Vi Operating Modes

**Problem:** Which key transitions from command mode to input mode by inserting text **before** the cursor?

- A. `a`
- B. `i`
- C. `o`
- D. `A`

### Solution

**Answer:** B. `i`

**Explanation:** `i` enters insert mode and places the cursor before the current character for insertion. `a` appends after the cursor. `o` opens a new line below the current line. `A` appends at the end of the current line. All four enter input mode, but they differ in where text entry begins.

---

<br>

## Exercise 2: Saving and Exiting Vi

**Problem:** You have made changes to a file in vi but want to quit **without saving** any changes. Which command is correct?

- A. `:wq`
- B. `:q`
- C. `:q!`
- D. `ZZ`

### Solution

**Answer:** C. `:q!`

**Explanation:** `:q!` forces vi to quit without saving any modifications. `:q` only works if no changes have been made. `:wq` saves changes and then quits. `ZZ` (in command mode) saves and quits, which is equivalent to `:wq`. The `!` in `:q!` overrides vi's safety check that prevents quitting with unsaved changes.

---

<br>

## Exercise 3: Deleting Lines

**Problem:** While in command mode, you want to delete the current line and the 4 lines below it (5 lines total). What command should you type?

- A. `d5`
- B. `5dd`
- C. `5dw`
- D. `dd5`

### Solution

**Answer:** B. `5dd`

**Explanation:** In vi, a number before a command repeats it that many times. `5dd` deletes 5 lines starting from the current line. `dw` deletes a word (not a line), so `5dw` would delete 5 words. The format `d5` is incomplete and would wait for a motion command. `dd5` deletes only the current line with `dd`, and the trailing `5` remains as the count for the next command. In vim, a count placed between the operator `d` and the second `d`, as in `d5d`, also deletes 5 lines, but the basic form of line deletion is `5dd`.

---

<br>

## Exercise 4: Search and Replace

**Problem:** Which command replaces **all** occurrences of `foo` with `bar` in the entire file, asking for confirmation before each replacement?

- A. `:s/foo/bar/g`
- B. `:%s/foo/bar/g`
- C. `:%s/foo/bar/gc`
- D. `:%s/foo/bar/`

### Solution

**Answer:** C. `:%s/foo/bar/gc`

**Explanation:** `%` means the entire file, `s` is the substitute command, `g` replaces all occurrences on each line (not just the first), and `c` adds a confirmation prompt before each replacement. Without `%`, the substitution only applies to the current line. Without `g`, only the first occurrence on each line is replaced. Without `c`, replacements happen silently.

---

<br>

## Exercise 5: Cursor Navigation

**Problem:** You are at the beginning of a large file and want to jump to line 50. Which of the following is **not** a valid way to do this?

- A. `50G` (in command mode)
- B. `:50` (in last-line mode)
- C. `50gg` (in command mode)
- D. `G50` (in command mode)

### Solution

**Answer:** D. `G50` (in command mode)

**Explanation:** `50G` jumps to line 50 using the `G` (go-to-line) command with a line number prefix. `:50` achieves the same in last-line mode. In vim, `50gg` also works since `gg` with a count goes to the specified line. However, `G50` is not valid. In vi, the number must precede the command, not follow it. `G` alone goes to the last line of the file, and the trailing `50` remains as the count for the next command.

---

<br>

## Exercise 6: Copy and Paste in Vi

**Problem:** Describe how to copy 3 lines starting from the current line and paste them below the current cursor position.

### Solution

**Answer:** Type `3yy` to yank (copy) 3 lines, then move the cursor to the desired location and press `p` to paste below the current line.

**Explanation:** `yy` (or `Y`) copies the current line into the default buffer. Prefixing with a number (`3yy`) copies that many lines. The `p` command pastes the buffer contents below the current line, while `P` pastes above. The yanked text remains in the buffer and can be pasted multiple times. In last-line mode, copying 3 lines from the current line with `:.,.+2y`, moving the cursor, and pasting with `:pu` gives the same result.

---

<br>

## Exercise 7: Vi Environment Settings

**Problem:** You want line numbers to be displayed every time you open vim, without having to type `:set nu` each session. How do you achieve this?

### Solution

**Answer:** Add `set number` to the `~/.vimrc` configuration file.

**Explanation:** The `~/.vimrc` file is vim's user-specific configuration file that is read every time vim starts. Any `:set` command can be placed here without the leading colon. For example, adding `set number` enables line numbers permanently, `set autoindent` enables auto-indentation, and `set tabstop=4` sets the tab width to 4 spaces.

---

<br>

## Exercise 8: Executing Shell Commands from Vi

**Problem:** You are editing a file in vi and need to check the current directory listing without exiting the editor. Which command allows this?

- A. `:ls`
- B. `:!ls`
- C. `:shell ls`
- D. `:run ls`

### Solution

**Answer:** B. `:!ls`

**Explanation:** The `:!command` syntax in vi executes an external shell command without leaving the editor. After the command runs and displays its output, pressing Enter returns to vi. This is useful for compiling code (`:!gcc program.c`), checking file listings, or running any shell command mid-edit. `:ls` in vim lists open buffers, not files on disk. `:shell` (`:sh`) starts a shell and takes no arguments, so `:shell ls` gives the error `E488: Trailing characters`. vim reads `:run` as an abbreviation of `:runtime`, so `:run ls` does not show a directory listing either.

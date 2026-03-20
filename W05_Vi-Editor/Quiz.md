# Week 5 — Quiz

> **Last Updated:** 2026-03-21

---

## Q1. Vi Operating Modes

**Question:** Which key transitions from command mode to input mode by inserting text **before** the cursor?

| Option | Key |
|--------|-----|
| A | `a` |
| B | `i` |
| C | `o` |
| D | `A` |

**Answer:** B. `i`

**Explanation:** `i` enters insert mode and places the cursor before the current character for insertion. `a` appends after the cursor. `o` opens a new line below the current line. `A` appends at the end of the current line. All four enter input mode, but they differ in where text entry begins.

---

## Q2. Saving and Exiting Vi

**Question:** You have made changes to a file in vi but want to quit **without saving** any changes. Which command is correct?

| Option | Command |
|--------|---------|
| A | `:wq` |
| B | `:q` |
| C | `:q!` |
| D | `ZZ` |

**Answer:** C. `:q!`

**Explanation:** `:q!` forces vi to quit without saving any modifications. `:q` only works if no changes have been made. `:wq` saves changes and then quits. `ZZ` (in command mode) saves and quits, which is equivalent to `:wq`. The `!` in `:q!` overrides vi's safety check that prevents quitting with unsaved changes.

---

## Q3. Deleting Lines

**Question:** While in command mode, you want to delete the current line and the 4 lines below it (5 lines total). What command should you type?

| Option | Command |
|--------|---------|
| A | `d5` |
| B | `5dd` |
| C | `5dw` |
| D | `d5d` |

**Answer:** B. `5dd`

**Explanation:** In vi, a number before a command repeats it that many times. `5dd` deletes 5 lines starting from the current line. `dw` deletes a word (not a line), so `5dw` would delete 5 words. The format `d5` is incomplete and would wait for a motion command. `d5d` is not valid vi syntax.

---

## Q4. Search and Replace

**Question:** Which command replaces **all** occurrences of `foo` with `bar` in the entire file, asking for confirmation before each replacement?

| Option | Command |
|--------|---------|
| A | `:s/foo/bar/g` |
| B | `:%s/foo/bar/g` |
| C | `:%s/foo/bar/gc` |
| D | `:%s/foo/bar/` |

**Answer:** C. `:%s/foo/bar/gc`

**Explanation:** `%` means the entire file, `s` is the substitute command, `g` replaces all occurrences on each line (not just the first), and `c` adds a confirmation prompt before each replacement. Without `%`, the substitution only applies to the current line. Without `g`, only the first occurrence on each line is replaced. Without `c`, replacements happen silently.

---

## Q5. Cursor Navigation

**Question:** You are at the beginning of a large file and want to jump to line 50. Which of the following is NOT a valid way to do this?

| Option | Command |
|--------|---------|
| A | `50G` (in command mode) |
| B | `:50` (in last-line mode) |
| C | `50gg` (in command mode) |
| D | `G50` (in command mode) |

**Answer:** D. `G50` (in command mode)

**Explanation:** `50G` jumps to line 50 using the `G` (go-to-line) command with a line number prefix. `:50` achieves the same in last-line mode. `50gg` also works since `gg` with a count goes to the specified line. However, `G50` is not valid — in vi, the number must precede the command, not follow it. `G` alone goes to the last line of the file.

---

## Q6. Copy and Paste in Vi

**Question:** Describe how to copy 3 lines starting from the current line and paste them below the current cursor position.

**Answer:** Type `3yy` to yank (copy) 3 lines, then move the cursor to the desired location and press `p` to paste below the current line.

**Explanation:** `yy` (or `Y`) copies the current line into the default buffer. Prefixing with a number (`3yy`) copies that many lines. The `p` command pastes the buffer contents below the current line, while `P` pastes above. The yanked text remains in the buffer and can be pasted multiple times.

---

## Q7. Vi Environment Settings

**Question:** You want line numbers to be displayed every time you open vim, without having to type `:set nu` each session. How do you achieve this?

**Answer:** Add `set number` to the `~/.vimrc` configuration file.

**Explanation:** The `~/.vimrc` file is vim's user-specific configuration file that is read every time vim starts. Any `:set` command can be placed here without the leading colon. For example, adding `set number` enables line numbers permanently, `set autoindent` enables auto-indentation, and `set tabstop=4` sets the tab width to 4 spaces.

---

## Q8. Executing Shell Commands from Vi

**Question:** You are editing a file in vi and need to check the current directory listing without exiting the editor. Which command allows this?

| Option | Command |
|--------|---------|
| A | `:ls` |
| B | `:!ls` |
| C | `:shell ls` |
| D | `:run ls` |

**Answer:** B. `:!ls`

**Explanation:** The `:!command` syntax in vi executes an external shell command without leaving the editor. After the command runs and displays its output, pressing Enter returns to vi. This is useful for compiling code (`:!gcc program.c`), checking file listings, or running any shell command mid-edit. `:ls` in vim lists open buffers, not files on disk.

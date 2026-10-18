# Week 5 Exercises — Vi Editor

[Repository Guide](../../README.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **Last Updated:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 3

---

<br>

## Exercise 1: Vi Operating Modes

**Problem:** Which key transitions from command mode to input mode by inserting text **before** the cursor?

- A. `a`
- B. `i`
- C. `o`
- D. `A`

**[Solution](Solutions.md#exercise-1-vi-operating-modes)**

---

<br>

## Exercise 2: Saving and Exiting Vi

**Problem:** You have made changes to a file in vi but want to quit **without saving** any changes. Which command is correct?

- A. `:wq`
- B. `:q`
- C. `:q!`
- D. `ZZ`

**[Solution](Solutions.md#exercise-2-saving-and-exiting-vi)**

---

<br>

## Exercise 3: Deleting Lines

**Problem:** While in command mode, you want to delete the current line and the 4 lines below it (5 lines total). What command should you type?

- A. `d5`
- B. `5dd`
- C. `5dw`
- D. `dd5`

**[Solution](Solutions.md#exercise-3-deleting-lines)**

---

<br>

## Exercise 4: Search and Replace

**Problem:** Which command replaces **all** occurrences of `foo` with `bar` in the entire file, asking for confirmation before each replacement?

- A. `:s/foo/bar/g`
- B. `:%s/foo/bar/g`
- C. `:%s/foo/bar/gc`
- D. `:%s/foo/bar/`

**[Solution](Solutions.md#exercise-4-search-and-replace)**

---

<br>

## Exercise 5: Cursor Navigation

**Problem:** You are at the beginning of a large file and want to jump to line 50. Which of the following is **not** a valid way to do this?

- A. `50G` (in command mode)
- B. `:50` (in last-line mode)
- C. `50gg` (in command mode)
- D. `G50` (in command mode)

**[Solution](Solutions.md#exercise-5-cursor-navigation)**

---

<br>

## Exercise 6: Copy and Paste in Vi

**Problem:** Describe how to copy 3 lines starting from the current line and paste them below the current cursor position.

**[Solution](Solutions.md#exercise-6-copy-and-paste-in-vi)**

---

<br>

## Exercise 7: Vi Environment Settings

**Problem:** You want line numbers to be displayed every time you open vim, without having to type `:set nu` each session. How do you achieve this?

**[Solution](Solutions.md#exercise-7-vi-environment-settings)**

---

<br>

## Exercise 8: Executing Shell Commands from Vi

**Problem:** You are editing a file in vi and need to check the current directory listing without exiting the editor. Which command allows this?

- A. `:ls`
- B. `:!ls`
- C. `:shell ls`
- D. `:run ls`

**[Solution](Solutions.md#exercise-8-executing-shell-commands-from-vi)**

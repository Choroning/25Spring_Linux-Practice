# Week 5 — Vi Editor

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Linux Text Editors](#1-linux-text-editors)
2. [Vi Operating Modes](#2-vi-operating-modes)
3. [Starting and Exiting Vi](#3-starting-and-exiting-vi)
4. [Cursor Movement](#4-cursor-movement)
5. [Editing Commands](#5-editing-commands)
6. [Copy, Cut, and Paste](#6-copy-cut-and-paste)
7. [Search and Replace](#7-search-and-replace)
8. [Vi Environment Settings](#8-vi-environment-settings)
9. [Best Practices](#9-best-practices)
10. [Summary](#summary)

---

## 1. Linux Text Editors

### 1.1 Types of Editors

| Category | Editors | Description |
|----------|---------|-------------|
| Line editors | `ed`, `ex`, `sed` | Edit one line at a time |
| Screen editors | `vi`, `emacs` | Full-screen editing (modal / modeless) |
| GUI editors | `gedit`, `kate` | Graphical interface editors |

### 1.2 Modal vs. Modeless Editors

| Feature | Modal (vi/vim) | Modeless (nano, notepad) |
|---------|---------------|-------------------------|
| Input Mode | Text entry | Text entry |
| Copy | `yy` (command mode) | `Ctrl+C` |
| Paste | `p` (command mode) | `Ctrl+V` |
| Save | `:wq` or `ZZ` | `Ctrl+S` |
| Mode Switch | `i`, `a`, `o`, `Esc` | Not applicable |

> **Key Point:** `vim` is an upgraded version of `vi` ("Vi IMproved"). They share the same core usage.

---

## 2. Vi Operating Modes

### 2.1 Three Modes

```
                    i, I, a, A, o, O
    +-------------+  ──────────────>  +-------------+
    | Command Mode|                   |  Input Mode  |
    | (Normal)    |  <──────────────  | (Insert)     |
    +------+------+      Esc          +-------------+
           │
      : / ?│         Enter
           v           │
    +------+------+    │
    | Last-Line   |────┘
    | Mode (Ex)   |
    +------+------+
           │
     :q :wq :q!
           v
    +-------------+
    |   Vi Exit   |
    +-------------+
```

- **Command Mode (Normal):** Interpret keystrokes as commands (cursor movement, delete, copy)
- **Input Mode (Insert):** Keystrokes are entered as text content
- **Last-Line Mode (Ex):** Enter commands after `:`, `/`, or `?` at the bottom of screen

---

## 3. Starting and Exiting Vi

### 3.1 Starting Vi

```bash
vi filename              # Open file (create if not exists)
vi                       # Open empty buffer
vi +10 filename          # Open file at line 10
vi +/pattern filename    # Open file at first occurrence of pattern
vi -R filename           # Open in read-only mode
vim filename             # Use vim (enhanced vi)
```

### 3.2 Saving and Exiting

| Mode | Command | Action |
|------|---------|--------|
| Last-line | `:q` | Quit (only if no changes) |
| Last-line | `:q!` | Quit without saving |
| Last-line | `:w` | Save |
| Last-line | `:w filename` | Save as different file |
| Last-line | `:wq` | Save and quit |
| Last-line | `:wq!` | Force save and quit |
| Command | `ZZ` | Save and quit (Shift+z, Shift+z) |

---

## 4. Cursor Movement

### 4.1 Basic Movement

| Key | Action |
|-----|--------|
| `h` | Move left one character |
| `j` | Move down one line |
| `k` | Move up one line |
| `l` | Move right one character |
| Arrow keys | Same as h/j/k/l |

### 4.2 Line Movement

| Key | Action |
|-----|--------|
| `0` or `^` | Move to beginning of line |
| `$` | Move to end of line |
| `-` | Move to beginning of previous line |
| `+` or `Enter` | Move to beginning of next line |

### 4.3 Word Movement

| Key | Action |
|-----|--------|
| `w` | Move to beginning of next word |
| `W` | Move to next word (space-delimited) |
| `e` | Move to end of current word |
| `E` | Move to end of word (space-delimited) |
| `b` | Move to beginning of previous word |
| `B` | Move to previous word (space-delimited) |

### 4.4 Screen Movement

| Key | Action |
|-----|--------|
| `Ctrl+f` | Forward one full page (Page Down) |
| `Ctrl+b` | Backward one full page (Page Up) |
| `Ctrl+d` | Forward half page |
| `Ctrl+u` | Backward half page |
| `Ctrl+e` | Scroll down one line |
| `Ctrl+y` | Scroll up one line |

### 4.5 Jump to Specific Locations

| Key | Action |
|-----|--------|
| `G` | Go to last line of file |
| `1G` or `gg` | Go to first line of file |
| `nG` | Go to line n (e.g., `20G`) |
| `:n` | Go to line n (last-line mode) |
| `:$` | Go to last line |
| `H` | Go to top of screen |
| `M` | Go to middle of screen |
| `L` | Go to bottom of screen |

---

## 5. Editing Commands

### 5.1 Entering Insert Mode

| Key | Action |
|-----|--------|
| `i` | Insert before cursor |
| `I` | Insert at beginning of line |
| `a` | Append after cursor |
| `A` | Append at end of line |
| `o` | Open new line below |
| `O` | Open new line above |

### 5.2 Deleting Text

| Key | Action |
|-----|--------|
| `x` | Delete character under cursor |
| `X` | Delete character before cursor |
| `dw` | Delete from cursor to end of word |
| `dd` | Delete entire line |
| `d$` or `D` | Delete from cursor to end of line |
| `d0` | Delete from cursor to beginning of line |
| `ndd` | Delete n lines (e.g., `5dd`) |
| `dG` | Delete from current line to end of file |
| `d1G` | Delete from current line to beginning of file |

### 5.3 Undo and Redo

| Key | Action |
|-----|--------|
| `u` | Undo last change |
| `U` | Undo all changes on current line |
| `Ctrl+r` | Redo (vim only) |
| `.` | Repeat last command |

### 5.4 Replacing Text

| Key | Action |
|-----|--------|
| `r` | Replace single character under cursor |
| `R` | Enter replace mode (overwrite) |
| `cw` | Change word (delete word + enter insert mode) |
| `cc` or `S` | Change entire line |
| `c$` or `C` | Change from cursor to end of line |
| `~` | Toggle case of character under cursor |
| `J` | Join current line with next line |

---

## 6. Copy, Cut, and Paste

### 6.1 Yank (Copy) and Put (Paste)

| Key | Action |
|-----|--------|
| `yy` or `Y` | Yank (copy) current line |
| `nyy` | Yank n lines (e.g., `5yy`) |
| `yw` | Yank word |
| `y$` | Yank from cursor to end of line |
| `p` | Put (paste) after cursor / below current line |
| `P` | Put (paste) before cursor / above current line |

### 6.2 Named Buffers (Registers)

```
"ayy        # Yank current line into register 'a'
"ap         # Paste from register 'a'
"bdd        # Delete (cut) current line into register 'b'
```

---

## 7. Search and Replace

### 7.1 Searching

| Command | Action |
|---------|--------|
| `/pattern` | Search forward for pattern |
| `?pattern` | Search backward for pattern |
| `n` | Repeat search in same direction |
| `N` | Repeat search in opposite direction |
| `*` | Search forward for word under cursor |
| `#` | Search backward for word under cursor |

### 7.2 Search and Replace (Substitution)

```vim
:s/old/new/              # Replace first occurrence on current line
:s/old/new/g             # Replace all occurrences on current line
:n,ms/old/new/g          # Replace all occurrences from line n to m
:%s/old/new/g            # Replace all occurrences in entire file
:%s/old/new/gc           # Replace all with confirmation
:1,$s/old/new/g          # Same as :%s/old/new/g
```

---

## 8. Vi Environment Settings

### 8.1 Set Commands

| Command | Action |
|---------|--------|
| `:set nu` or `:set number` | Show line numbers |
| `:set nonu` | Hide line numbers |
| `:set ai` | Auto-indent |
| `:set noai` | Disable auto-indent |
| `:set ic` | Ignore case in searches |
| `:set noic` | Case-sensitive searches |
| `:set ts=4` | Set tab stop to 4 spaces |
| `:set showmode` | Show current mode |
| `:set all` | Show all settings |
| `:set syntax=on` | Enable syntax highlighting |

### 8.2 Persistent Configuration (~/.vimrc)

```vim
" ~/.vimrc - Vim configuration file
set number              " Show line numbers
set autoindent          " Auto-indent new lines
set tabstop=4           " Tab width = 4 spaces
set shiftwidth=4        " Indent width = 4 spaces
set expandtab           " Convert tabs to spaces
set hlsearch            " Highlight search results
set ignorecase          " Case-insensitive search
set smartcase           " Case-sensitive if uppercase used
set showmatch           " Highlight matching brackets
syntax on               " Enable syntax highlighting
set encoding=utf-8      " UTF-8 encoding
```

### 8.3 Other Useful Commands

```vim
:!command                # Execute shell command without leaving vi
:r filename              # Read and insert file contents
:r !command              # Insert command output
:n                       # Go to next file (when editing multiple)
:prev                    # Go to previous file
:split filename          # Split window horizontally
:vsplit filename         # Split window vertically
Ctrl+w w                 # Switch between split windows
```

---

## 9. Best Practices

### 9.1 Productivity Tips

- Use `gg=G` to auto-indent entire file (in vim)
- Use `.` to repeat last command
- Use `ciw` to change inner word efficiently
- Use `visual mode` (`v`, `V`, `Ctrl+v`) for block selection in vim
- Master `hjkl` navigation instead of relying on arrow keys

### 9.2 Vi vs. Nano vs. Emacs

| Feature | Vi/Vim | Nano | Emacs |
|---------|--------|------|-------|
| Learning Curve | Steep | Easy | Steep |
| Available Everywhere | Yes | Usually | Usually |
| Extensibility | High (Vim) | Low | Very High |
| Modal Editing | Yes | No | No |
| Speed (experienced user) | Very Fast | Moderate | Fast |

### 9.3 Vim Practice Exercise

The lecture includes a vi practice exercise:
- Write and run a **C program** or **Python program** to print multiplication tables (1-9)
- Practice using `gcc` to compile C code and `python3` to run Python code

---

## Summary

| Concept | Key Point |
|---------|-----------|
| Vi Modes | Command mode (default), Input mode (`i/a/o`), Last-line mode (`:`) |
| Exit | `:q` (quit), `:wq` (save+quit), `:q!` (force quit), `ZZ` (save+quit) |
| Movement | `hjkl` (basic), `w/b/e` (word), `0/$` (line), `G/gg` (file) |
| Insert | `i` (before), `a` (after), `o` (new line below), `I/A/O` (variants) |
| Delete | `x` (char), `dw` (word), `dd` (line), `D` (to end) |
| Copy/Paste | `yy` (copy line), `p` (paste after), `P` (paste before) |
| Search | `/pattern` (forward), `?pattern` (backward), `n/N` (next/prev) |
| Replace | `:%s/old/new/g` (all), `:%s/old/new/gc` (with confirmation) |
| Settings | `:set nu` (line numbers), `~/.vimrc` (persistent config) |

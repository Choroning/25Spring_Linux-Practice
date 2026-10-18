# Week 15 Solutions — Linux Utilities

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19

---

<br>

## Table of Contents

- [Exercise 1: Counting Lines, Words, and Characters](#exercise-1-counting-lines-words-and-characters)
- [Exercise 2: Function of `wc -c`](#exercise-2-function-of-wc--c)
- [Exercise 3: Reverse Sort Option](#exercise-3-reverse-sort-option)
- [Exercise 4: Field Separator for Sort](#exercise-4-field-separator-for-sort)
- [Exercise 5: Numeric Sort Option](#exercise-5-numeric-sort-option)
- [Exercise 6: Default Filenames for `split`](#exercise-6-default-filenames-for-split)
- [Exercise 7: Unique-Only Lines with `uniq`](#exercise-7-unique-only-lines-with-uniq)
- [Exercise 8: Field Delimiter for `cut`](#exercise-8-field-delimiter-for-cut)
- [Exercise 9: Horizontal Paste](#exercise-9-horizontal-paste)
- [Exercise 10: Creating a File with `dd`](#exercise-10-creating-a-file-with-dd)

---

<br>

## Exercise 1: Counting Lines, Words, and Characters

**Problem:** What Linux command outputs the number of lines, words, and characters in a text file?

### Solution

**Answer:** `wc`

**Explanation:** The `wc` (word count) command displays the number of lines, words, and bytes (or characters) in a file. By default, `wc filename` outputs three values: line count, word count, and byte count. Specific counts can be obtained with `-l` (lines), `-w` (words), `-c` (bytes), or `-m` (characters).

---

<br>

## Exercise 2: Function of `wc -c`

**Problem:** What does the following command do?

```text
$ wc -c /etc/passwd
```

### Solution

**Answer:** It outputs the byte count of the `/etc/passwd` file.

**Explanation:** The `wc -c` option counts and displays the number of bytes in the specified file. The output is the byte count followed by the file name, as in `2237 /etc/passwd`. For text files using single-byte encodings (like ASCII), the byte count equals the character count. For multi-byte encodings (like UTF-8), use `wc -m` to get the actual character count instead.

---

<br>

## Exercise 3: Reverse Sort Option

**Problem:** What option is used with the `sort` command to sort in reverse order?

### Solution

**Answer:** `-r`

**Explanation:** The `sort -r` option reverses the default sort order, producing output in descending order. This can be combined with other options, such as `sort -rn` to sort numerically in descending order, or `sort -rk2` to sort by the second field in reverse order.

---

<br>

## Exercise 4: Field Separator for Sort

**Problem:** What option is used with the `sort` command to set the field delimiter to `:`?

### Solution

**Answer:** `-t:`

**Explanation:** The `sort -t:` option specifies `:` as the field separator. This is essential when sorting structured data like `/etc/passwd` where fields are colon-delimited. For example, `sort -t: -k3 -n /etc/passwd` sorts the passwd file numerically by the third field (UID). The delimiter is used only to divide key fields, so `-t` is meaningful only together with `-k`.

---

<br>

## Exercise 5: Numeric Sort Option

**Problem:** What option is used with the `sort` command to treat numeric fields as numbers?

### Solution

**Answer:** `-n`

**Explanation:** The `sort -n` option performs numeric sorting instead of lexicographic sorting. Without `-n`, the string "9" would sort after "10" (since '9' > '1' lexicographically). With `-n`, numbers are compared by their numeric value, so 9 correctly appears before 10.

---

<br>

## Exercise 6: Default Filenames for `split`

**Problem:** When the `split` command generates files, what is the name of the second file created?

### Solution

**Answer:** `xab`

**Explanation:** By default, `split` names output files using a prefix of `x` followed by alphabetic suffixes. The names run `xaa`, `xab`, `xac`, and so on, so the second file is `xab`. A custom prefix can be specified as the last argument to `split`, e.g., `split -l 100 input.txt output_` would produce `output_aa`, `output_ab`, etc.

---

<br>

## Exercise 7: Unique-Only Lines with `uniq`

**Problem:** What option is used with the `uniq` command to output only non-duplicated lines?

### Solution

**Answer:** `-u`

**Explanation:** The `uniq -u` option prints only lines that are not repeated in the input. Lines that appear more than once consecutively are suppressed entirely. Note that `uniq` only detects adjacent duplicates, so the input should typically be sorted first with `sort` to group identical lines together. For example, for `u.dat` in the Week 15 lecture, `sort u.dat | uniq -u` prints `aaaaa` and `ccc`. The `-d` option does the opposite, showing only duplicated lines.

---

<br>

## Exercise 8: Field Delimiter for `cut`

**Problem:** What option is used with the `cut` command to set the field delimiter to `:`?

### Solution

**Answer:** `-d :`

**Explanation:** The `cut -d :` option (or `cut -d:`) specifies `:` as the field delimiter. This is commonly used with the `-f` option to extract specific fields. For example, `cut -d: -f1,3 /etc/passwd` extracts the username (field 1) and UID (field 3) from the passwd file. Without `-d`, `cut` uses only the tab as the delimiter.

---

<br>

## Exercise 9: Horizontal Paste

**Problem:** What option is used with the `paste` command to merge files horizontally (serial mode)?

### Solution

**Answer:** `-s`

**Explanation:** The `paste -s` option serializes the input, merging all lines of each file into a single line separated by tabs (or a custom delimiter). Without `-s`, `paste` merges files line by line, so each file becomes one vertical column and the columns are placed side by side. For example, if a file contains three lines, `paste -s file` outputs all three values on one tab-separated line, and given two files it outputs two lines, one per file.

---

<br>

## Exercise 10: Creating a File with `dd`

**Problem:** Complete the `dd` command to create a 1 MB file.

### Solution

**Answer:** `dd if=/dev/zero bs=1M count=1 of=dd_test`

**Explanation:** The `dd` command copies data block by block. `if=/dev/zero` specifies the input source (an infinite stream of zero bytes), `bs=1M` sets the block size to 1 megabyte, `count=1` copies exactly one block, and `of=dd_test` specifies the output file. The result is a 1 MB file filled with null bytes. In GNU `dd`, `1M` is $2^{20}$ = 1048576 bytes; use `bs=1MB` if 1000000 bytes are needed. Changing the block size and count, as in `bs=1024 count=1024`, creates a file of the same size. `dd` is commonly used for disk imaging, creating swap files, and benchmarking I/O performance.

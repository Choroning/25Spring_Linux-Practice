# Week 15 — Quiz

> **Last Updated:** 2026-03-21

---

## Q1. Counting Lines, Words, and Characters

**Question:** What Linux command outputs the number of lines, words, and characters in a text file?

**Answer:** `wc`

**Explanation:** The `wc` (word count) command displays the number of lines, words, and bytes (or characters) in a file. By default, `wc filename` outputs three values: line count, word count, and byte count. Specific counts can be obtained with `-l` (lines), `-w` (words), `-c` (bytes), or `-m` (characters).

---

## Q2. Function of `wc -c`

**Question:** What does the following command do?
```bash
$ wc -c /etc/passwd
```

**Answer:** It outputs the byte count of the `/etc/passwd` file.

**Explanation:** The `wc -c` option counts and displays the number of bytes in the specified file. For text files using single-byte encodings (like ASCII), the byte count equals the character count. For multi-byte encodings (like UTF-8), use `wc -m` to get the actual character count instead.

---

## Q3. Reverse Sort Option

**Question:** What option is used with the `sort` command to sort in reverse order?

**Answer:** `-r`

**Explanation:** The `sort -r` option reverses the default sort order, producing output in descending order. This can be combined with other options, such as `sort -rn` to sort numerically in descending order, or `sort -rk2` to sort by the second field in reverse order.

---

## Q4. Field Separator for Sort

**Question:** What option is used with the `sort` command to set the field delimiter to `:`?

**Answer:** `-t:`

**Explanation:** The `sort -t:` option specifies `:` as the field separator. This is essential when sorting structured data like `/etc/passwd` where fields are colon-delimited. For example, `sort -t: -k3 -n /etc/passwd` sorts the passwd file numerically by the third field (UID).

---

## Q5. Numeric Sort Option

**Question:** What option is used with the `sort` command to treat numeric fields as numbers?

**Answer:** `-n`

**Explanation:** The `sort -n` option performs numeric sorting instead of lexicographic sorting. Without `-n`, the string "9" would sort after "10" (since '9' > '1' lexicographically). With `-n`, numbers are compared by their numeric value, so 9 correctly appears before 10.

---

## Q6. Default Filenames for `split`

**Question:** When the `split` command generates files, what is the name of the second file created?

**Answer:** `xab`

**Explanation:** By default, `split` names output files using a prefix of `x` followed by alphabetic suffixes: `xaa`, `xab`, `xac`, and so on. The second file is therefore `xab`. A custom prefix can be specified as the second argument to `split`, e.g., `split -l 100 input.txt output_` would produce `output_aa`, `output_ab`, etc.

---

## Q7. Unique-Only Lines with `uniq`

**Question:** What option is used with the `uniq` command to output only non-duplicated lines?

**Answer:** `-u`

**Explanation:** The `uniq -u` option prints only lines that are not repeated in the input. Lines that appear more than once consecutively are suppressed entirely. Note that `uniq` only detects adjacent duplicates, so the input should typically be sorted first with `sort` to group identical lines together. The `-d` option does the opposite, showing only duplicated lines.

---

## Q8. Field Delimiter for `cut`

**Question:** What option is used with the `cut` command to set the field delimiter to `:`?

**Answer:** `-d :`

**Explanation:** The `cut -d :` option (or `cut -d:`) specifies `:` as the field delimiter. This is commonly used with the `-f` option to extract specific fields. For example, `cut -d: -f1,3 /etc/passwd` extracts the username (field 1) and UID (field 3) from the passwd file.

---

## Q9. Horizontal Paste

**Question:** What option is used with the `paste` command to merge files horizontally (serial mode)?

**Answer:** `-s`

**Explanation:** The `paste -s` option serializes the input, merging all lines of each file into a single line separated by tabs (or a custom delimiter). Without `-s`, `paste` merges files line by line (vertically). For example, if a file contains three lines, `paste -s file` outputs all three values on one tab-separated line.

---

## Q10. Creating a File with `dd`

**Question:** Complete the `dd` command to create a 1 MB file.

**Answer:** `dd if=/dev/zero bs=1M count=1 of=dd_test`

**Explanation:** The `dd` command copies data block by block. `if=/dev/zero` specifies the input source (an infinite stream of zero bytes), `bs=1M` sets the block size to 1 megabyte, `count=1` copies exactly one block, and `of=dd_test` specifies the output file. The result is a 1 MB file filled with null bytes. `dd` is commonly used for disk imaging, creating swap files, and benchmarking I/O performance.

# Week 13 Solutions — Bash Shell Programming

[Repository Guide](../../README.md) | [English](Solutions.md) | [한국어](Solutions.ko.md)

> **Last Updated:** 2026-10-19

---

<br>

## Table of Contents

- [Exercise 1: Script Definition](#exercise-1-script-definition)
- [Exercise 2: Magic Number (Shebang)](#exercise-2-magic-number-shebang)
- [Exercise 3: Comments in Shell Scripts](#exercise-3-comments-in-shell-scripts)
- [Exercise 4: Variable Substitution with Default Value](#exercise-4-variable-substitution-with-default-value)
- [Exercise 5: String Pattern Removal](#exercise-5-string-pattern-removal)
- [Exercise 6: Counting Command-Line Arguments](#exercise-6-counting-command-line-arguments)
- [Exercise 7: Summing All Arguments](#exercise-7-summing-all-arguments)
- [Exercise 8: Debug Mode with `-x`](#exercise-8-debug-mode-with--x)
- [Exercise 9: File Existence Test](#exercise-9-file-existence-test)
- [Exercise 10: Multiplication Table with Brace Expansion](#exercise-10-multiplication-table-with-brace-expansion)
- [Exercise 11: Counting Script Files in a Directory](#exercise-11-counting-script-files-in-a-directory)

---

<br>

## Exercise 1: Script Definition

**Problem:** What is the term for a program that is executed by another program called an interpreter? Examples of interpreter programs include Python, Bash, and sh.

### Solution

**Answer:** Script

**Explanation:** A script is a program written in a scripting language that is interpreted and executed at runtime by an interpreter, rather than being compiled into machine code beforehand. Shell scripts are interpreted by shell programs like bash or sh, while Python scripts are interpreted by the Python interpreter.

---

<br>

## Exercise 2: Magic Number (Shebang)

**Problem:** What is the following line at the very beginning of a shell script file called?

```bash
#!/bin/bash
```

### Solution

**Answer:** Magic number (Shebang)

**Explanation:** The `#!` sequence at the beginning of a script is called the shebang (or magic number). It tells the kernel which interpreter to use when executing the script. The path following `#!` specifies the absolute path to the interpreter binary. For example, `#!/bin/bash` means the script should be executed using the Bash shell located at `/bin/bash`.

---

<br>

## Exercise 3: Comments in Shell Scripts

**Problem:** In shell scripts, comments start with (1), and everything from (1) to the end of the line is treated as a comment. What is (1)?

### Solution

**Answer:** `#`

**Explanation:** In bash and other shell scripting languages, a `#` character at the start of a word marks the beginning of a comment. Everything from `#` to the end of that line is ignored by the interpreter. The shebang (`#!`) on the first line is also a comment to the shell, but when the file is run directly, the kernel reads this line to choose the interpreter. A `#` inside quotes or in the middle of a word, as in `$#` and `${#var}`, does not start a comment.

---

<br>

## Exercise 4: Variable Substitution with Default Value

**Problem:** What is printed by the following shell script?

```bash
#!/bin/bash
a=red
echo ${a:-blue} ${b:=blue}
```

### Solution

**Answer:** `red blue`

**Explanation:** `${a:-blue}` returns the value of `a` if it is set and non-empty; otherwise it returns `blue`. Since `a=red`, the result is `red`. `${b:=blue}` assigns `blue` to `b` if `b` is unset or empty, then returns the value. Since `b` was not set, it gets assigned `blue` and outputs `blue`.

---

<br>

## Exercise 5: String Pattern Removal

**Problem:** What is printed by the following shell script?

```bash
#!/bin/bash
path="/usr/local/bin/tmskim/bin/file"
echo ${path##*/}
```

### Solution

**Answer:** `file`

**Explanation:** `${path##*/}` removes the longest part matching the pattern `*/` from the front of the variable. The `##` operator removes a prefix using the longest match. The pattern `*/` matches everything up to and including the last `/`, leaving only `file`. This is a common idiom to extract the filename from a full path, equivalent to `basename`. With a single `#`, `${path#*/}` removes only the shortest match, the first `/`, and prints `usr/local/bin/tmskim/bin/file`.

---

<br>

## Exercise 6: Counting Command-Line Arguments

**Problem:** What is printed when the following script is executed as `./a.sh 1 2 3 4 5 6`?

```bash
#!/bin/bash
echo $#
```

### Solution

**Answer:** `6`

**Explanation:** The special variable `$#` holds the number of positional parameters (command-line arguments) passed to the script. Since the script was invoked with six arguments (`1 2 3 4 5 6`), `$#` evaluates to `6`. The script name `$0` is not counted.

---

<br>

## Exercise 7: Summing All Arguments

**Problem:** The following script sums all command-line arguments when run as `./a.sh 1 2 3 4 5 6`. What should (1) be?

```bash
#!/bin/bash
sum=0
for i in (1)
do
  (( sum = sum + i ))
done
echo $sum
```

### Solution

**Answer:** `"$@"`

**Explanation:** `"$@"` expands to all positional parameters as separate words, preserving each argument as an individual token. In a `for` loop, this iterates over each argument one by one, so the script computes 1 + 2 + ... + 6 = 21 and prints `21`. `"$*"` would concatenate all arguments into a single string. The quotes around `$@` are important to handle arguments containing spaces correctly. When no argument contains spaces, as here, unquoted `$@` or `$*` gives the same result.

---

<br>

## Exercise 8: Debug Mode with `-x`

**Problem:** What is the role of `-x` in `#!/bin/bash -x`?

```bash
#!/bin/bash -x
i=0
while (( i<10 ))
do
  echo $i
  ((i++))
done
```

### Solution

**Answer:** It prints each command to the terminal before it is executed (debug, trace mode).

**Explanation:** The `-x` option enables xtrace (execution trace) mode in bash. When active, bash prints each command to standard error before executing it, prefixed with `+`. What is printed is not the source line but the command actually run with all variable expansions applied, which makes it invaluable for debugging scripts. Running this script as `./a.sh` shows trace lines and real output alternately, as in `+ i=0`, `+ ((  i<10  ))`, `+ echo 0`, `0`, `+ (( i++ ))`. Shebang options apply only when the file is run directly, so running it as `bash a.sh` produces no trace. In that case, run `bash -x a.sh`.

---

<br>

## Exercise 9: File Existence Test

**Problem:** The following script checks if the file given as a command-line argument exists. What should (1) be?

```bash
#!/bin/bash
if (1)
then
  echo "$1 exist"
else
  echo "$1 does not exist"
fi
```

Usage: `./a.sh /bin/lls`

### Solution

**Answer:** `[ -e "$1" ]` (or `[[ -e "$1" ]]`)

**Explanation:** The `-e` test operator checks whether a file exists, regardless of its type (regular file, directory, symlink, etc.). The `$1` refers to the first command-line argument. Using `"$1"` with quotes handles filenames containing spaces. Both `[ ]` (test) and `[[ ]]` (bash extended test) syntax are valid. Since `/bin/lls` does not exist, the usage example prints `/bin/lls does not exist`, and `./a.sh /bin/ls` prints `/bin/ls exist`.

---

<br>

## Exercise 10: Multiplication Table with Brace Expansion

**Problem:** The following script prints the multiplication table for the given argument. What should (1) be?

```bash
#!/bin/bash
for i in (1)
do
  printf "%2d x %2d = %2d " $1 $i $(($1 * $i))
  printf "\n"
done
```

Usage: `./a.sh 5` prints `5 x 1 = 5` through `5 x 9 = 45`.

### Solution

**Answer:** `{1..9}`

**Explanation:** Brace expansion `{1..9}` generates a sequence of integers from 1 to 9. In the `for` loop, `i` iterates through each value from 1 to 9, computing `$1 * $i` for each iteration. This is a bash-specific feature; POSIX sh uses `$(seq 1 9)` instead. `%2d` right-aligns an integer in two columns, so the first line of the actual output has spaces before the one-digit numbers, as in ` 5 x  1 =  5 `.

---

<br>

## Exercise 11: Counting Script Files in a Directory

**Problem:** Write a script `a.sh` that takes a directory as a command-line argument and outputs the number of script files (`.sh` files) in that directory.

```text
$ ./a.sh /tmp
6
```

### Solution

**Answer:**

```bash
#!/bin/bash
dir="$1"
if [ ! -d "$dir" ]; then
    echo "Usage: $0 <existing-directory>"
    exit 1
fi
count=$(find "$dir" -type f -name '*.sh' | wc -l)
echo $count
```

**Explanation:** The script validates that the argument is an existing directory using `[ ! -d "$dir" ]`, and otherwise prints the usage and ends with exit status 1. It then uses `find` to recursively search for regular files (`-type f`) matching the pattern `*.sh` in the specified directory. The pattern must be quoted as `'*.sh'` so that the shell passes it to `find` as is instead of expanding it first. The output is piped to `wc -l` to count the number of matching lines (files), and the result is printed. Since `find` also searches subdirectories, add `-maxdepth 1`, as in `find "$dir" -maxdepth 1 -type f -name '*.sh'`, to count only the files directly under the given directory.

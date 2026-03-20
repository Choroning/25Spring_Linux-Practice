# W13 — Quiz

> **Last Updated:** 2026-03-21

---

## Q1. Script Definition

**Question:** What is the term for a program that is executed by another program called an interpreter? Examples of interpreter programs include Python, Bash, and sh.

**Answer:** Script

**Explanation:** A script is a program written in a scripting language that is interpreted and executed at runtime by an interpreter, rather than being compiled into machine code beforehand. Shell scripts are interpreted by shell programs like bash or sh, while Python scripts are interpreted by the Python interpreter.

---

## Q2. Magic Number (Shebang)

**Question:** What is the following line at the very beginning of a shell script file called?
```bash
#!/bin/bash
```

**Answer:** Magic number (Shebang)

**Explanation:** The `#!` sequence at the beginning of a script is called the shebang (or magic number). It tells the kernel which interpreter to use when executing the script. The path following `#!` specifies the absolute path to the interpreter binary. For example, `#!/bin/bash` means the script should be executed using the Bash shell located at `/bin/bash`.

---

## Q3. Comments in Shell Scripts

**Question:** In shell scripts, comments start with (1), and everything from (1) to the end of the line is treated as a comment. What is (1)?

**Answer:** `#`

**Explanation:** In bash and other shell scripting languages, the `#` character marks the beginning of a comment. Everything from `#` to the end of that line is ignored by the interpreter. The only exception is the shebang (`#!`) on the first line, which is interpreted by the kernel, not the shell.

---

## Q4. Variable Substitution with Default Value

**Question:** What is printed by the following shell script?
```bash
#!/bin/bash
a=red
echo ${a:-blue} ${b:=blue}
```

**Answer:** `red blue`

**Explanation:** `${a:-blue}` returns the value of `a` if it is set and non-empty; otherwise returns `blue`. Since `a=red`, the result is `red`. `${b:=blue}` assigns `blue` to `b` if `b` is unset or empty, then returns the value. Since `b` was not set, it gets assigned `blue` and outputs `blue`.

---

## Q5. String Pattern Removal

**Question:** What is printed by the following shell script?
```bash
#!/bin/bash
path="/usr/local/bin/tmskim/bin/file"
echo ${path##*/}
```

**Answer:** `file`

**Explanation:** `${path##*/}` removes the longest matching prefix pattern `*/` from the variable. The `##` operator performs greedy (longest match) prefix removal. The pattern `*/` matches everything up to and including the last `/`, leaving only `file`. This is a common idiom to extract the filename from a full path, equivalent to `basename`.

---

## Q6. Counting Command-Line Arguments

**Question:** What is printed when the following script is executed as `./a.sh 1 2 3 4 5 6`?
```bash
#!/bin/bash
echo $#
```

**Answer:** `6`

**Explanation:** The special variable `$#` holds the number of positional parameters (command-line arguments) passed to the script. Since the script was invoked with six arguments (`1 2 3 4 5 6`), `$#` evaluates to `6`.

---

## Q7. Summing All Arguments

**Question:** The following script sums all command-line arguments when run as `./a.sh 1 2 3 4 5 6`. What should (1) be?
```bash
#!/bin/bash
sum=0
for i in (1)
do
  (( sum = sum + i ))
done
echo $sum
```

**Answer:** `"$@"`

**Explanation:** `"$@"` expands to all positional parameters as separate words, preserving each argument as an individual token. In a `for` loop, this iterates over each argument one by one. `"$*"` would concatenate all arguments into a single string. The quotes around `$@` are important to handle arguments containing spaces correctly.

---

## Q8. Debug Mode with `-x`

**Question:** What is the role of `-x` in `#!/bin/bash -x`?
```bash
#!/bin/bash -x
i=0
while (( i<10 ))
do
  echo $i
  ((i++))
done
```

**Answer:** It prints each line to the terminal before it is executed (debug/trace mode).

**Explanation:** The `-x` option enables xtrace (execution trace) mode in bash. When active, bash prints each command to stderr before executing it, prefixed with `+`. This is invaluable for debugging scripts, as it shows the exact commands being run with all variable expansions applied.

---

## Q9. File Existence Test

**Question:** The following script checks if the file given as a command-line argument exists. What should (1) be?
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

**Answer:** `[ -e "$1" ]` (or `[[ -e "$1" ]]`)

**Explanation:** The `-e` test operator checks whether a file exists, regardless of its type (regular file, directory, symlink, etc.). The `$1` refers to the first command-line argument. Using `"$1"` with quotes handles filenames containing spaces. Both `[ ]` (test) and `[[ ]]` (bash extended test) syntax are valid.

---

## Q10. Multiplication Table with Brace Expansion

**Question:** The following script prints the multiplication table for the given argument. What should (1) be?
```bash
#!/bin/bash
for i in (1)
do
  printf "%2d x %2d = %2d " $1 $i $(($1 * $i))
  printf "\n"
done
```
Usage: `./a.sh 5` prints `5 x 1 = 5` through `5 x 9 = 45`.

**Answer:** `{1..9}`

**Explanation:** Brace expansion `{1..9}` generates a sequence of integers from 1 to 9. In the `for` loop, `i` iterates through each value from 1 to 9, computing `$1 * $i` for each iteration. This is a bash-specific feature; POSIX sh uses `seq 1 9` or `$(seq 1 9)` instead.

---

## Q11. Counting Script Files in a Directory

**Question:** Write a script `a.sh` that takes a directory as a command-line argument and outputs the number of script files (`.sh` files) in that directory.
```
$ ./a.sh /tmp
6
```

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

**Explanation:** The script validates that the argument is an existing directory using `[ ! -d "$dir" ]`. It then uses `find` to recursively search for regular files (`-type f`) matching the pattern `*.sh` in the specified directory. The output is piped to `wc -l` to count the number of matching lines (files), and the result is printed.

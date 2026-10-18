# Week 13 Exercises — Bash Shell Programming

[Repository Guide](../../README.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **Last Updated:** 2026-10-19

---

<br>

## Exercise 1: Script Definition

**Problem:** What is the term for a program that is executed by another program called an interpreter? Examples of interpreter programs include Python, Bash, and sh.

**[Solution](Solutions.md#exercise-1-script-definition)**

---

<br>

## Exercise 2: Magic Number (Shebang)

**Problem:** What is the following line at the very beginning of a shell script file called?

```bash
#!/bin/bash
```

**[Solution](Solutions.md#exercise-2-magic-number-shebang)**

---

<br>

## Exercise 3: Comments in Shell Scripts

**Problem:** In shell scripts, comments start with (1), and everything from (1) to the end of the line is treated as a comment. What is (1)?

**[Solution](Solutions.md#exercise-3-comments-in-shell-scripts)**

---

<br>

## Exercise 4: Variable Substitution with Default Value

**Problem:** What is printed by the following shell script?

```bash
#!/bin/bash
a=red
echo ${a:-blue} ${b:=blue}
```

**[Solution](Solutions.md#exercise-4-variable-substitution-with-default-value)**

---

<br>

## Exercise 5: String Pattern Removal

**Problem:** What is printed by the following shell script?

```bash
#!/bin/bash
path="/usr/local/bin/tmskim/bin/file"
echo ${path##*/}
```

**[Solution](Solutions.md#exercise-5-string-pattern-removal)**

---

<br>

## Exercise 6: Counting Command-Line Arguments

**Problem:** What is printed when the following script is executed as `./a.sh 1 2 3 4 5 6`?

```bash
#!/bin/bash
echo $#
```

**[Solution](Solutions.md#exercise-6-counting-command-line-arguments)**

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

**[Solution](Solutions.md#exercise-7-summing-all-arguments)**

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

**[Solution](Solutions.md#exercise-8-debug-mode-with--x)**

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

**[Solution](Solutions.md#exercise-9-file-existence-test)**

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

**[Solution](Solutions.md#exercise-10-multiplication-table-with-brace-expansion)**

---

<br>

## Exercise 11: Counting Script Files in a Directory

**Problem:** Write a script `a.sh` that takes a directory as a command-line argument and outputs the number of script files (`.sh` files) in that directory.

```text
$ ./a.sh /tmp
6
```

**[Solution](Solutions.md#exercise-11-counting-script-files-in-a-directory)**

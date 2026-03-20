# W13 -- Bash Shell Programming

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Shell Script Basics](#1-shell-script-basics)
2. [Variables and Data Types](#2-variables-and-data-types)
3. [Input and Output](#3-input-and-output)
4. [Conditional Statements](#4-conditional-statements)
5. [Loops](#5-loops)
6. [Functions](#6-functions)
7. [String and File Operations](#7-string-and-file-operations)
8. [Advanced Features](#8-advanced-features)
9. [Best Practices](#9-best-practices)
10. [Summary](#summary)

---

## 1. Shell Script Basics

### 1.1 Creating a Script

```bash
#!/bin/bash
# My first script
echo "Hello Linux World."
pwd
```

### 1.2 Running a Script

```bash
chmod +x script.sh          # Make executable
./script.sh                  # Run with ./

bash script.sh               # Run with bash explicitly
source script.sh             # Run in current shell (affects environment)
. script.sh                  # Same as source
```

### 1.3 Shebang Line

```bash
#!/bin/bash                  # Use bash interpreter
#!/bin/sh                    # Use POSIX shell
#!/usr/bin/env bash          # Portable: find bash in PATH
#!/usr/bin/env python3       # Python script
```

---

## 2. Variables and Data Types

### 2.1 Variable Assignment

```bash
name="Linux"                 # No spaces around =
count=42
path="/home/user1"
readonly CONSTANT="fixed"    # Read-only variable
```

### 2.2 Variable Usage

```bash
echo $name                   # Simple expansion
echo ${name}                 # Explicit expansion
echo "Hello, $name"          # Inside double quotes
echo "Length: ${#name}"      # String length
```

### 2.3 Special Variables

| Variable | Description |
|----------|-------------|
| `$0` | Script name |
| `$1` to `$9` | Positional parameters |
| `$#` | Number of arguments |
| `$*` | All arguments as single string |
| `$@` | All arguments as separate strings |
| `$?` | Exit status of last command |
| `$$` | PID of current script |
| `$!` | PID of last background process |

### 2.4 Arithmetic

```bash
# Using (( ))
(( sum = 5 + 3 ))
(( count++ ))
echo $(( 10 * 5 ))          # Output: 50

# Using let
let "result = 5 + 3"

# Using expr (external command)
result=$(expr 5 + 3)

# Using bc for floating point
echo "scale=2; 10 / 3" | bc  # Output: 3.33
```

---

## 3. Input and Output

### 3.1 read -- User Input

```bash
read name                    # Read into variable
echo "Name: $name"

read -p "Enter name: " name # Prompt message
read -s password             # Silent input (passwords)
read -t 10 answer            # Timeout after 10 seconds
read -n 1 choice             # Read single character

# Read multiple variables
read first last
echo "First: $first, Last: $last"

# Read without variable (stored in $REPLY)
read -p "Input: "
echo "You entered: $REPLY"
```

### 3.2 echo and printf

```bash
echo "Hello World"
echo -n "No newline"         # Suppress newline
echo -e "Tab:\there"         # Enable escape sequences

printf "%-10s %5d\n" "Alice" 95
printf "Name: %s, Score: %d\n" "$name" "$score"
```

### 3.3 Here Document

```bash
cat << EOF
This is a here document.
Variables like $HOME are expanded.
Multiple lines are supported.
EOF

cat << 'EOF'
Variables like $HOME are NOT expanded.
EOF

cat -n << END
Line 1
Line 2
Line 3
END
```

---

## 4. Conditional Statements

### 4.1 if-then-else

```bash
if (( x < y )); then
    echo "$x is less than $y"
else
    echo "$y is less than or equal to $x"
fi
```

### 4.2 if-elif-else

```bash
if (( score >= 90 )); then
    echo "Grade: A"
elif (( score >= 80 )); then
    echo "Grade: B"
elif (( score >= 70 )); then
    echo "Grade: C"
else
    echo "Grade: F"
fi
```

### 4.3 Test Operators

**Numeric Comparisons (inside `(( ))` or with `-eq` etc.):**

| Operator | `(( ))` | `[ ]` / `[[ ]]` |
|----------|---------|------------------|
| Equal | `==` | `-eq` |
| Not equal | `!=` | `-ne` |
| Less than | `<` | `-lt` |
| Greater than | `>` | `-gt` |
| Less or equal | `<=` | `-le` |
| Greater or equal | `>=` | `-ge` |

**String Comparisons (inside `[[ ]]`):**

| Operator | Description |
|----------|-------------|
| `==` or `=` | Equal |
| `!=` | Not equal |
| `<` | Less than (alphabetical) |
| `>` | Greater than |
| `-z` | String is empty |
| `-n` | String is not empty |

**File Tests:**

| Operator | Description |
|----------|-------------|
| `-e file` | File exists |
| `-f file` | Regular file exists |
| `-d file` | Directory exists |
| `-r file` | File is readable |
| `-w file` | File is writable |
| `-x file` | File is executable |
| `-s file` | File is not empty |
| `-L file` | File is symbolic link |

### 4.4 case Statement

```bash
case $cmd in
    [0-9])
        date
        ;;
    cd|CD)
        echo "$HOME"
        ;;
    quit|exit)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Unknown command"
        ;;
esac
```

---

## 5. Loops

### 5.1 for Loop

```bash
# List-based
for num in 0 1 2 3 4; do
    echo "Number: $num"
done

# Range-based (bash)
for i in {1..10}; do
    echo "Count: $i"
done

# C-style
for (( i=0; i<10; i++ )); do
    echo "Index: $i"
done

# Over command output
for file in $(ls *.sh); do
    echo "Script: $file"
done

# Over command-line arguments
for arg in "$@"; do
    echo "Argument: $arg"
done
```

### 5.2 while Loop

```bash
count=1
sum=0
while (( count <= 10 )); do
    (( sum += count ))
    (( count++ ))
done
echo "Sum(1~10): $sum"
```

### 5.3 until Loop

```bash
# Wait for a user to log in
until who | grep -q "$person"; do
    sleep 5
done
echo "$person has logged in!"
```

### 5.4 select Menu

```bash
PS3="Choose an option (1-3): "
select cmd in pwd date quit; do
    case $cmd in
        pwd)  pwd ;;
        date) date ;;
        quit) break ;;
        *)    echo "Invalid option" ;;
    esac
done
```

### 5.5 Loop Control

```bash
# break -- exit loop entirely
# continue -- skip to next iteration

for name in alice bob charlie dave; do
    if [[ $name == "charlie" ]]; then
        continue        # Skip charlie
    fi
    echo "Hello, $name"
done
```

---

## 6. Functions

### 6.1 Defining Functions

```bash
function greet {
    echo "Hello, $1!"
}

# Alternative syntax
add() {
    local sum=$(( $1 + $2 ))
    echo $sum
}

# Call functions
greet "World"
result=$(add 5 3)
echo "Result: $result"
```

### 6.2 Return Values

```bash
function is_even {
    if (( $1 % 2 == 0 )); then
        return 0    # Success (true)
    else
        return 1    # Failure (false)
    fi
}

if is_even 4; then
    echo "4 is even"
fi
```

---

## 7. String and File Operations

### 7.1 String Operations

```bash
str="Hello World"
echo ${#str}              # Length: 11
echo ${str:0:5}           # Substring: Hello
echo ${str/World/Linux}   # Replace: Hello Linux
echo ${str^^}             # Uppercase: HELLO WORLD
echo ${str,,}             # Lowercase: hello world
```

### 7.2 File Type Testing

```bash
echo "Enter filename: "
read file

if [[ ! -e $file ]]; then
    echo "$file does not exist."
elif [[ -f $file ]]; then
    echo "$file is a regular file."
elif [[ -d $file ]]; then
    echo "$file is a directory."
else
    echo "$file is a special file."
fi
```

---

## 8. Advanced Features

### 8.1 Signal Trapping

```bash
trap 'echo "Line $LINENO: count=$count"' DEBUG
# DEBUG trap fires before every command

trap 'echo "Caught SIGINT"; exit 1' INT
# Catch Ctrl+C

trap 'cleanup_function' EXIT
# Run cleanup on script exit
```

### 8.2 Exit Status

```bash
#!/bin/bash
# Exit with specific code
command_that_might_fail
if [[ $? -ne 0 ]]; then
    echo "Command failed"
    exit 1
fi
exit 0
```

### 8.3 Comments and Self-printing Scripts

```bash
#!/bin/bash
# Regular comment

: '
This is a multi-line comment
using the colon builtin with
a here-string.
'

# Interesting trick: #!/bin/more makes a script print itself
# Interesting trick: #!/bin/rm makes a script delete itself
```

---

## 9. Best Practices

- Always use `#!/bin/bash` or `#!/usr/bin/env bash` as the shebang
- Quote variables: `"$variable"` to prevent word splitting
- Use `[[ ]]` instead of `[ ]` for string comparisons in bash
- Use `(( ))` for arithmetic comparisons
- Use `local` for function variables to avoid scope issues
- Use `set -euo pipefail` for strict error handling
- Add meaningful comments to complex logic
- Use `shellcheck` to lint your scripts

---

## Summary

| Concept | Key Point |
|---------|-----------|
| Shebang | `#!/bin/bash` -- specify interpreter |
| Variables | `name="value"`, `$name`, `${name}` |
| Positional Params | `$1`-`$9`, `$#`, `$*`, `$@`, `$?` |
| read | User input (`read -p "prompt" var`) |
| if/elif/else | Conditional branching with test operators |
| case | Pattern matching (`case $var in pattern) ... ;;`) |
| for | Iterate over lists, ranges, or C-style |
| while/until | Loop while condition true / until condition true |
| select | Interactive menu generation |
| Functions | `function name { }` with local variables and return |
| trap | Handle signals (`trap 'cmd' SIGNAL`) |

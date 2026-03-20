# Project: Custom Shell (minishell)
> **Author:** Cheolwon Park  
> **Date:** 2025-06-01

A minimal shell implementation written entirely in Bash. Demonstrates core shell concepts including command parsing, built-in commands, pipes, redirections, and quoting.

## Structure

```
Project_Custom-Shell/
├── minishell.sh    # Main shell entry point (REPL loop)
├── builtins.sh     # Built-in command implementations
├── parser.sh       # Command parsing (pipes, redirections, quoting)
└── README.md
```

## Usage

```bash
chmod +x *.sh
./minishell.sh
```

## Built-in Commands

| Command | Description | Example |
|---------|-------------|---------|
| `cd [dir]` | Change directory | `cd /tmp`, `cd ~`, `cd -` |
| `pwd` | Print working directory | `pwd` |
| `history [-c] [n]` | Show/clear command history | `history 10`, `history -c` |
| `export [VAR=val]` | Set/list environment variables | `export PATH=/usr/bin:$PATH` |
| `alias [name=cmd]` | Define/list command aliases | `alias ll='ls -la'` |
| `unalias [-a] name` | Remove aliases | `unalias ll`, `unalias -a` |
| `help` | Show help message | `help` |
| `exit` / `quit` | Exit the shell | `exit` |

## Features

- **Custom Prompt**: Displays `user@host:directory$` with color coding
- **Pipes**: `ls -la | grep ".sh" | wc -l`
- **Output Redirection**: `echo "hello" > file.txt`, `echo "world" >> file.txt`
- **Input Redirection**: `wc -l < file.txt`
- **Command History**: Persistent across sessions (`~/.minishell_history`)
- **Alias Support**: Define shorthand commands
- **Signal Handling**: Ctrl+C shows new prompt, Ctrl+D exits gracefully

## Design

The shell follows a classic REPL (Read-Eval-Print Loop) pattern:

1. **Read**: Display prompt and read user input with readline support
2. **Parse**: Tokenize input, expand aliases, detect pipes and redirections
3. **Evaluate**: Execute built-in commands directly or fork external commands
4. **Print**: Display command output to the terminal
5. **Loop**: Return to step 1

### Why Built-in Commands?

Some commands must be built into the shell because they modify the shell's own state:
- `cd` changes the shell's working directory
- `export` modifies the shell's environment variables
- `alias` adds to the shell's alias table

If these were external programs, they would run in a child process and their changes would not affect the parent shell.

## References

- Carnegie Mellon University, 15-213: Introduction to Computer Systems (Shell Lab)
- MIT, 6.033: Computer System Engineering
- Bash Reference Manual: https://www.gnu.org/software/bash/manual/
- Advanced Bash-Scripting Guide: https://tldp.org/LDP/abs/html/

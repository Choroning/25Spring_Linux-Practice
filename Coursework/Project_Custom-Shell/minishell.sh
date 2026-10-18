#!/bin/bash
# @file    minishell.sh
# @brief   Main entry point for the custom mini shell
# @author  Cheolwon Park
# @date    2025-06-10
#
# A minimal shell implementation in Bash that supports:
# - Custom prompt with username, hostname, and working directory
# - Command reading, parsing, and execution
# - Built-in commands (cd, pwd, history, export, alias)
# - Pipe and redirection support
# - Command history
#
# Usage: ./minishell.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source modules
source "$SCRIPT_DIR/builtins.sh"
source "$SCRIPT_DIR/parser.sh"

# Shell configuration
SHELL_NAME="minishell"
SHELL_VERSION="1.0.0"
HISTORY_FILE="$HOME/.minishell_history"
MAX_HISTORY=1000

# Terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Initialize shell
init_shell() {
    # Load history from file
    if [[ -f "$HISTORY_FILE" ]]; then
        while IFS= read -r line; do
            history -s "$line"
        done < "$HISTORY_FILE"
    fi

    # Set up signal handlers
    trap 'echo ""; display_prompt' INT       # Ctrl+C: new prompt
    trap '' TSTP                             # Ctrl+Z: ignore
    trap 'save_history; exit 0' EXIT         # Save history on exit

    # Display welcome message
    echo -e "${BOLD}${CYAN}"
    echo "  ====================================="
    echo "  Welcome to $SHELL_NAME v$SHELL_VERSION"
    echo "  Type 'help' for available commands"
    echo "  Type 'exit' or press Ctrl+D to quit"
    echo "  ====================================="
    echo -e "${RESET}"
}

# Generate the shell prompt
display_prompt() {
    local user
    user=$(whoami)
    local host
    host=$(hostname -s 2>/dev/null || hostname)
    local dir="${PWD/#$HOME/~}"

    # Color prompt: user@host:dir$
    echo -ne "${GREEN}${user}@${host}${RESET}:${BLUE}${dir}${RESET}\$ "
}

# Save command history to file
save_history() {
    history | tail -n "$MAX_HISTORY" | awk '{$1=""; print substr($0,2)}' > "$HISTORY_FILE" 2>/dev/null
}

# Execute a parsed command
execute_command() {
    local input="$1"

    # Skip empty input
    [[ -z "$input" ]] && return 0

    # Add to history
    history -s "$input"

    # Check for built-in commands first
    local first_word
    first_word=$(echo "$input" | awk '{print $1}')

    case "$first_word" in
        exit|quit)
            echo "Goodbye!"
            exit 0
            ;;
        cd)
            builtin_cd "$input"
            return $?
            ;;
        pwd)
            builtin_pwd
            return $?
            ;;
        history)
            builtin_history "$input"
            return $?
            ;;
        export)
            builtin_export "$input"
            return $?
            ;;
        alias)
            builtin_alias "$input"
            return $?
            ;;
        unalias)
            builtin_unalias "$input"
            return $?
            ;;
        help)
            builtin_help
            return $?
            ;;
    esac

    # Check for aliases
    local expanded
    expanded=$(expand_alias "$input")

    # Check for pipes
    if echo "$expanded" | grep -q '|'; then
        execute_pipeline "$expanded"
        return $?
    fi

    # Check for redirections
    if echo "$expanded" | grep -qE '[<>]'; then
        execute_with_redirection "$expanded"
        return $?
    fi

    # Execute external command
    eval "$expanded"
    local exit_code=$?

    if (( exit_code == 127 )); then
        echo -e "${RED}$SHELL_NAME: $first_word: command not found${RESET}"
    fi

    return $exit_code
}

# Main REPL (Read-Eval-Print Loop)
main() {
    init_shell

    while true; do
        display_prompt

        # Read user input (supports readline editing)
        if ! IFS= read -r -e input; then
            # EOF (Ctrl+D)
            echo ""
            echo "Goodbye!"
            break
        fi

        # Trim whitespace
        input=$(echo "$input" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

        # Execute the command
        execute_command "$input"
    done
}

# Run the shell
main

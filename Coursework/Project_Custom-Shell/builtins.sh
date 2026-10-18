#!/bin/bash
# @file    builtins.sh
# @brief   Built-in command implementations for the mini shell
# @author  Cheolwon Park
# @date    2025-06-10
#
# Implements shell built-in commands that cannot be external programs
# because they need to modify the shell's own state (e.g., cd changes
# the shell's working directory, export modifies environment variables).

# Associative array for aliases
declare -A SHELL_ALIASES

# Initialize default aliases
SHELL_ALIASES[ll]="ls -la"
SHELL_ALIASES[la]="ls -A"
SHELL_ALIASES[l]="ls -CF"

# Built-in: cd (change directory)
# Usage: cd [directory]
#   cd         -> go to $HOME
#   cd -       -> go to previous directory
#   cd ~       -> go to $HOME
#   cd ~/path  -> go to $HOME/path
builtin_cd() {
    local input="$1"
    local target

    # Extract the directory argument
    target=$(echo "$input" | awk '{print $2}')

    # Handle special cases
    if [[ -z "$target" || "$target" == "~" ]]; then
        target="$HOME"
    elif [[ "$target" == "-" ]]; then
        if [[ -n "$OLDPWD" ]]; then
            target="$OLDPWD"
            echo "$target"
        else
            echo "minishell: cd: OLDPWD not set"
            return 1
        fi
    elif [[ "$target" == ~* ]]; then
        target="${target/#\~/$HOME}"
    fi

    # Attempt to change directory
    if cd "$target" 2>/dev/null; then
        export OLDPWD
        return 0
    else
        echo "minishell: cd: $target: No such file or directory"
        return 1
    fi
}

# Built-in: pwd (print working directory)
builtin_pwd() {
    echo "$PWD"
    return 0
}

# Built-in: history
# Usage: history [n]     -> show last n entries
#        history -c      -> clear history
builtin_history() {
    local input="$1"
    local arg
    arg=$(echo "$input" | awk '{print $2}')

    case "$arg" in
        -c)
            history -c
            echo "History cleared."
            ;;
        "")
            history
            ;;
        *)
            if [[ "$arg" =~ ^[0-9]+$ ]]; then
                history "$arg"
            else
                echo "minishell: history: invalid option: $arg"
                echo "Usage: history [-c] [n]"
                return 1
            fi
            ;;
    esac
    return 0
}

# Built-in: export
# Usage: export VAR=value    -> set environment variable
#        export               -> list all exported variables
builtin_export() {
    local input="$1"
    local assignment
    assignment=$(echo "$input" | sed 's/^export[[:space:]]*//')

    if [[ -z "$assignment" || "$assignment" == "export" ]]; then
        # List all exported variables
        export -p | sort
    elif [[ "$assignment" == *=* ]]; then
        # Set the variable
        local var_name="${assignment%%=*}"
        local var_value="${assignment#*=}"

        # Remove surrounding quotes if present
        var_value=$(echo "$var_value" | sed "s/^['\"]//;s/['\"]$//")

        export "$var_name=$var_value"
        echo "Exported: $var_name=$var_value"
    else
        # Export existing variable
        export "$assignment" 2>/dev/null || echo "minishell: export: $assignment: not a valid identifier"
    fi
    return 0
}

# Built-in: alias
# Usage: alias name='command'    -> define alias
#        alias name               -> show specific alias
#        alias                    -> list all aliases
builtin_alias() {
    local input="$1"
    local arg
    arg=$(echo "$input" | sed 's/^alias[[:space:]]*//')

    if [[ -z "$arg" || "$arg" == "alias" ]]; then
        # List all aliases
        if [[ ${#SHELL_ALIASES[@]} -eq 0 ]]; then
            echo "No aliases defined."
        else
            for key in "${!SHELL_ALIASES[@]}"; do
                echo "alias $key='${SHELL_ALIASES[$key]}'"
            done | sort
        fi
    elif [[ "$arg" == *=* ]]; then
        # Define new alias
        local name="${arg%%=*}"
        local value="${arg#*=}"
        # Remove surrounding quotes
        value=$(echo "$value" | sed "s/^['\"]//;s/['\"]$//")
        SHELL_ALIASES[$name]="$value"
        echo "Alias set: $name='$value'"
    else
        # Show specific alias
        if [[ -n "${SHELL_ALIASES[$arg]}" ]]; then
            echo "alias $arg='${SHELL_ALIASES[$arg]}'"
        else
            echo "minishell: alias: $arg: not found"
            return 1
        fi
    fi
    return 0
}

# Built-in: unalias
# Usage: unalias name    -> remove alias
#        unalias -a      -> remove all aliases
builtin_unalias() {
    local input="$1"
    local arg
    arg=$(echo "$input" | awk '{print $2}')

    if [[ "$arg" == "-a" ]]; then
        SHELL_ALIASES=()
        echo "All aliases removed."
    elif [[ -n "$arg" ]]; then
        if [[ -n "${SHELL_ALIASES[$arg]}" ]]; then
            unset "SHELL_ALIASES[$arg]"
            echo "Alias '$arg' removed."
        else
            echo "minishell: unalias: $arg: not found"
            return 1
        fi
    else
        echo "Usage: unalias [-a] name"
        return 1
    fi
    return 0
}

# Expand alias in a command string
expand_alias() {
    local input="$1"
    local first_word
    first_word=$(echo "$input" | awk '{print $1}')

    if [[ -n "${SHELL_ALIASES[$first_word]}" ]]; then
        local rest
        rest=$(echo "$input" | sed "s/^$first_word[[:space:]]*//" )
        echo "${SHELL_ALIASES[$first_word]} $rest"
    else
        echo "$input"
    fi
}

# Built-in: help
builtin_help() {
    echo ""
    echo "minishell - Built-in Commands"
    echo "=============================="
    echo ""
    echo "  cd [dir]           Change working directory"
    echo "  pwd                Print working directory"
    echo "  history [-c] [n]   Show/clear command history"
    echo "  export [VAR=val]   Set/list environment variables"
    echo "  alias [name=cmd]   Set/list command aliases"
    echo "  unalias [-a] name  Remove command aliases"
    echo "  help               Show this help message"
    echo "  exit / quit        Exit the shell"
    echo ""
    echo "Features:"
    echo "  - Pipe support:        cmd1 | cmd2 | cmd3"
    echo "  - Output redirection:  cmd > file, cmd >> file"
    echo "  - Input redirection:   cmd < file"
    echo "  - Command history:     Up/Down arrow keys"
    echo ""
    return 0
}

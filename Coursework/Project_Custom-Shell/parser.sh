#!/bin/bash
# @file    parser.sh
# @brief   Command parser for the mini shell (pipes, redirections, quoting)
# @author  Cheolwon Park
# @date    2025-06-10
#
# Handles parsing and execution of complex command lines including:
# - Pipes: cmd1 | cmd2 | cmd3
# - Output redirection: cmd > file, cmd >> file
# - Input redirection: cmd < file
# - Combined: cmd < input | cmd2 > output
# - Quoting: handles single and double quotes

# Execute a pipeline of commands
# Splits the command line by '|' and executes each part in sequence
execute_pipeline() {
    local input="$1"

    # Use eval to let bash handle the pipe natively
    # This preserves proper pipe semantics including signal handling
    eval "$input"
    return $?
}

# Execute a command with I/O redirection
# Supports: >, >>, <, 2>, 2>&1
execute_with_redirection() {
    local input="$1"

    # Let bash handle redirections via eval
    # This handles all redirection cases including:
    #   cmd > file      (stdout to file, truncate)
    #   cmd >> file     (stdout to file, append)
    #   cmd < file      (stdin from file)
    #   cmd 2> file     (stderr to file)
    #   cmd 2>&1        (stderr to stdout)
    #   cmd &> file     (both stdout and stderr to file)

    eval "$input"
    return $?
}

# Parse and validate a command line
# Returns 0 if valid, 1 if syntax error detected
validate_syntax() {
    local input="$1"

    # Check for unmatched quotes
    local single_quotes double_quotes
    single_quotes=$(echo "$input" | tr -cd "'" | wc -c)
    double_quotes=$(echo "$input" | tr -cd '"' | wc -c)

    if (( single_quotes % 2 != 0 )); then
        echo "minishell: syntax error: unmatched single quote"
        return 1
    fi

    if (( double_quotes % 2 != 0 )); then
        echo "minishell: syntax error: unmatched double quote"
        return 1
    fi

    # Check for empty pipe segments: "cmd | | cmd"
    if echo "$input" | grep -qE '\|\s*\|'; then
        echo "minishell: syntax error near unexpected token '|'"
        return 1
    fi

    # Check for trailing pipe: "cmd |"
    if echo "$input" | grep -qE '\|\s*$'; then
        echo "minishell: syntax error: unexpected end of input after '|'"
        return 1
    fi

    # Check for leading pipe: "| cmd"
    if echo "$input" | grep -qE '^\s*\|'; then
        echo "minishell: syntax error near unexpected token '|'"
        return 1
    fi

    # Check for redirection without target: "cmd >"
    if echo "$input" | grep -qE '>[>]?\s*$'; then
        echo "minishell: syntax error: expected filename after redirection"
        return 1
    fi

    return 0
}

# Tokenize a command string into an array
# Respects quoted strings as single tokens
tokenize() {
    local input="$1"
    local -a tokens=()
    local current=""
    local in_single_quote=0
    local in_double_quote=0
    local i

    for (( i=0; i<${#input}; i++ )); do
        local char="${input:$i:1}"

        if (( in_single_quote )); then
            if [[ "$char" == "'" ]]; then
                in_single_quote=0
            else
                current+="$char"
            fi
        elif (( in_double_quote )); then
            if [[ "$char" == '"' ]]; then
                in_double_quote=0
            else
                current+="$char"
            fi
        else
            case "$char" in
                "'")
                    in_single_quote=1
                    ;;
                '"')
                    in_double_quote=1
                    ;;
                ' '|$'\t')
                    if [[ -n "$current" ]]; then
                        tokens+=("$current")
                        current=""
                    fi
                    ;;
                *)
                    current+="$char"
                    ;;
            esac
        fi
    done

    # Add the last token
    if [[ -n "$current" ]]; then
        tokens+=("$current")
    fi

    # Output tokens one per line
    printf '%s\n' "${tokens[@]}"
}

# Split a command line by a delimiter (e.g., '|')
# Respects quoted strings
split_by_delimiter() {
    local input="$1"
    local delimiter="$2"
    local -a segments=()
    local current=""
    local in_single_quote=0
    local in_double_quote=0
    local i

    for (( i=0; i<${#input}; i++ )); do
        local char="${input:$i:1}"

        if (( in_single_quote )); then
            current+="$char"
            [[ "$char" == "'" ]] && in_single_quote=0
        elif (( in_double_quote )); then
            current+="$char"
            [[ "$char" == '"' ]] && in_double_quote=0
        elif [[ "$char" == "$delimiter" ]]; then
            segments+=("$current")
            current=""
        else
            [[ "$char" == "'" ]] && in_single_quote=1
            [[ "$char" == '"' ]] && in_double_quote=1
            current+="$char"
        fi
    done

    if [[ -n "$current" ]]; then
        segments+=("$current")
    fi

    printf '%s\n' "${segments[@]}"
}

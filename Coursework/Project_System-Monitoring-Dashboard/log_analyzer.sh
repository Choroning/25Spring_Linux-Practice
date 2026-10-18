#!/bin/bash
# @file    log_analyzer.sh
# @brief   System log analyzer for identifying issues and patterns
# @author  Cheolwon Park
# @date    2025-06-10
#
# Analyzes system logs to find errors, warnings, and anomalies.
# Supports syslog, auth.log, and journalctl output.
#
# Usage: ./log_analyzer.sh [log_file] [num_lines]

LOG_FILE="${1:-/var/log/syslog}"
NUM_LINES="${2:-1000}"

# Terminal colors
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

draw_line() {
    printf '%60s\n' '' | tr ' ' '-'
}

echo -e "${BOLD}=== System Log Analyzer ===${RESET}"
echo "Log file: $LOG_FILE"
echo "Analyzing last $NUM_LINES lines"
draw_line

# Check if log file exists or use journalctl
if [[ -f "$LOG_FILE" ]] && [[ -r "$LOG_FILE" ]]; then
    LOG_DATA=$(tail -n "$NUM_LINES" "$LOG_FILE")
elif command -v journalctl &>/dev/null; then
    echo "Log file not accessible. Using journalctl instead."
    LOG_DATA=$(journalctl --no-pager -n "$NUM_LINES" 2>/dev/null)
else
    echo "Error: Cannot access '$LOG_FILE' and journalctl is not available."
    echo "Try running with sudo or specify a readable log file."
    exit 1
fi

# Count error levels
echo ""
echo -e "${BOLD}--- Message Severity Summary ---${RESET}"
error_count=$(echo "$LOG_DATA" | grep -ic 'error\|fail\|critical\|fatal' || echo 0)
warn_count=$(echo "$LOG_DATA" | grep -ic 'warn' || echo 0)
info_count=$(echo "$LOG_DATA" | grep -ic 'info\|notice' || echo 0)

echo -e "  ${RED}Errors/Failures:  $error_count${RESET}"
echo -e "  ${YELLOW}Warnings:         $warn_count${RESET}"
echo -e "  ${GREEN}Info/Notice:      $info_count${RESET}"

# Show recent errors
echo ""
echo -e "${BOLD}--- Recent Errors (last 10) ---${RESET}"
echo "$LOG_DATA" | grep -i 'error\|fail\|critical\|fatal' | tail -10 | \
    while IFS= read -r line; do
        echo -e "  ${RED}$line${RESET}"
    done
if (( error_count == 0 )); then
    echo -e "  ${GREEN}No errors found.${RESET}"
fi

# Show recent warnings
echo ""
echo -e "${BOLD}--- Recent Warnings (last 5) ---${RESET}"
echo "$LOG_DATA" | grep -i 'warn' | tail -5 | \
    while IFS= read -r line; do
        echo -e "  ${YELLOW}$line${RESET}"
    done
if (( warn_count == 0 )); then
    echo -e "  ${GREEN}No warnings found.${RESET}"
fi

# Top services generating logs
echo ""
echo -e "${BOLD}--- Top 10 Log Sources ---${RESET}"
echo "$LOG_DATA" | awk -F'[][]' '{print $2}' | \
    grep -v '^$' | sort | uniq -c | sort -rn | head -10 | \
    awk '{printf "  %5d  %s\n", $1, $2}'

# Authentication events (if auth.log or similar)
echo ""
echo -e "${BOLD}--- Authentication Events ---${RESET}"
auth_success=$(echo "$LOG_DATA" | grep -ic 'accepted\|session opened' || echo 0)
auth_fail=$(echo "$LOG_DATA" | grep -ic 'authentication failure\|failed password' || echo 0)
echo "  Successful:  $auth_success"
echo "  Failed:      $auth_fail"

draw_line
echo "Analysis complete."

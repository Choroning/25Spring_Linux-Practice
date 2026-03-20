#!/bin/bash
# @file    monitor.sh
# @brief   Main TUI dashboard for system monitoring
# @author  Cheolwon Park
# @date    2025-06-10
#
# A terminal-based system monitoring dashboard that displays
# CPU, memory, disk, and network statistics in real-time.
#
# Usage: ./monitor.sh [refresh_interval]
#   refresh_interval: seconds between updates (default: 3)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REFRESH=${1:-3}

# Source individual monitor modules
source "$SCRIPT_DIR/cpu_monitor.sh"
source "$SCRIPT_DIR/mem_monitor.sh"
source "$SCRIPT_DIR/disk_monitor.sh"
source "$SCRIPT_DIR/network_monitor.sh"

# Terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Draw a horizontal separator line
draw_line() {
    local width=${1:-60}
    printf '%*s\n' "$width" '' | tr ' ' '='
}

# Draw a section header
draw_header() {
    local title="$1"
    echo -e "${BOLD}${CYAN}[ $title ]${RESET}"
}

# Display the main dashboard
display_dashboard() {
    clear

    local width=60
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    draw_line "$width"
    echo -e "${BOLD}${GREEN}       SYSTEM MONITORING DASHBOARD${RESET}"
    echo -e "       Host: $(hostname) | $timestamp"
    echo -e "       Uptime: $(uptime -p 2>/dev/null || uptime | sed 's/.*up //' | sed 's/,.*//')"
    draw_line "$width"
    echo ""

    # CPU Section
    draw_header "CPU Usage"
    get_cpu_info
    echo ""

    # Memory Section
    draw_header "Memory Usage"
    get_memory_info
    echo ""

    # Disk Section
    draw_header "Disk Usage"
    get_disk_info
    echo ""

    # Network Section
    draw_header "Network"
    get_network_info
    echo ""

    # Top Processes
    draw_header "Top 5 Processes (by CPU)"
    ps aux --sort=-%cpu 2>/dev/null | head -6 | \
        awk 'NR==1 {printf "  %-10s %5s %5s  %s\n", $1, $3, $4, $11}
             NR>1  {printf "  %-10s %5s%% %5s%%  %s\n", $1, $3, $4, $11}'
    echo ""

    draw_line "$width"
    echo -e "  Refresh: ${REFRESH}s | Press ${BOLD}Ctrl+C${RESET} to exit"
    draw_line "$width"
}

# Trap Ctrl+C for graceful exit
trap 'echo ""; echo "Dashboard stopped."; exit 0' INT TERM

# Main loop
echo "Starting System Monitoring Dashboard (refresh: ${REFRESH}s)..."
echo "Press Ctrl+C to stop."
sleep 1

while true; do
    display_dashboard
    sleep "$REFRESH"
done

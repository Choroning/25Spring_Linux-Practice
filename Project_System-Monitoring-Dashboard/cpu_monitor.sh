#!/bin/bash
# @file    cpu_monitor.sh
# @brief   CPU monitoring module for the system dashboard
# @author  Cheolwon Park
# @date    2025-06-10
#
# Provides functions to gather and display CPU usage information.
# Designed to be sourced by monitor.sh.

# Get CPU usage information
get_cpu_info() {
    # Try Linux /proc/stat first, then fall back to top
    if [[ -f /proc/stat ]]; then
        # Read CPU times from /proc/stat
        local cpu_line
        cpu_line=$(head -1 /proc/stat)
        local user nice system idle iowait irq softirq
        read -r _ user nice system idle iowait irq softirq <<< "$cpu_line"

        local total=$(( user + nice + system + idle + iowait + irq + softirq ))
        local active=$(( total - idle - iowait ))
        local usage=0
        if (( total > 0 )); then
            usage=$(( active * 100 / total ))
        fi

        # Display CPU info
        echo "  CPU Usage:  ${usage}%"

        # Draw a simple bar
        local bar_width=40
        local filled=$(( usage * bar_width / 100 ))
        local empty=$(( bar_width - filled ))
        printf "  ["
        printf '%*s' "$filled" '' | tr ' ' '#'
        printf '%*s' "$empty" '' | tr ' ' '-'
        printf "] %d%%\n" "$usage"

        # CPU count
        local cpu_count
        cpu_count=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo "N/A")
        echo "  CPU Cores:  $cpu_count"

        # Load average
        local load_avg
        load_avg=$(cat /proc/loadavg 2>/dev/null | awk '{print $1, $2, $3}')
        echo "  Load Avg:   $load_avg (1m, 5m, 15m)"

    elif command -v sysctl &>/dev/null; then
        # macOS fallback
        local cpu_count
        cpu_count=$(sysctl -n hw.ncpu 2>/dev/null)
        echo "  CPU Cores:  $cpu_count"

        local load_avg
        load_avg=$(sysctl -n vm.loadavg 2>/dev/null | tr -d '{}')
        echo "  Load Avg:   $load_avg"
    else
        echo "  CPU info not available on this platform."
    fi
}

# Get per-core CPU usage (Linux only)
get_cpu_per_core() {
    if [[ -f /proc/stat ]]; then
        echo "  Per-Core Usage:"
        grep '^cpu[0-9]' /proc/stat | while read -r line; do
            local core user nice system idle iowait irq softirq
            read -r core user nice system idle iowait irq softirq <<< "$line"
            local total=$(( user + nice + system + idle + iowait + irq + softirq ))
            local active=$(( total - idle - iowait ))
            local usage=0
            if (( total > 0 )); then
                usage=$(( active * 100 / total ))
            fi
            printf "    %-6s %3d%%\n" "$core" "$usage"
        done
    fi
}

# Run standalone if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "=== CPU Monitor ==="
    get_cpu_info
    echo ""
    get_cpu_per_core
fi

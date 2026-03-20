#!/bin/bash
# @file    mem_monitor.sh
# @brief   Memory monitoring module for the system dashboard
# @author  Cheolwon Park
# @date    2025-06-10
#
# Provides functions to gather and display memory usage information.
# Designed to be sourced by monitor.sh.

# Get memory usage information
get_memory_info() {
    if command -v free &>/dev/null; then
        # Linux: use free command
        local mem_info
        mem_info=$(free -m | awk '/^Mem:/ {print $2, $3, $4, $7}')
        local total used free available
        read -r total used free available <<< "$mem_info"

        local usage_pct=0
        if (( total > 0 )); then
            usage_pct=$(( used * 100 / total ))
        fi

        echo "  Total:      ${total} MB"
        echo "  Used:       ${used} MB (${usage_pct}%)"
        echo "  Free:       ${free} MB"
        echo "  Available:  ${available} MB"

        # Draw memory bar
        local bar_width=40
        local filled=$(( usage_pct * bar_width / 100 ))
        local empty=$(( bar_width - filled ))
        printf "  ["
        printf '%*s' "$filled" '' | tr ' ' '#'
        printf '%*s' "$empty" '' | tr ' ' '-'
        printf "] %d%%\n" "$usage_pct"

        # Swap info
        local swap_info
        swap_info=$(free -m | awk '/^Swap:/ {print $2, $3}')
        local swap_total swap_used
        read -r swap_total swap_used <<< "$swap_info"
        if (( swap_total > 0 )); then
            local swap_pct=$(( swap_used * 100 / swap_total ))
            echo "  Swap:       ${swap_used}/${swap_total} MB (${swap_pct}%)"
        else
            echo "  Swap:       Not configured"
        fi

    elif command -v vm_stat &>/dev/null; then
        # macOS fallback
        local page_size
        page_size=$(sysctl -n hw.pagesize 2>/dev/null || echo 4096)
        local total_mem
        total_mem=$(sysctl -n hw.memsize 2>/dev/null)
        local total_mb=$(( total_mem / 1024 / 1024 ))

        local pages_free pages_active pages_inactive pages_wired
        pages_free=$(vm_stat | awk '/Pages free/ {gsub(/\./, ""); print $3}')
        pages_active=$(vm_stat | awk '/Pages active/ {gsub(/\./, ""); print $3}')
        pages_inactive=$(vm_stat | awk '/Pages inactive/ {gsub(/\./, ""); print $3}')
        pages_wired=$(vm_stat | awk '/Pages wired/ {gsub(/\./, ""); print $4}')

        local used_mb=$(( (pages_active + pages_wired) * page_size / 1024 / 1024 ))
        local usage_pct=$(( used_mb * 100 / total_mb ))

        echo "  Total:      ${total_mb} MB"
        echo "  Used:       ${used_mb} MB (${usage_pct}%)"
    else
        echo "  Memory info not available on this platform."
    fi
}

# Run standalone if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "=== Memory Monitor ==="
    get_memory_info
fi

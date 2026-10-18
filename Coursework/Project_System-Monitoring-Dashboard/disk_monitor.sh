#!/bin/bash
# @file    disk_monitor.sh
# @brief   Disk usage monitoring module for the system dashboard
# @author  Cheolwon Park
# @date    2025-06-10
#
# Provides functions to gather and display disk usage information.
# Designed to be sourced by monitor.sh.

# Warning threshold for disk usage percentage
DISK_WARN_THRESHOLD=${DISK_WARN_THRESHOLD:-80}
DISK_CRIT_THRESHOLD=${DISK_CRIT_THRESHOLD:-90}

# Get disk usage information
get_disk_info() {
    # Use df to get filesystem usage, exclude tmpfs and devtmpfs
    echo "  Filesystem           Size   Used  Avail  Use%  Mounted on"
    echo "  -------------------------------------------------------------------"

    df -h 2>/dev/null | awk 'NR>1 && $1 !~ /^(tmpfs|devtmpfs|none|udev)/' | \
    while read -r fs size used avail pct mount; do
        # Strip the % sign for comparison
        local pct_num="${pct%\%}"

        # Color coding based on usage
        local color=""
        if [[ "$pct_num" =~ ^[0-9]+$ ]]; then
            if (( pct_num >= DISK_CRIT_THRESHOLD )); then
                color="\033[0;31m"  # Red
            elif (( pct_num >= DISK_WARN_THRESHOLD )); then
                color="\033[0;33m"  # Yellow
            else
                color="\033[0;32m"  # Green
            fi
        fi

        printf "  ${color}%-20s %5s  %5s  %5s  %4s  %s\033[0m\n" \
            "$fs" "$size" "$used" "$avail" "$pct" "$mount"
    done
}

# Get inode usage information
get_inode_info() {
    echo "  Inode Usage:"
    df -i 2>/dev/null | awk 'NR>1 && $1 !~ /^(tmpfs|devtmpfs|none|udev)/' | \
    while read -r fs inodes iused ifree ipct mount; do
        printf "    %-20s  %s used / %s total (%s)\n" "$fs" "$iused" "$inodes" "$ipct"
    done
}

# Check for disk usage warnings
check_disk_warnings() {
    local warnings=0
    while read -r fs size used avail pct mount; do
        local pct_num="${pct%\%}"
        if [[ "$pct_num" =~ ^[0-9]+$ ]] && (( pct_num >= DISK_WARN_THRESHOLD )); then
            echo "  WARNING: $mount is at ${pct} capacity ($fs)"
            warnings=1
        fi
    done < <(df -h 2>/dev/null | awk 'NR>1 && $1 !~ /^(tmpfs|devtmpfs|none|udev)/')
    if (( warnings == 0 )); then
        echo "  All filesystems within normal usage."
    fi
}

# Run standalone if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "=== Disk Monitor ==="
    get_disk_info
    echo ""
    check_disk_warnings
fi

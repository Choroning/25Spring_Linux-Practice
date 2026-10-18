#!/bin/bash
# @file    network_monitor.sh
# @brief   Network monitoring module for the system dashboard
# @author  Cheolwon Park
# @date    2025-06-10
#
# Provides functions to gather and display network information.
# Designed to be sourced by monitor.sh.

# Get network interface information
get_network_info() {
    # Display active network interfaces and their IP addresses
    echo "  Active Interfaces:"

    if command -v ip &>/dev/null; then
        # Linux: use ip command
        ip -o addr show 2>/dev/null | awk '$3 == "inet" {
            split($4, a, "/");
            printf "    %-12s  %s/%s\n", $2, a[1], a[2]
        }'
    elif command -v ifconfig &>/dev/null; then
        # macOS / fallback: use ifconfig
        ifconfig 2>/dev/null | awk '/^[a-z]/ {iface=$1}
            /inet / && !/127.0.0.1/ {
                printf "    %-12s  %s\n", iface, $2
            }'
    else
        echo "    Network info not available."
    fi

    echo ""

    # Show listening ports (top 5)
    echo "  Listening Ports (top 5):"
    if command -v ss &>/dev/null; then
        ss -tlnp 2>/dev/null | awk 'NR>1 {printf "    %-6s  %s\n", $1, $4}' | head -5
    elif command -v netstat &>/dev/null; then
        netstat -tlnp 2>/dev/null | awk 'NR>2 {printf "    %-6s  %s\n", $1, $4}' | head -5
    else
        echo "    Port info not available."
    fi

    echo ""

    # Show network traffic statistics (Linux only)
    if [[ -d /sys/class/net ]]; then
        echo "  Traffic Statistics:"
        for iface_path in /sys/class/net/*/statistics; do
            local iface
            iface=$(echo "$iface_path" | cut -d/ -f5)
            if [[ "$iface" != "lo" ]] && [[ -f "$iface_path/rx_bytes" ]]; then
                local rx_bytes tx_bytes
                rx_bytes=$(cat "$iface_path/rx_bytes" 2>/dev/null || echo 0)
                tx_bytes=$(cat "$iface_path/tx_bytes" 2>/dev/null || echo 0)
                local rx_mb=$(( rx_bytes / 1024 / 1024 ))
                local tx_mb=$(( tx_bytes / 1024 / 1024 ))
                printf "    %-12s  RX: %d MB  |  TX: %d MB\n" "$iface" "$rx_mb" "$tx_mb"
            fi
        done
    fi
}

# Get connection counts by state
get_connection_stats() {
    echo "  Connection States:"
    if command -v ss &>/dev/null; then
        ss -s 2>/dev/null | head -5 | sed 's/^/    /'
    elif command -v netstat &>/dev/null; then
        netstat -an 2>/dev/null | awk '/^tcp/ {print $6}' | sort | uniq -c | sort -rn | \
            head -5 | awk '{printf "    %-15s %d\n", $2, $1}'
    fi
}

# Run standalone if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "=== Network Monitor ==="
    get_network_info
    echo ""
    get_connection_stats
fi

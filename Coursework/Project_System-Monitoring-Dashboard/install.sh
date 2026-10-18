#!/bin/bash
# @file    install.sh
# @brief   Setup script to install cron jobs for automated monitoring
# @author  Cheolwon Park
# @date    2025-06-10
#
# Installs cron jobs that periodically run the monitoring scripts
# and save output to log files.
#
# Usage: ./install.sh [install|uninstall|status]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$HOME/monitor_logs"
CRON_TAG="# SYSTEM_MONITOR_DASHBOARD"

# Ensure scripts are executable
make_executable() {
    chmod +x "$SCRIPT_DIR"/*.sh
    echo "Made all scripts executable."
}

# Create log directory
setup_log_dir() {
    mkdir -p "$LOG_DIR"
    echo "Log directory: $LOG_DIR"
}

# Install cron jobs
install_cron() {
    echo "Installing monitoring cron jobs..."

    # Remove any existing monitor cron entries first
    crontab -l 2>/dev/null | grep -v "$CRON_TAG" > /tmp/cron_backup.tmp

    # Add new cron entries
    cat >> /tmp/cron_backup.tmp << EOF

# System Monitoring Dashboard - Automated Reports $CRON_TAG
# Run system snapshot every 5 minutes $CRON_TAG
*/5 * * * * $SCRIPT_DIR/cpu_monitor.sh >> $LOG_DIR/cpu_\$(date +\%Y\%m\%d).log 2>&1 $CRON_TAG
*/5 * * * * $SCRIPT_DIR/mem_monitor.sh >> $LOG_DIR/mem_\$(date +\%Y\%m\%d).log 2>&1 $CRON_TAG
# Run disk check every hour $CRON_TAG
0 * * * * $SCRIPT_DIR/disk_monitor.sh >> $LOG_DIR/disk_\$(date +\%Y\%m\%d).log 2>&1 $CRON_TAG
# Run log analysis daily at midnight $CRON_TAG
0 0 * * * $SCRIPT_DIR/log_analyzer.sh >> $LOG_DIR/analysis_\$(date +\%Y\%m\%d).log 2>&1 $CRON_TAG
# Clean logs older than 30 days weekly $CRON_TAG
0 3 * * 0 find $LOG_DIR -name "*.log" -mtime +30 -delete $CRON_TAG
EOF

    crontab /tmp/cron_backup.tmp
    rm -f /tmp/cron_backup.tmp

    echo "Cron jobs installed successfully."
    echo ""
    echo "Schedule:"
    echo "  - CPU/Memory monitoring: every 5 minutes"
    echo "  - Disk monitoring: every hour"
    echo "  - Log analysis: daily at midnight"
    echo "  - Log cleanup: weekly (Sunday 3 AM, >30 days old)"
}

# Remove cron jobs
uninstall_cron() {
    echo "Removing monitoring cron jobs..."
    crontab -l 2>/dev/null | grep -v "$CRON_TAG" | crontab -
    echo "Cron jobs removed."
}

# Show current cron status
show_status() {
    echo "=== Monitoring Cron Jobs ==="
    local jobs
    jobs=$(crontab -l 2>/dev/null | grep "$CRON_TAG" | grep -v "^#")
    if [[ -n "$jobs" ]]; then
        echo "Status: ACTIVE"
        echo ""
        echo "Installed jobs:"
        echo "$jobs" | sed "s/ $CRON_TAG//"
    else
        echo "Status: NOT INSTALLED"
    fi

    echo ""
    echo "=== Log Directory ==="
    if [[ -d "$LOG_DIR" ]]; then
        echo "Path: $LOG_DIR"
        echo "Files: $(ls "$LOG_DIR" 2>/dev/null | wc -l)"
        echo "Size:  $(du -sh "$LOG_DIR" 2>/dev/null | awk '{print $1}')"
    else
        echo "Not created yet."
    fi
}

# Main logic
case "${1:-status}" in
    install)
        make_executable
        setup_log_dir
        install_cron
        ;;
    uninstall)
        uninstall_cron
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: $0 [install|uninstall|status]"
        echo ""
        echo "  install    - Set up cron jobs and log directory"
        echo "  uninstall  - Remove all monitoring cron jobs"
        echo "  status     - Show current monitoring status"
        exit 1
        ;;
esac

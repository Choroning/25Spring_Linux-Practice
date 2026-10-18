# Project: System Monitoring Dashboard
> **Author:** Cheolwon Park  
> **Date:** 2025-06-06

A terminal-based (TUI) system monitoring dashboard built entirely in Bash. Displays real-time CPU, memory, disk, and network statistics with color-coded output and automatic alerting.

## Structure

```
Project_System-Monitoring-Dashboard/
├── monitor.sh           # Main TUI dashboard (entry point)
├── cpu_monitor.sh       # CPU usage monitoring module
├── mem_monitor.sh       # Memory usage monitoring module
├── disk_monitor.sh      # Disk usage monitoring module
├── network_monitor.sh   # Network interface monitoring module
├── log_analyzer.sh      # System log analysis tool
├── install.sh           # Cron job setup for automated monitoring
└── README.md
```

## Usage

### Interactive Dashboard
```bash
chmod +x *.sh
./monitor.sh           # Default 3-second refresh
./monitor.sh 5         # 5-second refresh interval
```

### Individual Monitors
Each monitor module can run standalone:
```bash
./cpu_monitor.sh
./mem_monitor.sh
./disk_monitor.sh
./network_monitor.sh
```

### Log Analysis
```bash
./log_analyzer.sh                        # Analyze /var/log/syslog (default)
./log_analyzer.sh /var/log/auth.log 500  # Analyze specific log, last 500 lines
```

### Automated Monitoring (Cron)
```bash
./install.sh install     # Set up cron jobs
./install.sh status      # Check current status
./install.sh uninstall   # Remove cron jobs
```

## Features

- **CPU**: Usage percentage, load average, core count, per-core breakdown
- **Memory**: Total/used/free/available, swap usage, visual bar graph
- **Disk**: Filesystem usage with color-coded warnings (yellow >80%, red >90%)
- **Network**: Active interfaces, IP addresses, listening ports, traffic stats
- **Log Analysis**: Error/warning counts, authentication events, top log sources
- **Cron Integration**: Automated periodic monitoring with log rotation

## Platform Support

- Primary: Linux (Ubuntu/Debian, CentOS/RHEL)
- Partial: macOS (basic CPU and memory monitoring)

## References

- Carnegie Mellon University, 15-213: Introduction to Computer Systems
- MIT, The Missing Semester of Your CS Education (Shell Tools and Scripting)
- Linux man pages: `proc(5)`, `free(1)`, `df(1)`, `ss(8)`, `crontab(5)`

# 시스템 모니터링 대시보드

[레포지토리 안내](../../README.ko.md) | [English](README.md) | [한국어](README.ko.md)

> **최종 수정일:** 2026-10-26

Bash만으로 만든 터미널 기반(TUI) 시스템 모니터링 대시보드이다. CPU, 메모리, 디스크, 네트워크 통계를 실시간으로 보여 주며, 출력을 색으로 구분하고 경고를 자동으로 띄운다.

## 구조

```text
Project_System-Monitoring-Dashboard/
├── monitor.sh           # Main TUI dashboard (entry point)
├── cpu_monitor.sh       # CPU usage monitoring module
├── mem_monitor.sh       # Memory usage monitoring module
├── disk_monitor.sh      # Disk usage monitoring module
├── network_monitor.sh   # Network interface monitoring module
├── log_analyzer.sh      # System log analysis tool
├── install.sh           # Cron job setup for automated monitoring
├── README.ko.md
└── README.md
```

## 사용법

### 대화형 대시보드
```bash
chmod +x *.sh
./monitor.sh           # Default 3-second refresh
./monitor.sh 5         # 5-second refresh interval
```

### 개별 모니터
각 모니터 모듈은 단독으로 실행할 수 있다.
```bash
./cpu_monitor.sh
./mem_monitor.sh
./disk_monitor.sh
./network_monitor.sh
```

### 로그 분석
```bash
./log_analyzer.sh                        # Analyze /var/log/syslog (default)
./log_analyzer.sh /var/log/auth.log 500  # Analyze specific log, last 500 lines
```

### 자동 모니터링 (Cron)
```bash
./install.sh install     # Set up cron jobs
./install.sh status      # Check current status
./install.sh uninstall   # Remove cron jobs
```

## 기능

- **CPU:** 사용률, 부하 평균, 코어 수, 코어별 사용률
- **메모리:** 전체, 사용 중, 여유, 사용 가능 메모리, 스왑 사용량, 막대그래프 표시
- **디스크:** 색으로 구분한 경고를 포함한 파일 시스템 사용량(80% 초과는 노란색, 90% 초과는 빨간색)
- **네트워크:** 활성 인터페이스, IP 주소, 수신 대기 중인 포트, 트래픽 통계
- **로그 분석:** 오류와 경고 건수, 인증 이벤트, 로그를 많이 남긴 출처
- **Cron 연동:** 로그 순환을 포함한 주기적 자동 모니터링

## 지원 플랫폼

- **주 지원:** Linux (Ubuntu/Debian, CentOS/RHEL)
- **부분 지원:** macOS (기본 CPU와 메모리 모니터링)

## 참고 문헌

- Carnegie Mellon University, 15-213: Introduction to Computer Systems
- MIT, The Missing Semester of Your CS Education (Shell Tools and Scripting)
- Linux man 페이지: `proc(5)`, `free(1)`, `df(1)`, `ss(8)`, `crontab(5)`

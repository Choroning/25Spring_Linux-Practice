# 9주차 — 프로세스 관리

> **최종 수정일:** 2026-04-01

> **선수 지식**: 셸과 파일시스템 기초 (1-7주차).
>
> **학습 목표**:
> 1. ps, top, kill을 사용하여 프로세스를 모니터링하고 관리할 수 있다
> 2. 전경과 배경 프로세스 실행을 구분할 수 있다
> 3. 작업 제어(bg, fg, jobs, nohup)를 적용할 수 있다

---

## 목차

1. [프로세스 이해](#1-프로세스-이해)
2. [프로세스 확인](#2-프로세스-확인)
3. [포그라운드 및 백그라운드 프로세스](#3-포그라운드-및-백그라운드-프로세스)
4. [시그널과 프로세스 제어](#4-시그널과-프로세스-제어)
5. [프로세스 스케줄링](#5-프로세스-스케줄링)
6. [예약 작업 (cron과 at)](#6-예약-작업-cron과-at)
7. [시스템 모니터링](#7-시스템-모니터링)
8. [모범 사례](#8-모범-사례)
9. [요약](#요약)

---

<br>

## 1. 프로세스 이해

### 1.1 프로세스란?

**프로세스(Process)**는 실행 중인 프로그램의 인스턴스이다. 각 프로세스는 다음을 가진다:
- **PID (Process ID):** 고유 식별자
- **PPID (Parent Process ID):** 해당 프로세스를 생성한 부모의 PID
- **UID/GID:** 프로세스의 소유자 및 그룹
- **상태(State):** 실행 중, 대기 중, 정지, 좀비 등
- **우선순위(Priority):** 스케줄링 우선순위 값

### 1.2 프로세스 유형

| 유형 | 설명 | 예시 |
|------|-------------|---------|
| **포그라운드** | 대화형, 터미널에 연결됨 | `vi file.txt` |
| **백그라운드** | 터미널과 독립적으로 실행 | `command &` |
| **데몬** | 백그라운드에서 실행되는 시스템 서비스 | `sshd`, `cron`, `nginx` |
| **좀비** | 완료되었지만 부모가 아직 정리하지 않은 상태 | defunct 프로세스 |
| **고아** | 부모가 종료되어 init/systemd에 의해 입양됨 | |

### 1.3 프로세스 상태

| 상태 | 기호 | 설명 |
|-------|--------|-------------|
| 실행 중 | `R` | 현재 CPU에서 실행 중 |
| 대기 중 | `S` | 이벤트를 기다리는 중 (인터럽트 가능) |
| 비인터럽트 대기 | `D` | I/O를 기다리는 중 (인터럽트 불가) |
| 정지 | `T` | 일시 중지됨 (예: Ctrl+Z) |
| 좀비 | `Z` | 종료되었으나 부모가 종료 상태를 수집하지 않음 |

---

<br>

## 2. 프로세스 확인

### 2.1 ps — 프로세스 상태

```bash
ps                      # 현재 터미널의 현재 사용자 프로세스
ps -e                   # 모든 프로세스
ps -f                   # 전체 형식
ps -ef                  # 모든 프로세스, 전체 형식
ps aux                  # BSD 스타일 전체 프로세스 상세 정보
ps -u username          # 특정 사용자의 프로세스
ps -p PID               # PID로 특정 프로세스 조회
ps --forest             # 트리 형태로 프로세스 보기
```

**`ps aux` 출력 이해:**

```
USER  PID  %CPU  %MEM  VSZ    RSS   TTY  STAT  START  TIME  COMMAND
root    1   0.0   0.3  168K  12K    ?    Ss    10:00  0:01  /sbin/init
```

### 2.2 top — 실시간 프로세스 모니터

```bash
top                     # 대화형 프로세스 모니터
```

**top 대화형 명령어:**

| 키 | 동작 |
|-----|--------|
| `q` | 종료 |
| `k` | 프로세스 종료 (PID 입력) |
| `r` | 프로세스 우선순위 변경 |
| `P` | CPU 사용률 기준 정렬 |
| `M` | 메모리 사용률 기준 정렬 |
| `1` | 개별 CPU 코어 표시 |
| `h` | 도움말 |

### 2.3 pstree — 프로세스 트리

```bash
pstree                  # 프로세스 트리 표시
pstree -p               # PID 표시
pstree -u               # 사용자 전환 표시
pstree user1            # 특정 사용자의 프로세스 표시
```

---

<br>

## 3. 포그라운드 및 백그라운드 프로세스

### 3.1 프로세스 실행

```bash
# 포그라운드 (기본값)
command                          # 완료될 때까지 터미널을 점유

# 백그라운드
command &                        # 백그라운드에서 실행
nohup command &                  # 백그라운드에서 실행, 로그아웃 후에도 유지
```

### 3.2 작업 제어

```bash
jobs                             # 백그라운드 작업 목록
jobs -l                          # PID 포함 목록
fg %1                            # 작업 1을 포그라운드로 전환
bg %1                            # 작업 1을 백그라운드에서 재개
Ctrl+Z                           # 포그라운드 작업 일시 중지
Ctrl+C                           # 포그라운드 작업 종료
```

### 3.3 nohup — 끊김 방지

```bash
nohup long_running_script.sh &
# 출력은 기본적으로 nohup.out에 기록됨
nohup command > output.log 2>&1 &
```

---

<br>

## 4. 시그널과 프로세스 제어

### 4.1 주요 시그널

| 시그널 | 번호 | 이름 | 기본 동작 | 설명 |
|--------|--------|------|---------------|-------------|
| SIGHUP | 1 | Hangup | 종료 | 터미널이 닫힘 |
| SIGINT | 2 | Interrupt | 종료 | Ctrl+C |
| SIGQUIT | 3 | Quit | 코어 덤프 | Ctrl+\\ |
| SIGKILL | 9 | Kill | 종료 | 포착하거나 무시할 수 없음 |
| SIGTERM | 15 | Terminate | 종료 | 정상 종료 (기본값) |
| SIGSTOP | 19 | Stop | 정지 | 포착할 수 없음 (Ctrl+Z와 유사) |
| SIGCONT | 18 | Continue | 계속 | 정지된 프로세스 재개 |
| SIGUSR1 | 10 | 사용자 정의 | 종료 | 커스텀 시그널 |
| SIGUSR2 | 12 | 사용자 정의 | 종료 | 커스텀 시그널 |

### 4.2 kill — 시그널 전송

```bash
kill PID                         # SIGTERM (15) 전송 - 정상 종료
kill -9 PID                      # SIGKILL (9) 전송 - 강제 종료
kill -HUP PID                    # SIGHUP (1) 전송 - 설정 리로드
kill -STOP PID                   # 프로세스 일시 중지
kill -CONT PID                   # 프로세스 재개
kill -l                          # 모든 시그널 이름 나열

# 이름으로 종료
killall process_name             # 해당 이름의 모든 프로세스 종료
pkill -f "pattern"               # 패턴과 일치하는 프로세스 종료
```

### 4.3 프로세스 우선순위

```bash
# 조정된 우선순위로 실행 (-20~19, 낮을수록 높은 우선순위)
nice -n 10 command               # 낮은 우선순위로 실행
nice -n -5 command               # 높은 우선순위로 실행 (root 필요)

# 실행 중인 프로세스의 우선순위 변경
renice 10 -p PID                 # 우선순위를 10으로 설정
sudo renice -5 -p PID            # 높은 우선순위로 설정
```

---

<br>

## 5. 프로세스 스케줄링

### 5.1 프로세스 생명주기

```
생성 (fork) --> 준비 --> 실행 --> 종료
                 ^          |
                 |          v
                 +-- 대기/수면
```

### 5.2 /proc 파일시스템

```bash
ls /proc/                        # 모든 프로세스 디렉터리 나열
cat /proc/PID/status             # 프로세스 상태 정보
cat /proc/PID/cmdline            # 프로세스를 시작한 명령줄
cat /proc/cpuinfo                # CPU 정보
cat /proc/meminfo                # 메모리 정보
cat /proc/uptime                 # 시스템 가동 시간
```

---

<br>

## 6. 예약 작업 (cron과 at)

### 6.1 crontab — 반복 작업

```bash
crontab -e                       # 현재 사용자의 crontab 편집
crontab -l                       # 현재 사용자의 crontab 나열
crontab -r                       # 현재 사용자의 crontab 삭제
sudo crontab -u user1 -e         # 다른 사용자의 crontab 편집
```

**crontab 형식:**

```
* * * * * command
│ │ │ │ │
│ │ │ │ └── 요일 (0-7, 0과 7 = 일요일)
│ │ │ └──── 월 (1-12)
│ │ └────── 일 (1-31)
│ └──────── 시 (0-23)
└────────── 분 (0-59)
```

**예시:**

```bash
# 매분 실행
* * * * * /path/to/script.sh

# 매일 오전 2시 30분에 실행
30 2 * * * /path/to/backup.sh

# 매주 월요일 오전 8시에 실행
0 8 * * 1 /path/to/weekly.sh

# 매월 1일 자정에 실행
0 0 1 * * /path/to/monthly.sh

# 5분마다 실행
*/5 * * * * /path/to/check.sh

# 월-금 오전 9시에 실행
0 9 * * 1-5 /path/to/work.sh
```

### 6.2 at — 일회성 작업

```bash
at 10:00                         # 오늘 오전 10시에 예약
at now + 30 minutes              # 30분 후에 예약
at 2:00 AM tomorrow              # 내일 오전 2시에 예약
atq                              # 대기 중인 at 작업 나열
atrm job_number                  # at 작업 삭제
```

```bash
$ at now + 1 hour
at> /path/to/script.sh
at>                             # Ctrl+D를 눌러 완료
```

---

<br>

## 7. 시스템 모니터링

### 7.1 자원 모니터링 명령어

```bash
# CPU 및 메모리
top                              # 대화형 프로세스 모니터
htop                             # 향상된 top (설치: apt install htop)
vmstat 2 5                       # 2초 간격, 5회 가상 메모리 통계
mpstat                           # CPU 통계

# 메모리
free -h                          # 메모리 사용량 (사람이 읽기 쉬운 형식)
free -m                          # 메모리 사용량 (MB)

# 디스크
df -h                            # 디스크 공간 사용량
du -sh /path                     # 디렉터리 크기
iostat                           # I/O 통계

# 네트워크
ss -tuln                         # 소켓 통계
netstat -tuln                    # 네트워크 연결
```

### 7.2 uptime과 부하 평균

```bash
$ uptime
10:30:00 up 15 days, 3:22, 2 users, load average: 0.15, 0.10, 0.05
#                                                   ^^^^  ^^^^  ^^^^
#                                                   1분   5분   15분
```

부하 평균(load average): 실행 큐에 있는 프로세스 수이다. 단일 코어 시스템에서 1.0은 100% 활용을 의미한다.

---

<br>

## 8. 모범 사례

### 8.1 프로세스 관리 팁

- 항상 `SIGKILL` (9) 전에 `SIGTERM` (15)을 먼저 시도
- 로그아웃 후에도 유지되어야 하는 장기 실행 작업에는 `nohup` 사용
- `top` 또는 `htop`으로 시스템 자원을 정기적으로 모니터링
- 자동화된 반복 작업에는 `cron` 사용
- 디버깅을 위해 cron 작업 출력을 로그에 기록

### 8.2 흔한 실수

| 실수 | 해결 방법 |
|---------|----------|
| `kill -9`를 처음부터 사용 | 먼저 `kill PID` (SIGTERM) 시도 |
| 좀비 프로세스 누적 | 부모 프로세스 수정 또는 서비스 재시작 |
| cron 작업이 실행되지 않음 | 경로, 권한, cron 로그 확인 |
| SSH 작업에서 `nohup` 누락 | `nohup command &` 또는 `screen`/`tmux` 사용 |

---

<br>

## 요약

| 개념 | 핵심 내용 |
|---------|-----------|
| 프로세스 | 고유 PID를 가진 실행 중인 프로그램 인스턴스 |
| `ps` | 프로세스 정보 조회 (`ps aux`, `ps -ef`) |
| `top` | 실시간 대화형 프로세스 모니터 |
| 백그라운드 작업 | `command &`, `nohup`, `fg`, `bg`, `jobs` |
| 시그널 | `SIGTERM` (15, 정상 종료), `SIGKILL` (9, 강제 종료) |
| `kill` | 프로세스에 시그널 전송 (`kill PID`, `kill -9 PID`) |
| `nice`/`renice` | 프로세스 우선순위 조정 (-20~19) |
| `crontab` | 반복 작업 예약 (분 시 일 월 요일) |
| `at` | 일회성 작업 예약 |
| `/proc` | 프로세스 및 시스템 정보를 제공하는 가상 파일시스템 |

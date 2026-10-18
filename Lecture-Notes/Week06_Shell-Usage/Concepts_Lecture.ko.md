# 6주차 — 셸 사용법

> **최종 수정일:** 2026-04-01

> **선수 지식**: Vi 편집기와 명령줄 기초 (1-5주차).
>
> **학습 목표**:
> 1. 변수와 별칭으로 셸 환경을 커스터마이즈할 수 있다
> 2. I/O 리다이렉션과 파이핑을 적용할 수 있다
> 3. 명령 히스토리와 탭 완성을 효과적으로 사용할 수 있다

---

## 목차

1. [셸이란?](#1-셸이란)
2. [셸의 종류](#2-셸의-종류)
3. [셸 환경 변수](#3-셸-환경-변수)
4. [셸 초기화 파일](#4-셸-초기화-파일)
5. [별칭(Alias)](#5-별칭alias)
6. [명령어 히스토리](#6-명령어-히스토리)
7. [셸 메타문자](#7-셸-메타문자)
8. [인용 규칙](#8-인용-규칙)
9. [작업 제어](#9-작업-제어)
10. [모범 사례](#10-모범-사례)
11. [요약](#요약)

---

<br>

## 1. 셸이란?

**셸(Shell)** 은 사용자와 Linux 커널 사이의 인터페이스 역할을 하는 명령줄 해석기이다.

```
사용자 입력 --> 셸 (해석) --> 커널 (실행) --> 하드웨어
            <-- 셸 (표시) <-- 커널 (반환) <--
```

### 1.1 셸의 역할

- 사용자 명령을 읽고 구문 분석
- 와일드카드, 별칭, 변수 확장
- I/O 리다이렉션 및 파이프 처리
- 백그라운드 프로세스 관리
- 자식 프로세스를 fork하여 외부 프로그램 실행
- 스크립팅 기능 제공

---

<br>

## 2. 셸의 종류

### 2.1 주요 셸

| 셸 | 경로 | 설명 |
|-------|------|-------------|
| **bash** | `/bin/bash` | Bourne Again Shell; 대부분의 Linux 배포판에서 기본 셸 |
| **sh** | `/bin/sh` | Bourne Shell; 최초의 Unix 셸 |
| **csh** | `/bin/csh` | C Shell; C 언어와 유사한 문법 |
| **tcsh** | `/bin/tcsh` | 향상된 C Shell |
| **ksh** | `/bin/ksh` | Korn Shell; sh와 csh의 기능을 결합 |
| **zsh** | `/bin/zsh` | Z Shell; bash를 확장한 다양한 개선 기능 |
| **fish** | `/usr/bin/fish` | Friendly Interactive Shell |

### 2.2 셸 확인 및 변경

```bash
# 현재 셸 확인
echo $SHELL

# 사용 가능한 셸 목록 확인
cat /etc/shells

# 기본 셸 변경
chsh -s /bin/zsh

# 임시 셸 전환
bash            # bash 세션 시작
zsh             # zsh 세션 시작
exit            # 이전 셸로 복귀
```

---

<br>

## 3. 셸 환경 변수

### 3.1 주요 환경 변수

| 변수 | 설명 | 예시 |
|----------|-------------|---------|
| `HOME` | 사용자 홈 디렉터리 | `/home/user1` |
| `PATH` | 명령어 검색 경로 | `/usr/bin:/usr/local/bin` |
| `SHELL` | 현재 셸 경로 | `/bin/bash` |
| `USER` | 현재 사용자 이름 | `user1` |
| `HOSTNAME` | 시스템 호스트 이름 | `myubuntu` |
| `PWD` | 현재 작업 디렉터리 | `/home/user1` |
| `OLDPWD` | 이전 작업 디렉터리 | `/tmp` |
| `PS1` | 기본 프롬프트 문자열 | `\u@\h:\w\$` |
| `PS2` | 보조 프롬프트 (연속 입력) | `>` |
| `LANG` | 시스템 로캘 | `en_US.UTF-8` |
| `TERM` | 터미널 유형 | `xterm-256color` |
| `EDITOR` | 기본 텍스트 편집기 | `/usr/bin/vim` |
| `HISTSIZE` | 히스토리에 저장되는 명령어 수 | `1000` |
| `HISTFILE` | 히스토리 파일 위치 | `~/.bash_history` |

### 3.2 변수 다루기

```bash
# 변수 표시
echo $HOME
echo $PATH

# 지역 변수 설정 (현재 셸에서만 유효)
MY_VAR="Hello World"
echo $MY_VAR

# 환경 변수로 내보내기 (자식 프로세스에서도 사용 가능)
export MY_VAR="Hello World"

# 변수 해제
unset MY_VAR

# 모든 환경 변수 보기
env
printenv
export


# PATH 수정
export PATH=$PATH:/opt/myapp/bin
```

### 3.3 PS1 프롬프트 커스터마이징

| 이스케이프 코드 | 의미 |
|-------------|---------|
| `\u` | 사용자 이름 |
| `\h` | 호스트 이름 (짧은 형식) |
| `\H` | 호스트 이름 (전체) |
| `\w` | 현재 작업 디렉터리 (전체 경로) |
| `\W` | 현재 디렉터리 (기본 이름) |
| `\d` | 날짜 |
| `\t` | 시간 (24시간 형식) |
| `\$` | 일반 사용자는 `$`, root는 `#` |
| `\n` | 줄 바꿈 |

```bash
# 프롬프트 커스터마이징 예시
export PS1="\u@\h:\w\$ "         # user@host:/path$
export PS1="[\t] \u:\W\$ "      # [14:30:00] user:dir$
```

---

<br>

## 4. 셸 초기화 파일

### 4.1 Bash 시작 파일

| 파일 | 읽히는 시점 | 범위 |
|------|-----------|-------|
| `/etc/profile` | 로그인 셸 | 시스템 전체 |
| `/etc/bash.bashrc` | 모든 대화형 셸 | 시스템 전체 |
| `~/.profile` | 로그인 셸 | 사용자별 |
| `~/.bash_profile` | 로그인 셸 | 사용자별 |
| `~/.bashrc` | 모든 대화형 셸 | 사용자별 |
| `~/.bash_logout` | 로그아웃 시 | 사용자별 |

### 4.2 로딩 순서 (로그인 셸)

```
/etc/profile
    └── /etc/bash.bashrc
    └── ~/.bash_profile (또는 ~/.profile)
            └── ~/.bashrc
```

```bash
# 로그아웃 없이 설정 다시 불러오기
source ~/.bashrc
# 또는
. ~/.bashrc
```

---

<br>

## 5. 별칭(Alias)

### 5.1 별칭 생성 및 관리

```bash
# 별칭 생성
alias ll='ls -la'
alias grep='grep --color=auto'
alias rm='rm -i'
alias ..='cd ..'
alias ...='cd ../..'

# 모든 별칭 보기
alias

# 별칭 제거
unalias ll

# 별칭을 영구적으로 만들기 (~/.bashrc에 추가)
echo "alias ll='ls -la'" >> ~/.bashrc
```

### 5.2 유용한 별칭

```bash
alias la='ls -la'
alias lt='ls -lt'
alias mkdir='mkdir -pv'
alias ports='netstat -tulanp'
alias df='df -h'
alias du='du -sh'
alias free='free -m'
alias update='sudo apt update && sudo apt upgrade -y'
```

---

<br>

## 6. 명령어 히스토리

### 6.1 히스토리 명령어

```bash
history                 # 명령어 히스토리 보기
history 20              # 최근 20개 명령어 보기
!n                      # n번 명령어 실행
!!                      # 마지막 명령어 실행
!string                 # string으로 시작하는 마지막 명령어 실행
!?string                # string을 포함하는 마지막 명령어 실행
^old^new                # 마지막 명령어에서 old를 new로 교체

# 히스토리 검색
Ctrl+r                  # 역방향 검색 (입력하면서 검색)
Ctrl+s                  # 정방향 검색
```

### 6.2 히스토리 설정

```bash
# ~/.bashrc에 추가
export HISTSIZE=10000           # 메모리에 저장할 명령어 수
export HISTFILESIZE=20000       # 히스토리 파일에 저장할 명령어 수
export HISTCONTROL=ignoredups   # 중복 명령어 무시
export HISTTIMEFORMAT="%F %T "  # 타임스탬프 추가
```

---

<br>

## 7. 셸 메타문자

### 7.1 특수 문자

| 문자 | 의미 |
|-----------|---------|
| `~` | 홈 디렉터리 |
| `#` | 주석 |
| `$` | 변수 확장 |
| `&` | 백그라운드에서 명령 실행 |
| `*` | 와일드카드: 임의의 문자열 |
| `?` | 와일드카드: 단일 문자 |
| `;` | 명령 구분자 |
| `\|` | 파이프 |
| `>` `>>` | 출력 리다이렉션 |
| `<` `<<` | 입력 리다이렉션 |
| `\` | 이스케이프 문자 |
| `` ` `` | 명령 치환 (백틱) |
| `$()` | 명령 치환 (권장 형식) |
| `()` | 서브셸 실행 |
| `{}` | 중괄호 확장 |
| `[]` | 와일드카드에서의 문자 클래스 |

### 7.2 명령 실행 제어

```bash
# 순차 실행
command1 ; command2              # 성공 여부와 관계없이 모두 실행

# 조건부 실행
command1 && command2             # command1이 성공해야 command2 실행
command1 || command2             # command1이 실패해야 command2 실행

# 명령 그룹화
{ command1; command2; }          # 현재 셸에서 실행
( command1; command2 )           # 서브셸에서 실행
```

---

<br>

## 8. 인용 규칙

### 8.1 인용 유형

| 인용 부호 | 유형 | 변수 확장 | 예시 |
|-------|------|-------------------|---------|
| `' '` | 작은따옴표 | 안 됨 | `echo '$HOME'`은 `$HOME`을 출력 |
| `" "` | 큰따옴표 | 됨 | `echo "$HOME"`은 `/home/user1`을 출력 |
| `` ` ` `` | 백틱 | 명령 치환 | `` echo `date` ``은 현재 날짜를 출력 |
| `$()` | 명령 치환 | 됨 | `echo $(date)`은 현재 날짜를 출력 |
| `\` | 이스케이프 | 다음 문자를 이스케이프 | `echo \$HOME`은 `$HOME`을 출력 |

```bash
name="Linux"
echo 'Hello $name'      # 출력: Hello $name
echo "Hello $name"      # 출력: Hello Linux
echo "Today is $(date)" # 출력: Today is Fri Mar 21 ...
echo "Files: $(ls)"     # 출력: Files: file1 file2 ...
```

---

<br>

## 9. 작업 제어

### 9.1 포그라운드 및 백그라운드 작업

```bash
# 백그라운드에서 명령 실행
command &

# 작업 목록 보기
jobs
jobs -l                         # PID 포함

# 백그라운드 작업을 포그라운드로 전환
fg %1                           # 작업 번호 1

# 포그라운드 작업을 백그라운드로 전환
Ctrl+Z                          # 현재 작업 일시 중지
bg %1                           # 작업 1을 백그라운드에서 재개

# 작업 종료
kill %1                         # 작업 1에 SIGTERM 전송
kill -9 %1                      # SIGKILL 전송 (강제 종료)
```

### 9.2 프로세스 우선순위

```bash
nice -n 10 command              # 낮은 우선순위로 실행
renice -n 5 -p PID              # 실행 중인 프로세스의 우선순위 변경
```

---

<br>

## 10. 모범 사례

### 10.1 셸 효율성

- 빠른 입력을 위해 `Tab` 자동 완성 활용
- 전체 명령어를 입력하는 대신 `Ctrl+R`로 히스토리 검색 활용
- 자주 사용하는 명령어에 대해 별칭 생성
- 가독성을 위해 백틱 대신 `$()` 명령 치환 사용
- 단어 분리를 방지하기 위해 변수를 큰따옴표로 감싸기

### 10.2 보안 고려사항

- 기록될 수 있는 환경 변수에 비밀번호를 저장하지 않기
- `PATH` 수정 시 주의 (PATH 앞에 `.`을 추가하지 않기)
- 민감한 변수는 `export -n`으로 내보내기 해제
- 셸 히스토리에서 민감한 정보 확인

---

<br>

## 요약

| 개념 | 핵심 내용 |
|---------|-----------|
| 셸 | 사용자와 커널 사이의 명령 해석기 |
| Bash | 대부분의 Linux 시스템에서 기본 셸 (`/bin/bash`) |
| 환경 변수 | `$HOME`, `$PATH`, `$SHELL`, `$USER`, `$PS1` |
| 초기화 파일 | `/etc/profile`, `~/.bashrc`, `~/.profile` |
| 별칭 | 명령어 단축키 (`alias ll='ls -la'`) |
| 히스토리 | `history`, `!!`, `!n`, `Ctrl+R`로 검색 |
| 메타문자 | `*`, `?`, `\|`, `>`, `>>`, `&`, `;`, `$` |
| 인용 | 작은따옴표 (리터럴), 큰따옴표 (변수 확장) |
| 작업 제어 | `&` (백그라운드), `fg`/`bg`, `Ctrl+Z` (일시 중지) |

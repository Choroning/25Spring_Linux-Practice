# 2주차 — Linux 설치 및 기본 사용법

> **최종 수정일:** 2026-04-01

> **선수 지식**: 강좌 소개 (1주차).
>
> **학습 목표**:
> 1. 가상 머신 또는 듀얼 부팅으로 Linux를 설치할 수 있다
> 2. 설치 중 기본 시스템 설정을 구성할 수 있다
> 3. Linux 데스크톱 환경을 탐색할 수 있다

---

## 목차

1. [Linux 기초](#1-linux-기초)
2. [실습 환경 설정](#2-실습-환경-설정)
3. [Ubuntu Linux 설치](#3-ubuntu-linux-설치)
4. [Linux 데스크톱 환경](#4-linux-데스크톱-환경)
5. [기본 Linux 명령어](#5-기본-linux-명령어)
6. [원격 접속 설정](#6-원격-접속-설정)
7. [모범 사례](#7-모범-사례)
8. [요약](#요약)

---

<br>

## 1. Linux 기초

### 1.1 Linux 커널과 응용 프로그램

Linux 시스템은 두 가지 주요 구성 요소로 이루어진다:

```
+---------------------------+
|    응용 프로그램          |  <-- 텍스트 편집기, 컴파일러, 웹 서버
|  (User Space)             |
+---------------------------+
|       Linux 커널          |  <-- 프로세스 관리, 파일시스템, 메모리, 장치
|  (Kernel Space)           |
+---------------------------+
|        하드웨어           |  <-- CPU, RAM, 디스크, NIC
+---------------------------+
```

- **커널:** 프로세스 스케줄링, 메모리 관리, 파일시스템 운영, 장치 입출력을 관리
- **응용 프로그램:** 커널 위에서 실행되는 사용자 대상 프로그램
- 최신 커널 버전 (2025년 3월 기준): **6.13.5** (https://kernel.org)

### 1.2 Linux 특징

| 특징 | 설명 |
|------|------|
| 오픈소스 | GPL 라이선스 하에 소스 코드 자유 이용 가능 |
| Unix 호환 | 완전한 POSIX 호환성 |
| 다중 사용자 | 여러 사용자가 동시에 시스템 사용 가능 |
| 다중 작업 | 여러 프로세스를 동시에 실행 |
| 안정성 | 재부팅 없이 수년간 운영 가능 |
| 보안 | 내장된 접근 제어, SELinux, AppArmor |
| GUI 지원 | GNOME, KDE, XFCE 데스크톱 환경 |

---

<br>

## 2. 실습 환경 설정

### 2.1 가상 머신 설치

실습에는 VMware Workstation을 사용하여 가상 머신을 생성한다.

**다운로드:** https://www.vmware.com/ (2025년 3월 기준 버전 17.6.2)

### 2.2 Ubuntu를 위한 VM 구성

| 매개변수 | 권장 값 |
|----------|---------|
| 메모리 | 2 GB (최소 1 GB) |
| 디스크 | 20 GB (동적 할당) |
| CPU | 2코어 |
| 네트워크 | NAT 모드 |
| 게스트 OS | Ubuntu 22.04 LTS |

### 2.3 VMware 편의 기능

```bash
# 주요 단축키
Ctrl + Alt         # VM에서 호스트로 마우스 해제
Ctrl + Alt + Enter  # 전체 화면 모드 전환
```

- **Clone(복제):** 병렬 테스트를 위해 VM 복제
- **Suspend(일시 중지):** 현재 VM 상태를 저장하고 나중에 재개
- **Snapshot(스냅샷):** 안전한 실험을 위한 복원 지점 생성

---

<br>

## 3. Ubuntu Linux 설치

### 3.1 Ubuntu 다운로드

- **Desktop** (GUI 포함): 초보자에게 적합하며, GNOME 데스크톱 포함
- **Server** (CLI만): 경량으로, 운영 서버용

다운로드: https://ubuntu.com/download

### 3.2 설치 단계

1. VMware에서 새 가상 머신 생성
2. Ubuntu ISO 이미지 선택
3. VM 설정 구성 (메모리, 디스크, 네트워크)
4. ISO로 부팅하고 설치 프로그램을 따라 진행
5. 호스트 이름, 사용자 이름, 비밀번호 설정
6. 설치 완료 후 재부팅

### 3.3 설치 후 설정

```bash
# 패키지 목록 업데이트 및 설치된 패키지 업그레이드
sudo apt update && sudo apt upgrade -y

# 필수 빌드 도구 설치
sudo apt install -y build-essential

# VM 통합을 위한 VMware Tools 설치
sudo apt install -y open-vm-tools open-vm-tools-desktop

# Ubuntu 버전 확인
lsb_release -a

# 커널 버전 확인
uname -r
```

---

<br>

## 4. Linux 데스크톱 환경

### 4.1 GNOME 데스크톱

Ubuntu는 기본적으로 **GNOME** 데스크톱 환경을 사용하며, 다음을 제공한다:
- **Activities 개요:** 응용 프로그램 및 작업 공간 접근
- **응용 프로그램 메뉴:** 설치된 프로그램 실행
- **시스템 트레이:** 네트워크, 소리, 전원 설정
- **파일 관리자 (Nautilus):** GUI 기반 파일 관리

### 4.2 터미널 에뮬레이터

터미널은 Linux 관리에서 가장 중요한 도구이다:

```bash
# 터미널 열기
Ctrl + Alt + T    # Ubuntu GNOME에서의 키보드 단축키

# 터미널 프롬프트 형식
username@hostname:~$    # 일반 사용자
root@hostname:~#        # Root 사용자
```

> **핵심 포인트:** `$` 프롬프트는 일반 사용자를, `#`은 root(슈퍼유저)를 나타낸다.

---

<br>

## 5. 기본 Linux 명령어

### 5.1 시스템 정보 명령어

```bash
# 현재 날짜 및 시간 표시
date
# 출력: Tue Mar 21 14:30:00 KST 2025

# 달력 표시
cal
cal 2025           # 연간 달력

# 로그인된 사용자 표시
who
w                   # 더 자세한 정보

# 시스템 가동 시간 표시
uptime

# 호스트 이름 표시
hostname

# 커널 정보 표시
uname -a
```

### 5.2 사용자 명령어

```bash
# 현재 사용자 이름 표시
whoami

# 사용자 전환
su - username       # 다른 사용자로 전환
su -                # root로 전환

# 슈퍼유저로 실행
sudo command        # 단일 명령어를 root로 실행
sudo -i             # root 셸 열기
```

### 5.3 도움말 및 매뉴얼 페이지

```bash
# 명령어 매뉴얼 표시
man ls              # ls의 매뉴얼 페이지
man -k keyword      # 키워드로 매뉴얼 검색

# 간단한 도움말
ls --help           # 대부분의 명령어에 내장된 도움말
info ls             # GNU info 문서

# 명령어 유형 표시
type ls             # 명령어가 내장, 별칭, 외부인지 표시
which ls            # 명령어 바이너리의 경로 표시
```

### 5.4 시스템 제어

```bash
# 시스템 종료
sudo shutdown -h now          # 즉시 종료
sudo shutdown -h +10          # 10분 후 종료
sudo poweroff                 # 대체 종료 명령어

# 시스템 재부팅
sudo shutdown -r now          # 즉시 재부팅
sudo reboot                   # 대체 재부팅 명령어

# 예약된 종료 취소
sudo shutdown -c
```

### 5.5 명령줄 편집 단축키

| 단축키 | 동작 |
|--------|------|
| `Ctrl + A` | 줄의 시작으로 커서 이동 |
| `Ctrl + E` | 줄의 끝으로 커서 이동 |
| `Ctrl + U` | 커서에서 줄의 시작까지 삭제 |
| `Ctrl + K` | 커서에서 줄의 끝까지 삭제 |
| `Ctrl + L` | 화면 지우기 |
| `Ctrl + C` | 현재 명령어 취소 |
| `Ctrl + D` | 로그아웃 / EOF 신호 |
| `Tab` | 명령어 또는 파일 이름 자동 완성 |
| `Up/Down` | 명령어 히스토리 탐색 |

---

<br>

## 6. 원격 접속 설정

### 6.1 SSH (Secure Shell)

```bash
# Ubuntu에 SSH 서버 설치
sudo apt install -y openssh-server

# SSH 서비스 상태 확인
sudo systemctl status ssh

# 부팅 시 SSH 자동 시작 설정
sudo systemctl enable ssh

# 다른 머신에서 접속
ssh username@ip_address
ssh -p 2222 username@ip_address    # 사용자 지정 포트
```

### 6.2 IP 주소 확인

```bash
# 네트워크 인터페이스 정보 표시
ip addr show
ip a                # 축약형

# 레거시 명령어
ifconfig            # 필요 시: sudo apt install net-tools
```

---

<br>

## 7. 모범 사례

### 7.1 보안

- 사용자 계정에 항상 강력한 비밀번호 사용
- root로 직접 로그인하는 대신 `sudo` 사용
- `apt update && apt upgrade`로 시스템을 최신 상태로 유지
- 운영 환경에서는 root SSH 로그인 비활성화

### 7.2 흔한 실수

| 실수 | 결과 | 예방 |
|------|------|------|
| 모든 작업을 root로 실행 | 보안 위험, 실수로 인한 손상 | 특정 명령어에만 `sudo` 사용 |
| 업데이트 생략 | 취약점 노출 | 정기적으로 `apt update && upgrade` 실행 |
| 약한 비밀번호 | 무단 접근 용이 | 강력하고 고유한 비밀번호 사용 |
| 백업 무시 | 데이터 손실 | 스냅샷과 정기적인 백업 활용 |

---

<br>

## 요약

| 개념 | 핵심 사항 |
|------|-----------|
| Linux 구성 요소 | 커널 (자원 관리) + 응용 프로그램 (사용자 프로그램) |
| VMware | 여러 운영체제를 실행하기 위한 가상 머신 소프트웨어 |
| Ubuntu | Debian 기반 배포판으로, 초보자에게 가장 인기 |
| 터미널 | 시스템 관리의 주요 인터페이스 (`Ctrl+Alt+T`) |
| 프롬프트 | `$` = 일반 사용자, `#` = root 사용자 |
| SSH | 안전한 원격 접속 프로토콜 (포트 22) |
| sudo | 슈퍼유저 권한으로 명령어를 안전하게 실행 |
| man 페이지 | 내장 문서 시스템 (`man command`) |

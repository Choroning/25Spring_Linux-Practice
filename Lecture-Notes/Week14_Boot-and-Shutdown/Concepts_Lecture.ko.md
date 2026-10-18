# 14주차 이론 — 부팅과 종료

[레포지토리 안내](../../README.ko.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **최종 수정일:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 8

> **학습 목표:**
> 1. Linux 부팅 과정(BIOS/UEFI, GRUB, init/systemd)과 부트로더의 역할을 설명할 수 있다
> 2. GRUB 부트로더 설정을 구성할 수 있다
> 3. systemctl로 시스템 서비스를 관리할 수 있다
> 4. 런레벨과 systemd 타겟을 이해하고 변경할 수 있다
> 5. 시스템 종료 방법과 데몬, 슈퍼데몬의 역할을 설명할 수 있다
> 6. root 계정의 비밀번호를 복구할 수 있다

---

## 목차

- [1. Linux 부팅 과정](#1-linux-부팅-과정)
  - [1.1 부팅 순서 개요](#11-부팅-순서-개요)
  - [1.2 상세 부팅 단계](#12-상세-부팅-단계)
  - [1.3 바이오스 단계](#13-바이오스-단계)
  - [1.4 부트로더 단계](#14-부트로더-단계)
  - [1.5 커널 초기화 단계](#15-커널-초기화-단계)
  - [1.6 systemd 서비스 단계](#16-systemd-서비스-단계)
  - [1.7 부팅 메시지 확인: dmesg](#17-부팅-메시지-확인-dmesg)
  - [1.8 1번 프로세스](#18-1번-프로세스)
- [2. BIOS/UEFI와 부트로더](#2-biosuefi와-부트로더)
  - [2.1 BIOS vs. UEFI](#21-bios-vs-uefi)
  - [2.2 부팅 디스크 구조 (MBR)](#22-부팅-디스크-구조-mbr)
- [3. GRUB 부트로더](#3-grub-부트로더)
  - [3.1 GRUB 개요](#31-grub-개요)
  - [3.2 GRUB2 설정](#32-grub2-설정)
  - [3.3 주요 GRUB 설정](#33-주요-grub-설정)
  - [3.4 GRUB 부팅 메뉴](#34-grub-부팅-메뉴)
- [4. systemd와 Init 시스템](#4-systemd와-init-시스템)
  - [4.1 systemd 개요](#41-systemd-개요)
  - [4.2 systemd 유닛](#42-systemd-유닛)
  - [4.3 systemctl: 서비스 관리](#43-systemctl-서비스-관리)
  - [4.4 서비스 보기](#44-서비스-보기)
  - [4.5 journalctl: 시스템 로그](#45-journalctl-시스템-로그)
- [5. 런레벨과 타겟](#5-런레벨과-타겟)
  - [5.1 SysV 런레벨 vs. systemd 타겟](#51-sysv-런레벨-vs-systemd-타겟)
  - [5.2 타겟 관리](#52-타겟-관리)
  - [5.3 init과 telinit](#53-init과-telinit)
  - [5.4 단일 사용자 모드](#54-단일-사용자-모드)
- [6. 시스템 종료와 재부팅](#6-시스템-종료와-재부팅)
  - [6.1 종료 방법](#61-종료-방법)
  - [6.2 shutdown 명령](#62-shutdown-명령)
  - [6.3 종료 명령어](#63-종료-명령어)
- [7. 데몬 프로세스](#7-데몬-프로세스)
  - [7.1 데몬과 동작 방식](#71-데몬과-동작-방식)
  - [7.2 데몬의 조상](#72-데몬의-조상)
  - [7.3 주요 데몬](#73-주요-데몬)
- [8. Root 비밀번호 복구](#8-root-비밀번호-복구)
  - [8.1 복구 단계 (Ubuntu/GRUB2)](#81-복구-단계-ubuntugrub2)
  - [8.2 복구 모드로 부팅하기](#82-복구-모드로-부팅하기)
- [9. 모범 사례](#9-모범-사례)
- [요약](#요약)
- [점검 문제](#점검-문제)

---

<br>

## 1. Linux 부팅 과정

### 1.1 부팅 순서 개요

**부팅(booting)** 은 컴퓨터의 전원을 켠 뒤 운영체제가 동작하여 사용자가 로그인할 수 있는 상태가 되기까지의 과정이다. 리눅스의 부팅은 그림 1처럼 바이오스(또는 UEFI) 단계, 부트로더 단계, 커널 초기화 단계, systemd 서비스 단계를 거쳐 로그인 프롬프트를 출력하는 것으로 끝난다. 이 가운데 바이오스 단계는 설치된 운영체제와 관계없이 PC가 공통으로 수행하는 **PC 부팅**이고, 부트로더 단계부터 로그인 프롬프트까지가 **리눅스 부팅**이다.

```text
Power On
    |
    v
+--------+     +-----------+     +--------+     +---------+
|  BIOS/ | --> | Bootloader| --> | Kernel | --> | systemd |
|  UEFI  |     |  (GRUB)   |     | (init) |     | services|
+--------+     +-----------+     +--------+     +---------+
    |                |                |               |
    v                v                v               v
POST &          커널 로드        루트 파일         서비스 시작
부팅 장치       + initramfs     시스템 마운트     (network, ssh,
탐색                                              login 등)
```

*그림 1. Linux의 부팅 순서와 단계별 작업*

### 1.2 상세 부팅 단계

1. **BIOS/UEFI POST:** 하드웨어 자가 검사(POST, Power-On Self-Test)를 수행하고 장치를 초기화한다.
2. **부팅 장치 선택:** 부팅 가능한 장치(HDD, USB, 네트워크)를 탐색한다.
3. **부트로더 (GRUB):** 커널과 초기 RAM 디스크(initramfs)를 메모리에 로드한다.
4. **커널 초기화:** 하드웨어를 감지하고 드라이버를 로드한 뒤 루트 파일 시스템을 마운트한다.
5. **systemd (PID 1):** 시스템 서비스를 병렬로 시작한다.
6. **로그인 프롬프트:** 로그인 화면(GUI 또는 텍스트)을 표시한다.

**초기 RAM 디스크(initramfs)** 는 커널이 실제 루트 파일 시스템을 마운트하기 전에 임시 루트로 쓰는 작은 파일 시스템 이미지이다. 루트 파일 시스템이 있는 디스크를 읽는 데 필요한 드라이버와 도구가 들어 있다. 1.3~1.6절은 각 단계를 자세히 설명한다.

### 1.3 바이오스 단계

바이오스(BIOS)는 PC에 장착된 기본적인 하드웨어(키보드, 디스크 등)의 상태를 확인한 뒤 부팅 장치를 선택하고, 부팅 디스크의 첫 섹터에서 512바이트를 메모리로 읽어 들인다. 이 512바이트를 **마스터 부트 레코드(MBR, Master Boot Record)** 라 하며, 디스크의 어느 파티션에 2차 부팅 프로그램인 부트로더가 있는지에 대한 정보가 저장되어 있다(2.2절). 메모리에 로딩된 MBR의 코드는 부트로더를 찾아 메모리에 로딩하는 작업까지 수행한다. UEFI를 쓰는 시스템은 MBR의 코드 대신 디스크의 EFI 시스템 파티션(ESP)에 저장된 부트로더 프로그램을 펌웨어가 직접 읽어 실행한다.

### 1.4 부트로더 단계

**부트로더(bootloader)** 는 리눅스 커널을 메모리에 로딩하는 역할을 수행한다. 일반적으로 여러 운영체제나 여러 커널 버전 중에서 부팅할 것을 선택할 수 있도록 메뉴를 제공하며, 우분투는 부트로더로 GRUB를 사용한다(3절). 리눅스 커널은 `/boot` 디렉터리 아래에 `vmlinuz-버전명` 형태의 파일로 제공된다(예: `/boot/vmlinuz-5.13.0-22-generic`).

우분투는 기본 설정에서 GRUB 메뉴를 숨기고 바로 부팅한다. 부팅할 때 GRUB 메뉴를 출력하려면 `/etc/default/grub` 파일을 다음과 같이 수정한 뒤 `sudo update-grub`을 실행하여 변경된 내용을 적용한다(3.3절). 그러면 우분투를 다시 시작할 때 GRUB 메뉴가 출력된다.

- `GRUB_TIMEOUT_STYLE=hidden` 앞에 `#`을 추가하여 주석으로 만든다.
- `GRUB_TIMEOUT=0`을 `GRUB_TIMEOUT=10`으로 수정한다.

### 1.5 커널 초기화 단계

부트로더에 의해 메모리에 로딩된 커널은 가장 먼저 시스템에 연결된 메모리, 디스크, 키보드, 마우스 등의 장치를 검사하고 필요한 드라이버를 초기화한다. 장치 검사 등 기본적인 초기화 과정이 끝나면 커널은 커널 스레드(7.2절)와 첫 번째 사용자 프로세스를 생성하고, 루트 파일 시스템을 마운트한 뒤 1번 프로세스인 systemd를 실행한다.

### 1.6 systemd 서비스 단계

systemd가 시작되면 리눅스가 본격적으로 동작한다. systemd는 설정된 기본 타겟(5절)에 필요한 서비스를 병렬로 시작하며, 이 동안 화면에는 부트 스플래시 화면이 출력된다. 커널 매개변수에서 `quiet splash`를 빼면 스플래시 화면 대신 세부 부팅 메시지가 출력된다(3.3절). 모든 서비스가 시작되면 부팅이 완료되고 로그인 화면이 출력된다.

### 1.7 부팅 메시지 확인: dmesg

`dmesg`는 커널이 부팅 과정에서 출력한 메시지가 저장된 커널 링 버퍼의 내용을 출력한다. 메시지가 길므로 `more`로 한 화면씩 본다. 각 줄 앞의 `[ ]` 안 숫자는 커널이 시작된 뒤 지난 시간(초)이다.

```text
user1@myubuntu:~$ sudo dmesg | more
[    0.000000] Linux version 5.13.0-22-generic (buildd@lgw01-amd64-012) (gcc (Ubuntu 11.2.0-7ubuntu2) 11.2.0, GNU ld (GNU Binutils for Ubuntu) 2.37) #22-Ubuntu SMP Fri Nov 5 13:21:36 UTC 2021 (Ubuntu 5.13.0-22.22-generic 5.13.19)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.13.0-22-generic root=UUID=265c8913-ee1e-4034-885f-207969b0a23b ro splash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000]   zhaoxin   Shanghai
[    0.000000] Disabled fast string operations
(생략)
```

첫 줄은 커널 버전을, 둘째 줄의 `Command line`은 부트로더가 커널에 넘긴 매개변수(커널 이미지, 루트 파일 시스템의 UUID, `ro`, `splash`)를 보여 준다.

### 1.8 1번 프로세스

커널이 처음 실행하는 사용자 프로세스는 PID 1을 받으며, 다른 모든 사용자 프로세스의 조상이 된다. 전통적으로 1번 프로세스는 `init`이었고, `ps -ef`로 확인하면 지금도 1번 프로세스가 `/sbin/init`으로 표시된다.

```text
user1@myubuntu:~$ ps -ef | more
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 12:26 ?        00:00:01 /sbin/init splash
root           2       0  0 12:26 ?        00:00:00 [kthreadd]
root           3       2  0 12:26 ?        00:00:00 [rcu_gp]
root           4       2  0 12:26 ?        00:00:00 [rcu_par_gp]
(생략)
```

1번 프로세스가 여전히 `init`인 것처럼 보이지만, 사실 `/sbin/init`은 systemd 실행 파일의 심볼릭 링크이다. 따라서 실제로 1번 프로세스로 실행되는 프로그램은 systemd이다.

```text
user1@myubuntu:~$ ls -l /sbin/init
lrwxrwxrwx 1 root root 20 11월 21 11:10 /sbin/init -> /lib/systemd/systemd
```

---

<br>

## 2. BIOS/UEFI와 부트로더

### 2.1 BIOS vs. UEFI

**BIOS(Basic Input/Output System)** 는 메인보드의 ROM에 저장된 전통적인 펌웨어이고, **UEFI(Unified Extensible Firmware Interface)** 는 BIOS를 대체하기 위해 만든 현대적인 펌웨어 규격이다. 두 펌웨어의 특징은 다음과 같다.

| 특징 | BIOS | UEFI |
|------|------|------|
| 파티션 테이블 | MBR | GPT |
| 최대 부팅 디스크 | 2 TB | 9.4 ZB |
| 부팅 속도 | 느림 | 빠름 |
| 인터페이스 | 텍스트 기반 | 그래픽 |
| Secure Boot | 미지원 | 지원 |
| 아키텍처 | 16-bit | 32/64-bit |

*표 1. BIOS와 UEFI의 비교*

표의 파티션 테이블은 각 펌웨어가 일반적으로 함께 쓰는 형식이다. UEFI도 호환 모드로 MBR 디스크를 부팅할 수 있고, GRUB를 쓰면 BIOS로 GPT 디스크를 부팅할 수도 있다. 최대 부팅 디스크 크기의 차이는 파티션 테이블에서 온다. MBR은 섹터 번호를 32비트로 저장하므로 512바이트 섹터에서 $2^{32} \times 512$바이트, 약 2 TB까지만 다룰 수 있고, GPT는 64비트로 저장하므로 $2^{64} \times 512$바이트, 약 9.4 ZB까지 다룰 수 있다. **Secure Boot**는 서명이 확인된 부트로더와 커널만 실행하게 하여 부팅 과정에 악성 코드가 끼어드는 것을 막는 UEFI의 기능이다.

### 2.2 부팅 디스크 구조 (MBR)

```text
+---+-----------------------------------+
|MBR| Partition 1 | Partition 2 | ...   |
+---+-----------------------------------+
 |
 +-- 446 bytes: 부트로더 코드
 +-- 64 bytes: 파티션 테이블 (4개 항목)
 +-- 2 bytes: 매직 넘버 (0x55AA)
```

*그림 2. MBR 방식 부팅 디스크의 구조와 MBR의 구성*

MBR은 디스크의 첫 섹터 512바이트(446 + 64 + 2)를 차지한다. 앞의 446바이트에는 부트로더의 첫 단계 코드가 들어 있고, 64바이트의 파티션 테이블은 16바이트 항목 4개로 이루어져 주 파티션을 최대 4개까지 기록한다. 마지막 2바이트는 이 섹터가 유효한 부트 섹터임을 나타내는 부트 시그니처(magic number) `0x55AA`이다.

---

<br>

## 3. GRUB 부트로더

### 3.1 GRUB 개요

**GRUB(GRand Unified Bootloader)** 는 우분투가 기본으로 지원하는 부트로더이다. GRUB의 특징은 다음과 같다.

- 리눅스뿐 아니라 윈도도 부팅할 수 있으며, 여러 운영체제 중 하나를 골라 부팅하는 멀티 부팅 기능을 지원한다.
- 부팅할 때 명령을 사용하여 부팅 항목을 수정할 수 있으므로, root 비밀번호 복구나 안전 모드 부팅에 쓸 수 있다(8절).
- GRUB의 최신 버전은 GRUB2이다. GRUB2는 GRUB에 비해 이식성과 모듈화가 좋아져 필요한 모듈을 동적으로 로딩하며, 우분투는 GRUB2를 기본 부트로더로 사용한다.

### 3.2 GRUB2 설정

```text
# 주 설정 파일 (자동 생성)
/boot/grub/grub.cfg

# 사용자 정의 설정
/etc/default/grub

# 사용자 정의 메뉴 항목
/etc/grub.d/
```

- **`/boot/grub/grub.cfg`:** GRUB2의 기본 설정 파일이다. `/etc/default/grub` 파일과 `/etc/grub.d` 디렉터리 아래의 스크립트를 읽어서 자동으로 생성되므로 사용자가 직접 수정하지 않는다. 직접 수정해도 다음에 다시 생성될 때 덮어써진다.
- **`/etc/default/grub`:** GRUB 메뉴의 설정 내용이 저장되어 있다. GRUB 스크립트가 이 파일을 읽어서 `grub.cfg`에 기록한다.
- **`/etc/grub.d/`:** GRUB 스크립트를 가지고 있는 디렉터리이다. `grub.cfg`를 만드는 명령이 실행될 때 이 스크립트들이 파일 이름의 번호 순서대로 실행되어 `grub.cfg`의 각 부분을 생성한다. 사용자 정의 메뉴 항목은 `40_custom`에 추가한다.

```text
user1@myubuntu:~$ ls /etc/grub.d
00_header        10_linux      20_linux_xen    30_os-prober      40_custom  README
05_debian_theme  10_linux_zfs  20_memtest86+   30_uefi-firmware  41_custom
```

### 3.3 주요 GRUB 설정

```bash
# /etc/default/grub
GRUB_DEFAULT=0                    # 기본 부팅 항목
GRUB_TIMEOUT=5                    # 타임아웃 (초)
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"  # 커널 매개변수
GRUB_CMDLINE_LINUX=""             # 추가 커널 매개변수
```

`GRUB_DEFAULT=0`은 메뉴의 첫 번째 항목(0부터 센다)을 기본으로 부팅한다는 뜻이고, `GRUB_TIMEOUT`은 메뉴를 보여 주고 기본 항목으로 부팅하기까지 기다리는 시간(초)이다. `GRUB_CMDLINE_LINUX_DEFAULT`의 매개변수는 일반 부팅 항목에만, `GRUB_CMDLINE_LINUX`의 매개변수는 복구 모드를 포함한 모든 항목에 커널 매개변수로 전달된다. `quiet`는 부팅 메시지를 줄이고 `splash`는 부트 스플래시 화면을 출력한다. 다음은 1.4절처럼 GRUB 메뉴가 출력되도록 수정한 파일의 예이다.

```text
user1@myubuntu:~$ cat /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'
GRUB_DEFAULT=0
#GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="splash"
#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""
(생략)
```

```bash
# 편집 후 grub.cfg 재생성
sudo update-grub
# 또는
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

`grub-mkconfig`는 `grub.cfg` 파일을 생성하며, `-o`로 출력 파일을 지정하지 않으면 결과를 표준 출력에 출력한다. `update-grub`은 우분투에서 `grub-mkconfig -o /boot/grub/grub.cfg`를 실행하는 명령이다. `/etc/default/grub`을 수정한 뒤에는 둘 중 하나를 실행해야 변경 내용이 `grub.cfg`에 반영된다.

### 3.4 GRUB 부팅 메뉴

부팅 시 `Shift`(BIOS) 또는 `Esc`(UEFI)를 눌러 GRUB 메뉴에 접근하면 다음 작업을 할 수 있다.

- 다른 커널을 선택한다.
- 복구 모드로 부팅한다(8.2절).
- `e` 키로 부팅 매개변수를 임시로 편집한다. 편집한 내용은 그 부팅에만 적용되고 저장되지 않는다(8.1절).

---

<br>

## 4. systemd와 Init 시스템

### 4.1 systemd 개요

`systemd`는 현대 Linux의 init 시스템이자 서비스 관리자이다 (PID 1). 유닉스의 init 프로세스가 하던 작업을 대신 수행하여, 다양한 서비스 데몬을 시작하고 프로세스들의 상태를 유지하며 시스템의 상태를 관리한다. 현재 우분투에서 init 서비스는 systemd 서비스로 대체되었으며, `man init`으로 확인하면 systemd에 대한 설명이 출력된다.

- 빠른 부팅을 위한 병렬 서비스 시작
- 소켓 및 D-Bus 활성화
- 데몬의 온디맨드 시작
- 시스템 상태의 스냅샷 및 복원
- `journald`를 통한 로그 관리

이 밖에 systemd는 다음과 같은 장점이 있다.

- 소켓 기반으로 동작하여 inetd와 호환성을 유지한다(7.1절).
- 셸과 독립적으로 부팅이 가능하다.
- 마운트와 fsck(파일 시스템 검사)를 제어할 수 있다.
- 서비스에 시그널을 전달할 수 있다.
- 셧다운 전에 사용자 세션을 안전하게 종료할 수 있다.

> **참고:** **스냅샷 기능.** 시스템 상태의 스냅샷을 저장하는 snapshot 유닛은 초기 systemd의 기능이며, systemd 228(2015년)에서 제거되었다. 현재 배포판에서는 쓸 수 없다.

### 4.2 systemd 유닛

systemd는 **유닛(unit)** 이라 부르는 구성 요소를 사용하여 전체 시스템을 시작하고 관리한다. 관리 대상의 이름은 `서비스명.유닛종류` 형태이며, 예를 들어 `cron.service`는 cron 서비스 유닛, `multi-user.target`은 타겟 유닛이다. 유닛의 종류는 다음과 같다.

| 유닛 | 기능 | 예 |
|------|------|----|
| service | 시스템 서비스 유닛으로 데몬을 시작, 종료, 재시작, 로드한다. | `atd.service` |
| target | 유닛을 그루핑한다. 예를 들어 `multi-user.target`은 런레벨 3에 해당하는 유닛들의 묶음이다. | `basic.target` |
| automount | 디렉터리 계층 구조에서 자동 마운트 포인트를 관리한다. | `proc-sys-fs-binfmt_misc.automount` |
| device | 리눅스 장치 트리에 있는 장치를 관리한다. | `sys-module-fuse.device` |
| mount | 디렉터리 계층 구조의 마운트 포인트를 관리한다. | `boot.mount` |
| path | 파일 시스템의 파일이나 디렉터리 등 경로를 관리한다. | `cups.path` |
| scope | 외부에서 생성된 프로세스를 관리한다. | `init.scope` |
| slice | 시스템의 프로세스를 계층적으로 관리한다. | `system-getty.slice` |
| socket | 소켓을 관리하는 유닛으로 AF_INET, AF_INET6, AF_UNIX 소켓 스트림과 데이터그램, FIFO를 지원한다. | `dbus.socket` |
| swap | 스왑 장치를 관리한다. | `dev-mapper-fedora\x2dswap.swap` |
| timer | 타이머와 관련된 기능을 관리한다. | `dnf-makecache.timer` |

*표 2. systemd 유닛의 종류*

### 4.3 systemctl: 서비스 관리

`systemctl`은 systemd 서비스를 제어하는 명령이며, 형식은 `systemctl [옵션] [명령] [유닛명]`이다. 유닛명에서 `.service`는 생략할 수 있다.

```bash
# 서비스 제어
sudo systemctl start service          # 서비스 시작
sudo systemctl stop service           # 서비스 중지
sudo systemctl restart service        # 서비스 재시작
sudo systemctl reload service         # 설정 다시 불러오기
sudo systemctl status service         # 상태 확인
sudo systemctl enable service         # 부팅 시 자동 시작 활성화
sudo systemctl disable service        # 부팅 시 자동 시작 비활성화
sudo systemctl is-active service      # 실행 중인지 확인
sudo systemctl is-enabled service     # 활성화 여부 확인

# 예시
sudo systemctl status ssh
sudo systemctl restart nginx
sudo systemctl enable docker
```

| 옵션, 명령 | 기능 |
|------------|------|
| `-a` | 상태와 관계없이 유닛 전체를 출력한다. |
| `-t 유닛종류` | 지정한 종류의 유닛만 출력한다(예: `systemctl -t service`). |
| `start`, `stop` | 유닛을 시작하거나 정지한다. |
| `reload` | 유닛의 설정 파일을 다시 읽어 온다. |
| `restart` | 유닛을 재시작한다. |
| `status` | 유닛의 상태를 출력한다. |
| `enable`, `disable` | 부팅할 때 유닛이 시작되도록 하거나 시작되지 않도록 설정한다. |
| `is-active` | 유닛이 동작하고 있는지 확인한다. |
| `is-enabled` | 유닛이 부팅 시 시작되도록 설정되었는지 확인한다. |
| `isolate` | 지정한 유닛과 이와 관련된 유닛만 시작하고 나머지는 정지한다. |
| `kill` | 유닛의 프로세스에 시그널을 전송한다. |

*표 3. systemctl의 주요 옵션과 명령*

`start`와 `stop`은 지금 당장의 실행 상태만 바꾸고, `enable`과 `disable`은 다음 부팅부터의 자동 시작 여부만 바꾼다. 따라서 서비스를 지금 시작하고 부팅할 때마다 시작되게 하려면 둘 다 실행하거나 `systemctl enable --now`를 쓴다. `reload`는 프로세스를 다시 시작하지 않고 설정만 다시 읽게 하며, 이를 지원하지 않는 서비스도 있다. 다음은 cron 서비스를 시작하고 동작 여부를 확인하는 예이다. 상태는 `systemctl status cron`으로 자세히 보고, `sudo systemctl stop cron`으로 정지한다.

```text
user1@myubuntu:~$ sudo systemctl start cron
user1@myubuntu:~$ systemctl is-active cron
active
```

### 4.4 서비스 보기

```bash
systemctl list-units --type=service              # 활성 서비스
systemctl list-units --type=service --all         # 모든 서비스
systemctl list-unit-files --type=service          # 모든 유닛 파일
```

옵션 없이 `systemctl`만 실행하면 현재 메모리에 로드되어 동작 중인 유닛이 출력된다. `-a`를 붙이면 비활성 유닛까지, `-t service`나 `--type=service`를 붙이면 서비스 유닛만 출력한다.

```text
user1@myubuntu:~$ systemctl
  UNIT                   LOAD   ACTIVE SUB    DESCRIPTION
(생략)
  basic.target           loaded active active Basic System
  bluetooth.target       loaded active active Bluetooth
  cryptsetup.target      loaded active active Local Encrypted Volumes
  getty.target           loaded active active Login Prompts
  graphical.target       loaded active active Graphical Interface
  local-fs-pre.target    loaded active active Local File Systems (Pre)
  local-fs.target        loaded active active Local File Systems
  multi-user.target      loaded active active Multi-User System
  network-online.target  loaded active active Network is Online
  network.target         loaded active active Network
(생략)
LOAD   = Reflects whether the unit definition was properly loaded.
ACTIVE = The high-level unit activation state, i.e. generalization of SUB.
SUB    = The low-level unit activation state, values depend on unit type.
229 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
```

`LOAD`는 유닛 정의가 제대로 로드되었는지, `ACTIVE`는 유닛의 활성화 상태를 일반화한 값(`active`, `inactive`, `failed` 등)을, `SUB`는 유닛 종류에 따라 달라지는 세부 상태(서비스의 `running`, `exited` 등)를 나타낸다.

### 4.5 journalctl: 시스템 로그

`journalctl`은 systemd의 로그 서비스인 journald가 수집한 로그를 조회한다.

```bash
journalctl                           # 모든 로그
journalctl -b                        # 마지막 부팅 이후 로그
journalctl -u ssh                    # 특정 서비스 로그
journalctl -f                        # 실시간 로그 추적 (tail -f와 유사)
journalctl --since "2025-03-21"      # 특정 날짜 이후 로그
journalctl -p err                    # 에러 수준 로그만
```

`-u`는 유닛 이름으로 로그를 거르고, `-p err`는 우선순위가 err 이상(err, crit, alert, emerg)인 로그만 보여 준다. 일반 사용자는 자신의 로그만 볼 수 있으므로, 시스템 전체의 로그를 보려면 `sudo`를 붙이거나 `adm` 또는 `systemd-journal` 그룹에 속해야 한다.

---

<br>

## 5. 런레벨과 타겟

### 5.1 SysV 런레벨 vs. systemd 타겟

**런레벨(runlevel)** 은 시스템의 상태를 구분하는 숫자나 문자이다. SysV init은 런레벨마다 실행할 서비스를 정해 두었고, systemd는 런레벨 대신 타겟 유닛으로 시스템 상태를 정의한다. 호환성을 위해 `runlevel0.target`부터 `runlevel6.target`까지의 타겟 파일이 실제 타겟 유닛을 가리키는 심볼릭 링크로 제공된다.

| 런레벨 | 타겟 파일 (심볼릭 링크) | systemd 타겟 | 설명 |
|--------|------------------------|-------------|------|
| 0 | `runlevel0.target` | `poweroff.target` | 정지 / 전원 끄기 |
| 1, S, s | `runlevel1.target` | `rescue.target` | 단일 사용자 / 복구 모드 |
| 2 | `runlevel2.target` | `multi-user.target` | 다중 사용자 (네트워크 없음) |
| 3 | `runlevel3.target` | `multi-user.target` | 네트워크 포함 다중 사용자 |
| 4 | `runlevel4.target` | `multi-user.target` | 미사용 / 사용자 정의 |
| 5 | `runlevel5.target` | `graphical.target` | 네트워크 포함 GUI |
| 6 | `runlevel6.target` | `reboot.target` | 재부팅 |

*표 4. SysV 런레벨과 systemd 타겟의 대응*

> **참고:** **런레벨 2\~4.** systemd에서는 런레벨 2, 3, 4가 모두 `multi-user.target`에 연결되므로 셋은 같은 다중 사용자 모드이다. 표의 2(네트워크 없음), 3(네트워크 포함), 4(미사용) 구분은 Red Hat 계열 SysV init의 관례이며, Debian과 Ubuntu의 SysV init은 런레벨 2\~5를 같은 다중 사용자 모드로 썼다.

### 5.2 타겟 관리

```bash
# 현재 타겟 확인
systemctl get-default

# 기본 타겟 설정
sudo systemctl set-default graphical.target    # GUI로 부팅
sudo systemctl set-default multi-user.target   # CLI로 부팅

# 즉시 타겟 전환
sudo systemctl isolate multi-user.target       # 지금 CLI로 전환
sudo systemctl isolate graphical.target        # 지금 GUI로 전환
```

`systemctl get-default`는 부팅할 때 쓰는 기본 타겟을 출력하고, `runlevel`은 직전 런레벨과 현재 런레벨을 출력한다. 다음 출력의 `N 5`는 직전 런레벨이 없고(N) 런레벨 5로 부팅되었다는 뜻이다.

```text
user1@myubuntu:~$ systemctl get-default
graphical.target
user1@myubuntu:~$ runlevel
N 5
```

기본 타겟은 `systemctl set-default <타겟 이름>.target`으로 지정한다. 기본 타겟은 `/etc/systemd/system/default.target` 심볼릭 링크가 가리키는 타겟이므로, `set-default`는 이 링크를 다시 만든다.

```text
user1@myubuntu:~$ sudo systemctl set-default multi-user.target
Created symlink /etc/systemd/system/default.target → /lib/systemd/system/multi-user.target.
user1@myubuntu:~$ ls -l /etc/systemd/system/default.target
lrwxrwxrwx 1 root root 37  1월  1 13:31 /etc/systemd/system/default.target -> /lib/systemd/system/multi-user.target
user1@myubuntu:~$ sudo systemctl set-default graphical.target
Removed /etc/systemd/system/default.target.
Created symlink /etc/systemd/system/default.target → /lib/systemd/system/graphical.target.
```

`set-default`는 다음 부팅부터 적용된다. 지금 바로 타겟을 바꾸려면 `isolate`를 쓰며, `.target`을 생략하거나 런레벨 이름의 타겟을 써도 된다. 예를 들어 `systemctl isolate multi-user`와 `systemctl isolate runlevel3`은 `multi-user.target`(런레벨 3)으로, `systemctl isolate graphical`과 `systemctl isolate runlevel5`는 `graphical.target`(런레벨 5)으로 변경한다.

### 5.3 init과 telinit

전통적인 `init`과 `telinit` 명령으로도 런레벨을 바꿀 수 있다. 지금의 `/sbin/telinit`은 `/bin/systemctl`의 심볼릭 링크이며, `init 숫자`는 해당하는 `runlevelX.target`으로의 전환 요청으로 처리된다.

```text
user1@myubuntu:~$ init --help
init [OPTIONS...] COMMAND

Send control commands to the init daemon.

Commands:
  0              Power-off the machine
  6              Reboot the machine
  2, 3, 4, 5     Start runlevelX.target unit
  1, s, S        Enter rescue mode
  q, Q           Reload init daemon configuration
  u, U           Reexecute init daemon

Options:
     --help      Show this help
     --no-wall   Don't send wall message before halt/power-off/reboot

See the telinit(8) man page for details.
user1@myubuntu:~$ ls -l /sbin/telinit
lrwxrwxrwx 1 root root 14 11월 21 11:10 /sbin/telinit -> /bin/systemctl
```

```text
# init 0       // shutdown
# telinit 0
# init 3       // multi-user target
# init 5       // graphical-user target
# init 6       // reboot
```

### 5.4 단일 사용자 모드

시스템에 문제가 있을 때는 시스템을 `rescue.target` 유닛(런레벨 1, 런레벨 S)으로 변경하여 점검한다. 이 상태를 **단일 사용자 모드(single-user mode)** 라 하며, 필수 서비스만 실행되고 root만 로그인하여 작업할 수 있다. 다음 네 명령은 모두 단일 사용자 모드로 전환한다.

```text
systemctl isolate rescue
systemctl isolate runlevel1
init 1
telinit S
```

단일 사용자 모드에서 다중 사용자 모드로 돌아가려면 `reboot` 명령으로 재시작하거나 `systemctl default` 명령으로 기본 타겟으로 전환한다.

---

<br>

## 6. 시스템 종료와 재부팅

### 6.1 종료 방법

리눅스를 종료하는 방법은 다음과 같다.

- `shutdown` 명령을 사용한다.
- `halt` 명령을 사용한다.
- `poweroff` 명령을 사용한다.
- 런레벨을 0이나 6으로 전환한다.
- `reboot` 명령을 사용한다.
- 전원을 끈다.

리눅스는 디스크에 쓸 데이터를 메모리에 모아 두었다가 기록하므로, 정상적인 종료 절차 없이 전원을 끄면 기록되지 않은 데이터를 잃거나 파일 시스템이 손상될 수 있다. 전원 차단은 시스템이 응답하지 않을 때만 쓴다.

### 6.2 shutdown 명령

`shutdown`은 리눅스 시스템을 가장 정상적으로 종료하는 방법이다. 로그인한 모든 사용자에게 종료 메시지를 보내고, 새 로그인을 막은 뒤 지정한 시간에 시스템을 종료한다. 형식은 `shutdown [옵션] [시간] [메시지]`이다.

| 항목 | 의미 |
|------|------|
| `-k` | 실제로 시스템을 종료하지 않고 사용자들에게 메시지만 전달한다. |
| `-r` | 종료한 후 재시작한다. |
| `-h` | 시스템을 종료한다. 전통적으로는 halt 상태로 이동하며, systemd의 `shutdown`에서는 `--halt`를 함께 주지 않으면 전원까지 끈다. |
| `-f` | 빠른 재시작으로, 이 과정에서 fsck를 생략할 수 있다. SysV init의 `shutdown` 옵션이며 systemd의 `shutdown`에는 없다. |
| `-c` | 이전에 내린 `shutdown` 명령을 취소한다. |
| 시간 | 종료할 시간이다. `hh:mm`(시각), `+m`(m분 후), `now`(즉시)로 지정한다. |
| 메시지 | 모든 사용자에게 보낼 메시지이다. |

*표 5. shutdown의 옵션과 인자*

```text
user1@myubuntu:~$ sudo shutdown -h now
user1@myubuntu:~$ sudo shutdown -h +2 "System is going down in 2 min"
user1@myubuntu:~$ sudo shutdown -r +3
user1@myubuntu:~$ sudo shutdown -c
user1@myubuntu:~$ sudo shutdown -k 2
```

위 명령은 차례로 시스템을 즉시 종료하고, 2분 뒤 종료한다는 메시지를 보내고 종료하고, 3분 뒤 재시작하고, 예약된 명령을 취소하고, 2분 뒤 종료한다는 메시지만 보낸다.

### 6.3 종료 명령어

```bash
sudo shutdown -h now                 # 즉시 종료
sudo shutdown -h +10                 # 10분 후 종료
sudo shutdown -h 22:00               # 오후 10시에 종료
sudo shutdown -r now                 # 즉시 재부팅
sudo shutdown -c                     # 예약된 종료 취소
sudo poweroff                        # 전원 끄기
sudo halt                            # 시스템 정지
sudo reboot                          # 재부팅
sudo init 0                          # 종료 (SysV)
sudo init 6                          # 재부팅 (SysV)
```

`halt`는 운영체제를 정지시키지만 전원은 끄지 않을 수 있고, `poweroff`는 정지한 뒤 전원까지 끈다. 런레벨을 0으로 바꾸면 시스템이 종료되고, 6으로 바꾸면 재시작된다. systemd에서는 타겟을 직접 지정하여 같은 일을 할 수 있다.

```text
user1@myubuntu:~$ sudo systemctl isolate poweroff.target
user1@myubuntu:~$ sudo systemctl isolate runlevel0.target
user1@myubuntu:~$ sudo systemctl isolate reboot.target
user1@myubuntu:~$ sudo systemctl isolate runlevel6.target
```

앞의 두 명령은 시스템을 종료하고, 뒤의 두 명령은 재시작한다. `halt`, `poweroff`, `reboot`는 모두 `systemctl` 명령의 심볼릭 링크이다. `systemctl`은 자신이 어떤 이름으로 실행되었는지 보고 해당하는 동작을 수행한다.

```text
user1@myubuntu:~$ ls -l /sbin/halt
lrwxrwxrwx 1 root root 14 11월 21 11:10 /sbin/halt -> /bin/systemctl
user1@myubuntu:~$ ls -l /sbin/poweroff
lrwxrwxrwx 1 root root 14 11월 21 11:10 /sbin/poweroff -> /bin/systemctl
user1@myubuntu:~$ ls -l /sbin/reboot
lrwxrwxrwx 1 root root 14 11월 21 11:10 /sbin/reboot -> /bin/systemctl
```

---

<br>

## 7. 데몬 프로세스

### 7.1 데몬과 동작 방식

**데몬(daemon)** 은 리눅스의 백그라운드에서 동작하며 특정한 서비스를 제공하는 프로세스이다. 데몬이 동작하는 방식은 두 가지이다.

- **독자형 데몬(stand-alone daemon):** 시스템이 시작될 때부터 계속 실행되면서 서비스 요청을 직접 받아 처리한다. 요청에 바로 응답할 수 있지만, 요청이 없어도 메모리를 차지한다.
- **슈퍼데몬을 통한 동작:** 평소에는 실행되지 않다가 요청이 들어오면 슈퍼데몬이 해당 데몬을 실행한다.

**슈퍼데몬(super daemon)** 은 데몬들을 관리하는 데몬이다. 사용자가 네트워크 서비스를 요청하면 슈퍼데몬이 요청을 받아서 해당하는 서비스 데몬을 동작시킨다. 유닉스의 슈퍼데몬은 inetd였고, 이후 보안 기능이 포함된 xinetd가 쓰였다. systemd를 쓰는 현재 배포판에서는 systemd가 소켓 유닛으로 요청을 받아 서비스를 시작하는 방식(소켓 활성화)으로 이 역할을 대신하며, xinetd는 필요할 때 따로 설치한다.

### 7.2 데몬의 조상

- **systemd 데몬:** 대부분 프로세스의 조상 프로세스이며, 시스템의 상태를 종합적으로 관리하는 역할을 수행한다.
- **커널 스레드 데몬:** 커널 기능의 일부분을 프로세스처럼 관리하는 데몬이다. `ps` 명령으로 확인했을 때 이름이 대괄호(`[ ]`)에 들어 있는 프로세스들이며, 1.8절의 출력처럼 대부분 PID 2인 `kthreadd`의 자식이다. 커널 데몬은 대부분 입출력이나 메모리 관리, 디스크 동기화 등을 수행한다.

### 7.3 주요 데몬

| 데몬 | 기능 |
|------|------|
| atd | 특정 시간에 실행하도록 예약한 명령을 실행한다(`at` 명령으로 예약). |
| cron | 주기적으로 실행하도록 예약한 명령을 실행한다. |
| dhcpd | 동적으로 IP 주소를 부여하는 서비스를 제공한다. |
| httpd | 웹 서비스를 제공한다. |
| lpd | 프린트 서비스를 제공한다. |
| nfs | 네트워크 파일 시스템 서비스를 제공한다. |
| named | DNS 서비스를 제공한다. |
| sendmail | 이메일 서비스를 제공한다. |
| smtpd | 메일 전송 데몬이다. |
| popd | 기본 편지함 서비스를 제공한다. |
| routed | 자동 IP 라우터 테이블 서비스를 제공한다. |
| smb | 삼바 서비스를 제공한다. |
| syslogd | 로그 기록 서비스를 제공한다. |
| sshd | 원격 보안 접속 서비스를 제공한다. |
| in.telnetd | 원격 접속 서비스를 제공한다. |
| ftpd | 파일 송수신 서비스를 제공한다. |
| ntpd | 시간 동기화 서비스를 제공한다. |

*표 6. 리눅스의 주요 데몬*

데몬 이름은 대개 서비스 이름 뒤에 daemon을 뜻하는 `d`를 붙여 짓는다.

---

<br>

## 8. Root 비밀번호 복구

### 8.1 복구 단계 (Ubuntu/GRUB2)

root 비밀번호를 잊었을 때는 GRUB에서 커널 매개변수를 임시로 바꾸어, 비밀번호 확인 없이 root 셸을 얻은 뒤 비밀번호를 변경한다.

1. 재부팅 후 GRUB 메뉴에 접근한다(부팅 중 `Shift` 키를 누른다).
2. 커널 항목을 선택하고 `e`를 눌러 편집한다.
3. `linux`로 시작하는 줄을 찾아 `init=/bin/bash`를 추가한다.
4. `Ctrl+X` 또는 `F10`을 눌러 부팅한다.
5. 루트 파일 시스템을 읽기-쓰기로 다시 마운트한다: `mount -o remount,rw /`
6. root 비밀번호를 변경한다: `passwd root`
7. 재부팅한다: `exec /sbin/init` 또는 `reboot -f`

`init=/bin/bash`는 커널이 1번 프로세스로 systemd 대신 bash를 실행하게 하므로, 로그인 절차 없이 root 권한의 셸이 열린다. 이때 루트 파일 시스템은 `linux` 줄의 `ro` 매개변수 때문에 읽기 전용으로 마운트되어 있으므로, 비밀번호 파일을 수정하려면 5단계처럼 읽기-쓰기로 다시 마운트해야 한다. systemd가 실행되고 있지 않으므로 보통의 `reboot`(`systemctl`)은 동작하지 않으며, `reboot -f`로 강제로 재부팅하거나 `exec /sbin/init`으로 systemd를 실행하여 부팅을 계속한다. `reboot -f`는 파일 시스템을 정상적으로 해제하지 않으므로, 그 전에 `sync`를 실행하여 변경 내용을 디스크에 기록해 두는 것이 안전하다.

2, 3, 5단계는 다음처럼 한 번에 처리할 수도 있다.

1. 시스템을 재시작한다.
2. GRUB 부팅 메뉴가 출력될 때 재빨리 `e`를 눌러 편집 모드로 전환한다.
3. 리눅스 커널 정보가 있는 행에서 `ro splash $vt_handoff`를 `rw init=/bin/bash`로 수정하고 `F10`을 눌러 재시작한다.
4. 시스템이 root 계정으로 동작한다.
5. `passwd root`로 비밀번호를 변경한다.
6. 작업을 마친 뒤 `reboot -f`로 재부팅한다.

```text
linux  /boot/vmlinuz-5.13.0-22-generic root=UUID=265c8913-ee1e-4034-885f-207969b0a23b ro splash $vt_handoff
linux  /boot/vmlinuz-5.13.0-22-generic root=UUID=265c8913-ee1e-4034-885f-207969b0a23b rw init=/bin/bash
```

첫 줄은 수정하기 전, 둘째 줄은 단일 사용자 모드로 부팅하기 위해 수정한 뒤의 `linux` 행이다. `rw`로 처음부터 읽기-쓰기로 마운트하므로 `mount -o remount,rw /` 단계가 필요 없다.

> **주의:** 이 방법은 시스템에 물리적으로 접근할 수 있는 사람이면 누구나 root 권한을 얻을 수 있음을 뜻한다. 서버처럼 보안이 중요한 시스템은 GRUB 비밀번호를 설정하여 부팅 항목의 편집을 막는다(9절).

### 8.2 복구 모드로 부팅하기

**복구 모드(recovery mode)** 는 가장 기본적인 서비스만 제공하며 명령 모드로 작업할 수 있는 부팅 방식이다. 복구 모드로 부팅하는 절차는 다음과 같다.

1. GRUB 메뉴 초기 화면에서 `Ubuntu용 고급 설정`(Advanced options for Ubuntu)을 선택하고, 메뉴가 출력되면 `recovery mode`가 붙은 항목을 선택한다.
2. 복구 메뉴(Recovery Menu)가 출력되면 `root` 항목을 선택한다.
3. `root` 항목을 선택하면 바로 root 프롬프트가 출력된다.
4. 루트 파일 시스템을 읽기-쓰기 모드로 다시 마운트한다: `mount -o remount,rw /`
5. 복구 작업을 수행한 뒤 `reboot -f`로 재시작한다.

| 항목 | 기능 |
|------|------|
| resume | 정상 부팅을 계속한다(Resume normal boot). |
| clean | 디스크의 여유 공간을 확보한다(Try to make free space). |
| dpkg | 손상된 패키지를 복구한다(Repair broken packages). |
| fsck | 모든 파일 시스템을 검사한다(Check all file systems). |
| grub | GRUB 부트로더를 갱신한다(Update grub bootloader). |
| network | 네트워크를 활성화한다(Enable networking). |
| root | root 셸 프롬프트로 들어간다(Drop to root shell prompt). |
| system-summary | 시스템 요약 정보를 출력한다(System summary). |

*표 7. 우분투 복구 메뉴의 항목*

복구 메뉴의 제목에 `filesystem state: read-only`가 표시되듯이, 복구 모드도 처음에는 루트 파일 시스템을 읽기 전용으로 마운트한다. 그래서 4단계의 다시 마운트가 필요하다. `root` 항목을 선택하면 `Press Enter for maintenance (or press Control-D to continue):`가 출력되며, `Enter`를 누르면 root 프롬프트(`root@myubuntu:~#`)가 나타난다.

---

<br>

## 9. 모범 사례

- GRUB 타임아웃을 적절하게(3~5초) 유지한다.
- 문제 해결을 위해 부팅 과정을 이해한다.
- 모든 서비스 관리에 `systemctl`을 사용한다.
- `systemd-analyze`와 `systemd-analyze blame`으로 부팅 시간을 모니터링한다. `blame`은 서비스별 시작 시간을 오래 걸린 순서로 보여 준다.
- 물리적 보안을 위해 GRUB 비밀번호를 설정한다.
- 사용자 정의 부팅 매개변수를 문서화한다.

---

<br>

## 요약

| 개념 | 핵심 요약 |
|------|----------|
| 부팅 과정 | BIOS/UEFI, GRUB, 커널, systemd, 서비스의 순서로 진행되어 로그인 프롬프트를 출력한다. |
| MBR | 부팅 디스크의 첫 섹터 512바이트로, 부트로더 코드 446바이트, 파티션 테이블 64바이트, 매직 넘버 2바이트로 이루어진다. |
| GRUB | 커널을 메모리에 로딩하는 부트로더이며, `/etc/default/grub`을 수정한 뒤 `update-grub`으로 `grub.cfg`를 다시 생성한다. |
| systemd | PID 1로 동작하는 현대적 init 시스템으로, 유닛 단위로 서비스를 병렬로 시작하고 관리한다. |
| systemctl | `start`, `stop`, `enable`, `disable`, `status`, `is-active`, `isolate` 등으로 유닛을 관리한다. |
| journalctl | journald가 수집한 systemd 로그를 부팅, 유닛, 우선순위 등으로 걸러 확인한다. |
| 타겟 | systemd 부팅 타겟(graphical, multi-user, rescue 등)이 SysV 런레벨을 대신하며, `set-default`로 기본값을, `isolate`로 현재 상태를 바꾼다. |
| 종료 | `shutdown -h now`, `poweroff`, `reboot`, `init 0`/`init 6`으로 종료하거나 재시작하며, `halt`, `poweroff`, `reboot`는 `systemctl`의 심볼릭 링크이다. |
| 데몬 | 백그라운드에서 서비스를 제공하는 프로세스로, 독자형으로 동작하거나 슈퍼데몬(inetd, xinetd)을 통해 실행된다. |
| 비밀번호 복구 | GRUB 항목의 `linux` 행에 `init=/bin/bash`를 넣어 root 셸로 부팅한 뒤 `passwd root`로 비밀번호를 바꾼다. |

---

<br>

## 점검 문제

1. **MBR의 구성:** MBR 512바이트의 구성을 쓰고, MBR 디스크에 주 파티션을 최대 4개까지만 만들 수 있는 이유를 설명하라.

   <details>
   <summary>정답</summary>

   MBR은 부트로더 코드 446바이트, 파티션 테이블 64바이트, 매직 넘버(부트 시그니처) `0x55AA` 2바이트로 이루어지며 446 + 64 + 2 = 512바이트이다. 파티션 테이블의 각 항목은 16바이트이므로 64 / 16 = 4개의 항목만 들어간다. 따라서 주 파티션은 최대 4개이다.

   </details>

2. **GRUB 설정 변경:** GRUB 메뉴를 10초 동안 보여 주도록 바꾸려 한다. `/boot/grub/grub.cfg`를 직접 수정하지 않는 이유와 올바른 절차를 쓰라.

   <details>
   <summary>정답</summary>

   `grub.cfg`는 `/etc/default/grub`과 `/etc/grub.d`의 스크립트로부터 자동 생성되는 파일이므로, 직접 수정해도 다음에 다시 생성될 때 덮어써진다. 올바른 절차는 `/etc/default/grub`에서 `GRUB_TIMEOUT_STYLE=hidden`을 주석 처리하고 `GRUB_TIMEOUT=10`으로 바꾼 뒤, `sudo update-grub`(또는 `sudo grub-mkconfig -o /boot/grub/grub.cfg`)을 실행하는 것이다.

   </details>

3. **start와 enable:** `sudo systemctl start cron`과 `sudo systemctl enable cron`의 차이를 설명하라. 재부팅한 뒤 cron이 실행되고 있으려면 무엇이 필요한가?

   <details>
   <summary>정답</summary>

   `start`는 cron 서비스를 지금 시작할 뿐 다음 부팅에는 영향을 주지 않는다. `enable`은 부팅할 때 cron이 자동으로 시작되도록 설정할 뿐 지금 실행 상태를 바꾸지 않는다. 재부팅 뒤에도 실행되려면 `enable`이 필요하며, 지금 시작하면서 자동 시작도 설정하려면 두 명령을 모두 실행하거나 `systemctl enable --now cron`을 쓴다.

   </details>

4. **심볼릭 링크로 된 명령:** `ls -l /sbin/reboot`의 결과가 `/sbin/reboot -> /bin/systemctl`이다. 이것이 뜻하는 바와, `init=/bin/bash`로 부팅한 상태에서 `reboot` 대신 `reboot -f`를 쓰는 이유를 설명하라.

   <details>
   <summary>정답</summary>

   `reboot`는 별도 프로그램이 아니라 `systemctl`이며, `systemctl`은 `reboot`라는 이름으로 실행되면 systemd에 재시작을 요청한다. `init=/bin/bash`로 부팅하면 1번 프로세스가 bash이고 systemd가 실행되고 있지 않으므로 이 요청을 처리할 수 없다. `reboot -f`는 서비스를 정상적으로 종료하는 절차 없이 강제로 재시작하며, systemd가 동작하지 않으면 커널에 직접 재시작을 요청하므로 이 상태에서도 재부팅된다.

   </details>

5. **데몬의 동작 방식:** 독자형 데몬과 슈퍼데몬을 통한 동작을 응답 속도와 자원 사용 측면에서 비교하라.

   <details>
   <summary>정답</summary>

   독자형 데몬은 항상 실행되어 있으므로 요청에 바로 응답하지만, 요청이 없어도 메모리 같은 자원을 차지한다. 슈퍼데몬을 통한 방식은 요청이 올 때 슈퍼데몬이 해당 데몬을 실행하므로 평소에는 자원을 쓰지 않지만, 요청마다 데몬을 시작하는 만큼 응답이 늦어진다. 그래서 요청이 잦은 서비스는 독자형으로, 드물게 쓰는 서비스는 슈퍼데몬이나 systemd의 소켓 활성화로 운영한다.

   </details>

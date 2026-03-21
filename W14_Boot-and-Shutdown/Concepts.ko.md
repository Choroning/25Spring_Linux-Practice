# 14주차 - 부팅과 종료

> **최종 수정일:** 2026-03-21

---

## 목차

1. [Linux 부팅 과정](#1-linux-부팅-과정)
2. [BIOS/UEFI와 부트로더](#2-biosuefi와-부트로더)
3. [GRUB 부트로더](#3-grub-부트로더)
4. [systemd와 Init 시스템](#4-systemd와-init-시스템)
5. [런레벨과 타겟](#5-런레벨과-타겟)
6. [시스템 종료와 재부팅](#6-시스템-종료와-재부팅)
7. [Root 비밀번호 복구](#7-root-비밀번호-복구)
8. [모범 사례](#8-모범-사례)
9. [요약](#요약)

---

## 1. Linux 부팅 과정

### 1.1 부팅 순서 개요

```
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

### 1.2 상세 부팅 단계

1. **BIOS/UEFI POST:** 하드웨어 자가 검사, 장치 초기화
2. **부팅 장치 선택:** 부팅 가능한 장치 탐색 (HDD, USB, 네트워크)
3. **부트로더 (GRUB):** 커널과 초기 RAM 디스크 로드
4. **커널 초기화:** 하드웨어 감지, 드라이버 로드, 루트 파일 시스템 마운트
5. **systemd (PID 1):** 시스템 서비스를 병렬로 시작
6. **로그인 프롬프트:** 로그인 화면 표시 (GUI 또는 텍스트)

---

## 2. BIOS/UEFI와 부트로더

### 2.1 BIOS vs. UEFI

| 특징 | BIOS | UEFI |
|------|------|------|
| 파티션 테이블 | MBR | GPT |
| 최대 부팅 디스크 | 2 TB | 9.4 ZB |
| 부팅 속도 | 느림 | 빠름 |
| 인터페이스 | 텍스트 기반 | 그래픽 |
| Secure Boot | 미지원 | 지원 |
| 아키텍처 | 16-bit | 32/64-bit |

### 2.2 부팅 디스크 구조 (MBR)

```
+---+-----------------------------------+
|MBR| Partition 1 | Partition 2 | ...   |
+---+-----------------------------------+
 |
 +-- 446 bytes: 부트로더 코드
 +-- 64 bytes: 파티션 테이블 (4개 항목)
 +-- 2 bytes: 매직 넘버 (0x55AA)
```

---

## 3. GRUB 부트로더

### 3.1 GRUB2 설정

```bash
# 주 설정 파일 (자동 생성)
/boot/grub/grub.cfg

# 사용자 정의 설정
/etc/default/grub

# 사용자 정의 메뉴 항목
/etc/grub.d/
```

### 3.2 주요 GRUB 설정

```bash
# /etc/default/grub
GRUB_DEFAULT=0                    # 기본 부팅 항목
GRUB_TIMEOUT=5                    # 타임아웃 (초)
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"  # 커널 매개변수
GRUB_CMDLINE_LINUX=""             # 추가 커널 매개변수
```

```bash
# 편집 후 grub.cfg 재생성
sudo update-grub
# 또는
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 3.3 GRUB 부팅 메뉴

부팅 시 `Shift`(BIOS) 또는 `Esc`(UEFI)를 눌러 GRUB 메뉴에 접근:
- 다른 커널 선택
- 복구 모드로 부팅
- `e` 키로 부팅 매개변수를 임시 편집

---

## 4. systemd와 Init 시스템

### 4.1 systemd 개요

`systemd`는 현대 Linux의 init 시스템이자 서비스 관리자이다 (PID 1):
- 빠른 부팅을 위한 병렬 서비스 시작
- 소켓 및 D-Bus 활성화
- 데몬의 온디맨드 시작
- 시스템 상태의 스냅샷 및 복원
- `journald`를 통한 로그 관리

### 4.2 systemctl - 서비스 관리

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

### 4.3 서비스 보기

```bash
systemctl list-units --type=service              # 활성 서비스
systemctl list-units --type=service --all         # 모든 서비스
systemctl list-unit-files --type=service          # 모든 유닛 파일
```

### 4.4 journalctl - 시스템 로그

```bash
journalctl                           # 모든 로그
journalctl -b                        # 마지막 부팅 이후 로그
journalctl -u ssh                    # 특정 서비스 로그
journalctl -f                        # 실시간 로그 추적 (tail -f와 유사)
journalctl --since "2025-03-21"      # 특정 날짜 이후 로그
journalctl -p err                    # 에러 수준 로그만
```

---

## 5. 런레벨과 타겟

### 5.1 SysV 런레벨 vs. systemd 타겟

| 런레벨 | systemd 타겟 | 설명 |
|--------|-------------|------|
| 0 | `poweroff.target` | 정지 / 전원 끄기 |
| 1 | `rescue.target` | 단일 사용자 / 복구 모드 |
| 2 | `multi-user.target` | 다중 사용자 (네트워크 없음) |
| 3 | `multi-user.target` | 네트워크 포함 다중 사용자 |
| 4 | `multi-user.target` | 미사용 / 사용자 정의 |
| 5 | `graphical.target` | 네트워크 포함 GUI |
| 6 | `reboot.target` | 재부팅 |

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

---

## 6. 시스템 종료와 재부팅

### 6.1 종료 명령어

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

---

## 7. Root 비밀번호 복구

### 7.1 복구 단계 (Ubuntu/GRUB2)

1. 재부팅 후 GRUB 메뉴에 접근 (부팅 중 `Shift` 키 누르기)
2. 커널 항목을 선택하고 `e`를 눌러 편집
3. `linux`으로 시작하는 줄을 찾아 `init=/bin/bash` 추가
4. `Ctrl+X` 또는 `F10`을 눌러 부팅
5. 루트 파일 시스템을 읽기-쓰기로 다시 마운트: `mount -o remount,rw /`
6. root 비밀번호 변경: `passwd root`
7. 재부팅: `exec /sbin/init` 또는 `reboot -f`

---

## 8. 모범 사례

- GRUB 타임아웃을 적절하게 유지 (3-5초)
- 문제 해결을 위해 부팅 과정을 이해
- 모든 서비스 관리에 `systemctl` 사용
- `systemd-analyze`와 `systemd-analyze blame`으로 부팅 시간 모니터링
- 물리적 보안을 위해 GRUB 비밀번호 설정
- 사용자 정의 부팅 매개변수 문서화

---

## 요약

| 개념 | 핵심 사항 |
|------|----------|
| 부팅 과정 | BIOS/UEFI -> GRUB -> Kernel -> systemd -> Services |
| GRUB | 부트로더; `/etc/default/grub`으로 설정 |
| systemd | 현대적 init 시스템 (PID 1); 병렬 서비스 시작 |
| systemctl | 서비스 관리 (`start/stop/enable/disable`) |
| journalctl | systemd 로그 확인 |
| 타겟 | systemd 부팅 타겟 (graphical, multi-user, rescue) |
| 종료 | `shutdown -h now`, `poweroff`, `reboot` |
| 비밀번호 복구 | GRUB 항목 편집, bash로 부팅, 비밀번호 변경 |

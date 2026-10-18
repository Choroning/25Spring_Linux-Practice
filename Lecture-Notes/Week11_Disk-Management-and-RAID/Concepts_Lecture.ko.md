# 11주차 이론 — 디스크 관리와 RAID

[레포지토리 안내](../../README.ko.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **최종 수정일:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 7

> **학습 목표:**
> 1. fdisk와 parted로 디스크를 파티셔닝할 수 있다
> 2. 논리 볼륨 관리자(LVM)를 관리할 수 있다
> 3. RAID 레벨(0, 1, 5, 6, 10)의 저장 방식, 용량, 장애 허용을 비교할 수 있다
> 4. RAID 5가 패리티로 고장 난 디스크의 데이터를 복구하는 원리를 설명할 수 있다
> 5. mdadm으로 RAID 레벨(0, 1, 5, 6, 10)을 구성하고 고장 난 디스크를 교체할 수 있다
> 6. 디스크 쿼터를 설정할 수 있다

---

## 목차

- [1. 고급 디스크 관리](#1-고급-디스크-관리)
  - [1.1 새 디스크 추가](#11-새-디스크-추가)
  - [1.2 USB/외장 드라이브 관리](#12-usb외장-드라이브-관리)
- [2. LVM (Logical Volume Manager)](#2-lvm-logical-volume-manager)
  - [2.1 LVM 아키텍처](#21-lvm-아키텍처)
  - [2.2 LVM 명령어](#22-lvm-명령어)
  - [2.3 LVM의 장점](#23-lvm의-장점)
- [3. RAID 개요](#3-raid-개요)
  - [3.1 RAID란?](#31-raid란)
  - [3.2 하드웨어 RAID vs. 소프트웨어 RAID](#32-하드웨어-raid-vs-소프트웨어-raid)
  - [3.3 저장 방식의 비교](#33-저장-방식의-비교)
- [4. RAID 레벨](#4-raid-레벨)
  - [4.1 RAID 0 (스트라이핑)](#41-raid-0-스트라이핑)
  - [4.2 RAID 1 (미러링)](#42-raid-1-미러링)
  - [4.3 RAID 5 (분산 패리티 스트라이핑)](#43-raid-5-분산-패리티-스트라이핑)
  - [4.4 RAID 6 (이중 분산 패리티)](#44-raid-6-이중-분산-패리티)
  - [4.5 RAID 10 (미러링 후 스트라이핑)](#45-raid-10-미러링-후-스트라이핑)
  - [4.6 RAID 레벨 비교](#46-raid-레벨-비교)
- [5. mdadm을 이용한 소프트웨어 RAID](#5-mdadm을-이용한-소프트웨어-raid)
  - [5.1 RAID 배열 생성](#51-raid-배열-생성)
  - [5.2 RAID 관리](#52-raid-관리)
  - [5.3 장애 테스트와 복구](#53-장애-테스트와-복구)
- [6. 디스크 쿼터](#6-디스크-쿼터)
  - [6.1 쿼터 설정](#61-쿼터-설정)
- [7. 모범 사례](#7-모범-사례)
- [요약](#요약)
- [점검 문제](#점검-문제)

---

<br>

## 1. 고급 디스크 관리

### 1.1 새 디스크 추가

새 디스크를 추가하여 쓰는 과정(10주차 2.3절)을 명령으로 정리하면 다음과 같다.

```bash
# 1. 새 디스크 확인
lsblk
sudo fdisk -l

# 2. 디스크 파티션 생성
sudo fdisk /dev/sdb
# n -> 새 파티션
# p -> 주 파티션
# 1 -> 파티션 번호
# Enter -> 기본 시작 섹터
# Enter -> 기본 마지막 섹터
# w -> 저장 후 종료

# 3. 파일 시스템 생성
sudo mkfs.ext4 /dev/sdb1

# 4. 마운트 포인트 생성 및 마운트
sudo mkdir /data
sudo mount /dev/sdb1 /data

# 5. 영구 마운트를 위해 fstab에 추가
echo '/dev/sdb1 /data ext4 defaults 0 2' | sudo tee -a /etc/fstab
```

장치 이름은 디스크를 추가하거나 제거하면 바뀔 수 있으므로, 5단계에서는 `/dev/sdb1` 대신 `blkid`로 확인한 `UUID=...`를 쓰는 편이 안전하다(10주차 5.4절).

### 1.2 USB/외장 드라이브 관리

```bash
# USB 장치 확인
lsblk
dmesg | tail -20          # 커널 메시지 확인

# USB 마운트
sudo mount /dev/sdb1 /media/usb

# 안전하게 제거
sync                       # 버퍼 비우기
sudo umount /media/usb
```

`sync`는 메모리 버퍼에 남아 있는 쓰기 데이터를 디스크에 기록한다. `umount`도 언마운트하기 전에 버퍼를 비우므로, 장치를 뽑기 전에 반드시 언마운트한다.

---

<br>

## 2. LVM (Logical Volume Manager)

### 2.1 LVM 아키텍처

LVM은 물리 볼륨(PV)을 볼륨 그룹(VG)으로 묶고, VG에서 논리 볼륨(LV)을 나누어 마운트한다. LVM의 용어(PV, VG, LV, PE)와 생성 절차는 10주차 6절에서 다룬다.

```text
+----------+  +----------+  +----------+
| /dev/sda1|  | /dev/sdb1|  | /dev/sdc1|   Physical Volumes (PV)
+----+-----+  +----+-----+  +----+-----+
     |             |              |
     +------+------+------+------+
            |             |
     +------+------+ +----+-----+
     | Volume Group| | Volume   |          Volume Groups (VG)
     | (vg_data)   | | Group 2  |
     +------+------+ +----------+
            |
     +------+------+------+
     |             |      |
+----+----+ +-----+---+ +-+--------+
| Logical | | Logical  | | Logical  |  Logical Volumes (LV)
| Volume  | | Volume   | | Volume   |
| (lv_home| | (lv_var) | | (lv_tmp) |
+---------+ +----------+ +----------+
     |            |           |
  /home        /var        /tmp               Mount Points
```

*그림 1. LVM의 물리 볼륨, 볼륨 그룹, 논리 볼륨 계층*

### 2.2 LVM 명령어

```bash
# Physical Volume (PV)
sudo pvcreate /dev/sdb1 /dev/sdc1       # PV 생성
sudo pvdisplay                            # PV 정보 표시
sudo pvs                                  # 요약 정보

# Volume Group (VG)
sudo vgcreate vg_data /dev/sdb1 /dev/sdc1  # VG 생성
sudo vgdisplay                              # VG 정보 표시
sudo vgextend vg_data /dev/sdd1             # VG에 디스크 추가

# Logical Volume (LV)
sudo lvcreate -L 10G -n lv_home vg_data    # 10GB LV 생성
sudo lvcreate -l 100%FREE -n lv_data vg_data  # 모든 여유 공간 사용
sudo lvdisplay                               # LV 정보 표시

# 포맷 및 마운트
sudo mkfs.ext4 /dev/vg_data/lv_home
sudo mount /dev/vg_data/lv_home /home

# LV 크기 확장
sudo lvextend -L +5G /dev/vg_data/lv_home   # 5GB 추가
sudo resize2fs /dev/vg_data/lv_home          # 파일 시스템 크기 조정
```

`lvcreate`의 `-L`은 크기를 용량으로, `-l`은 PE 수나 `100%FREE` 같은 비율로 지정한다. LV를 늘린 뒤에는 그 안의 파일 시스템도 늘려야 하며, ext 계열은 `resize2fs`, xfs는 `xfs_growfs`를 쓴다.

### 2.3 LVM의 장점

- **동적 크기 조정:** 볼륨을 마운트한 채로 확장할 수 있다(ext4, xfs). 축소는 ext4에서 언마운트한 뒤에 할 수 있고, xfs는 축소할 수 없다.
- **디스크 스패닝:** 단일 디스크보다 큰 볼륨을 만들 수 있다.
- **스냅샷:** 백업을 위한 특정 시점의 복사본을 만들 수 있다.
- **스트라이핑:** 여러 디스크에 걸쳐 데이터를 나누어 써서 I/O 성능을 높일 수 있다.

---

<br>

## 3. RAID 개요

### 3.1 RAID란?

**RAID** (Redundant Array of Independent Disks)는 여러 물리 디스크를 하나의 논리적 단위로 결합하는 기술로, 다음을 목적으로 한다.

- **성능:** 여러 디스크에 걸쳐 병렬로 읽고 쓴다.
- **이중화:** 디스크에 장애가 나도 데이터를 보존한다.
- **용량:** 여러 개의 작은 디스크를 하나로 결합한다.

RAID라는 이름은 처음에 Redundant Array of Inexpensive Disks의 약자로 제안되었다. 값싼 디스크 여러 개를 하나처럼 써서 비용을 줄이면서 신뢰성과 성능을 함께 높인다는 뜻이며, 지금은 Independent로 풀어 쓰는 경우가 많다.

### 3.2 하드웨어 RAID vs. 소프트웨어 RAID

| 특징 | 하드웨어 RAID | 소프트웨어 RAID |
|------|--------------|---------------|
| 컨트롤러 | 전용 RAID 카드 | CPU/OS가 관리 |
| 성능 | 우수 (전용 프로세서) | 약간 낮음 |
| 비용 | 높음 (RAID 컨트롤러) | 무료 (OS 내장) |
| 유연성 | 컨트롤러 기능에 제한 | OS 수준의 완전한 제어 |
| 도구 | 컨트롤러 BIOS | Linux의 `mdadm` |

*표 1. 하드웨어 RAID와 소프트웨어 RAID의 비교*

하드웨어 RAID는 제조업체가 여러 하드디스크로 만든 장비를 그대로 공급하는 방식으로, 더 안정적이지만 상당히 비싸다. 소프트웨어 RAID는 운영체제가 지원하는 방식으로, 비싼 하드웨어 RAID의 대안이며 적은 비용으로 데이터를 더 안전하게 저장할 수 있다. 5절에서는 Linux의 소프트웨어 RAID를 다룬다.

### 3.3 저장 방식의 비교

용량이 1GB인 디스크 N개로 구성한 저장 방식을 비교하면 다음과 같다. 단순 볼륨과 LVM은 RAID에 포함되지 않지만, RAID와 저장 방식을 비교하기 위해 함께 적는다.

| 방식 | 디스크 수 | 사용 가능 용량 | 저장 방식과 특징 |
|:-----|:-----|:-----|:-----|
| 단순 볼륨 | 1개 | 1GB | 하드디스크 하나를 볼륨 하나로 쓴다 |
| LVM (선형) | 2개 이상 | N GB | 첫 번째 디스크부터 차례로 채우며, 디스크를 추가할 수 있다 |
| RAID 0 | 2개 이상 | N GB | 모든 디스크에 동시에 나누어 저장하며 가장 빠르다(스트라이핑) |
| RAID 1 | 2개 이상 | 1GB (디스크 1개 분량) | 모든 디스크에 같은 데이터를 동시에 저장하여 결함 허용을 제공한다(미러링) |
| RAID 5 | 3개 이상 | (N-1) GB | 패리티 정보를 써서 결함 허용을 제공하며 공간 효율이 좋다 |
| RAID 6 | 4개 이상 | (N-2) GB | RAID 5를 개선하여 패리티를 두 개 쓰며 결함 허용을 제공한다 |

*표 2. 1GB 디스크 N개로 구성한 저장 방식의 비교*

---

<br>

## 4. RAID 레벨

### 4.1 RAID 0 (스트라이핑)

```text
     Data: ABCDEFGH

     Disk 1: A C E G    Disk 2: B D F H
```

*그림 2. 데이터 블록을 두 디스크에 번갈아 나누어 저장하는 RAID 0의 스트라이핑*

| 속성 | 값 |
|------|-----|
| 최소 디스크 수 | 2 |
| 이중화 | 없음 |
| 용량 | N x 디스크 크기 |
| 읽기 속도 | N x 단일 디스크 |
| 쓰기 속도 | N x 단일 디스크 |
| 장애 허용 | 없음 (디스크 하나라도 고장나면 전체 손실) |

*표 3. RAID 0의 속성*

RAID 0은 LVM과 비슷해 보이지만 저장 방식이 다르다. LVM(선형)은 첫 번째 디스크를 다 채운 뒤 다음 디스크에 저장하지만, RAID 0은 모든 디스크에 동시에 나누어 저장한다. 따라서 저장 속도가 크게 향상되고 공간 효율은 100%이지만, 디스크 하나만 고장 나도 모든 데이터를 잃으므로 신뢰성이 낮다. 빠른 성능이 필요하면서 모두 잃어도 큰 문제가 되지 않는 자료에 적당하다.

### 4.2 RAID 1 (미러링)

```text
     Data: ABCD

     Disk 1: A B C D    Disk 2: A B C D  (정확한 복사본)
```

*그림 3. 같은 데이터를 두 디스크에 복사하는 RAID 1의 미러링*

| 속성 | 값 |
|------|-----|
| 최소 디스크 수 | 2 |
| 이중화 | 완전 미러 |
| 용량 | 1개 디스크 크기 (50% 효율) |
| 읽기 속도 | 최대 2배 |
| 쓰기 속도 | 1배 (양쪽에 동시 기록) |
| 장애 허용 | 1개 디스크 장애 가능 |

*표 4. RAID 1의 속성*

RAID 1은 데이터를 저장하는 데 두 배의 용량이 필요하므로 비용이 두 배이고 공간 효율이 나쁘지만, 디스크 하나가 고장 나도 데이터가 남는 **결함 허용(fault tolerance)** 을 제공하여 신뢰성이 높다. 쓰기는 두 디스크에 모두 해야 하므로 저장 속도는 단일 디스크와 같다. 중요한 데이터를 저장하기에 적절하다. 표의 50% 효율은 디스크 2개로 구성할 때의 값이며, 디스크를 더 넣어도 사용 가능 용량은 디스크 1개 분량이다.

| 항목 | RAID 0 | RAID 1 |
|:-----|:-----|:-----|
| 성능(저장 속도) | 뛰어남 | 변화 없음 |
| 데이터 안전성(결함 허용) | 보장하지 못함 | 보장함 |
| 공간 효율 | 좋음 | 나쁨 |

*표 5. RAID 0과 RAID 1의 비교*

### 4.3 RAID 5 (분산 패리티 스트라이핑)

```text
     Disk 1    Disk 2    Disk 3
     A1        A2        Ap (parity)
     Bp        B1        B2
     C1        Cp        C2
```

*그림 4. 패리티 블록을 디스크마다 돌아가며 두는 RAID 5의 분산 패리티 배치*

| 속성 | 값 |
|------|-----|
| 최소 디스크 수 | 3 |
| 이중화 | 분산 패리티 |
| 용량 | (N-1) x 디스크 크기 |
| 읽기 속도 | (N-1) x 단일 디스크 |
| 쓰기 속도 | 느림 (패리티 계산) |
| 장애 허용 | 1개 디스크 장애 가능 |

*표 6. RAID 5의 속성*

RAID 5는 RAID 1의 데이터 안전성과 RAID 0의 공간 효율을 함께 얻기 위한 방식으로, 최소 3개의 디스크가 필요하다. 각 줄(스트라이프)마다 데이터 비트와 합쳐 1의 개수가 짝수가 되도록 **패리티(parity)** 비트를 정하고(데이터 비트들의 XOR와 같다), 패리티를 저장하는 디스크를 줄마다 바꾼다. 디스크 하나가 고장 나면 나머지 디스크의 값으로 사라진 값을 계산하여 복구한다.

예를 들어 12비트 데이터 000 111 010 011을 디스크 4개(sda, sdb, sdc, sdd)에 세 비트씩 나누어 저장하면 다음과 같다.

| 줄 | sda | sdb | sdc | sdd | 데이터 | 패리티 위치와 값 |
|:-----|:-----|:-----|:-----|:-----|:-----|:-----|
| 1 | 0 | 0 | 0 | **0** | 000 | sdd, 0 |
| 2 | 1 | 1 | **1** | 1 | 111 | sdc, 1 |
| 3 | 0 | **1** | 1 | 0 | 010 | sdb, 1 |
| 4 | **0** | 0 | 1 | 1 | 011 | sda, 0 |

*표 7. 데이터 000 111 010 011을 RAID 5로 저장한 결과(굵은 값이 패리티)*

sdb가 고장 나면 각 줄에서 남은 세 값과 합쳐 1의 개수가 짝수가 되도록 sdb의 값을 정한다. 줄 1은 0, 0, 0이므로 0, 줄 2는 1, 1, 1이므로 1, 줄 3은 0, 1, 0이므로 1, 줄 4는 0, 1, 1이므로 0이 되어 원래 값 0, 1, 1, 0을 그대로 복구한다. 이처럼 RAID 5는 어느 정도 결함 허용을 제공하면서 저장 공간의 효율도 좋다(디스크 개수 - 1만큼의 공간을 쓴다). 그러나 디스크 2개가 동시에 고장 나면 한 줄에 모르는 값이 두 개가 되어 복구할 수 없다.

### 4.4 RAID 6 (이중 분산 패리티)

```text
     Disk 1    Disk 2    Disk 3    Disk 4
     A1        A2        Ap        Aq
     B1        Bp        Bq        B2
     Cp        Cq        C1        C2
```

*그림 5. 두 패리티 P와 Q를 분산하여 배치한 RAID 6의 예*

RAID 6은 RAID 5를 개선한 방식으로, 스트라이프마다 서로 다른 방식으로 계산한 패리티 두 개(P, Q)를 분산 저장한다. P는 RAID 5와 같은 XOR 패리티이고, Q는 리드-솔로몬 부호 같은 다른 계산으로 만들어 두 디스크의 값을 모두 복원할 수 있게 한다. 최소 4개의 디스크가 필요하고 사용 가능 용량은 (N-2) x 디스크 크기이다. 공간 효율과 성능(속도)은 RAID 5보다 약간 떨어지지만, 디스크 2개가 동시에 고장 나도 데이터에 이상이 없으므로 신뢰도가 더 높다.

### 4.5 RAID 10 (미러링 후 스트라이핑)

```text
                RAID 0 (striping)
          +-----------+-----------+
          |                       |
   RAID 1 (mirror)         RAID 1 (mirror)
   Disk 1   Disk 2         Disk 3   Disk 4
   A1       A1             A2       A2
   B1       B1             B2       B2
```

*그림 6. 미러 쌍 두 개를 스트라이핑한 RAID 10의 구성*

RAID 10(RAID 1+0)은 디스크를 둘씩 RAID 1로 미러링한 뒤, 그 미러 쌍들을 다시 RAID 0으로 스트라이핑하는 방식이다. 신뢰성(안전성)과 성능(속도)이 동시에 뛰어나지만 공간 효율은 50%(사용 가능 용량 N/2 x 디스크 크기)이고, 최소 4개의 디스크가 필요하다.

> **주의:** RAID 10은 디스크 2개가 고장 나도 두 디스크가 서로 다른 미러 쌍에 속하면 데이터가 안전하지만, 같은 미러 쌍의 두 디스크가 함께 고장 나면 그 쌍의 데이터를 모두 잃는다. 따라서 어떤 경우에도 보장되는 장애 허용은 디스크 1개이다.

### 4.6 RAID 레벨 비교

| 레벨 | 최소 디스크 | 이중화 | 용량 | 사용 사례 |
|------|------------|--------|------|----------|
| RAID 0 | 2 | 없음 | 100% | 성능 (임시 데이터) |
| RAID 1 | 2 | 미러 | 50% | 부팅 드라이브, 중요 데이터 |
| RAID 5 | 3 | 1개 패리티 | (N-1)/N | 범용 서버 |
| RAID 6 | 4 | 2개 패리티 | (N-2)/N | 높은 안정성 |
| RAID 10 | 4 | 미러 + 스트라이프 | 50% | 데이터베이스, 높은 I/O |

*표 8. RAID 레벨별 최소 디스크 수, 이중화, 용량과 사용 사례*

---

<br>

## 5. mdadm을 이용한 소프트웨어 RAID

### 5.1 RAID 배열 생성

```bash
# mdadm 설치
sudo apt install mdadm

# RAID 1 (미러) 생성
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

# RAID 5 생성
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1

# 포맷 및 마운트
sudo mkfs.ext4 /dev/md0
sudo mkdir /mnt/raid
sudo mount /dev/md0 /mnt/raid
```

RAID 0을 처음부터 만드는 실습 절차는 다음과 같다.

1. RAID에 쓸 디스크마다 파티션을 하나 만들고, `t` 명령으로 파티션 종류를 fd(Linux RAID 자동 감지)로 바꾼다. `fdisk /dev/sdb`를 실행하여 `n`, `p`, `1`, Enter, Enter, `t`, `fd`, `p`, `w` 순서로 입력한다.
2. `mknod`로 RAID 장치 파일을 만든다. `mknod /dev/md0 b 9 0`은 주 번호(major) 9(md 드라이버), 부 번호(minor) 0인 블록(`b`) 장치 `/dev/md0`을 만든다. 최근 배포판에서는 mdadm과 udev가 장치 파일을 자동으로 만들므로 생략해도 된다.
3. `mdadm --create`로 배열을 만들고, `mdadm --detail --scan`과 `mdadm --query --detail`로 결과를 확인한다.
4. `mkfs.ext4`로 파일 시스템을 만들고 마운트 포인트에 마운트한다.

```bash
sudo fdisk /dev/sdb                 # n, p, 1, Enter, Enter, t, fd, p, w
sudo mknod /dev/md0 b 9 0           # 최근 배포판에서는 생략 가능
sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb1 /dev/sdc1
sudo mdadm --detail --scan
sudo mdadm --query --detail /dev/md0
sudo mkfs.ext4 /dev/md0
sudo mkdir /mnt/raid0data
sudo mount /dev/md0 /mnt/raid0data
```

같은 방법으로 RAID 1은 `--level=1 --raid-devices=2`, RAID 5는 `--level=5 --raid-devices=3`, RAID 6은 `--level=6 --raid-devices=4`, RAID 10은 `--level=10 --raid-devices=4`로 만든다.

### 5.2 RAID 관리

```bash
# RAID 상태 확인
cat /proc/mdstat
sudo mdadm --detail /dev/md0

# 예비 디스크 추가
sudo mdadm --add /dev/md0 /dev/sde1

# 장애 디스크 제거
sudo mdadm --remove /dev/md0 /dev/sdb1

# RAID 배열 중지
sudo mdadm --stop /dev/md0

# 설정 저장
sudo mdadm --detail --scan >> /etc/mdadm/mdadm.conf
```

`--remove`는 장애 상태이거나 예비인 디스크만 뺄 수 있다. 정상 동작 중인 디스크를 빼려면 먼저 `sudo mdadm /dev/md0 --fail /dev/sdb1`로 장애 표시를 한다. 설정 저장 명령의 `>>`는 root 권한이 필요한 리다이렉션이므로, root 셸에서 실행하거나 `sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf`처럼 쓴다.

### 5.3 장애 테스트와 복구

RAID 1, 5, 6, 10은 결함 허용 기능이 있으므로 디스크 일부를 제거해도 배열이 계속 동작한다. 디스크가 빠진 채로 동작하는 상태를 **성능 저하(degraded)** 상태라고 한다. RAID 1과 RAID 5는 디스크 1개를, RAID 6은 아무 디스크나 2개를 잃어도 데이터가 안전하다.

성능 저하 상태의 RAID 5에서 사라진 디스크의 데이터를 읽으려면 남은 디스크의 값으로 매번 계산해야 하므로 속도가 약간 느려질 수 있다. 고장 난 디스크를 새 디스크로 교체하고 배열에 추가하면 mdadm이 데이터를 다시 만들어 새 디스크에 기록하는 **재구성(rebuild)** 을 하며, 재구성이 끝나면 값을 계산할 필요가 없으므로 속도 저하도 없어진다. RAID 1은 남은 디스크의 데이터를 새 디스크에 복사하여 다시 두 디스크 모두에 같은 파일이 있게 된다.

```bash
sudo mdadm --query --detail /dev/md1      # 상태 확인 (degraded 여부)
sudo mdadm /dev/md1 --add /dev/sdj1       # 새 디스크를 추가하여 재구성
sudo mdadm /dev/md5 --add /dev/sdk1
```

RAID 배열을 없앨 때는 언마운트하고 배열을 멈춘 뒤, 구성 디스크에 남은 RAID 메타데이터(슈퍼블록)를 지운다. 설정 파일에 등록되지 않은 배열은 부팅할 때 `/dev/md127`처럼 큰 번호로 자동 조립되기도 한다.

```bash
sudo umount /dev/md127
sudo mdadm --stop /dev/md127
sudo mdadm --zero-superblock /dev/sdb1 /dev/sdc1
```

---

<br>

## 6. 디스크 쿼터

### 6.1 쿼터 설정

디스크 쿼터는 사용자나 그룹이 쓸 수 있는 디스크 용량과 파일 수를 제한한다. 쿼터의 개념(하드 리미트, 소프트 리미트)과 각 명령의 자세한 사용법은 12주차 8절에서 다룬다.

```bash
# 쿼터 도구 설치
sudo apt install quota

# /etc/fstab에서 쿼터 활성화
# /dev/sda2 /home ext4 defaults,usrquota,grpquota 0 2

# 다시 마운트 및 초기화
sudo mount -o remount /home
sudo quotacheck -cugm /home
sudo quotaon /home

# 사용자 쿼터 설정
sudo edquota -u user1
# 블록과 inode에 대한 소프트 제한, 하드 제한 설정

# 그룹 쿼터 설정
sudo edquota -g developers

# 쿼터 사용량 확인
sudo repquota /home
quota -u user1
```

---

<br>

## 7. 모범 사례

- 부팅/OS 드라이브에는 RAID 1을, 데이터 저장소에는 RAID 5나 RAID 6을 사용한다.
- RAID는 백업이 아니므로 항상 별도의 백업을 유지한다.
- 유연한 볼륨 관리를 위해 RAID 위에 LVM을 사용한다.
- `mdadm --detail`로 RAID 상태를 정기적으로 모니터링한다.
- 자동 재구성을 위해 핫 스페어 디스크를 유지한다.
- 실제로 필요하기 전에 디스크 복구 절차를 테스트한다.

---

<br>

## 요약

| 개념 | 핵심 요약 |
|------|----------|
| LVM | PV를 VG로 묶고 VG에서 LV를 나누는(PV -> VG -> LV) 유연한 볼륨 관리 방식이다. |
| RAID 0 | 스트라이핑으로 성능은 좋지만 이중화가 없다. |
| RAID 1 | 미러링으로 완전한 이중화를 제공하며, 디스크 2개일 때 용량 효율은 50%이다. |
| RAID 5 | 분산 패리티로 성능과 이중화의 균형을 맞추며 디스크 1개의 장애를 허용한다. |
| RAID 6 | 패리티 두 개를 분산 저장하여 디스크 2개의 동시 장애를 허용한다. |
| RAID 10 | 미러 쌍을 스트라이핑하여 성능과 신뢰성을 함께 얻으며 용량 효율은 50%이다. |
| mdadm | Linux 소프트웨어 RAID를 만들고 관리하는 도구이다. |
| 디스크 쿼터 | 사용자나 그룹별로 디스크 사용량을 제한한다. |
| fstab | 영구 마운트와 쿼터 옵션을 설정하는 파일이다. |

---

<br>

## 점검 문제

1. **RAID 5 패리티 복구:** 디스크 4개(sda, sdb, sdc, sdd)로 된 RAID 5의 한 줄에서 sda=1, sdc=0이고 패리티가 저장된 sdd=0인데 sdb가 고장 났다. 짝수 패리티를 쓴다고 할 때 sdb의 값을 구하고, 같은 줄의 sdc도 함께 고장 나면 복구할 수 없는 이유를 설명하라.

   <details>
   <summary>정답</summary>

   네 값을 합친 1의 개수가 짝수여야 하므로 1 + x + 0 + 0이 짝수가 되는 x = 1이다(1 XOR 0 XOR 0 = 1). sdc도 고장 나면 sdb와 sdc의 값 x, y에 대해 x + y가 홀수라는 조건 하나만 남아 (0, 1)과 (1, 0)을 구분할 수 없으므로 복구할 수 없다.

   </details>

2. **RAID 6과 RAID 10의 비교:** 2TB 디스크 6개로 RAID 6과 RAID 10을 각각 구성할 때 사용 가능 용량과, 어떤 디스크가 고장 나더라도 보장되는 장애 허용 디스크 수를 구하라.

   <details>
   <summary>정답</summary>

   RAID 6의 용량은 (6 - 2) × 2TB = 8TB이고, 아무 디스크나 2개가 고장 나도 데이터가 안전하다. RAID 10의 용량은 6 / 2 × 2TB = 6TB이고, 보장되는 장애 허용은 1개이다. RAID 10은 고장 난 디스크가 모두 서로 다른 미러 쌍에 속하면 최대 3개까지 견딜 수 있지만, 같은 쌍의 두 디스크가 고장 나면 데이터를 잃는다.

   </details>

3. **RAID 10의 두 디스크 장애:** 디스크 4개를 (D1, D2), (D3, D4)의 미러 쌍으로 묶은 RAID 10에서 디스크 2개가 무작위로 동시에 고장 날 때 데이터가 살아남을 확률을 구하라.

   <details>
   <summary>정답</summary>

   고장 날 디스크 2개를 고르는 경우는 $\binom{4}{2} = 6$가지이다. 데이터를 잃는 경우는 같은 쌍이 함께 고장 나는 (D1, D2)와 (D3, D4)의 2가지뿐이므로, 살아남을 확률은 4 / 6 = 2/3이다.

   </details>

4. **성능 저하 상태와 재구성:** RAID 5에서 디스크 하나가 고장 난 뒤 교체하기 전까지 읽기 속도가 느려질 수 있는 이유와, `sudo mdadm /dev/md5 --add /dev/sdk1`을 실행했을 때 일어나는 일을 설명하라.

   <details>
   <summary>정답</summary>

   고장 난 디스크에 있던 데이터 블록을 읽으려면 같은 줄의 나머지 디스크를 모두 읽어 XOR로 계산해야 하므로 느려진다. `--add`로 새 디스크를 추가하면 mdadm이 각 줄의 값을 나머지 디스크로 계산하여 새 디스크에 기록하는 재구성을 시작하고, 재구성이 끝나면 배열은 정상 상태로 돌아가 계산 없이 읽을 수 있다.

   </details>

5. **mknod의 인자:** `mknod /dev/md1 b 9 1`의 각 인자의 뜻을 쓰고, 최근 배포판에서 이 명령을 생략할 수 있는 이유를 설명하라.

   <details>
   <summary>정답</summary>

   `/dev/md1`은 만들 장치 파일의 이름, `b`는 블록 장치, 9는 md(소프트웨어 RAID) 드라이버를 가리키는 주 번호, 1은 그 드라이버 안의 장치 번호인 부 번호이다. 최근 배포판에서는 `mdadm --create`가 배열을 만들 때 커널과 udev가 `/dev/md1` 같은 장치 파일을 자동으로 만들기 때문에 생략할 수 있다.

   </details>

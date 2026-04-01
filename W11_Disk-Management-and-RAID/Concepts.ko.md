# 11주차 — 디스크 관리와 RAID

> **최종 수정일:** 2026-04-01

> **선수 지식**: 파일시스템 (10주차). [운영체제] 저장장치 개념.
>
> **학습 목표**:
> 1. fdisk와 parted로 디스크를 파티셔닝할 수 있다
> 2. RAID 레벨(0, 1, 5, 6, 10)을 구성할 수 있다
> 3. 논리 볼륨 관리자(LVM)를 관리할 수 있다

---

## 목차

1. [고급 디스크 관리](#1-고급-디스크-관리)
2. [LVM (Logical Volume Manager)](#2-lvm-logical-volume-manager)
3. [RAID 개요](#3-raid-개요)
4. [RAID 레벨](#4-raid-레벨)
5. [mdadm을 이용한 소프트웨어 RAID](#5-mdadm을-이용한-소프트웨어-raid)
6. [디스크 쿼터](#6-디스크-쿼터)
7. [모범 사례](#7-모범-사례)
8. [요약](#요약)

---

<br>

## 1. 고급 디스크 관리

### 1.1 새 디스크 추가

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

---

<br>

## 2. LVM (Logical Volume Manager)

### 2.1 LVM 아키텍처

```
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

### 2.3 LVM의 장점

- **동적 크기 조정:** 언마운트 없이 볼륨 확장 또는 축소 가능 (ext4/xfs)
- **디스크 스패닝:** 단일 디스크보다 큰 볼륨 생성 가능
- **스냅샷:** 백업을 위한 특정 시점 복사본 생성
- **스트라이핑:** 여러 디스크에 걸쳐 I/O 성능 향상

---

<br>

## 3. RAID 개요

### 3.1 RAID란?

**RAID** (Redundant Array of Independent Disks)는 여러 물리 디스크를 하나의 논리적 단위로 결합하는 기술로, 다음을 목적으로 한다:
- **성능:** 여러 디스크에 걸친 병렬 읽기/쓰기
- **이중화:** 디스크 장애 시에도 데이터 보존
- **용량:** 여러 개의 작은 디스크를 결합

### 3.2 하드웨어 RAID vs. 소프트웨어 RAID

| 특징 | 하드웨어 RAID | 소프트웨어 RAID |
|------|--------------|---------------|
| 컨트롤러 | 전용 RAID 카드 | CPU/OS가 관리 |
| 성능 | 우수 (전용 프로세서) | 약간 낮음 |
| 비용 | 높음 (RAID 컨트롤러) | 무료 (OS 내장) |
| 유연성 | 컨트롤러 기능에 제한 | OS 수준의 완전한 제어 |
| 도구 | 컨트롤러 BIOS | Linux의 `mdadm` |

---

<br>

## 4. RAID 레벨

### 4.1 RAID 0 (스트라이핑)

```
     Data: ABCDEFGH

     Disk 1: A C E G    Disk 2: B D F H
```

| 속성 | 값 |
|------|-----|
| 최소 디스크 수 | 2 |
| 이중화 | 없음 |
| 용량 | N x 디스크 크기 |
| 읽기 속도 | N x 단일 디스크 |
| 쓰기 속도 | N x 단일 디스크 |
| 장애 허용 | 없음 (디스크 하나라도 고장나면 전체 손실) |

### 4.2 RAID 1 (미러링)

```
     Data: ABCD

     Disk 1: A B C D    Disk 2: A B C D  (정확한 복사본)
```

| 속성 | 값 |
|------|-----|
| 최소 디스크 수 | 2 |
| 이중화 | 완전 미러 |
| 용량 | 1개 디스크 크기 (50% 효율) |
| 읽기 속도 | 최대 2배 |
| 쓰기 속도 | 1배 (양쪽에 동시 기록) |
| 장애 허용 | 1개 디스크 장애 가능 |

### 4.3 RAID 5 (분산 패리티 스트라이핑)

```
     Disk 1    Disk 2    Disk 3
     A1        A2        Ap (parity)
     Bp        B1        B2
     C1        Cp        C2
```

| 속성 | 값 |
|------|-----|
| 최소 디스크 수 | 3 |
| 이중화 | 분산 패리티 |
| 용량 | (N-1) x 디스크 크기 |
| 읽기 속도 | (N-1) x 단일 디스크 |
| 쓰기 속도 | 느림 (패리티 계산) |
| 장애 허용 | 1개 디스크 장애 가능 |

### 4.4 RAID 레벨 비교

| 레벨 | 최소 디스크 | 이중화 | 용량 | 사용 사례 |
|------|------------|--------|------|----------|
| RAID 0 | 2 | 없음 | 100% | 성능 (임시 데이터) |
| RAID 1 | 2 | 미러 | 50% | 부팅 드라이브, 중요 데이터 |
| RAID 5 | 3 | 1개 패리티 | (N-1)/N | 범용 서버 |
| RAID 6 | 4 | 2개 패리티 | (N-2)/N | 높은 안정성 |
| RAID 10 | 4 | 미러 + 스트라이프 | 50% | 데이터베이스, 높은 I/O |

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

---

<br>

## 6. 디스크 쿼터

### 6.1 쿼터 설정

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

- 부팅/OS 드라이브에는 RAID 1, 데이터 저장소에는 RAID 5/6 사용
- RAID는 백업이 아님 - 항상 별도의 백업을 유지할 것
- 유연한 볼륨 관리를 위해 RAID 위에 LVM 사용
- `mdadm --detail`을 이용하여 RAID 상태를 정기적으로 모니터링
- 자동 리빌드를 위한 핫 스페어 디스크 유지
- 실제 필요하기 전에 디스크 복구 절차를 테스트

---

<br>

## 요약

| 개념 | 핵심 사항 |
|------|----------|
| LVM | 유연한 볼륨 관리 (PV -> VG -> LV) |
| RAID 0 | 스트라이핑; 성능은 좋으나 이중화 없음 |
| RAID 1 | 미러링; 완전한 이중화, 50% 용량 |
| RAID 5 | 분산 패리티; 성능과 이중화의 균형 |
| mdadm | Linux 소프트웨어 RAID 관리 도구 |
| 디스크 쿼터 | 사용자/그룹별 디스크 사용량 제한 |
| fstab | 영구 마운트 및 쿼터 설정 |

# 10주차 — 파일 시스템

> **최종 수정일:** 2026-04-01

> **선수 지식**: 프로세스 관리 (9주차). [운영체제] 기본 OS 개념.
>
> **학습 목표**:
> 1. Linux 파일시스템 유형(ext4, xfs, btrfs)을 설명할 수 있다
> 2. 파일시스템을 마운트하고 언마운트할 수 있다
> 3. df와 du 명령으로 디스크 사용량을 모니터링할 수 있다

---

## 목차

1. [Linux 파일 시스템 개요](#1-linux-파일-시스템-개요)
2. [디스크 파티셔닝](#2-디스크-파티셔닝)
3. [파일 시스템 유형](#3-파일-시스템-유형)
4. [파일 시스템 생성 및 관리](#4-파일-시스템-생성-및-관리)
5. [마운트와 언마운트](#5-마운트와-언마운트)
6. [디스크 사용량 모니터링](#6-디스크-사용량-모니터링)
7. [스왑 공간](#7-스왑-공간)
8. [모범 사례](#8-모범-사례)
9. [요약](#요약)

---

<br>

## 1. Linux 파일 시스템 개요

### 1.1 파일 시스템이란?

파일 시스템은 저장 장치에 파일을 조직하고 저장하는 방법이다. 파일 시스템은 다음을 정의한다:
- 데이터의 저장 및 검색 방법
- 디렉터리 구조 및 이름 지정
- 메타데이터 (권한, 타임스탬프, 소유권)
- 공간 할당 및 관리

### 1.2 디스크 장치 이름 규칙

| 장치 | 설명 |
|--------|-------------|
| `/dev/sda` | 첫 번째 SCSI/SATA 디스크 |
| `/dev/sdb` | 두 번째 SCSI/SATA 디스크 |
| `/dev/sda1` | 첫 번째 디스크의 첫 번째 파티션 |
| `/dev/sda2` | 첫 번째 디스크의 두 번째 파티션 |
| `/dev/nvme0n1` | 첫 번째 NVMe SSD |
| `/dev/nvme0n1p1` | NVMe SSD의 첫 번째 파티션 |

### 1.3 inode와 데이터 블록

```
+--------+     +---------+     +------------+
| Inode  | --> | Direct  | --> | Data Block |
| Table  |     | Pointers|     | (4KB)      |
+--------+     +---------+     +------------+
                    |
               +---------+     +------------+
               | Indirect| --> | Data Block |
               | Pointer |     +------------+
               +---------+
```

- **inode:** 파일 메타데이터 저장 (크기, 권한, 타임스탬프, 데이터 블록 포인터)
- **데이터 블록:** 실제 파일 내용 저장
- **디렉터리 엔트리:** 파일 이름을 inode 번호에 매핑

---

<br>

## 2. 디스크 파티셔닝

### 2.1 파티션 유형

| 유형 | 설명 |
|------|-------------|
| **주 파티션 (Primary)** | 디스크당 최대 4개 (MBR) |
| **확장 파티션 (Extended)** | 논리 파티션의 컨테이너 (주 파티션 1개로 계산) |
| **논리 파티션 (Logical)** | 확장 파티션 내부에 생성 |

### 2.2 파티셔닝 도구

```bash
# fdisk - MBR 파티션 도구 (최대 2TB 디스크)
sudo fdisk /dev/sdb
# 명령: n (생성), d (삭제), p (출력), w (저장), q (종료)

# gdisk - GPT 파티션 도구 (2TB 초과 디스크)
sudo gdisk /dev/sdb

# parted - MBR과 GPT 모두 지원
sudo parted /dev/sdb

# 모든 파티션 나열
sudo fdisk -l
lsblk
```

### 2.3 MBR vs. GPT

| 특성 | MBR | GPT |
|---------|-----|-----|
| 최대 디스크 크기 | 2 TB | 9.4 ZB |
| 최대 파티션 수 | 4개 주 파티션 (또는 3개 주 + 1개 확장) | 128개 |
| 부팅 모드 | BIOS | UEFI |
| 백업 | 없음 | 디스크 끝에 백업 |

---

<br>

## 3. 파일 시스템 유형

### 3.1 Linux 파일 시스템

| 파일 시스템 | 설명 | 최대 파일 크기 | 최대 볼륨 |
|-------------|-------------|---------------|------------|
| **ext4** | 대부분의 Linux에서 기본; 저널링 지원 | 16 TB | 1 EB |
| **ext3** | 이전 기본 파일 시스템; 저널링 지원 | 2 TB | 32 TB |
| **ext2** | 저널링 없음; 플래시 저장소에 적합 | 2 TB | 32 TB |
| **xfs** | 고성능; RHEL/CentOS에서 기본 | 8 EB | 8 EB |
| **btrfs** | Copy-on-Write; 스냅샷, 압축 지원 | 16 EB | 16 EB |
| **tmpfs** | RAM 기반 파일 시스템 | (RAM 크기) | (RAM 크기) |

### 3.2 비Linux 파일 시스템

| 파일 시스템 | 설명 |
|-------------|-------------|
| **FAT32** | 크로스 플랫폼; 4 GB 파일 크기 제한 |
| **exFAT** | 확장 FAT; USB 드라이브에 적합 |
| **NTFS** | Windows 기본; ntfs-3g를 통해 읽기/쓰기 지원 |
| **NFS** | 네트워크 파일 시스템; 네트워크를 통한 파일 공유 |

### 3.3 저널링

**저널(Journal)** 은 메인 파일 시스템에 쓰기 전에 변경 사항을 기록하여 장애 복구를 가능하게 한다.

```
쓰기 요청 --> 저널 (기록) --> 메인 파일 시스템 --> 저널 삭제
                    |
            전원 장애? --> 부팅 시 저널 재실행
```

---

<br>

## 4. 파일 시스템 생성 및 관리

### 4.1 mkfs — 파일 시스템 생성

```bash
# ext4 파일 시스템 생성
sudo mkfs.ext4 /dev/sdb1
sudo mkfs -t ext4 /dev/sdb1     # 대안 문법

# XFS 파일 시스템 생성
sudo mkfs.xfs /dev/sdb1

# FAT32 파일 시스템 생성 (USB 드라이브용)
sudo mkfs.vfat /dev/sdb1

# 파일 시스템 검사
sudo fsck /dev/sdb1              # 파일 시스템 검사
sudo e2fsck -f /dev/sdb1         # ext 파일 시스템 강제 검사
```

### 4.2 파일 시스템 정보 확인

```bash
# 파일 시스템 유형 확인
sudo blkid                        # 블록 장치 ID와 유형 표시
df -Th                            # 마운트된 파일 시스템과 유형 표시
lsblk -f                          # 트리 형식으로 파일 시스템 정보 표시

# ext 파일 시스템 상세 정보
sudo dumpe2fs /dev/sdb1 | head -30
sudo tune2fs -l /dev/sdb1
```

---

<br>

## 5. 마운트와 언마운트

### 5.1 mount — 파일 시스템 연결

```bash
# 수동 마운트
sudo mount /dev/sdb1 /mnt/data
sudo mount -t ext4 /dev/sdb1 /mnt/data    # 파일 시스템 유형 지정
sudo mount -o ro /dev/sdb1 /mnt/data       # 읽기 전용으로 마운트

# ISO 이미지 마운트
sudo mount -o loop image.iso /mnt/iso

# USB 드라이브 마운트
sudo mount /dev/sdb1 /media/usb

# 마운트된 모든 파일 시스템 표시
mount
df -h
findmnt
```

### 5.2 umount — 파일 시스템 분리

```bash
sudo umount /mnt/data              # 마운트 포인트로 언마운트
sudo umount /dev/sdb1              # 장치로 언마운트
sudo umount -l /mnt/data           # 지연 언마운트 (사용 중인 경우)
```

### 5.3 /etc/fstab — 영구 마운트

```bash
# /etc/fstab 형식:
# 장치              마운트포인트   유형   옵션            dump  pass
/dev/sda1         /             ext4   defaults        0     1
/dev/sda2         /home         ext4   defaults        0     2
/dev/sdb1         /data         ext4   defaults        0     2
UUID=xxxx-xxxx    /backup       ext4   defaults,noauto 0     0
tmpfs             /tmp          tmpfs  defaults        0     0
```

**마운트 옵션:**
| 옵션 | 설명 |
|--------|-------------|
| `defaults` | rw, suid, dev, exec, auto, nouser, async |
| `ro` | 읽기 전용 |
| `rw` | 읽기-쓰기 |
| `noexec` | 바이너리 실행 방지 |
| `nosuid` | SUID/SGID 비트 무시 |
| `noauto` | 부팅 시 마운트하지 않음 |
| `user` | 비root 사용자도 마운트 허용 |

```bash
# 재부팅 없이 fstab 변경사항 적용
sudo mount -a
```

---

<br>

## 6. 디스크 사용량 모니터링

### 6.1 df — 디스크 여유 공간

```bash
df                      # 마운트된 모든 파일 시스템 표시
df -h                   # 사람이 읽기 쉬운 크기
df -T                   # 파일 시스템 유형 표시
df -i                   # inode 사용량 표시
df /home                # 특정 마운트 포인트 표시
```

### 6.2 du — 디스크 사용량

```bash
du -sh /home/user1                # 디렉터리 크기 요약
du -h --max-depth=1 /home         # 1단계 깊이
du -sh *                          # 현재 디렉터리의 각 항목 크기
du -ah /var/log | sort -rh | head -10   # 가장 큰 파일 상위 10개
```

---

<br>

## 7. 스왑 공간

### 7.1 스왑이란?

스왑 공간은 물리적 RAM이 가득 찼을 때 사용된다. 커널은 비활성 페이지를 RAM에서 스왑으로 이동시킨다.

### 7.2 스왑 관리

```bash
# 스왑 사용량 확인
free -h
swapon --show

# 스왑 파일 생성
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 영구 설정 (/etc/fstab에 추가)
# /swapfile none swap sw 0 0

# 스왑 비활성화
sudo swapoff /swapfile
```

---

<br>

## 8. 모범 사례

- 보안과 관리를 위해 `/home`, `/var`, `/tmp`를 별도의 파티션으로 분리
- 일반 용도에는 `ext4`, 대용량 파일과 고성능에는 `xfs` 사용
- `df -h`로 디스크 사용량을 정기적으로 모니터링
- 장치를 제거하기 전에 항상 언마운트
- 안정성을 위해 `/etc/fstab`에 장치 이름 대신 UUID 사용

---

<br>

## 요약

| 개념 | 핵심 내용 |
|---------|-----------|
| 파일 시스템 | 저장 장치에 데이터를 조직하는 방법 |
| 파티셔닝 | 디스크를 영역으로 분할 (`fdisk`, `gdisk`) |
| ext4 | 저널링을 지원하는 Linux 기본 파일 시스템 |
| inode | 파일 메타데이터 저장; 디렉터리를 통해 파일 이름과 매핑 |
| `mount`/`umount` | 파일 시스템을 디렉터리 트리에 연결/분리 |
| `/etc/fstab` | 영구 마운트 설정 파일 |
| `df` | 디스크 여유 공간 표시 |
| `du` | 디렉터리별 디스크 사용량 표시 |
| 스왑 | 디스크 기반 가상 메모리 확장 |

# 11주차 - 퀴즈

> **최종 수정일:** 2026-03-21

---

## Q1. RAID 레벨 식별

**문제:** 성능을 위해 스트라이핑을 제공하지만 **이중화가 없어** 단일 디스크 장애 시 전체 데이터가 손실되는 RAID 레벨은 무엇인가?

| 선택지 | RAID 레벨 |
|--------|------------|
| A | RAID 0 |
| B | RAID 1 |
| C | RAID 5 |
| D | RAID 10 |

**정답:** A. RAID 0

**해설:** RAID 0은 패리티나 미러링 없이 둘 이상의 디스크에 데이터를 분산(스트라이핑)한다. 이를 통해 성능과 용량이 극대화되지만(모든 디스크의 100% 사용 가능) 장애 허용 능력은 전혀 없다. 어떤 단일 디스크라도 장애가 발생하면 각 디스크가 데이터의 일부만 보유하고 있으므로 배열 내 모든 데이터가 손실된다.

---

## Q2. RAID 5 용량 계산

**문제:** 각각 1 TB 크기의 디스크 4개를 사용하여 RAID 5 배열을 생성한다. 사용 가능한 저장 용량은 얼마인가?

| 선택지 | 용량 |
|--------|------|
| A | 4 TB |
| B | 3 TB |
| C | 2 TB |
| D | 1 TB |

**정답:** B. 3 TB

**해설:** RAID 5는 분산 패리티를 사용하며, 패리티 데이터를 위해 디스크 1개 분량의 용량을 소비한다. 공식은 `(N-1) x 디스크 크기`이므로, 4 x 1 TB 디스크의 경우: `(4-1) x 1 TB = 3 TB`의 사용 가능 공간이 된다. 패리티 정보는 모든 디스크에 분산 저장되며(단일 전용 디스크에 저장되는 것이 아님), 배열은 어떤 디스크 하나의 장애도 허용할 수 있다.

---

## Q3. LVM 아키텍처

**문제:** LVM 계층 구조를 가장 낮은 수준부터 가장 높은 수준까지 올바르게 나열한 것은?

| 선택지 | 순서 |
|--------|------|
| A | Logical Volume -> Volume Group -> Physical Volume |
| B | Volume Group -> Physical Volume -> Logical Volume |
| C | Physical Volume -> Volume Group -> Logical Volume |
| D | Physical Volume -> Logical Volume -> Volume Group |

**정답:** C. Physical Volume -> Volume Group -> Logical Volume

**해설:** LVM에서는 `pvcreate`를 사용하여 디스크 파티션으로부터 Physical Volume(PV)을 생성한다. 그런 다음 `vgcreate`를 사용하여 PV를 Volume Group(VG)으로 결합한다. 마지막으로 `lvcreate`를 사용하여 VG에서 Logical Volume(LV)을 분할한다. 이 계층적 추상화를 통해 볼륨 크기 조정 및 다중 디스크 스패닝과 같은 유연한 스토리지 관리가 가능하다.

---

## Q4. RAID 1 배열 생성

**문제:** `/dev/sdb1`과 `/dev/sdc1`을 사용하여 `/dev/md0`이라는 RAID 1(미러) 배열을 생성하는 `mdadm` 명령어는?

| 선택지 | 명령어 |
|--------|--------|
| A | `sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb1 /dev/sdc1` |
| B | `sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1` |
| C | `sudo mdadm --add /dev/md0 --level=1 /dev/sdb1 /dev/sdc1` |
| D | `sudo mdadm --assemble /dev/md0 --level=1 /dev/sdb1 /dev/sdc1` |

**정답:** B. `sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1`

**해설:** `--create`는 새로운 RAID 배열을 초기화하고, `--level=1`은 RAID 1(미러링)을 지정하며, `--raid-devices=2`는 배열 내 디스크 수가 2개임을 나타낸다. 선택지 A는 RAID 0(스트라이핑, 이중화 없음)을 생성한다. 선택지 C의 `--add`는 기존 배열에 디스크를 추가하는 것이다. 선택지 D의 `--assemble`은 이전에 생성된 배열을 재조합하는 것이다.

---

## Q5. RAID vs. 백업

**문제:** 동료가 "RAID 1 미러링이 있으니 백업이 필요 없다"고 말한다. 이 주장이 **잘못된** 이유는 무엇인가?

**정답:** RAID는 하드웨어 장애 허용(디스크 장애 생존)을 제공하지만, 실수로 인한 삭제, 파일 손상, 랜섬웨어, 소프트웨어 버그, 또는 모든 디스크에 동시에 영향을 미치는 재해 상황으로부터는 보호하지 못한다. 백업은 데이터 손실 원인과 관계없이 특정 시점의 데이터 복구를 제공한다.

**해설:** RAID 1은 데이터를 실시간으로 미러링하므로, 실수로 인한 삭제, 손상, 또는 악의적 수정이 즉시 미러에 복제된다. RAID는 물리적 디스크 장애만을 보호한다. 적절한 백업 전략은 서로 다른 시점의 데이터 사본을 종종 다른 위치에 저장하여, 다양한 데이터 손실 시나리오에서 복구를 가능하게 한다.

---

## Q6. Logical Volume 확장

**문제:** LVM의 Logical Volume `/dev/vg_data/lv_home`의 공간이 부족하다. 이 볼륨에 10 GB를 추가하고 파일 시스템이 새 공간을 인식하도록 하는 데 필요한 두 가지 명령어를 설명하시오.

**정답:**
1. `sudo lvextend -L +10G /dev/vg_data/lv_home` - Logical Volume을 10 GB 확장
2. `sudo resize2fs /dev/vg_data/lv_home` - 확장된 볼륨에 맞게 ext4 파일 시스템 크기 조정

**해설:** `lvextend`는 Logical Volume의 크기를 증가시키지만, 그 안의 파일 시스템을 자동으로 크기 조정하지는 않는다. 새로 사용 가능해진 공간을 사용하려면 ext2/ext3/ext4 파일 시스템을 확장하기 위해 `resize2fs`가 필요하다. XFS 파일 시스템의 경우 `xfs_growfs`를 대신 사용한다. 또는 `lvextend -r`을 사용하면 두 작업을 한 번에 수행할 수 있다.

---

## Q7. 디스크 쿼터 설정

**문제:** `/home` 파티션에서 사용자 및 그룹 디스크 쿼터를 활성화하려면 `/etc/fstab`에 어떤 마운트 옵션을 추가해야 하는가?

| 선택지 | 마운트 옵션 |
|--------|-------------|
| A | `defaults,quota` |
| B | `defaults,usrquota,grpquota` |
| C | `defaults,limit,quota` |
| D | `defaults,diskquota` |

**정답:** B. `defaults,usrquota,grpquota`

**해설:** 디스크 쿼터를 활성화하려면 대상 파티션의 `/etc/fstab`에 `usrquota`와 `grpquota` 마운트 옵션을 지정해야 한다. 이 옵션을 추가한 후, 파일 시스템을 다시 마운트하고(`mount -o remount /home`), 쿼터 파일을 초기화하고(`quotacheck -cugm /home`), 쿼터를 활성화해야 한다(`quotaon /home`). 개별 사용자 제한은 `edquota -u username`으로 설정한다.

---

## Q8. RAID 레벨 선택

**문제:** 높은 읽기/쓰기 성능과 단일 디스크 장애 대응 능력을 모두 필요로 하는 데이터베이스 서버의 스토리지를 구성해야 한다. 가장 적합한 RAID 레벨은 무엇이며 그 이유는?

**정답:** RAID 10(RAID 1+0이라고도 함)이 가장 적합하다. 이중화를 위한 미러링(RAID 1)과 성능을 위한 스트라이핑(RAID 0)을 결합하여, 빠른 I/O와 장애 허용을 모두 제공한다.

**해설:** RAID 10은 최소 4개의 디스크가 필요하며, 미러링된 쌍을 스트라이핑하는 방식으로 구성된다. 최소 1개의 디스크 장애를 허용할 수 있으며(어떤 디스크가 장애를 일으키느냐에 따라 더 많이 허용될 수도 있다). 스트라이핑이 여러 미러링 쌍에 I/O를 분산시키므로 읽기 및 쓰기 속도가 우수하다. 단점은 50%의 용량 효율이다. RAID 5는 더 나은 용량을 제공하지만 패리티 계산으로 인해 쓰기 성능이 느려, RAID 10이 데이터베이스용 표준 선택이 된다.

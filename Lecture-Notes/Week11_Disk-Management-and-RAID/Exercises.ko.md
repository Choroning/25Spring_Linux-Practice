# 11주차 연습 문제 — 디스크 관리와 RAID

[레포지토리 안내](../../README.ko.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **최종 수정일:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 7

---

<br>

## 연습 문제 1: RAID 레벨 식별

**문제:** 성능을 위해 스트라이핑을 제공하지만 **이중화가 없어** 단일 디스크 장애 시 전체 데이터가 손실되는 RAID 레벨은 무엇인가?

- A. RAID 0
- B. RAID 1
- C. RAID 5
- D. RAID 10

**[풀이](Solutions.ko.md#연습-문제-1-raid-레벨-식별)**

---

<br>

## 연습 문제 2: RAID 5 용량 계산

**문제:** 각각 1 TB 크기의 디스크 4개를 사용하여 RAID 5 배열을 생성한다. 사용 가능한 저장 용량은 얼마인가?

- A. 4 TB
- B. 3 TB
- C. 2 TB
- D. 1 TB

**[풀이](Solutions.ko.md#연습-문제-2-raid-5-용량-계산)**

---

<br>

## 연습 문제 3: LVM 아키텍처

**문제:** LVM 계층 구조를 가장 낮은 수준부터 가장 높은 수준까지 올바르게 나열한 것은?

- A. Logical Volume -> Volume Group -> Physical Volume
- B. Volume Group -> Physical Volume -> Logical Volume
- C. Physical Volume -> Volume Group -> Logical Volume
- D. Physical Volume -> Logical Volume -> Volume Group

**[풀이](Solutions.ko.md#연습-문제-3-lvm-아키텍처)**

---

<br>

## 연습 문제 4: RAID 1 배열 생성

**문제:** `/dev/sdb1`과 `/dev/sdc1`을 사용하여 `/dev/md0`이라는 RAID 1(미러) 배열을 생성하는 `mdadm` 명령어는?

- A. `sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb1 /dev/sdc1`
- B. `sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1`
- C. `sudo mdadm --add /dev/md0 --level=1 /dev/sdb1 /dev/sdc1`
- D. `sudo mdadm --assemble /dev/md0 --level=1 /dev/sdb1 /dev/sdc1`

**[풀이](Solutions.ko.md#연습-문제-4-raid-1-배열-생성)**

---

<br>

## 연습 문제 5: RAID vs. 백업

**문제:** 동료가 "RAID 1 미러링이 있으니 백업이 필요 없다"고 말한다. 이 주장이 **잘못된** 이유는 무엇인가?

**[풀이](Solutions.ko.md#연습-문제-5-raid-vs-백업)**

---

<br>

## 연습 문제 6: Logical Volume 확장

**문제:** LVM의 Logical Volume `/dev/vg_data/lv_home`의 공간이 부족하다. 이 볼륨에 10 GB를 추가하고 파일 시스템이 새 공간을 인식하도록 하는 데 필요한 두 가지 명령어를 설명하라.

**[풀이](Solutions.ko.md#연습-문제-6-logical-volume-확장)**

---

<br>

## 연습 문제 7: 디스크 쿼터 설정

**문제:** `/home` 파티션에서 사용자 및 그룹 디스크 쿼터를 활성화하려면 `/etc/fstab`에 어떤 마운트 옵션을 추가해야 하는가?

- A. `defaults,quota`
- B. `defaults,usrquota,grpquota`
- C. `defaults,limit,quota`
- D. `defaults,diskquota`

**[풀이](Solutions.ko.md#연습-문제-7-디스크-쿼터-설정)**

---

<br>

## 연습 문제 8: RAID 레벨 선택

**문제:** 높은 읽기/쓰기 성능과 단일 디스크 장애 대응 능력을 모두 필요로 하는 데이터베이스 서버의 스토리지를 구성해야 한다. 가장 적합한 RAID 레벨은 무엇이며 그 이유는?

**[풀이](Solutions.ko.md#연습-문제-8-raid-레벨-선택)**

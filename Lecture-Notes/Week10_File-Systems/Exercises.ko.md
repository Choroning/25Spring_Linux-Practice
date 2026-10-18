# 10주차 연습 문제 — 파일 시스템

[레포지토리 안내](../../README.ko.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **최종 수정일:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 7

---

<br>

## 연습 문제 1: Windows USB 드라이브 마운트

**문제:** Windows USB 드라이브를 마운트하는 올바른 명령어는?

- A. `mount -t ext3 /dev/sdb1 /mnt`
- B. `mount -t xfs /dev/sdb1 /mnt`
- C. `mount -t vfat /dev/sdb1 /mnt`
- D. `mount -t iso9660 /dev/sdb1 /mnt`

**[풀이](Solutions.ko.md#연습-문제-1-windows-usb-드라이브-마운트)**

---

<br>

## 연습 문제 2: 파티션 정보 확인

**문제:** 시스템에 설치된 모든 디스크의 파티션 정보를 확인하는 명령어는?

- A. `fdisk -a`
- B. `fdisk -l`
- C. `fdisk -v`
- D. `fdisk -d`

**[풀이](Solutions.ko.md#연습-문제-2-파티션-정보-확인)**

---

<br>

## 연습 문제 3: ext3 파일 시스템 생성

**문제:** ext3 파일 시스템을 생성하는 명령어로 **올바르지 않은** 것은?

- A. `mkfs -t ext3 /dev/sdb1`
- B. `mke2fs -t ext3 /dev/sdb1`
- C. `mkfs.ext3 /dev/sdb1`
- D. `mke2fs.ext3 /dev/sdb1`

**[풀이](Solutions.ko.md#연습-문제-3-ext3-파일-시스템-생성)**

---

<br>

## 연습 문제 4: 디스크 기반이 아닌 파일 시스템

**문제:** 다음 중 디스크 기반 파일 시스템이 **아닌** 것은?

- A. proc
- B. ext
- C. ext4
- D. xfs

**[풀이](Solutions.ko.md#연습-문제-4-디스크-기반이-아닌-파일-시스템)**

---

<br>

## 연습 문제 5: 디스크 설정 절차

**문제:** 새로 설치한 디스크를 설정할 때 올바른 작업 순서는?

- A. 파티션 생성 -> 디스크 마운트 -> 디스크 포맷
- B. 파티션 생성 -> 디스크 포맷 -> 디스크 마운트
- C. 디스크 마운트 -> 파티션 생성 -> 디스크 포맷
- D. 디스크 포맷 -> 파티션 생성 -> 디스크 마운트

**[풀이](Solutions.ko.md#연습-문제-5-디스크-설정-절차)**

---

<br>

## 연습 문제 6: 부팅 시 마운트 설정

**문제:** 부팅 시 파일 시스템을 마운트하기 위한 정보를 저장하는 파일은?

- A. `/etc/mtab`
- B. `/etc/mount`
- C. `/etc/fstab`
- D. `/etc/ftab`

**[풀이](Solutions.ko.md#연습-문제-6-부팅-시-마운트-설정)**

---

<br>

## 연습 문제 7: 마운트 포인트

**문제:** 디렉터리 계층 구조에서 파일 시스템이 연결되는 디렉터리를 무엇이라 하는가?

**[풀이](Solutions.ko.md#연습-문제-7-마운트-포인트)**

---

<br>

## 연습 문제 8: CD-ROM 마운트

**문제:** CD-ROM을 `/cdrom` 디렉터리에 마운트하는 명령어는?

**[풀이](Solutions.ko.md#연습-문제-8-cd-rom-마운트)**

---

<br>

## 연습 문제 9: 파티션에 파일 시스템 생성

**문제:** 파티션에 파일 시스템을 생성하는 데 사용하는 명령어는?

**[풀이](Solutions.ko.md#연습-문제-9-파티션에-파일-시스템-생성)**

---

<br>

## 연습 문제 10: LVM의 목적

**문제:** LVM(Logical Volume Manager)과 같은 기능이 필요한 이유를 설명하라.

**[풀이](Solutions.ko.md#연습-문제-10-lvm의-목적)**

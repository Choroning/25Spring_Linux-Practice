# 14주차 연습 문제 — 부팅과 종료

[레포지토리 안내](../../README.ko.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **최종 수정일:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 8

---

<br>

## 연습 문제 1: init의 대체 서비스

**문제:** 전통적인 PID 1 프로세스 `init`을 대체한 서비스의 이름은?

- A. system
- B. systemd
- C. systemctl
- D. sysinit

**[풀이](Solutions.ko.md#연습-문제-1-init의-대체-서비스)**

---

<br>

## 연습 문제 2: 현재 타겟 확인

**문제:** 현재(기본) 타겟을 확인하는 명령어는?

- A. `systemctl set-default`
- B. `systemctl status`
- C. `systemctl start`
- D. `systemctl get-default`

**[풀이](Solutions.ko.md#연습-문제-2-현재-타겟-확인)**

---

<br>

## 연습 문제 3: 시스템 종료 명령어

**문제:** 다음 중 시스템을 종료하는 명령어가 **아닌** 것은?

- A. `reboot`
- B. `halt`
- C. `kill`
- D. `poweroff`

**[풀이](Solutions.ko.md#연습-문제-3-시스템-종료-명령어)**

---

<br>

## 연습 문제 4: Linux 부팅 순서

**문제:** Linux 부팅 단계의 올바른 순서는?

- A. Boot loader -> BIOS -> Kernel init -> systemd -> Login prompt
- B. BIOS -> Kernel init -> Boot loader -> systemd -> Login prompt
- C. Boot loader -> Kernel init -> BIOS -> systemd -> Login prompt
- D. BIOS -> Boot loader -> Kernel init -> systemd -> Login prompt

**[풀이](Solutions.ko.md#연습-문제-4-linux-부팅-순서)**

---

<br>

## 연습 문제 5: 재부팅 런레벨

**문제:** 시스템 재부팅을 나타내는 런레벨은?

- A. 0
- B. 3
- C. 5
- D. 6

**[풀이](Solutions.ko.md#연습-문제-5-재부팅-런레벨)**

---

<br>

## 연습 문제 6: 예약 재부팅

**문제:** 1분 후에 시스템을 재부팅하도록 설정하는 명령어는?

- A. `shutdown -h +1`
- B. `shutdown -r +1`
- C. `shutdown -c +1`
- D. `shutdown -k +1`

**[풀이](Solutions.ko.md#연습-문제-6-예약-재부팅)**

---

<br>

## 연습 문제 7: 부트로더의 역할

**문제:** 부트로더의 역할을 설명하라.

**[풀이](Solutions.ko.md#연습-문제-7-부트로더의-역할)**

---

<br>

## 연습 문제 8: 장치 유닛 목록 확인

**문제:** 어떤 장치 유닛이 존재하는지 확인하는 명령어는?

**[풀이](Solutions.ko.md#연습-문제-8-장치-유닛-목록-확인)**

---

<br>

## 연습 문제 9: 서비스 활성 상태 확인

**문제:** `abc.service` 유닛이 활성(실행 중)인지 확인하는 명령어는?

**[풀이](Solutions.ko.md#연습-문제-9-서비스-활성-상태-확인)**

---

<br>

## 연습 문제 10: 단일 사용자 모드로 전환

**문제:** 문제 해결을 위해 시스템을 단일 사용자(복구) 모드로 전환하는 명령어는?

**[풀이](Solutions.ko.md#연습-문제-10-단일-사용자-모드로-전환)**

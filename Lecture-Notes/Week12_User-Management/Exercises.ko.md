# 12주차 연습 문제 — 사용자 관리

[레포지토리 안내](../../README.ko.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **최종 수정일:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 10

---

<br>

## 연습 문제 1: 중복 UID/GID를 지원하는 명령어

**문제:** 사용자 계정 그룹과 관련된 명령어 중 중복 UID 또는 GID 설정을 **허용하지 않는** 명령어는?

- A. `usermod`
- B. `useradd`
- C. `userdel`
- D. `groupadd`

**[풀이](Solutions.ko.md#연습-문제-1-중복-uidgid를-지원하는-명령어)**

---

<br>

## 연습 문제 2: 특정 UID로 사용자 생성

**문제:** `adduser` 명령어를 사용하여 UID 1010으로 사용자 계정 `han01`을 생성하는 방법은?

- A. `adduser 1010 han01`
- B. `adduser -u 1010 han01`
- C. `adduser -uid 1010 han01`
- D. `adduser --uid 1010 han01`

**[풀이](Solutions.ko.md#연습-문제-2-특정-uid로-사용자-생성)**

---

<br>

## 연습 문제 3: 사용자 비밀번호 잠금

**문제:** `han01` 계정의 비밀번호를 잠그는 명령어는?

- A. `passwd -d han01`
- B. `passwd -u han01`
- C. `passwd -l han01`
- D. `passwd -x han01`

**[풀이](Solutions.ko.md#연습-문제-3-사용자-비밀번호-잠금)**

---

<br>

## 연습 문제 4: 디스크 쿼터 할당

**문제:** 사용자 계정 `han01`에 디스크 쿼터를 할당하는 명령어는?

- A. `quotaon han01`
- B. `edquota -u han01`
- C. `edquota han01`
- D. `quotacheck -u han01`

**[풀이](Solutions.ko.md#연습-문제-4-디스크-쿼터-할당)**

---

<br>

## 연습 문제 5: 로그인 셸 지정

**문제:** Bourne 셸을 로그인 셸로 하여 사용자 계정 `han01`을 생성하는 명령어는?

- A. `useradd -b sh han01`
- B. `useradd -s sh han01`
- C. `useradd -b /bin/sh han01`
- D. `useradd -s /bin/sh han01`

**[풀이](Solutions.ko.md#연습-문제-5-로그인-셸-지정)**

---

<br>

## 연습 문제 6: 최대 비밀번호 사용 기간 설정

**문제:** `han01`의 최대 비밀번호 사용 기간을 200일로 설정하는 명령어는?

- A. `useradd -x 200 han01`
- B. `usermod -x 200 han01`
- C. `chage -M 200 han01`
- D. `chage -m 200 han01`

**[풀이](Solutions.ko.md#연습-문제-6-최대-비밀번호-사용-기간-설정)**

---

<br>

## 연습 문제 7: EUID 확인

**문제:** EUID(Effective User ID)를 확인하는 데 사용할 수 있는 명령어는?

**[풀이](Solutions.ko.md#연습-문제-7-euid-확인)**

---

<br>

## 연습 문제 8: 비밀번호 저장 파일

**문제:** 사용자 비밀번호가 저장되는 파일은?

**[풀이](Solutions.ko.md#연습-문제-8-비밀번호-저장-파일)**

---

<br>

## 연습 문제 9: 기본 그룹 정보

**문제:** 사용자의 기본(주) 그룹을 확인할 수 있는 파일은?

**[풀이](Solutions.ko.md#연습-문제-9-기본-그룹-정보)**

---

<br>

## 연습 문제 10: 사용자 삭제 시 `-r` 옵션

**문제:** 사용자 계정 삭제 시 `-r` 옵션의 의미는?

**[풀이](Solutions.ko.md#연습-문제-10-사용자-삭제-시--r-옵션)**

# 7주차 연습 문제 — 파일 접근 권한

[레포지토리 안내](../../README.ko.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **최종 수정일:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 5

---

<br>

## 연습 문제 1: 권한 문자열 해석

**문제:** 권한 문자열 `drwxr-x---`는 무엇을 나타내는가?

- A. 모든 사용자에게 전체 접근이 가능한 일반 파일
- B. 소유자에게 전체 접근 권한이 있고, 그룹은 읽기 및 진입이 가능하며, 기타 사용자는 접근 불가인 디렉터리
- C. 모든 사용자가 읽기와 실행이 가능한 디렉터리
- D. 제한된 권한을 가진 심볼릭 링크

**[풀이](Solutions.ko.md#연습-문제-1-권한-문자열-해석)**

---

<br>

## 연습 문제 2: 8진수 권한 변환

**문제:** 권한 `rw-r-xr--`의 8진수 표현은?

- A. `654`
- B. `645`
- C. `754`
- D. `544`

**[풀이](Solutions.ko.md#연습-문제-2-8진수-권한-변환)**

---

<br>

## 연습 문제 3: 기호 모드로 chmod 사용

**문제:** `script.sh`에 대해 소유자에게 실행 권한을 추가하고 기타 사용자의 쓰기 권한을 제거하는 명령어는?

- A. `chmod u+x,o+w script.sh`
- B. `chmod u+x,o-w script.sh`
- C. `chmod a+x,o-w script.sh`
- D. `chmod u-x,o+w script.sh`

**[풀이](Solutions.ko.md#연습-문제-3-기호-모드로-chmod-사용)**

---

<br>

## 연습 문제 4: umask 이해

**문제:** umask가 `027`로 설정된 경우, 새로 생성된 일반 파일의 권한은?

- A. `750` (`rwxr-x---`)
- B. `640` (`rw-r-----`)
- C. `027` (`----w-rwx`)
- D. `666` (`rw-rw-rw-`)

**[풀이](Solutions.ko.md#연습-문제-4-umask-이해)**

---

<br>

## 연습 문제 5: 소유권 변경

**문제:** `data/`와 그 모든 내용의 소유자를 `admin`으로, 그룹을 `staff`로 변경하는 명령어는?

- A. `sudo chown admin:staff data/`
- B. `sudo chown -R admin:staff data/`
- C. `sudo chgrp -R admin:staff data/`
- D. `sudo chmod -R admin:staff data/`

**[풀이](Solutions.ko.md#연습-문제-5-소유권-변경)**

---

<br>

## 연습 문제 6: 특수 권한 (Sticky Bit)

**문제:** `/tmp` 디렉터리의 권한이 다음과 같다:

```text
drwxrwxrwt 15 root root 4096 Mar 21 10:00 /tmp
```

권한 문자열 끝의 `t`는 무엇을 의미하는가?

**[풀이](Solutions.ko.md#연습-문제-6-특수-권한-sticky-bit)**

---

<br>

## 연습 문제 7: SetUID 권한

**문제:** `/usr/bin/passwd` 명령어에 SUID 비트가 설정되어 있는 이유와, 이를 제거하면 어떻게 되는가?

**[풀이](Solutions.ko.md#연습-문제-7-setuid-권한)**

---

<br>

## 연습 문제 8: 누구나 쓸 수 있는 파일 찾기

**문제:** "Permission denied" 오류를 억제하면서 시스템의 모든 누구나 쓸 수 있는 일반 파일을 찾는 명령어를 작성하라.

**[풀이](Solutions.ko.md#연습-문제-8-누구나-쓸-수-있는-파일-찾기)**

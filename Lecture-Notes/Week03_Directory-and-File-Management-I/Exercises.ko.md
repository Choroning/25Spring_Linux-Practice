# 3주차 연습 문제 — 디렉터리 및 파일 관리 I

[레포지토리 안내](../../README.ko.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **최종 수정일:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 2

---

<br>

## 연습 문제 1: 파일 유형 식별

**문제:** 다음 `ls -l` 출력에서 `mylink`는 어떤 유형의 파일인가?

```text
lrwxrwxrwx 1 user1 user1 16 Mar 21 10:00 mylink -> /home/user1/data
```

- A. 일반 파일
- B. 디렉터리
- C. 심볼릭 링크
- D. 블록 장치

**[풀이](Solutions.ko.md#연습-문제-1-파일-유형-식별)**

---

<br>

## 연습 문제 2: 디렉터리 계층 구조

**문제:** `hostname`, `passwd`, `fstab`과 같은 시스템 전체 설정 파일이 저장되는 디렉터리는?

- A. `/home`
- B. `/var`
- C. `/etc`
- D. `/usr`

**[풀이](Solutions.ko.md#연습-문제-2-디렉터리-계층-구조)**

---

<br>

## 연습 문제 3: 절대 경로 vs. 상대 경로

**문제:** 현재 작업 디렉터리가 `/home/user1/Documents`일 때, 상대 경로를 사용하여 `/home/user2/file.txt`를 올바르게 참조하는 것은?

- A. `../user2/file.txt`
- B. `./user2/file.txt`
- C. `../../user2/file.txt`
- D. `~/user2/file.txt`

**[풀이](Solutions.ko.md#연습-문제-3-절대-경로-vs-상대-경로)**

---

<br>

## 연습 문제 4: 중첩 디렉터리 생성

**문제:** `projects/2025/spring/` 디렉터리 구조를 하나의 명령어로 생성해야 하지만, 상위 디렉터리가 하나도 존재하지 않는다. 어떤 명령어가 성공하는가?

- A. `mkdir projects/2025/spring`
- B. `mkdir -p projects/2025/spring`
- C. `mkdir -r projects/2025/spring`
- D. `rmdir -p projects/2025/spring`

**[풀이](Solutions.ko.md#연습-문제-4-중첩-디렉터리-생성)**

---

<br>

## 연습 문제 5: 파일 내용 보기

**문제:** 새 항목이 추가되는 로그 파일을 실시간으로 모니터링하고 싶다. 가장 적절한 명령어는?

- A. `cat /var/log/syslog`
- B. `head -f /var/log/syslog`
- C. `tail -f /var/log/syslog`
- D. `less -f /var/log/syslog`

**[풀이](Solutions.ko.md#연습-문제-5-파일-내용-보기)**

---

<br>

## 연습 문제 6: 숨김 파일

**문제:** `.`으로 시작하는 숨김 파일을 포함하여 현재 디렉터리의 모든 파일을 나열하려면?

**[풀이](Solutions.ko.md#연습-문제-6-숨김-파일)**

---

<br>

## 연습 문제 7: /root와 /의 구분

**문제:** Linux 디렉터리 계층 구조에서 `/`와 `/root`의 차이를 설명하라.

**[풀이](Solutions.ko.md#연습-문제-7-root와-의-구분)**

---

<br>

## 연습 문제 8: ls -l 출력 해석

**문제:** 다음 출력에서 `report.txt` 파일의 하드 링크 수와 파일 크기는?

```text
-rw-r--r-- 3 user1 staff 2048 Mar 21 14:00 report.txt
```

**[풀이](Solutions.ko.md#연습-문제-8-ls--l-출력-해석)**

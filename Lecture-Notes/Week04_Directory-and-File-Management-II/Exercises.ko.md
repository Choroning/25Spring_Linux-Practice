# 4주차 연습 문제 — 디렉터리 및 파일 관리 II

[레포지토리 안내](../../README.ko.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **최종 수정일:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 2

---

<br>

## 연습 문제 1: 디렉터리 복사

**문제:** `project/` 디렉터리 전체와 그 내용을 `/backup/`으로 올바르게 복사하는 명령어는?

- A. `cp project/ /backup/`
- B. `cp -r project/ /backup/`
- C. `cp -f project/ /backup/`
- D. `cp -l project/ /backup/`

**[풀이](Solutions.ko.md#연습-문제-1-디렉터리-복사)**

---

<br>

## 연습 문제 2: 하드 링크 vs. 심볼릭 링크

**문제:** 하드 링크에 대한 다음 설명 중 **틀린** 것은?

- A. 하드 링크는 원본 파일과 동일한 inode 번호를 공유한다.
- B. 원본 파일을 삭제하면 하드 링크가 댕글링 링크가 된다.
- C. 하드 링크는 서로 다른 파일 시스템 사이에 생성할 수 없다.
- D. 하드 링크는 디렉터리에 대해 생성할 수 없다.

**[풀이](Solutions.ko.md#연습-문제-2-하드-링크-vs-심볼릭-링크)**

---

<br>

## 연습 문제 3: I/O 리다이렉션

**문제:** 출력 리다이렉션에서 `>`와 `>>`의 차이점은?

- A. `>`는 파일에 추가하고, `>>`는 파일을 덮어쓴다.
- B. `>`는 파일을 덮어쓰고, `>>`는 파일에 추가한다.
- C. `>`와 `>>` 모두 파일을 덮어쓴다.
- D. `>`는 stdout에 쓰고, `>>`는 stderr에 쓴다.

**[풀이](Solutions.ko.md#연습-문제-3-io-리다이렉션)**

---

<br>

## 연습 문제 4: grep과 정규 표현식 사용

**문제:** `/etc/passwd`에서 문자열 `root`로 시작하는 모든 줄을 표시하는 명령어는?

- A. `grep "root$" /etc/passwd`
- B. `grep "^root" /etc/passwd`
- C. `grep "*root" /etc/passwd`
- D. `grep "root" /etc/passwd`

**[풀이](Solutions.ko.md#연습-문제-4-grep과-정규-표현식-사용)**

---

<br>

## 연습 문제 5: find로 파일 찾기

**문제:** `/var` 아래에서 50 MB보다 큰 모든 `.log` 파일을 찾는 명령어를 작성하라.

**[풀이](Solutions.ko.md#연습-문제-5-find로-파일-찾기)**

---

<br>

## 연습 문제 6: 파이프 사용

**문제:** 다음 명령어는 무엇을 하는가?

```bash
cat /etc/passwd | sort | head -5
```

- A. `/etc/passwd`의 처음 5줄을 원래 순서로 표시한다.
- B. `/etc/passwd`의 마지막 5줄을 알파벳 순으로 표시한다.
- C. `/etc/passwd`의 모든 줄을 알파벳 순으로 정렬한 뒤 처음 5줄을 표시한다.
- D. `/etc/passwd`를 정렬하고 처음 5줄을 파일에 저장한다.

**[풀이](Solutions.ko.md#연습-문제-6-파이프-사용)**

---

<br>

## 연습 문제 7: tee 사용

**문제:** `ls -la`의 출력을 화면에서 보면서 동시에 `filelist.txt`에 저장하고 싶다. 어떤 명령어를 사용해야 하는가?

**[풀이](Solutions.ko.md#연습-문제-7-tee-사용)**

---

<br>

## 연습 문제 8: stderr 리다이렉션

**문제:** `find / -name "*.conf"`의 오류 메시지만 `errors.txt` 파일로 리다이렉션하고, 정상 출력은 화면에 표시하는 명령어는?

- A. `find / -name "*.conf" > errors.txt`
- B. `find / -name "*.conf" 2> errors.txt`
- C. `find / -name "*.conf" &> errors.txt`
- D. `find / -name "*.conf" 1> errors.txt`

**[풀이](Solutions.ko.md#연습-문제-8-stderr-리다이렉션)**

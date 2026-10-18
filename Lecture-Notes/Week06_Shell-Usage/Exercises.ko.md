# 6주차 연습 문제 — 셸 사용법

[레포지토리 안내](../../README.ko.md) | [English](Exercises.md) | [한국어](Exercises.ko.md)

> **최종 수정일:** 2026-10-19
>
> 우분투 리눅스, 이종원, Ch 4

---

<br>

## 연습 문제 1: 셸의 역할

**문제:** 다음 중 Linux에서 셸의 역할을 가장 잘 설명한 것은?

- A. 하드웨어 자원을 직접 관리하는 프로그램
- B. 사용자와 커널 사이의 명령줄 해석기
- C. Linux 커널 자체
- D. 그래픽 데스크톱 환경

**[풀이](Solutions.ko.md#연습-문제-1-셸의-역할)**

---

<br>

## 연습 문제 2: 기본 셸 확인

**문제:** 현재 사용자의 기본 로그인 셸을 표시하는 명령어는?

- A. `echo $HOME`
- B. `echo $SHELL`
- C. `echo $PATH`
- D. `echo $USER`

**[풀이](Solutions.ko.md#연습-문제-2-기본-셸-확인)**

---

<br>

## 연습 문제 3: 환경 변수와 지역 변수의 차이

**문제:** `MY_VAR="hello"`와 `export MY_VAR="hello"`의 차이점은?

- A. 차이가 없으며, 둘 다 환경 변수를 생성한다
- B. `export`는 변수를 자식 프로세스에서 사용 가능하게 하고, `export` 없이는 현재 셸에서만 유효하다
- C. `export`는 변수를 읽기 전용으로 만든다
- D. `export` 없이는 변수가 영구적이고, `export`를 사용하면 임시적이다

**[풀이](Solutions.ko.md#연습-문제-3-환경-변수와-지역-변수의-차이)**

---

<br>

## 연습 문제 4: 셸 초기화 파일

**문제:** 새로운 대화형 bash 셸 세션이 시작될 때마다(새 터미널 창 열기 포함) 실행되는 파일은?

- A. `~/.bash_profile`
- B. `~/.bash_logout`
- C. `~/.bashrc`
- D. `/etc/hostname`

**[풀이](Solutions.ko.md#연습-문제-4-셸-초기화-파일)**

---

<br>

## 연습 문제 5: 별칭 관리

**문제:** 현재 셸에서 `alias rm='rm -i'` 별칭을 만들었다. 재부팅 후 별칭이 사라졌다. 별칭을 영구적으로 만들려면 어떻게 해야 하는가?

**[풀이](Solutions.ko.md#연습-문제-5-별칭-관리)**

---

<br>

## 연습 문제 6: 인용 규칙

**문제:** `name="Linux"`가 설정된 상태에서, 각 명령어의 출력은?

```bash
echo 'Hello $name'
echo "Hello $name"
```

- A. `Hello Linux` / `Hello Linux`
- B. `Hello $name` / `Hello $name`
- C. `Hello $name` / `Hello Linux`
- D. `Hello Linux` / `Hello $name`

**[풀이](Solutions.ko.md#연습-문제-6-인용-규칙)**

---

<br>

## 연습 문제 7: 명령어 히스토리

**문제:** 키워드를 입력하여 명령어 히스토리를 대화형으로 검색할 수 있는 명령어 또는 단축키는?

- A. `history | grep keyword`
- B. `Ctrl + R`
- C. `!keyword`
- D. `Ctrl + Z`

**[풀이](Solutions.ko.md#연습-문제-7-명령어-히스토리)**

---

<br>

## 연습 문제 8: PATH 수정

**문제:** `/opt/myapp/bin`에 사용자 지정 애플리케이션을 설치했으며, 어느 디렉터리에서나 해당 명령어를 사용하고 싶다. 이 디렉터리를 `PATH`에 추가하는 명령어를 작성하라.

**[풀이](Solutions.ko.md#연습-문제-8-path-수정)**

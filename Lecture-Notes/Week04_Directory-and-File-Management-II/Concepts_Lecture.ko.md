# 4주차 — 디렉터리 및 파일 관리 II

> **최종 수정일:** 2026-04-01

> **선수 지식**: 기본 파일 관리 (3주차).
>
> **학습 목표**:
> 1. 파일 검색 명령어(find, locate, which)를 사용할 수 있다
> 2. 텍스트 처리 명령어(cat, head, tail, grep, sort)를 적용할 수 있다
> 3. 파일 압축과 아카이빙(tar, gzip)을 관리할 수 있다

---

## 목차

1. [파일 복사, 이동, 삭제](#1-파일-복사-이동-삭제)
2. [하드 링크와 심볼릭 링크](#2-하드-링크와-심볼릭-링크)
3. [빈 파일 생성](#3-빈-파일-생성)
4. [파일 내용 검색](#4-파일-내용-검색)
5. [파일 위치 검색](#5-파일-위치-검색)
6. [와일드카드와 글로빙](#6-와일드카드와-글로빙)
7. [I/O 리다이렉션과 파이프](#7-io-리다이렉션과-파이프)
8. [모범 사례](#8-모범-사례)
9. [요약](#요약)

---

<br>

## 1. 파일 복사, 이동, 삭제

### 1.1 cp — 파일 및 디렉터리 복사

```bash
cp source destination            # 파일 복사
cp file1.txt file2.txt           # file1.txt를 file2.txt로 복사
cp file.txt /tmp/                # /tmp 디렉터리로 복사
cp -r dir1/ dir2/                # 디렉터리를 재귀적으로 복사
cp -i file.txt /tmp/             # 대화형 (덮어쓰기 전 확인)
cp -p file.txt backup/           # 타임스탬프 및 권한 보존
cp -a dir1/ dir2/                # 아카이브 모드 (모든 것 보존)
cp file1 file2 file3 destdir/    # 여러 파일을 디렉터리로 복사
```

### 1.2 mv — 파일 이동 또는 이름 변경

```bash
mv oldname.txt newname.txt       # 파일 이름 변경
mv file.txt /tmp/                # 파일을 /tmp로 이동
mv dir1/ /home/user/             # 디렉터리 이동
mv -i file.txt /tmp/             # 대화형 (덮어쓰기 전 확인)
mv file1 file2 destdir/          # 여러 파일 이동
```

> **핵심 포인트:** `mv`는 이중 용도로 사용되며, 파일 이동과 이름 변경을 모두 수행한다.

### 1.3 rm — 파일 및 디렉터리 제거

```bash
rm file.txt                      # 파일 제거
rm -i file.txt                   # 대화형 (삭제 전 확인)
rm -f file.txt                   # 강제 제거 (확인 없음)
rm -r directory/                 # 디렉터리와 내용을 재귀적으로 제거
rm -rf directory/                # 강제 재귀 제거 (위험)
```

**경고:** Linux CLI에는 "휴지통"이 없다. 삭제된 파일은 영구적으로 사라진다.

```bash
# 안전 팁: 기본적으로 rm -i 사용
alias rm='rm -i'                 # ~/.bashrc에 추가
```

---

<br>

## 2. 하드 링크와 심볼릭 링크

### 2.1 Inode

Linux 파일시스템의 모든 파일은 다음을 저장하는 **inode** (index node)를 가진다:
- 파일 유형 및 권한
- 소유자 및 그룹
- 파일 크기
- 타임스탬프 (생성, 수정, 접근)
- 데이터 블록에 대한 포인터
- **파일 이름은 포함하지 않음** (이름은 디렉터리 항목에 저장됨)

```bash
ls -i file.txt                   # inode 번호 표시
stat file.txt                    # 상세 inode 정보 표시
```

### 2.2 하드 링크

하드 링크는 **동일한 inode** 를 가리키는 추가 디렉터리 항목을 생성한다.

```bash
ln original.txt hardlink.txt

# 두 파일이 동일한 inode를 공유
$ ls -li
1234567 -rw-r--r-- 2 user1 user1 100 Mar 21 10:00 hardlink.txt
1234567 -rw-r--r-- 2 user1 user1 100 Mar 21 10:00 original.txt
```

**특성:**
- 동일한 inode 번호
- 하드 링크 수 증가 (위 출력의 `2`)
- 하나를 삭제해도 다른 것에 영향 없음
- 파일시스템 간 연결 불가
- 디렉터리에 대한 하드 링크 불가 (`.`과 `..` 제외)

### 2.3 심볼릭 링크 (소프트 링크)

심볼릭 링크는 원본 파일의 경로를 포함하는 **새 파일** 을 생성한다.

```bash
ln -s /path/to/original.txt symlink.txt

$ ls -l
lrwxrwxrwx 1 user1 user1 21 Mar 21 10:00 symlink.txt -> /path/to/original.txt
```

**특성:**
- 원본과 다른 inode 번호
- 대상 파일의 경로를 포함
- 파일시스템 간 연결 가능
- 디렉터리에 대한 링크 가능
- 대상이 삭제되면 "댕글링 링크"가 됨

### 2.4 비교

| 특징 | 하드 링크 | 심볼릭 링크 |
|------|-----------|-------------|
| Inode | 원본과 동일 | 다름 |
| 파일시스템 간 | 불가 | 가능 |
| 디렉터리 링크 | 불가 | 가능 |
| 대상 삭제 시 | 파일 계속 접근 가능 | 댕글링(끊어진) 링크 |
| 파일 크기 | 원본과 동일 | 경로 문자열 크기 |
| 명령어 | `ln file link` | `ln -s file link` |

---

<br>

## 3. 빈 파일 생성

### 3.1 touch — 파일 생성 또는 타임스탬프 갱신

```bash
touch newfile.txt                # 빈 파일 생성 (또는 타임스탬프 갱신)
touch -t 202503211200 file.txt   # 특정 타임스탬프 설정
touch -r ref.txt file.txt        # 참조 파일에서 타임스탬프 복사
touch file1 file2 file3          # 여러 파일 생성
```

---

<br>

## 4. 파일 내용 검색

### 4.1 grep — 파일 내용 검색

```bash
grep "pattern" file.txt                  # 파일에서 패턴 검색
grep -i "pattern" file.txt               # 대소문자 구분 없이 검색
grep -n "pattern" file.txt               # 줄 번호 표시
grep -r "pattern" directory/             # 디렉터리에서 재귀적 검색
grep -v "pattern" file.txt               # 역 매칭 (매칭되지 않는 줄 표시)
grep -c "pattern" file.txt               # 매칭되는 줄 수 세기
grep -l "pattern" *.txt                  # 매칭되는 파일 이름만 표시
grep -w "word" file.txt                  # 완전한 단어만 매칭
grep -E "regex" file.txt                 # 확장 정규식 (egrep과 동일)
```

**정규 표현식 기초:**

| 패턴 | 의미 |
|------|------|
| `.` | 임의의 단일 문자 |
| `*` | 앞 문자의 0회 이상 반복 |
| `^` | 줄의 시작 |
| `$` | 줄의 끝 |
| `[abc]` | 집합 내의 임의의 문자 |
| `[^abc]` | 집합에 포함되지 않은 임의의 문자 |
| `\b` | 단어 경계 |

```bash
# 예시
grep "^root" /etc/passwd          # "root"로 시작하는 줄
grep "bash$" /etc/passwd          # "bash"로 끝나는 줄
grep "^$" file.txt                # 빈 줄
grep -E "[0-9]{3}" file.txt       # 연속된 3자리 숫자
```

---

<br>

## 5. 파일 위치 검색

### 5.1 find — 파일 검색

```bash
find /path -name "filename"              # 정확한 이름으로 검색
find /home -name "*.txt"                 # 패턴으로 검색
find / -name "*.log" -size +10M          # 10MB보다 큰 로그 파일 검색
find . -type f -name "*.sh"              # 일반 파일만 검색
find . -type d -name "backup"            # 디렉터리만 검색
find /tmp -mtime -7                      # 최근 7일 내 수정된 파일
find . -user user1                       # user1 소유 파일 검색
find . -perm 755                         # 특정 권한의 파일 검색
find . -empty                            # 빈 파일/디렉터리 검색

# 검색된 파일에 명령어 실행
find . -name "*.tmp" -exec rm {} \;      # 모든 .tmp 파일 삭제
find . -name "*.sh" -exec chmod +x {} \; # 모든 .sh 파일에 실행 권한 부여
```

### 5.2 whereis — 바이너리, 소스, 매뉴얼 위치

```bash
whereis ls
# ls: /usr/bin/ls /usr/share/man/man1/ls.1.gz
```

### 5.3 which — 명령어 바이너리 위치

```bash
which python3
# /usr/bin/python3
```

### 5.4 locate — 빠른 파일 검색 (데이터베이스 기반)

```bash
sudo apt install mlocate           # 미설치 시 설치
sudo updatedb                      # 파일 데이터베이스 갱신
locate filename                    # 빠른 검색
locate -i filename                 # 대소문자 구분 없이
```

> **핵심 포인트:** `locate`는 미리 구축된 데이터베이스를 검색하므로 `find`보다 훨씬 빠르지만, 최근 변경 사항이 반영되지 않을 수 있다. `updatedb`를 실행하여 갱신한다.

---

<br>

## 6. 와일드카드와 글로빙

### 6.1 셸 와일드카드

| 와일드카드 | 의미 | 예시 |
|-----------|------|------|
| `*` | 임의 수의 문자 | `*.txt` = 모든 .txt 파일 |
| `?` | 정확히 한 문자 | `file?.txt` = file1.txt, fileA.txt |
| `[abc]` | 집합 내의 한 문자 | `file[123].txt` = file1.txt, file2.txt |
| `[a-z]` | 범위 내의 한 문자 | `[a-z]*.txt` = 소문자로 시작하는 파일 |
| `[!abc]` | 집합에 포함되지 않은 한 문자 | `file[!0-9].txt` = 숫자가 아닌 접미사 |
| `{a,b,c}` | 중괄호 확장 | `file.{txt,log}` = file.txt, file.log |

```bash
ls *.txt                          # 모든 .txt 파일
ls file[0-9].txt                  # file0.txt부터 file9.txt까지
cp *.{jpg,png} images/            # 모든 jpg와 png 파일 복사
rm test_?.log                     # test_1.log, test_A.log 등 제거
```

---

<br>

## 7. I/O 리다이렉션과 파이프

### 7.1 표준 I/O 스트림

| 스트림 | 파일 디스크립터 | 기본값 |
|--------|----------------|--------|
| stdin | 0 | 키보드 |
| stdout | 1 | 화면 |
| stderr | 2 | 화면 |

### 7.2 출력 리다이렉션

```bash
command > file                    # stdout을 파일로 리다이렉션 (덮어쓰기)
command >> file                   # stdout을 파일로 리다이렉션 (추가)
command 2> file                   # stderr를 파일로 리다이렉션
command 2>&1                      # stderr를 stdout으로 리다이렉션
command > file 2>&1               # stdout과 stderr를 모두 리다이렉션
command &> file                   # 위의 축약형 (bash)
```

### 7.3 입력 리다이렉션

```bash
command < file                    # 파일에서 입력 읽기
sort < unsorted.txt               # 파일 입력으로 정렬
```

### 7.4 파이프

```bash
command1 | command2               # command1의 stdout을 command2의 stdin으로 전달
ls -la | grep "\.txt$"            # .txt 파일만 나열
cat /etc/passwd | sort            # passwd 항목 정렬
ps aux | grep nginx               # nginx 프로세스 찾기
history | tail -20                # 최근 20개 명령어 표시
```

### 7.5 tee — 파일과 화면에 동시 출력

```bash
command | tee file.txt            # 파일과 화면 모두에 출력
command | tee -a file.txt         # 파일에 추가하면서 화면에도 표시
```

---

<br>

## 8. 모범 사례

### 8.1 효율적인 파일 관리

- 실수 방지를 위해 `cp -i`, `mv -i`, `rm -i` 사용
- 디렉터리에는 하드 링크보다 심볼릭 링크 사용 권장
- 일괄 작업에 `find`와 `-exec` 사용
- 여러 파일에서 검색 시 `grep -r` 사용

### 8.2 안전 팁

```bash
# rm -rf 실행 전, 경로 확인
echo rm -rf /path/to/dir         # 먼저 명령어 미리 보기
ls /path/to/dir                  # 디렉터리 내용 확인

# 안전을 위해 rm 대신 trash-cli 사용
sudo apt install trash-cli
trash-put file.txt               # 삭제 대신 휴지통으로 이동
```

---

<br>

## 요약

| 개념 | 핵심 사항 |
|------|-----------|
| `cp` | 파일 복사; 디렉터리는 `-r`, 속성 보존은 `-p` 사용 |
| `mv` | 파일 및 디렉터리 이동 또는 이름 변경 |
| `rm` | 파일 제거; 디렉터리는 `-r`; 되돌릴 수 없음! |
| 하드 링크 | 동일 inode; 파일시스템 간 불가; 모든 링크 제거 시까지 파일 유지 |
| 심볼릭 링크 | 다른 inode; 파일시스템 간 가능; 디렉터리 링크 가능 |
| `touch` | 빈 파일 생성 또는 타임스탬프 갱신 |
| `grep` | 패턴과 정규식을 사용한 파일 내용 검색 |
| `find` | 이름, 유형, 크기, 날짜, 권한으로 파일 검색 |
| 와일드카드 | `*` (임의), `?` (단일 문자), `[set]`, `{a,b}` |
| 리다이렉션 | `>` (덮어쓰기), `>>` (추가), `2>` (stderr), `<` (입력) |
| 파이프 | `\|`로 명령어 연결, stdout을 stdin으로 전달 |

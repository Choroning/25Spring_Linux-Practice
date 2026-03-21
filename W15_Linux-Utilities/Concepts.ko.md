# 15주차 - Linux 유틸리티

> **최종 수정일:** 2026-03-21

---

## 목차

1. [텍스트 처리 유틸리티](#1-텍스트-처리-유틸리티)
2. [cut - 열 추출](#2-cut---열-추출)
3. [paste - 파일 병합](#3-paste---파일-병합)
4. [sort - 줄 정렬](#4-sort---줄-정렬)
5. [uniq - 중복 제거](#5-uniq---중복-제거)
6. [wc - 단어 수 세기](#6-wc---단어-수-세기)
7. [split - 파일 분할](#7-split---파일-분할)
8. [dd - 데이터 복제](#8-dd---데이터-복제)
9. [기타 유용한 유틸리티](#9-기타-유용한-유틸리티)
10. [모범 사례](#10-모범-사례)
11. [요약](#요약)

---

## 1. 텍스트 처리 유틸리티

Linux는 텍스트 데이터를 처리하기 위한 풍부한 명령줄 유틸리티를 제공한다. 이러한 도구들은 하나의 작업을 잘 수행한다는 Unix 철학을 따르며, 파이프와 결합하여 강력한 데이터 처리 파이프라인을 구성할 수 있다.

```bash
# 예시 파이프라인: /var/log에서 가장 큰 파일 상위 10개 찾기
du -ah /var/log 2>/dev/null | sort -rh | head -10
```

---

## 2. cut - 열 추출

### 2.1 사용법

```bash
cut -c list file          # 문자 위치로 잘라내기
cut -f list file          # 필드로 잘라내기 (탭 구분)
cut -d delim -f list file # 사용자 정의 구분자로 필드 잘라내기
```

### 2.2 예제

```bash
# 1-3번째 문자 추출
echo "Hello World" | cut -c1-3        # 출력: Hel

# 탭으로 구분된 파일에서 필드 추출
# s.dat: 001\tHong\tGil-Dong\t80\tM
cut -f 2,3 s.dat                      # 출력: Hong  Gil-Dong

# 콜론으로 구분된 파일에서 추출 (/etc/passwd와 같은)
cut -d: -f1,3 /etc/passwd            # 출력: root:0
cut -d: -f1,6 /etc/passwd            # username:homedir

# 특정 문자 범위 추출
cut -c1-5,10-15 filename
```

---

## 3. paste - 파일 병합

### 3.1 사용법

```bash
paste file1 file2         # 파일을 나란히 병합 (탭 구분)
paste -d delim file1 file2 # 사용자 정의 구분자 사용
paste -s file             # 단일 파일의 줄을 한 줄로 병합
```

### 3.2 예제

```bash
# ID 파일과 이름 파일 병합
# file1: 001\n002\n003
# file2: Hong Gil-Dong\nPark Ji-Soo\nLee Na-Young
paste file1 file2
# 출력:
# 001  Hong Gil-Dong
# 002  Park Ji-Soo
# 003  Lee Na-Young

# 직렬 병합 (모든 줄을 한 줄로)
paste -s file1
# 출력: 001  002  003  004  005  006  007

# 사용자 정의 구분자
paste -d',' file1 file2
# 출력: 001,Hong Gil-Dong
```

---

## 4. sort - 줄 정렬

### 4.1 사용법

```bash
sort file                 # 알파벳순 정렬
sort -n file              # 숫자순 정렬
sort -r file              # 역순 정렬
sort -k field file        # 특정 필드로 정렬
sort -t delim file        # 필드 구분자 지정
sort -u file              # 정렬 후 중복 제거
```

### 4.2 예제

```bash
# 기본 알파벳순 정렬
sort names.txt

# 숫자순 정렬
sort -n numbers.txt

# 4번째 필드(점수)로 숫자순 역순 정렬
sort -t' ' -k4 -n -r s.dat
# 출력 (최고 점수 우선):
# 002 Park Ji-Soo 100 M
# 001 Hong Gil-Dong 80 M
# 005 Han Ju-Hyun 75 M

# /etc/passwd를 UID(3번째 필드)로 정렬
sort -t: -k3 -n /etc/passwd

# 대소문자 무시 정렬
sort -f file.txt

# 로캘 인식 정렬 (특수 문자)
LC_ALL=C sort file.txt    # 일관된 결과를 위해 C 로캘 사용
```

---

## 5. uniq - 중복 제거

### 5.1 사용법

```bash
uniq file                 # 인접 중복 제거
uniq -c file              # 발생 횟수 표시
uniq -d file              # 중복된 줄만 표시
uniq -u file              # 고유한 줄만 표시
uniq -i file              # 대소문자 무시 비교
```

### 5.2 예제

```bash
# 중요: uniq는 인접 중복만 제거하므로, 먼저 sort를 해야 함!
sort data.txt | uniq

# 발생 횟수 표시
sort data.txt | uniq -c
# 출력:
#   3 abcde
#   1 aaaaa
#   3 bbbbb
#   1 ccc

# 중복된 줄만 찾기
sort data.txt | uniq -d

# 고유한 (중복되지 않은) 줄 찾기
sort data.txt | uniq -u
```

> **핵심 사항:** `uniq`는 인접한 줄만 비교하므로, 항상 `uniq` 전에 `sort`를 수행할 것.

---

## 6. wc - 단어 수 세기

### 6.1 사용법

```bash
wc file                   # 줄, 단어, 문자 수
wc -l file                # 줄 수만
wc -w file                # 단어 수만
wc -c file                # 바이트 수
wc -m file                # 문자 수
```

### 6.2 예제

```bash
wc /etc/passwd
#   43   76  2237 /etc/passwd
# 줄수  단어수  바이트수

# 사용자 수 세기
wc -l /etc/passwd

# 디렉터리 내 파일 수 세기
ls | wc -l

# 여러 파일의 줄 수 세기
wc -l *.txt

# 고유한 줄 수 세기
sort data.txt | uniq | wc -l
```

---

## 7. split - 파일 분할

### 7.1 사용법

```bash
split -l lines file prefix    # 줄 수로 분할
split -b size file prefix     # 파일 크기로 분할
split -n chunks file prefix   # N개의 동일한 조각으로 분할
```

### 7.2 예제

```bash
# 100줄씩 분할
split -l 100 largefile.txt part_
# 생성: part_aa, part_ab, part_ac, ...

# 10MB 단위로 분할
split -b 10M backup.tar.gz chunk_

# 분할된 파일 재조합
cat part_* > reassembled.txt
cat chunk_* > reassembled.tar.gz
```

---

## 8. dd - 데이터 복제

### 8.1 사용법

```bash
dd if=input of=output bs=blocksize count=blocks
```

### 8.2 예제

```bash
# 0으로 채워진 1GB 파일 생성
dd if=/dev/zero of=test.img bs=1M count=1024

# 디스크 복제 (주의 - 장치 이름을 매우 신중히 확인!)
sudo dd if=/dev/sda of=/dev/sdb bs=4M status=progress

# ISO로부터 부팅 가능한 USB 생성
sudo dd if=ubuntu.iso of=/dev/sdb bs=4M status=progress

# MBR 백업
sudo dd if=/dev/sda of=mbr_backup.bin bs=512 count=1

# 파일을 대문자로 변환
dd if=input.txt of=output.txt conv=ucase
```

> **핵심 사항:** `dd`는 원시 장치 수준에서 작동한다. 잘못된 `of=` 매개변수는 데이터를 파괴할 수 있다. 항상 장치 이름을 이중으로 확인할 것!

---

## 9. 기타 유용한 유틸리티

### 9.1 tr - 문자 변환

```bash
echo "hello" | tr 'a-z' 'A-Z'         # HELLO
echo "hello  world" | tr -s ' '       # 중복 공백 제거
echo "hello123" | tr -d '0-9'         # 숫자 제거: hello
```

### 9.2 sed - 스트림 편집기

```bash
sed 's/old/new/' file                  # 각 줄에서 첫 번째 치환
sed 's/old/new/g' file                 # 모두 치환
sed -n '5,10p' file                    # 5-10줄 출력
sed '3d' file                          # 3번째 줄 삭제
sed -i 's/old/new/g' file             # 제자리 편집
```

### 9.3 awk - 패턴 처리

```bash
awk '{print $1, $3}' file             # 1번째와 3번째 필드 출력
awk -F: '{print $1, $6}' /etc/passwd  # 사용자 정의 구분자
awk 'NR>=5 && NR<=10' file            # 5-10줄 출력
awk '{sum += $1} END {print sum}' file # 첫 번째 열 합산
```

### 9.4 xargs - 입력으로부터 명령 구성

```bash
find . -name "*.tmp" | xargs rm       # 찾은 파일 삭제
echo "a b c" | xargs -n1 echo         # 명령당 인자 1개
```

---

## 10. 모범 사례

- 파이프로 유틸리티를 연결하여 복잡한 텍스트 처리 수행
- `sort | uniq` 패턴 사용 (uniq 전에 sort)
- 복잡한 필드 기반 처리에는 `awk` 선호
- 제자리 편집 전 백업 생성을 위해 `sed -i.bak` 사용
- 긴 작업에 `dd status=progress` 사용
- `dd` 실행 전 항상 장치 이름 확인

---

## 요약

| 유틸리티 | 핵심 기능 | 주요 사용법 |
|---------|----------|------------|
| `cut` | 열/필드 추출 | `cut -d: -f1 /etc/passwd` |
| `paste` | 파일을 나란히 병합 | `paste file1 file2` |
| `sort` | 줄 정렬 | `sort -k2 -n file` |
| `uniq` | 인접 중복 제거 | `sort file \| uniq -c` |
| `wc` | 줄/단어/문자 수 세기 | `wc -l file` |
| `split` | 파일을 부분으로 분할 | `split -l 1000 file prefix_` |
| `dd` | 원시 데이터 복사/변환 | `dd if=input of=output bs=4M` |
| `tr` | 문자 변환/삭제 | `tr 'a-z' 'A-Z'` |
| `sed` | 스트림 텍스트 편집 | `sed 's/old/new/g' file` |
| `awk` | 패턴 기반 처리 | `awk '{print $1}' file` |

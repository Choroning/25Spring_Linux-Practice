# 13주차 — Bash 셸 프로그래밍

> **최종 수정일:** 2026-04-01

> **선수 지식**: 셸 사용법 (6주차). [프로그래밍언어] 기본 프로그래밍 논리.
>
> **학습 목표**:
> 1. 변수, 조건문, 반복문으로 bash 스크립트를 작성할 수 있다
> 2. 스크립트에서 명령줄 인수를 처리할 수 있다
> 3. awk와 sed로 텍스트 처리를 적용할 수 있다

---

## 목차

1. [셸 스크립트 기초](#1-셸-스크립트-기초)
2. [변수와 데이터 타입](#2-변수와-데이터-타입)
3. [입력과 출력](#3-입력과-출력)
4. [조건문](#4-조건문)
5. [반복문](#5-반복문)
6. [함수](#6-함수)
7. [문자열 및 파일 연산](#7-문자열-및-파일-연산)
8. [고급 기능](#8-고급-기능)
9. [모범 사례](#9-모범-사례)
10. [요약](#요약)

---

<br>

## 1. 셸 스크립트 기초

### 1.1 스크립트 작성

```bash
#!/bin/bash
# My first script
echo "Hello Linux World."
pwd
```

### 1.2 스크립트 실행

```bash
chmod +x script.sh          # 실행 권한 부여
./script.sh                  # ./로 실행

bash script.sh               # bash를 명시적으로 지정하여 실행
source script.sh             # 현재 셸에서 실행 (환경에 영향)
. script.sh                  # source와 동일
```

### 1.3 셔뱅(Shebang) 라인

```bash
#!/bin/bash                  # bash 인터프리터 사용
#!/bin/sh                    # POSIX 셸 사용
#!/usr/bin/env bash          # 이식성: PATH에서 bash 탐색
#!/usr/bin/env python3       # Python 스크립트
```

---

<br>

## 2. 변수와 데이터 타입

### 2.1 변수 할당

```bash
name="Linux"                 # = 주위에 공백 없음
count=42
path="/home/user1"
readonly CONSTANT="fixed"    # 읽기 전용 변수
```

### 2.2 변수 사용

```bash
echo $name                   # 단순 확장
echo ${name}                 # 명시적 확장
echo "Hello, $name"          # 큰따옴표 내부
echo "Length: ${#name}"      # 문자열 길이
```

### 2.3 특수 변수

| 변수 | 설명 |
|------|------|
| `$0` | 스크립트 이름 |
| `$1` ~ `$9` | 위치 매개변수 |
| `$#` | 인자 개수 |
| `$*` | 모든 인자를 하나의 문자열로 |
| `$@` | 모든 인자를 개별 문자열로 |
| `$?` | 마지막 명령의 종료 상태 |
| `$$` | 현재 스크립트의 PID |
| `$!` | 마지막 백그라운드 프로세스의 PID |

### 2.4 산술 연산

```bash
# (( )) 사용
(( sum = 5 + 3 ))
(( count++ ))
echo $(( 10 * 5 ))          # 출력: 50

# let 사용
let "result = 5 + 3"

# expr 사용 (외부 명령어)
result=$(expr 5 + 3)

# bc를 사용한 부동소수점 연산
echo "scale=2; 10 / 3" | bc  # 출력: 3.33
```

---

<br>

## 3. 입력과 출력

### 3.1 read - 사용자 입력

```bash
read name                    # 변수에 읽기
echo "Name: $name"

read -p "Enter name: " name # 프롬프트 메시지
read -s password             # 무음 입력 (비밀번호)
read -t 10 answer            # 10초 후 타임아웃
read -n 1 choice             # 한 글자만 읽기

# 여러 변수에 읽기
read first last
echo "First: $first, Last: $last"

# 변수 없이 읽기 ($REPLY에 저장)
read -p "Input: "
echo "You entered: $REPLY"
```

### 3.2 echo와 printf

```bash
echo "Hello World"
echo -n "No newline"         # 개행 억제
echo -e "Tab:\there"         # 이스케이프 시퀀스 활성화

printf "%-10s %5d\n" "Alice" 95
printf "Name: %s, Score: %d\n" "$name" "$score"
```

### 3.3 Here Document

```bash
cat << EOF
This is a here document.
Variables like $HOME are expanded.
Multiple lines are supported.
EOF

cat << 'EOF'
Variables like $HOME are NOT expanded.
EOF

cat -n << END
Line 1
Line 2
Line 3
END
```

---

<br>

## 4. 조건문

### 4.1 if-then-else

```bash
if (( x < y )); then
    echo "$x is less than $y"
else
    echo "$y is less than or equal to $x"
fi
```

### 4.2 if-elif-else

```bash
if (( score >= 90 )); then
    echo "Grade: A"
elif (( score >= 80 )); then
    echo "Grade: B"
elif (( score >= 70 )); then
    echo "Grade: C"
else
    echo "Grade: F"
fi
```

### 4.3 테스트 연산자

**숫자 비교 (`(( ))` 내부 또는 `-eq` 등 사용):**

| 연산자 | `(( ))` | `[ ]` / `[[ ]]` |
|--------|---------|------------------|
| 같음 | `==` | `-eq` |
| 같지 않음 | `!=` | `-ne` |
| 미만 | `<` | `-lt` |
| 초과 | `>` | `-gt` |
| 이하 | `<=` | `-le` |
| 이상 | `>=` | `-ge` |

**문자열 비교 (`[[ ]]` 내부):**

| 연산자 | 설명 |
|--------|------|
| `==` 또는 `=` | 같음 |
| `!=` | 같지 않음 |
| `<` | 사전순으로 앞 |
| `>` | 사전순으로 뒤 |
| `-z` | 문자열이 비어 있음 |
| `-n` | 문자열이 비어 있지 않음 |

**파일 테스트:**

| 연산자 | 설명 |
|--------|------|
| `-e file` | 파일 존재 |
| `-f file` | 일반 파일 존재 |
| `-d file` | 디렉터리 존재 |
| `-r file` | 파일 읽기 가능 |
| `-w file` | 파일 쓰기 가능 |
| `-x file` | 파일 실행 가능 |
| `-s file` | 파일이 비어 있지 않음 |
| `-L file` | 파일이 심볼릭 링크 |

### 4.4 case 문

```bash
case $cmd in
    [0-9])
        date
        ;;
    cd|CD)
        echo "$HOME"
        ;;
    quit|exit)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Unknown command"
        ;;
esac
```

---

<br>

## 5. 반복문

### 5.1 for 반복문

```bash
# 리스트 기반
for num in 0 1 2 3 4; do
    echo "Number: $num"
done

# 범위 기반 (bash)
for i in {1..10}; do
    echo "Count: $i"
done

# C 스타일
for (( i=0; i<10; i++ )); do
    echo "Index: $i"
done

# 명령어 출력 순회
for file in $(ls *.sh); do
    echo "Script: $file"
done

# 명령줄 인자 순회
for arg in "$@"; do
    echo "Argument: $arg"
done
```

### 5.2 while 반복문

```bash
count=1
sum=0
while (( count <= 10 )); do
    (( sum += count ))
    (( count++ ))
done
echo "Sum(1~10): $sum"
```

### 5.3 until 반복문

```bash
# 사용자 로그인 대기
until who | grep -q "$person"; do
    sleep 5
done
echo "$person has logged in!"
```

### 5.4 select 메뉴

```bash
PS3="Choose an option (1-3): "
select cmd in pwd date quit; do
    case $cmd in
        pwd)  pwd ;;
        date) date ;;
        quit) break ;;
        *)    echo "Invalid option" ;;
    esac
done
```

### 5.5 반복문 제어

```bash
# break -- 반복문 완전히 종료
# continue -- 다음 반복으로 건너뛰기

for name in alice bob charlie dave; do
    if [[ $name == "charlie" ]]; then
        continue        # charlie 건너뛰기
    fi
    echo "Hello, $name"
done
```

---

<br>

## 6. 함수

### 6.1 함수 정의

```bash
function greet {
    echo "Hello, $1!"
}

# 대안 문법
add() {
    local sum=$(( $1 + $2 ))
    echo $sum
}

# 함수 호출
greet "World"
result=$(add 5 3)
echo "Result: $result"
```

### 6.2 반환 값

```bash
function is_even {
    if (( $1 % 2 == 0 )); then
        return 0    # 성공 (참)
    else
        return 1    # 실패 (거짓)
    fi
}

if is_even 4; then
    echo "4 is even"
fi
```

---

<br>

## 7. 문자열 및 파일 연산

### 7.1 문자열 연산

```bash
str="Hello World"
echo ${#str}              # 길이: 11
echo ${str:0:5}           # 부분 문자열: Hello
echo ${str/World/Linux}   # 치환: Hello Linux
echo ${str^^}             # 대문자: HELLO WORLD
echo ${str,,}             # 소문자: hello world
```

### 7.2 파일 유형 테스트

```bash
echo "Enter filename: "
read file

if [[ ! -e $file ]]; then
    echo "$file does not exist."
elif [[ -f $file ]]; then
    echo "$file is a regular file."
elif [[ -d $file ]]; then
    echo "$file is a directory."
else
    echo "$file is a special file."
fi
```

---

<br>

## 8. 고급 기능

### 8.1 시그널 트래핑

```bash
trap 'echo "Line $LINENO: count=$count"' DEBUG
# DEBUG 트랩은 모든 명령 실행 전에 발동

trap 'echo "Caught SIGINT"; exit 1' INT
# Ctrl+C 캐치

trap 'cleanup_function' EXIT
# 스크립트 종료 시 정리 함수 실행
```

### 8.2 종료 상태

```bash
#!/bin/bash
# 특정 코드로 종료
command_that_might_fail
if [[ $? -ne 0 ]]; then
    echo "Command failed"
    exit 1
fi
exit 0
```

### 8.3 주석과 자기 출력 스크립트

```bash
#!/bin/bash
# 일반 주석

: '
이것은 콜론 내장 명령과
here-string을 사용한
여러 줄 주석이다.
'

# 재미있는 기법: #!/bin/more를 사용하면 스크립트가 자기 자신을 출력
# 재미있는 기법: #!/bin/rm을 사용하면 스크립트가 자기 자신을 삭제
```

---

<br>

## 9. 모범 사례

- 항상 `#!/bin/bash` 또는 `#!/usr/bin/env bash`를 셔뱅으로 사용
- 단어 분리를 방지하기 위해 변수를 따옴표로 감싸기: `"$variable"`
- bash에서 문자열 비교 시 `[ ]` 대신 `[[ ]]` 사용
- 산술 비교에 `(( ))` 사용
- 스코프 문제를 피하기 위해 함수 내 변수에 `local` 사용
- 엄격한 에러 처리를 위해 `set -euo pipefail` 사용
- 복잡한 로직에 의미 있는 주석 추가
- `shellcheck`를 사용하여 스크립트 린트

---

<br>

## 요약

| 개념 | 핵심 사항 |
|------|----------|
| 셔뱅 | `#!/bin/bash` - 인터프리터 지정 |
| 변수 | `name="value"`, `$name`, `${name}` |
| 위치 매개변수 | `$1`-`$9`, `$#`, `$*`, `$@`, `$?` |
| read | 사용자 입력 (`read -p "prompt" var`) |
| if/elif/else | 테스트 연산자를 사용한 조건 분기 |
| case | 패턴 매칭 (`case $var in pattern) ... ;;`) |
| for | 리스트, 범위, 또는 C 스타일 순회 |
| while/until | 조건이 참인 동안 / 조건이 참이 될 때까지 반복 |
| select | 대화형 메뉴 생성 |
| 함수 | `function name { }` - 지역 변수와 return |
| trap | 시그널 처리 (`trap 'cmd' SIGNAL`) |

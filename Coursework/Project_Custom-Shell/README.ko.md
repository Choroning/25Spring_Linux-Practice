# 사용자 정의 셸 (minishell)

[레포지토리 안내](../../README.ko.md) | [English](README.md) | [한국어](README.ko.md)

> **최종 수정일:** 2026-10-26

Bash만으로 작성한 최소 셸 구현이다. 명령 파싱, 내장 명령, 파이프, 리다이렉션, 인용 같은 셸의 핵심 개념을 보여 준다.

## 구조

```text
Project_Custom-Shell/
├── minishell.sh    # Main shell entry point (REPL loop)
├── builtins.sh     # Built-in command implementations
├── parser.sh       # Command parsing (pipes, redirections, quoting)
├── README.ko.md
└── README.md
```

## 사용법

```bash
chmod +x *.sh
./minishell.sh
```

## 내장 명령

| 명령 | 설명 | 예 |
|---------|-------------|---------|
| `cd [dir]` | 디렉터리 변경 | `cd /tmp`, `cd ~`, `cd -` |
| `pwd` | 작업 디렉터리 출력 | `pwd` |
| `history [-c] [n]` | 명령 히스토리 표시와 삭제 | `history 10`, `history -c` |
| `export [VAR=val]` | 환경 변수 설정과 목록 출력 | `export PATH=/usr/bin:$PATH` |
| `alias [name=cmd]` | 명령 별칭 정의와 목록 출력 | `alias ll='ls -la'` |
| `unalias [-a] name` | 별칭 제거 | `unalias ll`, `unalias -a` |
| `help` | 도움말 출력 | `help` |
| `exit` / `quit` | 셸 종료 | `exit` |

## 기능

- **사용자 정의 프롬프트:** `user@host:directory$` 형식의 프롬프트를 색으로 구분하여 표시한다.
- **파이프:** `ls -la | grep ".sh" | wc -l`
- **출력 리다이렉션:** `echo "hello" > file.txt`, `echo "world" >> file.txt`
- **입력 리다이렉션:** `wc -l < file.txt`
- **명령 히스토리:** 세션이 끝나도 히스토리가 유지된다(`~/.minishell_history`).
- **별칭 지원:** 명령의 짧은 이름을 정의할 수 있다.
- **시그널 처리:** Ctrl+C를 누르면 새 프롬프트를 표시하고, Ctrl+D를 누르면 정상적으로 종료한다.

## 설계

셸은 다음과 같은 전형적인 REPL(Read-Eval-Print Loop) 패턴을 따른다.

1. **읽기(Read):** 프롬프트를 표시하고 readline 기능으로 사용자 입력을 읽는다.
2. **파싱(Parse):** 입력을 토큰으로 나누고, 별칭을 확장하고, 파이프와 리다이렉션을 찾는다.
3. **평가(Evaluate):** 내장 명령은 셸에서 직접 실행하고, 외부 명령은 fork하여 실행한다.
4. **출력(Print):** 명령의 출력을 터미널에 표시한다.
5. **반복(Loop):** 1단계로 돌아간다.

### 내장 명령이 필요한 이유

어떤 명령은 셸 자신의 상태를 바꾸므로 셸에 내장되어야 한다.
- `cd`는 셸의 작업 디렉터리를 바꾼다.
- `export`는 셸의 환경 변수를 수정한다.
- `alias`는 셸의 별칭 표에 항목을 추가한다.

이 명령들이 외부 프로그램이라면 자식 프로세스에서 실행되므로, 변경한 내용이 부모 셸에 반영되지 않는다.

## 참고 문헌

- Carnegie Mellon University, 15-213: Introduction to Computer Systems (Shell Lab)
- MIT, 6.033: Computer System Engineering
- Bash Reference Manual: https://www.gnu.org/software/bash/manual/
- Advanced Bash-Scripting Guide: https://tldp.org/LDP/abs/html/

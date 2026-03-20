# [2025학년도 봄학기] Linux 실습

![Last Commit](https://img.shields.io/github/last-commit/Choroning/25Spring_Linux-Practice)
![Languages](https://img.shields.io/github/languages/top/Choroning/25Spring_Linux-Practice)

이 레포지토리는 대학 강의 및 과제를 위해 작성된 Linux 명령어 및 셸 스크립트를 체계적으로 정리하고 보관합니다.

*작성자: 박철원 (고려대학교(세종), 컴퓨터융합소프트웨어학과) - 2025년 기준 2학년*
<br><br>

## 📑 목차

- [레포지토리 소개](#about-this-repository)
- [강의 정보](#course-information)
- [사전 요구사항](#prerequisites)
- [레포지토리 구조](#repository-structure)
- [라이선스](#license)

---


<br><a name="about-this-repository"></a>
## 📝 레포지토리 소개

이 레포지토리에는 대학 수준의 Linux 실습 과목을 위해 작성된 코드 및 스크립트가 포함되어 있습니다:

- 각 주차별 Linux 관리 및 셸 활용을 종합적으로 정리한 **Concepts.md** 파일
- 일부 주차별 복습 문제 및 풀이를 담은 **Quiz.md** 파일
- 목적, 사용법, 구조를 문서화한 **Doxygen 스타일 헤더**가 포함된 개선된 셸 스크립트
- 강의 시연 코드 및 과제 솔루션
- 해외 CS 명문 대학 커리큘럼을 참고하여 설계한 2개의 **텀 프로젝트** (System Monitoring Dashboard, Custom Shell)

본 과목은 Linux 설치, 파일 및 디렉토리 관리, Vi/Vim 편집, 셸 명령어, 파일 권한, 프로세스 관리, 디스크 및 파일 시스템, 사용자 관리, Bash 셸 프로그래밍을 다룹니다.

<br><a name="course-information"></a>
## 📚 강의 정보

- **학기:** 2025학년도 봄학기 (3월 - 6월)
- **소속:** 고려대학교(세종)

|학수번호      |강의명    |이수구분|교수자|개설학과|
|:----------:|:-------|:----:|:------:|:----------------|
|`DCCS209-00`|Linux 실습|전공선택|김명섭 교수|컴퓨터융합소프트웨어학과|

- **📖 참고 자료**

| 유형 | 내용 |
|:----:|:---------|
|강의자료|교수자 제공 슬라이드 및 온라인 영상|

<br><a name="prerequisites"></a>
## ✅ 사전 요구사항

- C/C++ 프로그래밍 능력

- **💻 개발 환경**

| 도구 | 회사 |  운영체제  | 비고 |
|:-----|:-------:|:----:|:------|
|Terminal|Apple Inc.|macOS|    |
|Vi/Vim|Open Source|Linux|    |
|UTM|Open Source|macOS|Linux VM|
|VMware Fusion|Broadcom|macOS|Linux VM|

<br><a name="repository-structure"></a>
## 🗂 레포지토리 구조

```plaintext
25Spring_Linux-Practice
├── Project_Custom-Shell
│   ├── builtins.sh
│   ├── minishell.sh
│   ├── parser.sh
│   └── README.md
├── Project_System-Monitoring-Dashboard
│   ├── cpu_monitor.sh
│   ├── disk_monitor.sh
│   ├── install.sh
│   ├── log_analyzer.sh
│   ├── mem_monitor.sh
│   ├── monitor.sh
│   ├── network_monitor.sh
│   └── README.md
├── W01_Course-Introduction
│   └── Concepts.md
├── W02_Linux-Installation
│   └── Concepts.md
├── W03_Directory-and-File-Management-I
│   └── Concepts.md
├── W04_Directory-and-File-Management-II
│   └── Concepts.md
├── W05_Vi-Editor
│   └── Concepts.md
├── W06_Shell-Usage
│   └── Concepts.md
├── W07_File-Access-Permissions
│   └── Concepts.md
├── W09_Process-Management
│   ├── Concepts.md
│   └── Quiz.md
├── W10_File-Systems
│   ├── Concepts.md
│   └── Quiz.md
├── W11_Disk-Management-and-RAID
│   └── Concepts.md
├── W12_User-Management
│   ├── Concepts.md
│   └── Quiz.md
├── W13_Bash-Shell-Programming
│   ├── arithmetic.sh
│   ├── basic_script.sh
│   ├── case_statement.sh
│   ├── comments_advanced.sh
│   ├── comments.sh
│   ├── Concepts.md
│   ├── continue_test.sh
│   ├── elif_test.sh
│   ├── exit_test.sh
│   ├── file_operations.sh
│   ├── for_loop_files.sh
│   ├── for_loop_range.sh
│   ├── for_loop.sh
│   ├── here_document.sh
│   ├── if_test.sh
│   ├── positional_params.sh
│   ├── Quiz.md
│   ├── read_input.sh
│   ├── select_menu.sh
│   ├── signal_trap.sh
│   ├── string_operations.sh
│   ├── until_loop.sh
│   ├── while_loop_menu.sh
│   └── while_loop.sh
├── W14_Boot-and-Shutdown
│   ├── Concepts.md
│   └── Quiz.md
├── W15_Linux-Utilities
│   ├── Concepts.md
│   ├── cut_example.sh
│   ├── dd_example.sh
│   ├── passwd
│   ├── paste_example.sh
│   ├── Quiz.md
│   ├── s.dat
│   ├── sort_example.sh
│   ├── split_example.sh
│   ├── u.dat
│   ├── uniq_example.sh
│   └── wc_example.sh
├── LICENSE
├── README.ko.md
└── README.md

17개의 디렉토리, 62개의 파일
```

<br><a name="license"></a>
## 🤝 라이선스

이 레포지토리는 [Apache License 2.0](LICENSE) 하에 배포됩니다.

---

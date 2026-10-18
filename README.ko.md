# [2025학년도 봄학기] Linux 실습

![Last Commit](https://img.shields.io/github/last-commit/Choroning/25Spring_Linux-Practice)
![Languages](https://img.shields.io/github/languages/top/Choroning/25Spring_Linux-Practice)

이 레포지토리는 Linux 실습 과목의 이중 언어 강의 노트와 수업 결과물을 정리한 아카이브입니다.

*작성자: 박철원 (고려대학교(세종), 컴퓨터소프트웨어학과) - 2025년 기준 2학년*
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

이 레포지토리에는 대학 수준의 Linux 실습 과목을 위해 작성한 강의 노트, 연습 문제, Linux 명령어와 셸 스크립트가 담겨 있습니다.

- `Lecture-Notes/`에는 주차마다 Linux 관리와 셸 활용을 종합적으로 정리한 강의 노트(`Concepts_Lecture`)가 있고, 1주차를 뺀 주차에는 복습 문제를 모은 연습 문제(`Exercises`)와 그 풀이(`Solutions`)가 함께 있습니다. 수업 주차를 따라 단원을 `Week01`\~`Week15`로 나눴으며, 중간고사를 치른 8주차에는 단원이 없습니다.
- 모든 강의 노트, 연습 문제, 풀이는 영어 파일(`.md`)과 한국어 파일(`.ko.md`)이 같은 구성으로 짝을 이룹니다.
- `Coursework/`에는 강의 시연 코드(13주차와 15주차의 예제 스크립트)를 정리한 Bash 실습 스크립트(`Lab13`, `Lab15`)와 2개의 텀 프로젝트가 있습니다. 실습 숙제의 제출물은 올리지 않았습니다.
- 개선된 셸 스크립트에는 목적, 사용법, 구조를 문서화한 **Doxygen 스타일 헤더**가 있습니다.
- 2개의 **텀 프로젝트**(System Monitoring Dashboard, Custom Shell)는 해외 CS 명문 대학의 커리큘럼을 참고하여 설계했습니다. 기능, 사용법, 설계는 각 프로젝트 폴더의 `README.md`에 정리되어 있습니다.
- 모든 셸 스크립트는 Bash로 문법을 검사했고, 실습 스크립트는 예제 입력으로 실행하여 확인했습니다.

> **🤖 AI 에이전트 활용**
> 강의 노트의 정리와 번역, 레포지토리 구조 정리에 [Claude Code](https://claude.ai/download)를 활용했습니다.

<br><a name="course-information"></a>
## 📚 강의 정보

- **학기:** 2025학년도 봄학기 (3월 - 6월)
- **소속:** 고려대학교(세종)

|학수번호      |강의명    |이수구분|교수자|개설학과|
|:----------:|:-------|:----:|:------:|:----------------|
|`DCCS209-00`|Linux 실습|전공선택|김명섭 교수|컴퓨터소프트웨어학과|

### 과목 개요

현재 ICT 시스템에서 널리 쓰이는 Linux 시스템의 기본 사용법과 다양한 사용자 명령어, 응용 프로그램을 이론과 실습으로 배우는 전공선택 과목으로, 온라인 사전학습과 강의실 본수업을 묶은 SEMO class 형태로 진행된다. 교수자의 강의 PPT를 따라 Linux 설치, 파일 및 디렉터리 관리, Vi/Vim 편집, 셸 명령어, 파일 권한, 프로세스 관리, 디스크 및 파일 시스템, 사용자 관리, Bash 셸 프로그래밍을 다루며, 부팅과 종료, Linux 유틸리티도 함께 다룬다. 교수자와 조교, 수업 일정과 형식, 평가, 수업 운영 규정, 주차별 계획 및 진도, 참고 자료는 [강의 정보 문서](Course-Information.ko.md)에 정리했다.

<br><a name="prerequisites"></a>
## ✅ 사전 요구사항

- C/C++ 프로그래밍 능력이 있어야 합니다.
- Linux 사전 지식은 필요하지 않습니다. 실습에는 가상 머신 소프트웨어에 설치한 Ubuntu Linux를 사용합니다.
- 이 레포지토리의 스크립트를 실행하려면 Bash가 필요합니다. Custom Shell 텀 프로젝트는 연관 배열을 사용하므로 Bash 4.0 이상이 필요합니다.

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
├── Lecture-Notes               주차별 강의 노트, 연습 문제, 풀이
├── Coursework                  Bash 실습 스크립트와 텀 프로젝트
├── Course-Information.ko.md    수업 운영 정보
├── Course-Information.md
├── LICENSE                     문서 라이선스 (CC BY-NC-SA 4.0)
├── LICENSE-CODE                코드 라이선스 (PolyForm Noncommercial 1.0.0)
├── README.ko.md
└── README.md
```

단원 목록은 [`Lecture-Notes` 색인](Lecture-Notes/README.ko.md)에, 실습 스크립트와 텀 프로젝트는 [`Coursework` 색인](Coursework/README.ko.md)에 있습니다.

<br><a name="license"></a>
## 🤝 라이선스

이 레포지토리의 문서(강의 노트, 해설, 요약지)는 [CC BY-NC-SA 4.0](LICENSE), 코드는 [PolyForm Noncommercial 1.0.0](LICENSE-CODE)에 따라 배포됩니다. 강의자료와 교재에서 가져온 그림과 예제 코드, 강의가 배포한 과제 원본과 템플릿 코드는 원저작자에게 권리가 있으며 이 라이선스의 대상이 아닙니다.

---

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

- `Lecture-Notes/`에는 주차별 강의 노트(`Week01`\~`Week15`)가 있고, 대부분의 주차에 복습 문제를 모은 연습 문제와 풀이가 함께 있습니다.
- `Coursework/`에는 13주차와 15주차의 Bash 실습 스크립트(`Lab13`, `Lab15`)와 텀 프로젝트 2개가 있습니다.
- 모든 문서는 영어(`.md`)와 한국어(`.ko.md`) 파일이 짝을 이룹니다.
- 모든 셸 스크립트는 Bash로 문법을 검사했습니다.

> **🤖 AI 에이전트 활용**
> [Claude Code](https://claude.ai/download)를 노트 정리와 번역, 레포지토리 정리에 활용했습니다.

<br><a name="course-information"></a>
## 📚 강의 정보

- **학기:** 2025학년도 봄학기 (3월 - 6월)
- **소속:** 고려대학교(세종)

|학수번호      |강의명    |이수구분|교수자|개설학과|
|:----------:|:-------|:----:|:------:|:----------------|
|`DCCS209-00`|Linux 실습|전공선택|김명섭 교수|컴퓨터소프트웨어학과|

### 과목 개요

Linux 시스템의 기본 사용법과 명령어, 셸 프로그래밍을 이론과 실습으로 배우는 전공선택 과목이다. 교수자와 조교, 수업 일정, 평가, 수업 운영 규정, 진도는 [강의 정보 문서](Course-Information.ko.md)에 정리했다.

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

# [Spring 2025] Linux Practice

![Last Commit](https://img.shields.io/github/last-commit/Choroning/25Spring_Linux-Practice)
![Languages](https://img.shields.io/github/languages/top/Choroning/25Spring_Linux-Practice)

This repository archives bilingual lecture notes and coursework for the Linux Practice course.

*Author: Cheolwon Park (Korea University Sejong, CSE) - Year 2 (Sophomore) as of 2025*
<br><br>

## 📑 Table of Contents

- [About This Repository](#about-this-repository)
- [Course Information](#course-information)
- [Prerequisites](#prerequisites)
- [Repository Structure](#repository-structure)
- [License](#license)

---


<br><a name="about-this-repository"></a>
## 📝 About This Repository

This repository contains the lecture notes, exercises, Linux commands, and shell scripts written for a university-level Linux Practice course.

- `Lecture-Notes/` holds, for each week, lecture notes with comprehensive explanations of Linux administration and shell usage (`Concepts_Lecture`), and every week except week 1 also has exercises with review questions (`Exercises`) and their solutions (`Solutions`). The units follow the class weeks and are numbered `Week01`-`Week15`, and week 8, the midterm week, has no unit.
- Every lecture note, exercise set, and solution set comes as an English file (`.md`) and a Korean file (`.ko.md`) with the same structure.
- `Coursework/` holds Bash lab scripts (`Lab13`, `Lab15`) that organize the lecture demonstration code (the example scripts of weeks 13 and 15), and two term projects. Submissions for the lab homework are not included.
- The improved shell scripts carry **Doxygen-style headers** that document their purpose, usage, and structure.
- The two **term projects** (System Monitoring Dashboard and Custom Shell) were designed with reference to the curricula of leading overseas CS universities. Their features, usage, and design are described in the `README.md` of each project folder.
- All shell scripts were syntax-checked with Bash, and the lab scripts were run with sample input.

> **🤖 AI Agent Usage**
> [Claude Code](https://claude.ai/download) was used to organize and translate the lecture notes and to restructure the repository.

<br><a name="course-information"></a>
## 📚 Course Information

- **Semester:** Spring 2025 (March - June)
- **Affiliation:** Korea University Sejong

| Course&nbsp;Code| Course            | Type          | Instructor      | Department                              |
|:----------:|:------------------|:-------------:|:---------------:|:----------------------------------------|
|`DCCS209-00`|LINUX PRACTICE|Major Elective|Prof. Myung-Sup&nbsp;Kim|Department of Computer Science and Software Engineering|

### Course Overview

A major elective course on the basic usage of Linux systems, which are widely used in current ICT systems, and their various user commands and applications, learned through theory and practice, run as a SEMO class that combines online pre-study with in-class main sessions. Following the instructor's lecture PPT, it covers Linux installation, file and directory management, Vi/Vim editing, shell commands, file permissions, process management, disks and file systems, user administration, and Bash shell programming, along with booting and shutdown and Linux utilities. The instructor and teaching assistants, schedule and class format, assessment, course policies, weekly plan and progress, and references are in the [course information document](Course-Information.md).

<br><a name="prerequisites"></a>
## ✅ Prerequisites

- C/C++ programming skills are required.
- No prior knowledge of Linux is required. The labs use Ubuntu Linux installed in virtual machine software.
- Running the scripts in this repository requires Bash. The Custom Shell term project uses associative arrays and therefore requires Bash 4.0 or later.

- **💻 Development Environment**

| Tool | Company |  OS  | Notes |
|:-----|:-------:|:----:|:------|
|Terminal|Apple Inc.|macOS|    |
|Vi/Vim|Open Source|Linux|    |
|UTM|Open Source|macOS|Linux VM|
|VMware Fusion|Broadcom|macOS|Linux VM|

<br><a name="repository-structure"></a>
## 🗂 Repository Structure

```plaintext
25Spring_Linux-Practice
├── Lecture-Notes               Lecture notes, exercises, and solutions by week
├── Coursework                  Bash lab scripts and term projects
├── Course-Information.ko.md    Course operations
├── Course-Information.md
├── LICENSE                     Documentation license (CC BY-NC-SA 4.0)
├── LICENSE-CODE                Code license (PolyForm Noncommercial 1.0.0)
├── README.ko.md
└── README.md
```

The units are listed in the [`Lecture-Notes` index](Lecture-Notes/README.md), and the lab scripts and term projects in the [`Coursework` index](Coursework/README.md).

<br><a name="license"></a>
## 🤝 License

The documents in this repository (lecture notes, explanations, and summary sheets) are licensed under [CC BY-NC-SA 4.0](LICENSE), and the code under [PolyForm Noncommercial 1.0.0](LICENSE-CODE). Figures and example code taken from lecture slides and textbooks, as well as assignment handouts and template code distributed by the course, belong to their original authors and are not covered by these licenses.

---

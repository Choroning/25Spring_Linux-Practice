# Course Information

[Repository Guide](README.md) | [English](Course-Information.md) | [한국어](Course-Information.ko.md)

> **Last Updated:** 2026-10-19

## Table of Contents

- [1. Instructor, Teaching Assistants, and Research Lab](#1-instructor-teaching-assistants-and-research-lab)
- [2. Schedule and Class Format](#2-schedule-and-class-format)
- [3. Assessment](#3-assessment)
- [4. Course Policies](#4-course-policies)
- [5. Weekly Plan and Progress](#5-weekly-plan-and-progress)
- [6. References](#6-references)

---

<br>

## 1. Instructor, Teaching Assistants, and Research Lab

- **Instructor:** Prof. Myung-Sup Kim, Department of Computer Science and Software Engineering. He joined Korea University as a professor in September 2006.
- **Research Lab:** Network Management Lab (NMLab), <http://nmlab.korea.ac.kr>
- **Office:** Room 7-305
- **Office Hours:** The syllabus gives Tuesday afternoon and Thursday afternoon, and the orientation slides give Monday periods 5-6 (13:00 ~ 15:00).
- **Education:** B.S. (February 1998), M.S. (February 2000), and Ph.D. (August 2004) in Computer Science and Engineering from Pohang University of Science and Technology (POSTECH).
  - Master's research topic: Adaptive Application-Level QoS Management Technique for Multimedia Traffic
  - Doctoral research topic: Internet Application Traffic Monitoring and Analysis
- **Career:** From October 2004 to August 2006, he was a postdoctoral researcher in the Department of Electrical and Computer Engineering (ECE) at the University of Toronto, Canada, working on Virtual Network based Autonomic Network Resource Control and Management.
- **Research Interests:**
  - Internet Traffic Monitoring and Analysis: high-speed network traffic monitoring, application-level traffic analysis, abnormal traffic detection and analysis, and analysis and characterization of P2P, streaming media, and game traffic
  - Network and System Management: service and device management, SNMP-based management, XML and Web Services-based management
  - Autonomic Network Resource Management: MPLS/DiffServ traffic engineering, virtual network based core network resource management, MPLS QoS routing
  - Application-level Networking: P2P networking, application-level multicasting
- **Teaching Assistants:** Jaewon Park (박재원) and Seungwoo Nam (남승우). Both were in the third semester of the master's program at NMLab, and their office is Room 306 on the third floor of Science and Technology Building 2.

---

<br>

## 2. Schedule and Class Format

- **Course:** DCCS209 Linux Practice (리눅스 실습), section 00. The orientation slides give the course name as CSIE209 Linux Practice (Linux 실습).
- **Credits (Hours):** 3 (4)
- **Intended For:** Second- and third-year students
- **Class Times:** Tuesday periods 8-9 (16:00 ~ 17:50), Thursday periods 8-9 (16:00 ~ 17:50)
- **Classroom:** Room 315, Science and Technology Building 2 (7-315, Tue). The Thursday class is held online.
- **Class Format:** The course runs as a SEMO (Student Engaged MOdular) Class Type 1 (Module 2), which combines online pre-study with an in-class main session and is learner-centered. The activity types in the syllabus are lectures, presentations, and practice.
  - Pre-study: a 100-minute online class that includes lecture videos (50 minutes or more). The lecture materials are uploaded to Blackboard one week in advance.
  - Main session: a 100-minute class in the classroom that summarizes, discusses, and practices the online content through Q&A, discussion, and practice.
  - Lectures and discussion: the lectures center on the designated textbook or handouts distributed in advance, and instead of one-way knowledge transfer led by the professor, they proceed interactively through discussion of issues raised during the lecture and questions from students. Students must study the weekly lecture topics and references before class and participate actively.
  - Practice: following the planned lab materials, students learn the skills needed to install and operate a Linux system (using applications, system configuration, shell programming, C/C++ programming) and build the basic knowledge to use Linux systems in various fields.
- **Attendance:** Attendance is checked (the course is not exempt from attendance checks).
- **Exam Supervision:** Exams are not held unsupervised.
- **Class Description:** Students learn the basic usage of Linux systems, which are widely used in current ICT systems, their various user commands, and the applications used on Linux through theory and practice, and acquire the basic concepts.
- **Study Objectives:**
  1. Acquire basic knowledge of the LINUX operating system.
  2. Practice LINUX user commands and utilities.
  3. Learn how to use the VI editor.
  4. Acquire shell, C/C++, and Python programming techniques.

  The orientation slides list as course goals acquiring basic knowledge of the Linux operating system, practicing Linux user commands and utilities, and acquiring shell programming techniques.
- **Course and Departmental Objectives:** The course is a major elective for second- and third-year students, designed so that students learn how to use Linux systems, which are widely used in current ICT systems, and develop creative and convergent problem-solving skills with Linux systems.
- **Core Competencies:** The syllabus marks Pragmatic Practice and Creative Convergence as highly correlated.
- **Major Competencies:** Of the department's major competencies (Ethics & Leadership, Think & Technology, Network & Application), the course corresponds to Think & Technology.
- **Prerequisites:** C/C++ programming is recommended.
- **Lab Environment:** Ubuntu Linux installed on VMware Workstation (Player or Pro). A virtual machine (VM) creates a virtual system on the host operating system so that a guest operating system can be installed and run, and the operating systems supported by the main VM software are as follows.

| VM Software | Host OS | Guest OS |
|:-----|:-----|:-----|
| VMware | Windows, Linux, macOS | Windows, Linux, Solaris, macOS |
| VirtualBox | Windows, Linux, macOS, Solaris | Windows, Linux, Solaris, macOS, OpenBSD |
| Hyper-V | Windows | Windows, some Linux, Solaris |

- VMware has the following features that are useful in the labs.
  - **Clone:** Duplicates an entire VM for testing.
  - **Suspend:** Saves and restores the VM state.
  - **Snapshot:** Saves a checkpoint to revert to later.

---

<br>

## 3. Assessment

| Item | Weight |
|:-----|-----:|
| Attendance | 10% |
| Lab Homework (about 10) | 30% |
| Midterm Exam | 30% |
| Final Exam | 30% |

- The weights above follow the orientation slides, and the weights may change depending on how the course proceeds.
- Attendance loses 2% for each absence and 0.5% for each late arrival.
- The orientation slides give a bonus of 3% for the first-stage exam of the nationally certified Linux Master Level 2 test administered by the Korea Association for ICT Promotion (KAIT, <http://www.ihd.or.kr/>).
- The weights in the syllabus are quizzes 30%, midterm exam 25%, final exam 35%, and participation 10%, and its detailed assessment plan gives homework 30%, midterm exam 30%, final exam 30%, and participation 10%. Evaluation scores are not disclosed.
- The detailed assessment plan in the syllabus is as follows.
  - **Homework:** Programming for system programming with C/C++ on Linux and for implementing various operating system functions is given as weekly lab homework, and each assignment is graded on the completeness of the source code (Correctness 70%, Programming Style 30%). Late submission and cheating are not allowed, and each carries a penalty of -100%.
  - **Types of Homework:** C/C++ programming, shell programming, Python programming, and application practice on a Linux system
  - **Midterm and Final Exams:** Each has 5-10 system programming problems.
  - **Participation:** 2 points are deducted for each absence and 0.5 points for each late arrival, and an absence of more than 11 days (1/3) results in an F.
- Fifteen lab homework assignments were given, from Homework 1 to Homework 15, and the weeks in which they were given are listed in [5. Weekly Plan and Progress](#5-weekly-plan-and-progress).
- **Homework 14 (bash shell programming):** Write a bash shell script `user.sh` that is run from a root shell as `./user.sh user.txt`.
  - Create accounts with the user names listed in `user.txt` (for example, `user01`, `user02`, `tmskim`, `u01`, `u02`).
  - In each user's home directory, create the folder `username.d1` with the empty files `1`, `2`, `3`, `4`, `5` and the folder `username.d2` with the empty files `a`, `b`, `c`, `d`, `e` (for example, `user01.d1` and `user01.d2`).
  - Submit the source code and the execution results as a ppt.

---

<br>

## 4. Course Policies

- Course announcements, lecture materials, lab homework, exam results, and other information are provided through the LMS (<http://lms.korea.ac.kr>, Blackboard), and lab homework is also submitted through the LMS.
- Lecture materials (PDF) are uploaded to Blackboard at least one week in advance, and video lecture materials are shared through YouTube.
- Urgent announcements and Q&A about the course take place in a KakaoTalk open chat room.
- Missing one third or more of all class days results in an F.
- Unexcused absences are not accepted even if a certificate is submitted, so students must notify the instructor in advance, for example by email, before an absence.
- Missing either the midterm or the final exam results in an F.
- Arriving up to 10 minutes late for the midterm and final exams is accepted, and later arrival counts as absence.
- **Support for Students with Disabilities:** As long as it does not interfere with taking the course, students with disabilities are treated the same as other students, and any inconvenience during lab sessions is identified and resolved.
- **Learning Ethics:** Students have the following general obligations in all processes of completing the curriculum, including attending lectures, preparing and submitting assignments, and taking exams.
  1. Participate actively in all learning with a sincere and honest mind and a passionate attitude based on the purpose and educational philosophy of the university.
  2. Be aware of their position as educated people receiving higher education and devote themselves to creative academic inquiry based on moral sensitivity.
  3. Faithfully carry out what they have promised faculty members or fellow students in connection with educational activities.
  4. Respect the character of faculty members and fellow students and observe basic manners.
- Credits found to have been obtained through dishonest behavior such as plagiarism of assignments, duplicate use of assignments from other classes, or exam misconduct, or through any other unfair method, are canceled even after they have been granted, and disciplinary action such as reprimand, suspension, expulsion, or permanent expulsion may follow, taking the circumstances of the act into account.
- The university operates a plagiarism detection system (SafeAssign in Blackboard) to raise awareness of learning ethics and encourage creativity, and students must check in advance whether their work counts as plagiarism when submitting assignments.

---

<br>

## 5. Weekly Plan and Progress

| Week | Class Dates (Tue, Thu) | Planned Topic | Lecture Decks Covered |
|:-----|:-----|:-----|:-----|
| 1 | 3/4, 3/6 | Overview and basic usage of Unix/Linux | 00.강의소개 (Course Introduction) |
| 2 | 3/11, 3/13 | Working with directories | ch01 리눅스 설치와 기본 사용법 (Linux Installation and Basic Usage)<br>ch02 디렉터리와 파일 사용법 (1) (Using Directories and Files 1)<br>Homework 1. Linux Installation<br>Homework 2. Using Directories and Files 1 |
| 3 | 3/18, 3/20 | Working with files | ch02 디렉터리와 파일 사용법 (2) (Using Directories and Files 2)<br>(팁) 우분투 원격접속 (Tip: Remote Access to Ubuntu)<br>Homework 3. Using Directories and Files 2 |
| 4 | 3/25, 3/27 | Learning to use vi | Homework 4. Document Editing |
| 5 | 4/1, 4/3 | Using the Bash shell | ch03 문서 편집 (Document Editing)<br>ch03 실습vi (vi Lab)<br>Homework 5. vi Lab<br>Homework 6. Shell Usage |
| 6 | 4/8, 4/10 | Managing file access permissions | ch04 셸 사용법 (Shell Usage)<br>Homework 7. File Access Permission Management |
| 7 | 4/15, 4/17 | Searching for files and directories | ch05 파일 접근 권한 관리 (File Access Permission Management) |
| 8 | 4/22, 4/24 | Midterm exam | Midterm exam |
| 9 | 4/29, 5/1 | Learning process and user commands | ch06 프로세스 관리 (Process Management)<br>Homework 8. Process Management<br>Homework 9. Lab: at and crontab |
| 10 | 5/6, 5/8 | Learning file archive and compression commands | ch07 파일 시스템과 디스크 관리 (File Systems and Disk Management)<br>Homework 10. File Systems and Disk Management<br>Homework 11. Mounting HDD/USB File Systems |
| 11 | 5/13, 5/15 | Learning Internet and communication commands | ch07 디스크 관리 RAID (Disk Management: RAID)<br>Homework 12. Creating LVM and RAID 5 |
| 12 | 5/20, 5/22 | Using Unix/Linux utilities | ch10 사용자 관리 (User Management)<br>Homework 13. Lab: Setting Group Quotas |
| 13 | 5/27, 5/29 | Understanding the Unix/Linux shell | ch11 배시쉘 프로그래밍 (Bash Shell Programming)<br>실습숙제.배시쉘 프로그래밍 (Lab Homework: Bash Shell Programming)<br>Homework 14. bash shell programming |
| 14 | 6/3, 6/5 | Bash shell programming | ch08 리눅스의 부팅과 종료 (Linux Booting and Shutdown)<br>Homework 15. root Password Recovery |
| 15 | 6/10, 6/12 | Basics of system administration | ch11 리눅스 유틸리티 이용하기 (Using Linux Utilities) |
| 16 | 6/17, 6/19 | Final exam | Final exam<br>End of term |

- The planned topics follow the weekly schedule of the syllabus, which planned week 1 as orientation and every other week except the exam weeks as lectures, practice, and discussion.
- The schedule in the orientation slides followed the chapter order of the textbook: week 1 Linux installation and basic usage (Chapter 1), week 2 using directories and files (Chapter 2), week 3 document editing (Chapter 3), week 4 shell usage (Chapter 4), week 5 file access permission management (Chapter 5), week 6 process management (Chapter 6), week 7 file systems and disk management (Chapter 7), week 8 midterm exam, week 9 Linux booting and shutdown (Chapter 8), week 10 software management (Chapter 9), week 11 user management (Chapter 10), week 12 network configuration (Chapter 11), week 13 remote access and FTP (Chapter 12), week 14 DB server and web server (Chapter 13), week 15 NFS and Samba (Chapter 14), and week 16 final exam, and the slides noted that it could change as the course proceeded.
- In practice, the course covered ch01 through ch07 in chapter order and then ch10 User Management, ch11 Bash Shell Programming, ch08 Linux Booting and Shutdown, and ch11 Using Linux Utilities, in that order. No lecture deck covers software management (Chapter 9), network configuration (Chapter 11), remote access and FTP (Chapter 12), DB server and web server (Chapter 13), or NFS and Samba (Chapter 14), which were planned in the orientation slides.
- ch02 Using Directories and Files 2 was covered over weeks 3 and 4, and ch07 is split into two decks, File Systems and Disk Management (week 10) and Disk Management: RAID (week 11).
- The midterm exam was held in week 8, and the final exam was held in week 16, which ended the term.
- The lecture decks correspond to the units as follows. The units are listed in the [`Lecture-Notes` index](Lecture-Notes/README.md).
  - `00.강의소개` (Course Introduction): [`Week01`](Lecture-Notes/Week01_Course-Introduction/)
  - `ch01 리눅스 설치와 기본 사용법` (Linux Installation and Basic Usage): [`Week02`](Lecture-Notes/Week02_Linux-Installation/)
  - `ch02 디렉터리와 파일 사용법 (1)`, `(2)` (Using Directories and Files 1 and 2): [`Week03`](Lecture-Notes/Week03_Directory-and-File-Management-I/), [`Week04`](Lecture-Notes/Week04_Directory-and-File-Management-II/)
  - `ch03 문서 편집` (Document Editing), `ch03 실습vi` (vi Lab): [`Week05`](Lecture-Notes/Week05_Vi-Editor/)
  - `ch04 셸 사용법` (Shell Usage): [`Week06`](Lecture-Notes/Week06_Shell-Usage/)
  - `ch05 파일 접근 권한 관리` (File Access Permission Management): [`Week07`](Lecture-Notes/Week07_File-Access-Permissions/)
  - `ch06 프로세스 관리` (Process Management): [`Week09`](Lecture-Notes/Week09_Process-Management/)
  - `ch07 파일 시스템과 디스크 관리` (File Systems and Disk Management): [`Week10`](Lecture-Notes/Week10_File-Systems/)
  - `ch07 디스크 관리 RAID` (Disk Management: RAID): [`Week11`](Lecture-Notes/Week11_Disk-Management-and-RAID/)
  - `ch10 사용자 관리` (User Management): [`Week12`](Lecture-Notes/Week12_User-Management/)
  - `ch11 배시쉘 프로그래밍` (Bash Shell Programming): [`Week13`](Lecture-Notes/Week13_Bash-Shell-Programming/)
  - `ch08 리눅스의 부팅과 종료` (Linux Booting and Shutdown): [`Week14`](Lecture-Notes/Week14_Boot-and-Shutdown/)
  - `ch11 리눅스 유틸리티 이용하기` (Using Linux Utilities): [`Week15`](Lecture-Notes/Week15_Linux-Utilities/)
- `(팁) 우분투 원격접속` (Tip: Remote Access to Ubuntu) describes how to find the IP address on Ubuntu with `ifconfig` or `ip addr` and connect from the macOS terminal with `ssh username@IP`, and its content is covered in the remote access setup section of the [Week 2 lecture notes](Lecture-Notes/Week02_Linux-Installation/Concepts_Lecture.md).
- `실습숙제.배시쉘 프로그래밍` is the brief for Homework 14. The lab scripts based on the example script bundle of week 13 (`ex.sh`) and the lab file bundle of week 15 (`lab.util`) are in `Lab13` and `Lab15` of the [`Coursework` index](Coursework/README.md).

---

<br>

## 6. References

| Type | Contents |
|:-----|:-----|
| Textbook | J. Lee, *IT CookBook, 우분투 리눅스* (Ubuntu Linux), 3rd ed. Seoul, South Korea: Hanbit Academy, 2022. |
| Reference | J. Woo, *IT CookBook, 리눅스 실습 for Beginner* (Linux Practice for Beginner). Seoul, South Korea: Hanbit Academy, 2022. |
| Lecture Slides | Lecture PPT slides provided by the instructor (00.강의소개, ch01-ch08, ch10, ch11) and lab materials (ch03 실습vi, the week 13 lab homework, the week 13 example scripts `ex.sh`, the week 15 lab files `lab.util`) |
| Lecture Videos | Online lecture videos provided by the instructor. There is one video for each deck except ch07 Disk Management: RAID, 12 in total, and week 2 also has two lab videos (Linux installation and basic usage). |
| Reference Site | The official Ubuntu site (<https://ubuntu.com/>) |

- The syllabus designates Lecture PPT as the main material, and the orientation slides introduce the textbook and reference above. The ISBN of the textbook is 9791156646075, and that of the reference is 9791156644705.
- The numbers and titles of decks ch01-ch08 and ch10 match the textbook chapters listed in the schedule of the orientation slides, while the two ch11 decks (Bash Shell Programming and Using Linux Utilities) cover content different from Chapter 11 of the textbook (network configuration).

# 12주차 — 사용자 관리

> **최종 수정일:** 2026-04-01

> **선수 지식**: 파일 권한과 시스템 기초 (7-11주차).
>
> **학습 목표**:
> 1. 사용자 계정과 그룹을 생성하고 관리할 수 있다
> 2. 비밀번호 정책과 계정 만료를 설정할 수 있다
> 3. sudo와 권한 상승을 안전하게 적용할 수 있다

---

## 목차

1. [사용자와 그룹 개념](#1-사용자와-그룹-개념)
2. [사용자 계정 파일](#2-사용자-계정-파일)
3. [사용자 관리](#3-사용자-관리)
4. [그룹 관리](#4-그룹-관리)
5. [비밀번호 관리](#5-비밀번호-관리)
6. [sudo 설정](#6-sudo-설정)
7. [모범 사례](#7-모범-사례)
8. [요약](#요약)

---

<br>

## 1. 사용자와 그룹 개념

### 1.1 사용자 유형

| 유형 | UID 범위 | 설명 |
|------|----------|------|
| **Root** | 0 | 시스템 전체 접근 권한을 가진 슈퍼유저 |
| **시스템 사용자** | 1-999 | 서비스 계정 (daemon, www-data) |
| **일반 사용자** | 1000+ | 일반 사용자 |

### 1.2 그룹

- 모든 사용자는 최소 하나의 **주 그룹(primary group)** 에 소속
- 사용자는 **보조 그룹(supplementary group)** 에도 소속 가능
- 그룹은 공유 파일 접근을 제어

---

<br>

## 2. 사용자 계정 파일

### 2.1 /etc/passwd

```
username:x:UID:GID:comment:home_directory:login_shell
```

```bash
root:x:0:0:root:/root:/bin/bash
user1:x:1001:1001::/home/user1:/bin/bash
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
```

### 2.2 /etc/shadow

```
username:encrypted_password:lastchange:min:max:warn:inactive:expire:reserved
```

- 암호화된 비밀번호 저장 (root만 접근 가능)
- 비밀번호 만료 정보 포함

### 2.3 /etc/group

```
groupname:x:GID:member_list
```

```bash
sudo:x:27:user1
developers:x:1002:user1,user2,user3
```

---

<br>

## 3. 사용자 관리

### 3.1 useradd - 사용자 생성

```bash
sudo useradd username                        # 사용자 생성 (최소 설정)
sudo useradd -m username                     # 홈 디렉터리와 함께 생성
sudo useradd -m -s /bin/bash username        # 셸 지정
sudo useradd -m -G sudo,developers username  # 그룹에 추가
sudo useradd -m -c "John Doe" -s /bin/bash -G sudo john
```

### 3.2 adduser - 대화형 사용자 생성 (Debian/Ubuntu)

```bash
sudo adduser username    # 대화형: 비밀번호, 이름 등을 입력 요청
```

### 3.3 usermod - 사용자 수정

```bash
sudo usermod -aG sudo username            # 보조 그룹에 추가
sudo usermod -s /bin/zsh username          # 셸 변경
sudo usermod -d /new/home username         # 홈 디렉터리 변경
sudo usermod -l newname oldname            # 사용자 이름 변경
sudo usermod -L username                   # 계정 잠금
sudo usermod -U username                   # 계정 잠금 해제
sudo usermod -e 2025-12-31 username        # 만료일 설정
```

### 3.4 userdel - 사용자 삭제

```bash
sudo userdel username                      # 사용자 삭제 (홈 디렉터리 유지)
sudo userdel -r username                   # 사용자와 홈 디렉터리 삭제
```

---

<br>

## 4. 그룹 관리

```bash
# 그룹 생성
sudo groupadd developers

# 그룹 삭제
sudo groupdel developers

# 그룹 수정
sudo groupmod -n newname oldname           # 그룹 이름 변경

# 사용자를 그룹에 추가
sudo usermod -aG groupname username        # -a = 추가 (중요!)
sudo gpasswd -a username groupname         # 대안

# 그룹에서 사용자 제거
sudo gpasswd -d username groupname

# 그룹 멤버십 확인
groups username
id username
getent group groupname
```

> **핵심 사항:** `usermod`에서 항상 `-aG`(추가 + 그룹)를 사용할 것. `-a` 없이 사용하면 사용자의 보조 그룹이 교체된다!

---

<br>

## 5. 비밀번호 관리

### 5.1 비밀번호 설정

```bash
sudo passwd username               # 사용자 비밀번호 설정
passwd                             # 자신의 비밀번호 변경
sudo passwd -l username            # 계정 잠금
sudo passwd -u username            # 계정 잠금 해제
sudo passwd -d username            # 비밀번호 삭제 (비밀번호 없이 로그인)
sudo passwd -e username            # 다음 로그인 시 비밀번호 변경 강제
```

### 5.2 비밀번호 만료 관리

```bash
sudo chage -l username             # 비밀번호 만료 정보 확인
sudo chage -M 90 username          # 비밀번호 변경 간 최대 일수
sudo chage -m 7 username           # 비밀번호 변경 간 최소 일수
sudo chage -W 14 username          # 만료 전 경고 일수
sudo chage -E 2025-12-31 username  # 계정 만료일
```

---

<br>

## 6. sudo 설정

### 6.1 /etc/sudoers

```bash
# sudoers 파일을 안전하게 편집
sudo visudo

# 사용자에게 전체 sudo 접근 허용
username ALL=(ALL:ALL) ALL

# 그룹에 sudo 접근 허용
%developers ALL=(ALL:ALL) ALL

# 특정 명령어에 대해 비밀번호 없이 허용
username ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/systemctl
```

---

<br>

## 7. 모범 사례

- 최소 권한 원칙 준수
- 개별 권한보다 그룹을 통한 접근 관리
- 비밀번호 만료 정책 설정
- 사용하지 않는 계정 비활성화 (`usermod -L`)
- 사용자 계정 정기 감사
- 서비스 계정에 `nologin` 셸 사용

---

<br>

## 요약

| 개념 | 핵심 사항 |
|------|----------|
| `/etc/passwd` | 사용자 계정 정보 (username:UID:GID:home:shell) |
| `/etc/shadow` | 암호화된 비밀번호 및 만료 정보 |
| `/etc/group` | 그룹 정의 및 멤버십 |
| `useradd`/`adduser` | 새 사용자 계정 생성 |
| `usermod` | 사용자 속성 수정 (그룹, 셸, 홈) |
| `userdel` | 사용자 계정 삭제 |
| `groupadd`/`groupdel` | 그룹 생성/삭제 |
| `passwd` | 비밀번호 설정 및 관리 |
| `chage` | 비밀번호 만료 정책 설정 |
| `sudo`/`visudo` | 권한 상승 설정 |

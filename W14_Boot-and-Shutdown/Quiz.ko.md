# 14주차 - 퀴즈

> **최종 수정일:** 2026-03-21

---

## Q1. init의 대체 서비스

**문제:** 전통적인 PID 1 프로세스 `init`을 대체한 서비스의 이름은?

| 선택지 | 답변 |
|--------|------|
| A | system |
| B | systemd |
| C | systemctl |
| D | sysinit |

**정답:** B. systemd

**해설:** `systemd`는 대부분의 주요 Linux 배포판에서 전통적인 SysVinit(`init`)을 대체한 현대적인 init 시스템이다. PID 1로 실행되며 시스템 서비스, 마운트 포인트, 타이머 등을 관리한다. `systemctl`은 `systemd`와 상호작용하기 위한 명령줄 도구이지, 서비스 자체가 아니다.

---

## Q2. 현재 타겟 확인

**문제:** 현재(기본) 타겟을 확인하는 명령어는?

| 선택지 | 명령어 |
|--------|--------|
| A | `systemctl set-default` |
| B | `systemctl status` |
| C | `systemctl start` |
| D | `systemctl get-default` |

**정답:** D. `systemctl get-default`

**해설:** `systemctl get-default`는 시스템이 부팅되는 기본 타겟 유닛을 표시한다(예: `multi-user.target` 또는 `graphical.target`). `set-default`는 기본 타겟을 변경하고, `status`는 특정 유닛의 상태를 보여주며, `start`는 유닛을 시작한다. systemd의 타겟은 SysVinit의 런레벨 개념을 대체한다.

---

## Q3. 시스템 종료 명령어

**문제:** 다음 중 시스템을 종료하는 명령어가 **아닌** 것은?

| 선택지 | 명령어 |
|--------|--------|
| A | `reboot` |
| B | `halt` |
| C | `kill` |
| D | `poweroff` |

**정답:** C. `kill`

**해설:** `kill`은 개별 프로세스에 시그널을 보내지만 시스템을 종료하지는 않는다. `reboot`는 시스템을 재시작하고, `halt`는 CPU를 정지시키며, `poweroff`는 시스템을 종료하고 전원을 끈다. `kill`은 프로세스를 종료할 수 있지만, 시스템 종료 명령어는 아니다.

---

## Q4. Linux 부팅 순서

**문제:** Linux 부팅 단계의 올바른 순서는?

| 선택지 | 부팅 순서 |
|--------|----------|
| A | Boot loader -> BIOS -> Kernel init -> systemd -> Login prompt |
| B | BIOS -> Kernel init -> Boot loader -> systemd -> Login prompt |
| C | Boot loader -> Kernel init -> BIOS -> systemd -> Login prompt |
| D | BIOS -> Boot loader -> Kernel init -> systemd -> Login prompt |

**정답:** D. BIOS -> Boot loader -> Kernel init -> systemd -> Login prompt

**해설:** Linux 부팅 과정은 다음 순서를 따른다: (1) BIOS/UEFI가 POST 및 하드웨어 초기화를 수행하고, (2) 부트로더(예: GRUB2)가 커널을 메모리에 로드하고, (3) 커널이 하드웨어 드라이버를 초기화하고 루트 파일 시스템을 마운트하고, (4) systemd(PID 1)가 기본 타겟에 따라 시스템 서비스를 시작하고, (5) 로그인 프롬프트가 표시된다.

---

## Q5. 재부팅 런레벨

**문제:** 시스템 재부팅을 나타내는 런레벨은?

| 선택지 | 런레벨 |
|--------|--------|
| A | 0 |
| B | 3 |
| C | 5 |
| D | 6 |

**정답:** D. 6

**해설:** SysVinit 런레벨 체계에서: 런레벨 0은 정지/종료, 런레벨 1은 단일 사용자 모드, 런레벨 3은 네트워킹 포함 다중 사용자(GUI 없음), 런레벨 5는 GUI 포함 다중 사용자, 런레벨 6은 재부팅이다. systemd에서 런레벨 6은 `reboot.target`에 해당한다.

---

## Q6. 예약 재부팅

**문제:** 1분 후에 시스템을 재부팅하도록 설정하는 명령어는?

| 선택지 | 명령어 |
|--------|--------|
| A | `shutdown -h +1` |
| B | `shutdown -r +1` |
| C | `shutdown -c +1` |
| D | `shutdown -k +1` |

**정답:** B. `shutdown -r +1`

**해설:** `shutdown -r +1`은 1분 후 시스템 재부팅을 예약한다. `-r` 플래그는 재부팅, `-h`는 정지/전원 끄기, `-c`는 예약된 종료 취소, `-k`는 실제로 종료하지 않고 경고 메시지만 전송하는 것이다. `+1`은 분 단위 지연 시간을 지정한다.

---

## Q7. 부트로더의 역할

**문제:** 부트로더의 역할을 설명하시오.

**정답:** 부트로더는 커널을 메모리에 로드한다.

**해설:** 부트로더(예: GRUB2, LILO)는 디스크에서 Linux 커널 이미지를 RAM에 로드하고 제어를 커널에 전달하는 역할을 한다. 또한 여러 운영 체제나 커널 버전 중 선택할 수 있는 메뉴를 제공하고, 커널에 부팅 매개변수를 전달하며, 초기 단계 하드웨어 초기화를 위한 초기 RAM 디스크(initrd/initramfs)를 로드할 수 있다.

---

## Q8. 장치 유닛 목록 확인

**문제:** 어떤 장치 유닛이 존재하는지 확인하는 명령어는?

**정답:** `systemctl -t device`

**해설:** `systemctl -t device` 명령어는 systemd가 관리하는 모든 장치 유닛을 나열한다. `-t`(type) 옵션은 유닛을 유형별로 필터링한다. 다른 유닛 유형으로는 `service`, `socket`, `mount`, `timer`, `target` 등이 있다. 장치 유닛은 udev 장치 이벤트에 기반하여 systemd에 의해 자동으로 생성된다.

---

## Q9. 서비스 활성 상태 확인

**문제:** `abc.service` 유닛이 활성(실행 중)인지 확인하는 명령어는?

**정답:** `systemctl is-active abc.service`

**해설:** `systemctl is-active abc.service`는 지정된 유닛의 활성 상태를 확인하고 출력한다. 서비스가 실행 중이면 "active", 중지되었으면 "inactive", 오류가 발생했으면 "failed"를 반환한다. 이 명령어는 적절한 종료 코드(active의 경우 0, 그 외 0이 아닌 값)도 반환하므로 스크립트에서 유용하다.

---

## Q10. 단일 사용자 모드로 전환

**문제:** 문제 해결을 위해 시스템을 단일 사용자(복구) 모드로 전환하는 명령어는?

**정답:** `systemctl isolate rescue`

**해설:** `systemctl isolate rescue.target`(또는 줄임말 `rescue`)은 시스템을 복구 모드로 전환하며, 이는 전통적인 단일 사용자 모드(런레벨 1)에 해당한다. 복구 모드에서는 필수 서비스만 실행되고, 루트 파일 시스템이 마운트되며, root 사용자만 로그인할 수 있다. 이 모드는 정상적인 다중 사용자 모드가 제대로 작동하지 않을 때 시스템 유지보수 및 문제 해결에 사용된다.

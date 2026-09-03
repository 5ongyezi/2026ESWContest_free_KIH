# 💤ZZIP

### 수면 중 불필요한 아파트 안내방송을 선택적으로 차단하는 스마트 수면 보조 시스템

ZZIP은 Wi-Fi CSI 기반으로 사용자의 수면 상태를 감지하고,
수면 중 불필요한 아파트 안내방송을 차단하여
영유아가 있는 가정과 교대근무자의 수면 환경을 개선하는
임베디드 시스템이다.

## 주요 기능

- Wi-Fi CSI 기반 수면 상태 감지
- ZZIP Mode 자동/수동 전환
- 서보모터 기반 방송 차단 덮개
- 방음재를 활용한 외부 소음 감쇠
- 긴급 방송 증폭 및 RED LED 알림
- 수면 중 일상 방송 기록
- Flutter 기반 상태 및 알림 확인
- 수면 시간 및 요일 스케줄 설정

## Hardware

- ESP32
- Servo Motor
- LM386
- Speaker
- RED LED
- LCD
- ...

## Software

- Flutter
- Dart
- Arduino / ESP32
- Wi-Fi CSI

## Directory

```text
ZZIP/
├── HW/
│   └── zzip.ino
├── lib/
│   ├── data/
│   ├── screens/
│   └── widgets/
├── android/
├── ios/
└── pubspec.yaml

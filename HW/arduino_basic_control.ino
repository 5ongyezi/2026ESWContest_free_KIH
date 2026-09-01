#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <Servo.h>

// 핀 설정
const int BUTTON_PIN = 7;
const int LED_PIN = 13;
const int SERVO_PIN = 9;

// LCD
LiquidCrystal_I2C lcd(0x27, 16, 2);

// 서보
Servo myServo;

// 상태
bool sleeping = false;
bool lastButtonState = HIGH;

// 서보 각도
const int READY_ANGLE = 0;
const int SLEEP_ANGLE = 180;

void setup() {

  // 버튼
  pinMode(BUTTON_PIN, INPUT_PULLUP);

  // LED
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  // 서보
  myServo.attach(SERVO_PIN);
  myServo.write(READY_ANGLE);

  // LCD
  Wire.begin();
  lcd.init();
  lcd.backlight();

  // 처음 상태
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("ZZIP Ready");
}

void loop() {

  bool buttonState = digitalRead(BUTTON_PIN);

  // 버튼을 새롭게 눌렀을 때
  if (lastButtonState == HIGH && buttonState == LOW) {

    // 상태 변경
    sleeping = !sleeping;

    if (sleeping) {

      // ==================
      // SLEEPING
      // ==================

      // LED ON
      digitalWrite(LED_PIN, HIGH);

      // LCD
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("SLEEPING..ZZ");

      // 서보 OPEN
      myServo.write(SLEEP_ANGLE);

    } 
    else {

      // ==================
      // READY
      // ==================

      // LED OFF
      digitalWrite(LED_PIN, LOW);

      // LCD
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("ZZIP Ready");

      // 서보 CLOSE
      myServo.write(READY_ANGLE);
    }

    // 버튼 떨림 방지
    delay(200);
  }

  lastButtonState = buttonState;
}
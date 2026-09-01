#include <Servo.h>

Servo myServo;

void setup() {
  myServo.attach(9);
}

void loop() {
  // OPEN
  myServo.write(0);
  delay(2000);

  // CLOSE
  myServo.write(180);
  delay(2000);
}
const int BUTTON = 7;

void setup() {
  pinMode(BUTTON, INPUT_PULLUP);
  Serial.begin(9600);
}

void loop() {
  if (digitalRead(BUTTON) == LOW) {
    Serial.println("BUTTON PRESSED");
  } else {
    Serial.println("BUTTON RELEASED");
  }

  delay(200);
}
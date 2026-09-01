#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
  Wire.begin();

  lcd.init();
  lcd.backlight();

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("ZZIP Ready");
}

void loop() {
  delay(5000);

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("SLEEPING..ZZ");

  delay(5000);

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("ZZIP Ready");
}
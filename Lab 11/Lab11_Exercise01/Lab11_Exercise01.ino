int pin[] = {5, 6, 7};
int Tdelay[] = {2000, 1000, 3000};

void setup() {
  for (int i = 0; i <= 2; i++) {
    pinMode(pin[i], OUTPUT);
    digitalWrite(pin[i], LOW);
  }
}

void loop() {
  for (int i = 0; i <= 2; i++) {
    digitalWrite(pin[i], HIGH);
    digitalWrite(pin[(i+1)%3], LOW);
    digitalWrite(pin[(i+2)%3], LOW);
    delay(Tdelay[i]);
  }
}

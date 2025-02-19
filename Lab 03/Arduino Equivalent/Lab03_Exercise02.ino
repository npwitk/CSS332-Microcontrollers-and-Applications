const int pin4 = 4;
const int pin5 = 5;

void setup() {
  pinMode(pin4, OUTPUT);
  pinMode(pin5, OUTPUT);
}

void loop() {
  digitalWrite(pin4, HIGH);
  digitalWrite(pin5, LOW);
  delay_ms(128 * 200 * 250 * 2 / 16000000); // Approximate delay calculation

  digitalWrite(pin4, LOW);
  digitalWrite(pin5, HIGH);
  delay_ms(128 * 200 * 250 * 2 / 16000000); // Approximate delay calculation
}
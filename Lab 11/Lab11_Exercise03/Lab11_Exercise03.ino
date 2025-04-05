void setup() { }

void loop() {
  int inValue = analogRead(A2);
  int outValue = map(inValue, 0, 1023, 0, 255); // Change range from 0-1023 to 0-255
  analogWrite(9, outValue);
}

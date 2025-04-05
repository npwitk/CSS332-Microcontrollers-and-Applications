void setup() {
  Serial.begin(9600);
  pinMode(8, OUTPUT);
  digitalWrite(8, HIGH);
}

void loop() {
  int inValue = analogRead(A0);
  Serial.println(inValue);
  if (inValue > 750) {
    digitalWrite(8, HIGH);
  } else {
    digitalWrite(8, LOW);
  }
  delay(1000);
}

void setup() {
  Serial.begin(9600);
  pinMode(4, OUTPUT);
  digitalWrite(4, HIGH);
}

void loop() {
  int inValue = analogRead(A0);
  Serial.println(inValue);
  if (inValue > 600) {
    digitalWrite(4, HIGH);
  } else {
    digitalWrite(4, LOW);
  }
  delay(1000);
}
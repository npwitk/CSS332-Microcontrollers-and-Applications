int x = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  x++;
  if (x % 2 == 0) {
    Serial.print("The value of x = ");
    Serial.print(x);
    Serial.println(" is even.");
  }
  delay(1500);
}

int test;

void setup() {
  Serial.begin(9600);
  test = 0;
}

void loop() {
  test = test + 1;
  Serial.print("The value is ");
  Serial.println(test);
  delay(1000);
}
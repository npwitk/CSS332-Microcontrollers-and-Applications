int outPin[] = {5, 6, 7};
int inPin[] = {8, 9, 10};

void setup() {
  for (int i = 0; i <= 2; i++) {
    pinMode(inPin[i], INPUT);
    pinMode(outPin[i], OUTPUT);
    digitalWrite(outPin[i], LOW);
  }
}

void loop() {
  for (int i = 0; i <= 2; i++) {
    digitalWrite(outPin[i], !digitalRead(inPin[i]));
  }
}

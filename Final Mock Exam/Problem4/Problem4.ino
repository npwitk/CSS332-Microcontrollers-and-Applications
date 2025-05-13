const int pot1Pin = A0;    // First potentiometer
const int pot2Pin = A1;    // Second potentiometer
const int led1Pin = 8;     // LED1 (for A0 > A1)
const int led2Pin = 9;     // LED2 (for A0 < A1)
const int led3Pin = 10;    // LED3 (for A0 = A1)

void setup() {
  pinMode(led1Pin, OUTPUT);
  pinMode(led2Pin, OUTPUT);
  pinMode(led3Pin, OUTPUT);
  
  pinMode(pot1Pin, INPUT);
  pinMode(pot2Pin, INPUT);
  
  digitalWrite(led1Pin, LOW);
  digitalWrite(led2Pin, LOW);
  digitalWrite(led3Pin, LOW);
}

void loop() {
  int pot1Value = analogRead(pot1Pin);  // Read from A0 (0-1023)
  int pot2Value = analogRead(pot2Pin);  // Read from A1 (0-1023)
  
  digitalWrite(led1Pin, LOW);
  digitalWrite(led2Pin, LOW);
  digitalWrite(led3Pin, LOW);
  
  if (pot1Value > pot2Value) {
    digitalWrite(led1Pin, HIGH);  // Turn on LED1
  } else if (pot1Value < pot2Value) {
    digitalWrite(led2Pin, HIGH);  // Turn on LED2
  } else {  // Values are equal
    digitalWrite(led3Pin, HIGH);  // Turn on LED3
  }
  
  delay(100);
}
/// Transmitter

const int switch0Pin = 2;
const int switch1Pin = 3;

int switch0PrevState = HIGH;
int switch1PrevState = HIGH;

void setup() {
  pinMode(switch0Pin, INPUT_PULLUP);
  pinMode(switch1Pin, INPUT_PULLUP);
  
  Serial.begin(9600);
}

void loop() {
  int switch0State = digitalRead(switch0Pin);
  int switch1State = digitalRead(switch1Pin);
  
  if (switch0State == LOW && switch0PrevState == HIGH) {
    Serial.write('1');  // Send '1' character to toggle LED0
    delay(50);
  }
  
  if (switch1State == LOW && switch1PrevState == HIGH) {
    Serial.write('2');  // Send '2' character to toggle LED1
    delay(50);
  }
  
  switch0PrevState = switch0State;
  switch1PrevState = switch1State;

  delay(10);
}
const int led0Pin = 8;
const int led1Pin = 9;

boolean led0State = LOW;
boolean led1State = LOW;

void setup() {
  pinMode(led0Pin, OUTPUT);
  pinMode(led1Pin, OUTPUT);
  
  digitalWrite(led0Pin, led0State); // RESET here
  digitalWrite(led1Pin, led1State);
  
  Serial.begin(9600);
}

void loop() {

  if (Serial.available() > 0) {

    char receivedChar = Serial.read();
    
    if (receivedChar == '1') {
      led0State = !led0State;
      digitalWrite(led0Pin, led0State);
    } 
    else if (receivedChar == '2') {
      led1State = !led1State;
      digitalWrite(led1Pin, led1State);
    }
  }
}
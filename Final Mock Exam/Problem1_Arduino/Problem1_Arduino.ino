#include <TimerOne.h>

const int switchPin = 2;
const int led0Pin = 9;
const int led1Pin = 10;

// Variable to track LED1 state
volatile boolean led1State = LOW;

void setup() {
  pinMode(led0Pin, OUTPUT);
  pinMode(led1Pin, OUTPUT);
  
  pinMode(switchPin, INPUT_PULLUP);
  
  digitalWrite(led0Pin, LOW);
  digitalWrite(led1Pin, LOW);
  
  // Initialize Timer1 with a period of 0.5 seconds
  Timer1.initialize(500000);
  Timer1.attachInterrupt(toggleLED1);
}

void loop() {
  // Task 1: Monitor switch status
  if (digitalRead(switchPin) == LOW) {  // Switch is pressed (LOW because of pull-up resistor)
    digitalWrite(led0Pin, HIGH);        // Turn LED0 on
  } else {
    digitalWrite(led0Pin, LOW);         // Turn LED0 off
  }
  
}

// Timer interrupt service routine
void toggleLED1() {
  led1State = !led1State;
  digitalWrite(led1Pin, led1State);
}
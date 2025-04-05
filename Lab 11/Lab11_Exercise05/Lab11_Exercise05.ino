#include <Keypad.h>

// Define LED pins
const int ledPins[] = {10, 11, 12, 13};  // LED1 to LED4

// Keypad setup
const byte ROWS = 4; // Four rows
const byte COLS = 4; // Four columns
char keys[ROWS][COLS] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};

byte rowPins[ROWS] = {9, 8, 7, 6};   // Connect to the row pinouts of the keypad
byte colPins[COLS] = {5, 4, 3, 2};   // Connect to the column pinouts of the keypad

Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);

void setup() {
  for (int i = 0; i < 4; i++) {
    pinMode(ledPins[i], OUTPUT);
    digitalWrite(ledPins[i], LOW);
  }
}

void loop() {
  char key = keypad.getKey();
  if (key) {
    switch (key) {
      case '1': digitalWrite(ledPins[0], HIGH); break;
      case '2': digitalWrite(ledPins[1], HIGH); break;
      case '3': digitalWrite(ledPins[2], HIGH); break;
      case '4': digitalWrite(ledPins[3], HIGH); break;
      case 'A': digitalWrite(ledPins[0], LOW); break;
      case 'B': digitalWrite(ledPins[1], LOW); break;
      case 'C': digitalWrite(ledPins[2], LOW); break;
      case 'D': digitalWrite(ledPins[3], LOW); break;
    }
  }
}

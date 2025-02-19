const int ledPin = 4;      // LED connected to digital pin 4
const int buttonPin = 8;   // Button connected to digital pin 8

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT_PULLUP); // Use INPUT_PULLUP for the internal pull-up resistor
}

void loop() {
  int buttonState = digitalRead(buttonPin);

  if (buttonState == LOW) { // Check if the button is pressed (LOW because of pull-up)
    digitalWrite(ledPin, HIGH); // Turn the LED on
  } else {
    digitalWrite(ledPin, LOW);  // Turn the LED off
  }
}

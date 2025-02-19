		SBI DDRD, 4 ; pinMode(4, OUTPUT);
		CBI PORTD, 4 ; digitalWrite(4, LOW);
		CBI DDRB, 0 ; pinMode(8, INPUT);
		SBI PORTB, 0 ; digitalWrite(8, HIGH);
AGAIN:	SBIS PINB, 0 ; Checks if PB0 is HIGH.
		RJMP LED_ON
		CBI PORTD, 4
		RJMP AGAIN
LED_ON:	SBI PORTD, 4 ; digitalWrite(4, HIGH);
		RJMP AGAIN

/*
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
*/
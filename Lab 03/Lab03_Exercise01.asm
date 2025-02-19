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
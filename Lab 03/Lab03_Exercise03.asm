	.ORG    0
		
	SBI     DDRD, 4       ; pinMode(4, OUTPUT);
	CBI     PORTD, 4      ; digitalWrite(4, LOW);
		
	SBI     DDRD, 5       ; pinMode(5, OUTPUT);
	CBI     PORTD, 5      ; digitalWrite(5, LOW);
		
	CBI     DDRD, 6       ; pinMode(6, INPUT);
	SBI     PORTD, 6      ; digitalWrite(6, HIGH); (Enable pull-up resistor)
		
	CBI     DDRD, 7       ; pinMode(7, INPUT);
	SBI     PORTD, 7      ; digitalWrite(7, HIGH); (Enable pull-up resistor)

AGAIN:  
	SBIS    PIND, 6   ; Checks if PD6 (pin 6) is HIGH.
	RJMP    LED_On1   ; If button is pressed (LOW), jump to LED_On1.
	CBI     PORTD, 4  ; digitalWrite(4, LOW);

	SBIS    PIND, 7   ; Checks if PD7 (pin 7) is HIGH.
	RJMP    LED_On2   ; If button is pressed (LOW), jump to LED_On2.
	CBI     PORTD, 5  ; digitalWrite(5, LOW);

	RJMP    AGAIN     ; Repeat loop.

LED_On1:  
	SBI     PORTD, 4  ; digitalWrite(4, HIGH);
	RJMP    AGAIN     ; Repeat loop.

LED_On2:  
	SBI     PORTD, 5  ; digitalWrite(5, HIGH);
	RJMP    AGAIN     ; Repeat loop.

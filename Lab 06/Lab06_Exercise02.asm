	.ORG 0
	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	LDI R16, LOW(RAMEND)
	OUT SPL, R16
	SBI DDRD, 5 ; Set the pin PD5 as the output

LOOP:	CBI PORTD, 5 ; Set the pin PD5 = 0
	LDI R16, 0xC8
HERE1:	CALL DELAY
	DEC R16
	BRNE HERE1

	SBI PORTD, 5
	LDI R16, 0xC8
HERE2:	CALL DELAY
	DEC R16
	BRNE HERE2
	RJMP LOOP

DELAY:
	LDI R20, 0x40
	OUT TCNT0, R20 ; Set the initial value of Timer0
	LDI R20, 0xDB
	OUT OCR0A, R20 ; Set the max value of Timer0
	LDI R20, 0x02
	OUT TCCR0A, R20 ; Set the CTC mode
	LDI R20, 0x04
	OUT TCCR0B, R20 ; Pre-scaling 256 & start the clock
AGAIN:	SBIS TIFR0, 1 ; Check if TOV0 flag = 1?
	RJMP AGAIN
	LDI R20, 0x00
	OUT TCCR0B, R20 ; Stop the clock
	LDI R20, 0x02
	OUT TIFR0, R20 ; Clear the TOV0 flag
	RET ; Return to the main program!
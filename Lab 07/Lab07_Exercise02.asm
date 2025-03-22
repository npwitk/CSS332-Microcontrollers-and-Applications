.ORG 0x0
	JMP MAIN
.ORG 0x02
	JMP INT0_ISR

.ORG 0x100
MAIN:	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	LDI R16, LOW(RAMEND)
	OUT SPL, R16

	CALL PIN_SETUP

	LDI R16, (1<<INT0)
	OUT EIMSK, R16
	LDI R16, (1<<ISC01)
	STS EICRA, R16
	SEI

LOOP:	SBIC PIND, 4
	RJMP L_OFF
	RJMP L_ON

L_OFF:	CBI PORTB, 0
	RJMP LOOP

L_ON:	SBI PORTB, 0
	RJMP LOOP

PIN_SETUP:
	SBI DDRB, 0
	CBI PORTB, 0
	SBI DDRB, 1
	CBI PORTB, 1
	CBI DDRD, 4
	SBI PORTD, 4
	SBI PORTD, 2
	RET

TIMER0_SETUP:
	LDI R20, 0xB2
	OUT TCNT0, R20 ; Set the initial value of Timer0
	LDI R20, 0x00
	OUT TCCR0A, R20 ; Set the normal mode
	LDI R20, 0x05
	OUT TCCR0B, R20 ; Pre-scaling 1024 & start the clock
	RET

.ORG 0x200
INT0_ISR:
	IN R17, PORTB
	LDI R18, (1<<1)
	EOR R17, R18
	OUT PORTB, R17
	RETI
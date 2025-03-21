.ORG 0x0
	JMP MAIN
.ORG 0x04
	JMP INT1_ISR
.ORG 0x0A
	JMP PCINT21_IST
.ORG 0x20
	JMP T0_OV_ISR

.ORG 0x100
MAIN:	LDI R16, HIGH(RAMEND)
	OUT SPH, R16
	LDI R16, LOW(RAMEND)
	OUT SPL, R16

	CALL PIN_SETUP

	LDI R16, (1<<INT1)
	OUT EIMSK, R16
	LDI R16, (1<<ISC11)
	STS EICRA, R16

	LDI R16, (1<<PCIE2)
	STS PCICR, R16
	LDI R16, 0x20
	STS PCMSK2, R16
	LDI R22, 2

	LDI R16, (1<<TOIE0)
	STS TIMSK0, R16
	SEI
	CALL TIMER0_SETUP
	LDI R21, 200
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
	SBI DDRB, 2
	CBI PORTB, 2
	SBI DDRB, 3
	CBI PORTB, 3

	CBI DDRD, 3
	SBI PORTD, 3
	CBI DDRD, 4
	SBI PORTD, 4
	SBI PORTD, 5
	RET

TIMER0_SETUP:
    LDI R20, 0xB2          ; Load initial value for Timer0
    OUT TCNT0, R20         ; Set Timer0 initial value
    LDI R20, 0x00          ; Set normal mode (TCCR0A = 0)
    OUT TCCR0A, R20        ; Store in Timer Control Register A
    LDI R20, 0x05          ; Set pre-scaler to 1024 and start Timer0 (TCCR0B = 0x05)
    OUT TCCR0B, R20        ; Store in Timer Control Register B
    RET                    ; Return from subroutine

.ORG 0x200
INT1_ISR:
	IN R17, PORTB
	LDI R18, (1<<1)
	EOR R17, R18
	OUT PORTB, R17
	RETI

PCINT21_ISR:
	DEC R22
	BRNE HERE1
	IN R17, PORTB
	LDI R18, (1<<2)
	EOR R17, R18
	OUT PORTB, R17
	LDI R22, 2
HERE1:	RETI

T0_OV_ISR:
	DEC R21
	BRNE HERE2
	LDI R21, 200
	IN R17, PORTB
	LDI R18, (1<<3)
	EOR R17, R18
	OUT PORTB, R17
HERE2:	LDI R18, 0xB2
	OUT TCNT0, R18
	RETI
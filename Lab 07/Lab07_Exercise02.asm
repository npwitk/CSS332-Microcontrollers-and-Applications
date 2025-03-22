.ORG 0x0         ; Reset vector
	JMP MAIN      ; Jump to the main program

.ORG 0x02       ; External Interrupt 0 vector
	JMP INT0_ISR  ; Jump to interrupt service routine (ISR) for INT0

.ORG 0x100      ; Start of main program code
MAIN:	LDI R16, HIGH(RAMEND)  ; Load high byte of RAMEND to R16
	OUT SPH, R16           ; Set stack pointer high byte
	LDI R16, LOW(RAMEND)   ; Load low byte of RAMEND to R16
	OUT SPL, R16           ; Set stack pointer low byte

	CALL PIN_SETUP         ; Call subroutine to initialize I/O pins

	LDI R16, (1<<INT0)     ; Enable external interrupt INT0
	OUT EIMSK, R16         ; Set INT0 enable bit in EIMSK
	LDI R16, (1<<ISC01)    ; Set INT0 to trigger on falling edge
	STS EICRA, R16         ; Store configuration in EICRA register
	SEI                    ; Enable global interrupts

LOOP:	SBIC PIND, 4          ; Skip next instruction if switch SW0 (PIND4) is clear
	RJMP L_OFF             ; If not pressed, turn off LED0
	RJMP L_ON              ; If pressed, turn on LED0

L_OFF:	CBI PORTB, 0          ; Clear bit 0 of PORTB (turn off LED0)
	RJMP LOOP              ; Repeat loop

L_ON:	SBI PORTB, 0          ; Set bit 0 of PORTB (turn on LED0)
	RJMP LOOP              ; Repeat loop

; Subroutine to configure I/O pins
PIN_SETUP:
	SBI DDRB, 0    ; Set PORTB0 (LED0) as output
	CBI PORTB, 0   ; Ensure LED0 is initially off
	SBI DDRB, 1    ; Set PORTB1 (LED1) as output
	CBI PORTB, 1   ; Ensure LED1 is initially off
	CBI DDRD, 4    ; Set PIND4 (SW0) as input
	SBI PORTD, 4   ; Enable pull-up resistor for SW0
	SBI PORTD, 2   ; Enable pull-up resistor for SW1 (INT0)
	RET            ; Return from subroutine

.ORG 0x200       ; Start of INT0 ISR (Interrupt Service Routine)
INT0_ISR:
	IN R17, PORTB  ; Read current state of PORTB
	LDI R18, (1<<1) ; Load mask for LED1 (PORTB1)
	EOR R17, R18   ; Toggle LED1 state using XOR
	OUT PORTB, R17 ; Output new state to PORTB
	RETI           ; Return from interrupt

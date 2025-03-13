	.ORG 0  ; Origin of the program in memory
	
	; Stack Initialization (used for function calls)
	LDI R16, HIGH(RAMEND) ; Load the high byte of the RAM end address into R16
	OUT SPH, R16          ; Set the Stack Pointer High (SPH)
	LDI R16, LOW(RAMEND)  ; Load the low byte of the RAM end address into R16
	OUT SPL, R16          ; Set the Stack Pointer Low (SPL)
	
	; Pin Configuration
	SBI DDRD, 4           ; pinMode(4, OUTPUT);
	CBI PORTD, 4          ; digitalWrite(4, LOW);
	SBI DDRD, 5           ; pinMode(5, OUTPUT);
	CBI PORTD, 5          ; digitalWrite(5, LOW);

AGAIN: 
	SBI PORTD, 4      ; digitalWrite(4, HIGH);
	CBI PORTD, 5      ; digitalWrite(5, LOW);
	CALL DELAY        ; Call the delay subroutine
	CBI PORTD, 4      ; digitalWrite(4, LOW);
	SBI PORTD, 5      ; digitalWrite(5, HIGH);
	CALL DELAY        ; Call the delay subroutine
	RJMP AGAIN        ; Repeat loop

DELAY:  ; Delay subroutine
	LDI R20, 128      ; Outer loop counter
L1:	LDI R21, 200      ; Middle loop counter
L2:	LDI R22, 250      ; Inner loop counter
L3:	NOP              ; No Operation (used for timing)
	NOP              ; No Operation (used for timing)
	DEC R22          ; Decrement R22
	BRNE L3          ; Branch if R22 is not equal to zero (loop back to L3)
	DEC R21          ; Decrement R21
	BRNE L2          ; Branch if R21 is not equal to zero (loop back to L2)
	DEC R20          ; Decrement R20
	BRNE L1          ; Branch if R20 is not equal to zero (loop back to L1)
	RET              ; Return from subroutine

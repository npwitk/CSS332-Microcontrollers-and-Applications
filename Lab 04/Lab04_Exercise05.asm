SETUP:  
	LDI R16, 0xFF      ; Load 0xFF (11111111) into R16
	OUT DDRD, R16      ; Set all PORTD pins as output (pinMode for all)

START:  
	SEC                ; Set Carry flag (used for ROR operation)  
	LDI R17, 0x80      ; Load 0x80 (10000000) into R17, setting MSB high  

AGAIN:  
	OUT PORTD, R17     ; Output R17 value to PORTD (LED pattern shift)  
	CALL DELAY         ; Call delay subroutine  
	ROR R17            ; Rotate bits in R17 right (shifting LED pattern)  
	SBIC PORTD, 0      ; Skip next instruction if bit 0 of PORTD is set  
	RJMP START         ; Restart pattern if bit 0 is set  
	RJMP AGAIN         ; Loop back  

DELAY:  
	LDI R20, 64        ; Outer loop counter  
L1:	LDI R21, 200       ; Middle loop counter  
L2:	LDI R22, 250       ; Inner loop counter  
L3:	NOP               ; No Operation (used for timing)  
	NOP               ; No Operation (used for timing)  
	DEC R22           ; Decrement R22  
	BRNE L3           ; Loop if R22 is not zero  
	DEC R21           ; Decrement R21  
	BRNE L2           ; Loop if R21 is not zero  
	DEC R20           ; Decrement R20  
	BRNE L1           ; Loop if R20 is not zero  
	RET               ; Return from subroutine  

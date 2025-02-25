.MACRO SETOUT  	LDI @0, @1  ; Macro to load a value into a register and output it
               	OUT @2, @0  ; Usage: SETOUT Register, Value, Port

.ENDMACRO

.MACRO TDELAY  	LDI R20, @0  ; Macro for a timed delay

L1: 		LDI R21, @1
L2: 		LDI R22, @2
L3: 		NOP      ; No operation (for timing)
              	NOP
              	DEC R22     ; Decrement inner loop counter
              	BRNE L3     ; Branch if not equal to zero (loop back)
              	DEC R21     ; Decrement middle loop counter
              	BRNE L2     ; Branch if not equal to zero
              	DEC R20     ; Decrement outer loop counter
              	BRNE L1     ; Branch if not equal to zero
.ENDMACRO

START:       	.ORG 0x00      ; Set program origin to address 0x00

		SETOUT R18, 0xFF, DDRD  ; Set Port D as output (all pins high)
LOOP:  		SETOUT R18, 0xAA, PORTD  ; Output alternating bits on Port D (0b10101010)

             	TDELAY 60, 200, 250     ; Delay using the TDELAY macro
             	SETOUT R18, 0x55, PORTD  ; Output alternating bits on Port D (0b01010101)

             	TDELAY 60, 200, 250     ; Delay again
             	RJMP LOOP            ; Jump back to the LOOP label (infinite loop)
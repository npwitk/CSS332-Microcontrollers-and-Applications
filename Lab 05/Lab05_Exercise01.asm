.ORG 0x00             ; Set the origin to address 0x00 (start of flash memory)

    LDI R16, 0xFF        ; Load immediate value 0xFF into register R16
    OUT DDRD, R16       ; Set all pins of Port D as outputs (DDRD = 0xFF)

AGAIN1:                 ; Label for the main loop
    LDI ZH, HIGH(0x400) ; Load the high byte of the address of MYDATA (or 0x400 if MYDATA is at that address) into ZH
    LDI ZL, LOW(0x400)  ; Load the low byte of the address of MYDATA (or 0x400 if MYDATA is at that address) into ZL
    LDI R17, 10          ; Load loop counter (10 iterations) into R17

AGAIN2:                 ; Label for the inner loop
    LPM R16, Z+         ; Load program memory byte from the address in Z (ZL:ZH) into R16, then increment Z
    OUT PORTD, R16       ; Output the value in R16 to Port D (controlling LEDs or a display)
    CALL DELAY           ; Call the delay subroutine
    DEC R17             ; Decrement the loop counter R17
    BRNE AGAIN2         ; Branch if R17 is not zero (loop back to AGAIN2)
    JMP AGAIN1          ; Jump back to the beginning of the main loop (AGAIN1)

; 1-second delay subroutine
DELAY:
    LDI R23, 60        ; Outer loop counter for delay
L1:
    LDI R24, 200        ; Middle loop counter for delay
L2:
    LDI R25, 250        ; Inner loop counter for delay
L3:
    NOP                 ; No operation (burns a clock cycle)
    NOP                 ; No operation (burns a clock cycle)
    DEC R25             ; Decrement R25
    BRNE L3             ; Branch if R25 is not zero (loop back to L3)
    DEC R24             ; Decrement R24
    BRNE L2             ; Branch if R24 is not zero (loop back to L2)
    DEC R23             ; Decrement R23
    BRNE L1             ; Branch if R23 is not zero (loop back to L1)
    RET                 ; Return from the delay subroutine

.ORG 0x200            ; Set the origin to address 0x200 (where the lookup table is stored)

MYDATA:                 ; Lookup table for 7-segment display codes (common cathode)
    .DB 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

.ORG 0x00             ; Set the origin to address 0x00 (start of flash memory)

    LDI R16, 0xFF        ; Load immediate value 0xFF into register R16
    OUT DDRD, R16       ; Set all pins of Port D as outputs (DDRD = 0xFF)

AGAIN1:                 ; Label for the main loop
    LDI ZH, HIGH(0x400) ; Load the high byte of the address of MYDATA into ZH
    LDI ZL, LOW(0x400)  ; Load the low byte of the address of MYDATA into ZL
    LDI R17, 10          ; Load loop counter (10 iterations) into R17

AGAIN2:                 ; Label for the inner loop
    LPM R16, Z+         ; Load program memory byte from the address in Z (ZL:ZH) into R16, then increment Z
    OUT PORTD, R16       ; Output the value in R16 to Port D (controlling LEDs or a display)
    CALL DELAY           ; Call the delay subroutine
    DEC R17             ; Decrement the loop counter R17
    BRNE AGAIN2         ; Branch if R17 is not zero (loop back to AGAIN2)
    JMP AGAIN1          ; Jump back to the beginning of the main loop (AGAIN1)

; 2-second delay subroutine
DELAY:
    LDI R23, 64
L1:
    LDI R24, 200
L2:
    LDI R25, 250
L3:
    NOP
    NOP
    DEC R25
    BRNE L3
    DEC R24
    BRNE L2
    DEC R23
    BRNE L1
    RET    

.ORG 0x200

MYDATA:                 ; My student ID hereeeee...
    .DB 0x7D, 0x7D, 0x5B, 0x5B, 0x07, 0x07, 0x5B, 0x66, 0x5B, 0x5B

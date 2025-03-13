.ORG 0x00
.MACRO DELAY
    LDI  R20, @0
L1: LDI  R21, @1
L2: LDI  R22, @2
L3: NOP
    NOP
    DEC  R22
    BRNE L3
    DEC  R21
    BRNE L2
    DEC  R20
    BRNE L1
.ENDMACRO
.MACRO SETLED
    LDI  R16, @0
    OUT  PORTD, R16
.ENDMACRO

MAIN:
    ; Initialize PORTD as output
    LDI  R16, 0xFF
    OUT  DDRD, R16
    
    ; Clear PORTD initially
    LDI  R16, 0x00
    OUT  PORTD, R16

LOOP:
    ; Move LED from left to right (PD0 to PD7)
    SETLED 0b00000001     ; PD0
    DELAY 5, 200, 250
    
    SETLED 0b00000010     ; PD1
    DELAY 5, 200, 250
    
    SETLED 0b00000100     ; PD2
    DELAY 5, 200, 250
    
    SETLED 0b00001000     ; PD3
    DELAY 5, 200, 250
    
    SETLED 0b00010000     ; PD4
    DELAY 5, 200, 250
    
    SETLED 0b00100000     ; PD5
    DELAY 5, 200, 250
    
    SETLED 0b01000000     ; PD6
    DELAY 5, 200, 250
    
    SETLED 0b10000000     ; PD7
    DELAY 5, 200, 250
    
    ; Move LED from right to left (PD6 to PD1)
    SETLED 0b01000000     ; PD6
    DELAY 5, 200, 250
    
    SETLED 0b00100000     ; PD5
    DELAY 5, 200, 250
    
    SETLED 0b00010000     ; PD4
    DELAY 5, 200, 250
    
    SETLED 0b00001000     ; PD3
    DELAY 5, 200, 250
    
    SETLED 0b00000100     ; PD2
    DELAY 5, 200, 250
    
    SETLED 0b00000010     ; PD1
    DELAY 5, 200, 250
    
    RJMP LOOP             ; Repeat forever

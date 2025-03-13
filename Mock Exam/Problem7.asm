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
    ; Initialize stack pointer
    LDI  R16, HIGH(RAMEND)
    OUT  SPH, R16
    LDI  R16, LOW(RAMEND)
    OUT  SPL, R16
    
    ; Initialize PORTD as output
    LDI  R16, 0xFF       ; All pins as output
    OUT  DDRD, R16
    
    ; Initialize direction flag and LED pattern
    LDI  R18, 0x01       ; Direction: 1=right, 0=left
    LDI  R17, 0x01       ; Start with LED at PD0

LOOP:
    ; Output current LED pattern
    MOV  R16, R17
    OUT  PORTD, R16
    
    ; Delay to make movement visible
    DELAY 32, 200, 250
    
    ; Check direction
    CPI  R18, 0x01
    BRNE GO_LEFT
    
GO_RIGHT:
    ; Shift LED to the right
    LSL  R17
    
    ; Check if we've reached PD7
    CPI  R17, 0x80
    BRNE LOOP            ; If not at PD7, continue in same direction
    
    ; At PD7, change direction
    LDI  R18, 0x00       ; Set direction to left
    RJMP LOOP
    
GO_LEFT:
    ; Shift LED to the left
    LSR  R17
    
    ; Check if we've reached PD0
    CPI  R17, 0x01
    BRNE LOOP            ; If not at PD0, continue in same direction
    
    ; At PD0, change direction
    LDI  R18, 0x01       ; Set direction to right
    RJMP LOOP

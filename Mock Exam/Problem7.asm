.ORG 0x00

.MACRO DELAY
    LDI R20, @0
L1: LDI R21, @1
L2: LDI R22, @2
L3: NOP
    NOP
    DEC R22
    BRNE L3
    DEC R21
    BRNE L2
    DEC R20
    BRNE L1
.ENDMACRO

.MACRO SETLED
    LDI R16, @0
    OUT PORTD, R16
.ENDMACRO

MAIN:
    LDI R16, 0xFF        ; Load 0xFF into R16
    OUT DDRD, R16        ; Set all bits in DDRD (all pins as output)
    
    LDI R17, 0x01        ; Start with LED at PD0
    LDI R19, 0x01        ; Direction flag (1 = right, 0 = left)
    
LOOP:
    SETLED R17           ; Set LED pattern
    DELAY 50, 255, 255   ; Delay to make movement visible
    
    TST R19              ; Check direction flag
    BRNE SHIFT_RIGHT     ; If not zero, shift right
    
SHIFT_LEFT:
    LSR R17              ; Shift right (LED moves left)
    BRNE LOOP            ; If result not zero, continue loop
    LDI R17, 0x02        ; Restart from PD1
    LDI R19, 0x01        ; Change direction to right
    RJMP LOOP
    
SHIFT_RIGHT:
    LSL R17              ; Shift left (LED moves right)
    CPI R17, 0x00        ; Check if we've shifted past the end
    BRNE CHECK_END       ; If not zero, check if we reached the end
    LDI R17, 0x40        ; Restart from PD6
    CLR R19              ; Change direction to left
    RJMP LOOP
    
CHECK_END:
    CPI R17, 0x80        ; Check if LED reached PD7
    BRNE LOOP            ; If not at PD7, continue loop
    LDI R19, 0x00        ; Change direction to left
    RJMP LOOP

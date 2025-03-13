.ORG 0x00

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
    LDI R17, 0x01         ; Start with LED at PD0
    LDI R18, 0x80         ; Mask for checking PD7
    LDI R19, 0x01         ; Direction flag (1 = right, 0 = left)
    
    SBI DDRD, 0xFF        ; Set PORTD as output

LOOP:
    SETLED R17            ; Set LED pattern

    DELAY 50, 255, 255    ; Delay to make movement visible

    TST R19               ; Check direction flag
    BRNE SHIFT_RIGHT      ; If not zero, shift right

SHIFT_LEFT:
    LSR R17               ; Shift left
    BRCC CHANGE_DIR_LEFT  ; If carry set, change direction
    RJMP LOOP

SHIFT_RIGHT:
    LSL R17               ; Shift right
    BRCC CHANGE_DIR_RIGHT ; If carry set, change direction
    RJMP LOOP

CHANGE_DIR_LEFT:
    LDI R17, 0x02         ; Restart from PD1
    CLR R19               ; Change direction to left
    RJMP LOOP

CHANGE_DIR_RIGHT:
    LDI R17, 0x40         ; Restart from PD6
    LDI R19, 0x01         ; Change direction to right
    RJMP LOOP

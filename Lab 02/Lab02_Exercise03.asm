.ORG 0

; Initialize the stack pointer to 0x0700
LDI R16, 0x07       ; Load high byte of stack address (0x07) into R16
OUT SPH, R16        ; Set stack pointer high byte
LDI R17, 0x00       ; Load low byte of stack address (0x00) into R17
OUT SPL, R17        ; Set stack pointer low byte to complete stack initialization at 0x0700

LDI R18, 0x1A
LDI R19, 0x33
LDI R20, 0x55

PUSH R18
PUSH R19
PUSH R20

; Simple Button-Click LED Pattern Shift
; 
; Hardware configuration:
; - 8 LEDs connected to PORTD (PD0-PD7)
; - Push button connected to PB0 with pull-up resistor
; - AVR microcontroller running at 16MHz

.ORG 0x00                     ; Start at address 0x00

SETUP:
    ; Configure PORTD (LEDs) as output
    LDI R16, 0xFF             ; Set all bits to 1
    OUT DDRD, R16             ; Configure PORTD as output
    
    ; Configure PORTB (button) as input with pull-up
    CBI DDRB, 0               ; Set PB0 as input (button)
    SBI PORTB, 0              ; Enable pull-up resistor on PB0
    
    ; Initialize LED pattern - start with rightmost LED on
    LDI R17, 0x01             ; 0000 0001 - PD0 LED on
    OUT PORTD, R17            ; Output initial pattern to PORTD
    
    ; Initialize button state tracking
    LDI R18, 1                ; R18 = previous button state (1 = not pressed)

MAIN_LOOP:
    ; Read current button state
    IN R19, PINB              ; Read PINB
    ANDI R19, 0x01            ; Isolate PB0 bit
    
    ; Check for button state change (press)
    CP R19, R18               ; Compare current with previous state
    BREQ SKIP_ACTION          ; If same, no change
    
    ; Button state changed - check if it's a press (1->0)
    CPI R18, 1                ; Was previous state "not pressed"?
    BRNE SKIP_ACTION          ; If not, it's a release - skip action
    
    ; Button pressed - shift LED pattern
    LSL R17                   ; Logical shift left
    
    ; Check if we've gone past the leftmost LED
    BRNE SKIP_RESET           ; If result is not zero, we're still in range
    LDI R17, 0x01             ; If zero, wrap around to PD0
    
SKIP_RESET:
    OUT PORTD, R17            ; Output the new pattern to PORTD
    
SKIP_ACTION:
    ; Update previous button state
    MOV R18, R19              ; Store current state as previous
    
    ; Small delay to slow down the checking loop
    LDI R20, 200
DELAY_LOOP:
    DEC R20
    BRNE DELAY_LOOP
    
    RJMP MAIN_LOOP            ; Return to main loop
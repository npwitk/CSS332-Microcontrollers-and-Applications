.ORG 0x00                     ; Start at address 0x00

SETUP:
    ; Initialize stack pointer (required for CALL instructions)
    LDI R16, HIGH(RAMEND)     ; Load high byte of RAMEND
    OUT SPH, R16              ; Set Stack Pointer High
    LDI R16, LOW(RAMEND)      ; Load low byte of RAMEND
    OUT SPL, R16              ; Set Stack Pointer Low
    
    ; Configure PORTD (LEDs) as output
    LDI R16, 0xFF             ; Set all bits to 1
    OUT DDRD, R16             ; Configure PORTD as output
    
    ; Configure PORTB (button) as input with pull-up
    CBI DDRB, 0               ; Set PB0 as input
    SBI PORTB, 0              ; Enable pull-up resistor on PB0
    
    ; Initialize LED pattern - start with rightmost LED on
    LDI R17, 0x01             ; 0000 0001 - PD0 LED on
    OUT PORTD, R17            ; Output initial pattern to PORTD

MAIN_LOOP:
    ; Check if button is pressed (PB0 will be LOW when pressed)
    SBIC PINB, 0              ; Skip next instruction if PB0 is LOW (button pressed)
    RJMP MAIN_LOOP            ; If button not pressed, keep checking
    
    ; Button pressed, now debounce
    CALL DEBOUNCE_DELAY       ; Wait for button to stabilize
    
    ; Check if button is still pressed after debounce
    SBIC PINB, 0              ; Skip next instruction if PB0 is still LOW
    RJMP MAIN_LOOP            ; If button not pressed anymore (false trigger), go back
    
    ; Shift LED pattern left
    LSL R17                   ; Logical shift left
    
    ; Check if we've gone past the leftmost LED
    BRNE SKIP_RESET           ; If result is not zero, we're still in range
    LDI R17, 0x01             ; If result is zero, wrap around to PD0
    
SKIP_RESET:
    OUT PORTD, R17            ; Output the new pattern to PORTD
    
    ; Wait for button release with debounce
WAIT_RELEASE:
    SBIS PINB, 0              ; Skip next instruction if PB0 is HIGH (button released)
    RJMP WAIT_RELEASE         ; If button still pressed, keep checking
    
    CALL DEBOUNCE_DELAY       ; Debounce delay for button release
    
    RJMP MAIN_LOOP            ; Return to main loop

; Debounce delay (approximately 20ms at 16MHz)
DEBOUNCE_DELAY:
    LDI R20, 50               ; Outer loop counter
DD1:
    LDI R21, 200              ; Middle loop counter
DD2:
    LDI R22, 200              ; Inner loop counter
DD3:
    NOP                       ; No operation
    DEC R22                   ; Decrement inner counter
    BRNE DD3                  ; Loop if not zero
    DEC R21                   ; Decrement middle counter
    BRNE DD2                  ; Loop if not zero
    DEC R20                   ; Decrement outer counter
    BRNE DD1                  ; Loop if not zero
    RET                       ; Return from subroutine
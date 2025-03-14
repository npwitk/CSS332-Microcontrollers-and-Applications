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
    
    ; Configure PORTB (buttons) as input with pull-ups
    CBI DDRB, 0               ; Set PB0 as input
    SBI PORTB, 0              ; Enable pull-up resistor on PB0
    CBI DDRB, 1               ; Set PB1 as input
    SBI PORTB, 1              ; Enable pull-up resistor on PB1
    
    ; Initialize LED pattern - start with rightmost LED on
    LDI R17, 0x01             ; 0000 0001 - PD0 LED on
    OUT PORTD, R17            ; Output initial pattern to PORTD

MAIN_LOOP:
    ; Check if Button 1 (PB0) is pressed for shifting left
    SBIS PINB, 0              ; Skip next instruction if PB0 is HIGH (button not pressed)
    RJMP BUTTON1_PRESSED      ; If Button 1 is pressed, handle it
    
    ; Check if Button 2 (PB1) is pressed for shifting right
    SBIS PINB, 1              ; Skip next instruction if PB1 is HIGH (button not pressed)
    RJMP BUTTON2_PRESSED      ; If Button 2 is pressed, handle it
    
    RJMP MAIN_LOOP            ; If no button pressed, keep checking

; Handle Button 1 press (shift left)
BUTTON1_PRESSED:
    CALL DEBOUNCE_DELAY       ; Wait for button to stabilize
    
    ; Check if button is still pressed after debounce
    SBIS PINB, 0              ; Skip next instruction if PB0 is HIGH (button not pressed)
    RJMP SHIFT_LEFT           ; If Button 1 is still pressed, shift left
    RJMP MAIN_LOOP            ; If button not pressed anymore (false trigger), go back

; Handle Button 2 press (shift right)
BUTTON2_PRESSED:
    CALL DEBOUNCE_DELAY       ; Wait for button to stabilize
    
    ; Check if button is still pressed after debounce
    SBIS PINB, 1              ; Skip next instruction if PB1 is HIGH (button not pressed)
    RJMP SHIFT_RIGHT          ; If Button 2 is still pressed, shift right
    RJMP MAIN_LOOP            ; If button not pressed anymore (false trigger), go back

; Shift LED pattern left
SHIFT_LEFT:
    LSL R17                   ; Logical shift left
    BRNE SKIP_LEFT_RESET      ; If result is not zero, we're still in range
    LDI R17, 0x01             ; If result is zero, wrap around to PD0
SKIP_LEFT_RESET:
    OUT PORTD, R17            ; Output the new pattern to PORTD
    
    ; Wait for Button 1 release with debounce
WAIT_RELEASE1:
    SBIC PINB, 0              ; Skip next instruction if PB0 is LOW (button still pressed)
    RJMP CHECK_DEBOUNCE1      ; Button might be released, check with debounce
    RJMP WAIT_RELEASE1        ; Button still pressed, keep waiting

CHECK_DEBOUNCE1:
    CALL DEBOUNCE_DELAY       ; Debounce delay for button release
    SBIS PINB, 0              ; Skip next instruction if PB0 is HIGH (button released)
    RJMP WAIT_RELEASE1        ; If button pressed again (bounce), keep waiting
    RJMP MAIN_LOOP            ; Return to main loop

; Shift LED pattern right
SHIFT_RIGHT:
    CPI R17, 0x01             ; Compare with rightmost position
    BRNE NORMAL_RIGHT_SHIFT   ; If not at rightmost, do normal shift
    LDI R17, 0x80             ; If at rightmost, wrap around to PD7
    RJMP SKIP_RIGHT_SHIFT
    
NORMAL_RIGHT_SHIFT:
    LSR R17                   ; Logical shift right

SKIP_RIGHT_SHIFT:
    OUT PORTD, R17            ; Output the new pattern to PORTD
    
    ; Wait for Button 2 release with debounce
WAIT_RELEASE2:
    SBIC PINB, 1              ; Skip next instruction if PB1 is LOW (button still pressed)
    RJMP CHECK_DEBOUNCE2      ; Button might be released, check with debounce
    RJMP WAIT_RELEASE2        ; Button still pressed, keep waiting

CHECK_DEBOUNCE2:
    CALL DEBOUNCE_DELAY       ; Debounce delay for button release
    SBIS PINB, 1              ; Skip next instruction if PB1 is HIGH (button released)
    RJMP WAIT_RELEASE2        ; If button pressed again (bounce), keep waiting
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
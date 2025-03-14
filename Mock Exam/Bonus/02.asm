; Button Debouncing and LED Control

.ORG 0x00                     ; Start at address 0x00

SETUP:
    ; Configure LED pin (PD4) as output
    SBI DDRD, 4                ; Configure PD4 (LED) as output
    CBI PORTD, 4               ; Initialize LED as OFF
    
    ; Configure button pin (PB0) as input with pull-up
    CBI DDRB, 0                ; Configure PB0 (button) as input
    SBI PORTB, 0               ; Enable pull-up resistor on PB0
    
    ; Initialize button state
    LDI R18, 0                 ; R18 = LED state (0 = OFF, 1 = ON)

MAIN_LOOP:
    SBIC PINB, 0               ; Skip next instruction if button is pressed (PB0 = 0)
    RJMP MAIN_LOOP             ; If button not pressed, keep checking
    
    ; Button pressed, now debounce
    CALL DEBOUNCE_DELAY        ; Wait for button to stabilize
    
    ; Check if button is still pressed after debounce
    SBIC PINB, 0               ; Skip next instruction if button is still pressed
    RJMP MAIN_LOOP             ; If button not pressed anymore (false trigger), go back
    
    ; Toggle LED state
    LDI R19, 1                 ; Load 1 for XOR operation
    EOR R18, R19               ; Toggle R18 state (0->1 or 1->0)
    
    ; Update LED based on state
    CBI PORTD, 4               ; First turn off LED
    SBRC R18, 0                ; Skip next instruction if bit 0 of R18 is 0
    SBI PORTD, 4               ; Turn on LED if R18 state is 1
    
    ; Wait for button release with debounce
WAIT_RELEASE:
    SBIS PINB, 0               ; Skip next instruction if button is released (PB0 = 1)
    RJMP WAIT_RELEASE          ; If button still pressed, keep checking
    
    CALL DEBOUNCE_DELAY        ; Debounce delay for button release
    
    RJMP MAIN_LOOP             ; Return to main loop

; Debounce delay (approximately 20ms)
DEBOUNCE_DELAY:
    LDI R20, 30                ; Outer loop counter
DD1:
    LDI R21, 200               ; Middle loop counter
DD2:
    LDI R22, 200               ; Inner loop counter
DD3:
    NOP                        ; No operation
    DEC R22                    ; Decrement inner counter
    BRNE DD3                   ; Loop if not zero
    DEC R21                    ; Decrement middle counter
    BRNE DD2                   ; Loop if not zero
    DEC R20                    ; Decrement outer counter
    BRNE DD1                   ; Loop if not zero
    RET                        ; Return from subroutine
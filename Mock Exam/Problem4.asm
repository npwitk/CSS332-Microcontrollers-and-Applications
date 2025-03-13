        .ORG 0

        // Configure LED pins as OUTPUT (PD4, PD5)
        SBI DDRD, 4      ; Set PD4 as output (LED 0)
        SBI DDRD, 5      ; Set PD5 as output (LED 1)

        // Turn off LEDs initially
        CBI PORTD, 4     ; Ensure LED 0 is OFF
        CBI PORTD, 5     ; Ensure LED 1 is OFF

        // Configure switch pins as INPUT with pull-up resistors (PB0, PB1)
        CBI DDRB, 0      ; Set PB0 as input (Switch 0)
        SBI PORTB, 0     ; Enable pull-up resistor on PB0

        CBI DDRB, 1      ; Set PB1 as input (Switch 1)
        SBI PORTB, 1     ; Enable pull-up resistor on PB1

AGAIN:
        // Check Switch 0 (PB0)
        SBIS PINB, 0     ; Skip next instruction if PB0 is HIGH (not pressed)
        RJMP LED_On0     ; If PB0 is LOW (pressed), jump to LED_On0
        CBI PORTD, 4     ; Otherwise, turn off LED 0

        // Check Switch 1 (PB1)
        SBIS PINB, 1     ; Skip next instruction if PB1 is HIGH (not pressed)
        RJMP LED_On1     ; If PB1 is LOW (pressed), jump to LED_On1
        CBI PORTD, 5     ; Otherwise, turn off LED 1

        RJMP AGAIN       ; Repeat loop

LED_On0:
        SBI PORTD, 4     ; Turn on LED 0 (PD4)
        RJMP AGAIN

LED_On1:
        SBI PORTD, 5     ; Turn on LED 1 (PD5)
        RJMP AGAIN
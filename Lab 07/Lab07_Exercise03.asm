.ORG 0x0         ; Set the origin at address 0x0000 (Reset Vector)
    JMP MAIN     ; Jump to MAIN routine (bypass interrupt vector area)

.ORG 0x08        ; Set the interrupt vector for PCINT8 (Pin Change Interrupt on PC0)
    JMP PCINT8_ISR  ; Jump to PCINT8_ISR when the interrupt occurs

.ORG 0x100       ; Start the main program at address 0x0100
MAIN:   
    ; Initialize Stack Pointer
    LDI R16, HIGH(RAMEND) ; Load high byte of RAMEND (top of stack)
    OUT SPH, R16          ; Set stack pointer high byte
    LDI R16, LOW(RAMEND)  ; Load low byte of RAMEND
    OUT SPL, R16          ; Set stack pointer low byte

    ; Call the subroutine to configure input/output pins
    CALL PIN_SETUP

    ; Enable Pin Change Interrupts on PCINT8 (PC0)
    LDI R16, (1<<PCIE1)  ; Enable Pin Change Interrupts for PCINT[14:8]
    STS PCICR, R16       ; Store in Pin Change Interrupt Control Register

    ; Enable PCINT8 (bit 0 of PCMSK1)
    LDI R16, 0x01        ; Enable only PCINT8 (bit 0 of PCMSK1)
    STS PCMSK1, R16      ; Store in Pin Change Mask Register 1

    SEI                  ; Enable Global Interrupts
    LDI R20, 2           ; Load debounce counter with 2

; Main Loop - Monitors SW0 (PD4) to control LED0 (PB0)
LOOP:  
    SBIC PIND, 4         ; Skip next instruction if SW0 (PD4) is pressed (logic LOW)
    RJMP L_OFF           ; If not pressed, turn off LED0
    RJMP L_ON            ; If pressed, turn on LED0

L_OFF:  
    CBI PORTB, 0         ; Clear bit 0 of PORTB (Turn LED0 OFF)
    RJMP LOOP            ; Repeat loop

L_ON:  
    SBI PORTB, 0         ; Set bit 0 of PORTB (Turn LED0 ON)
    RJMP LOOP            ; Repeat loop

; Subroutine to Configure I/O Pins
PIN_SETUP:  
    SBI DDRB, 0          ; Set PB0 (LED0) as an OUTPUT
    CBI PORTB, 0         ; Ensure LED0 is OFF initially

    SBI DDRB, 1          ; Set PB1 (LED1) as an OUTPUT
    CBI PORTB, 1         ; Ensure LED1 is OFF initially

    CBI DDRD, 4          ; Set PD4 (SW0) as an INPUT
    SBI PORTD, 4         ; Enable pull-up resistor for SW0

    SBI PORTC, 0         ; Enable pull-up resistor for SW1 (PC0)
    RET                  ; Return from subroutine

.ORG 0x200  ; Pin Change Interrupt Service Routine (ISR) at address 0x0200
PCINT8_ISR:  
    DEC R20             ; Decrease debounce counter
    BRNE HERE           ; If not zero, skip LED toggle and exit ISR

    IN R17, PORTB       ; Read PORTB (LED states)
    LDI R18, (1<<1)     ; Load mask for PB1 (LED1)
    EOR R17, R18        ; Toggle PB1 (LED1)
    OUT PORTB, R17      ; Store new LED state back to PORTB

    LDI R20, 2          ; Reset debounce counter
HERE:  
    RETI                ; Return from Interrupt

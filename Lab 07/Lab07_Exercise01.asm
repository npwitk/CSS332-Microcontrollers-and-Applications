.ORG 0x0       ; Set the origin for the reset vector
    JMP MAIN   ; Jump to the main program

.ORG 0x20      ; Interrupt Vector Table for Timer0 Overflow Interrupt
    JMP T0_OV_ISR ; Jump to the Timer0 Overflow Interrupt Service Routine

.ORG 0x100     ; Start of the main program
MAIN:    
    LDI R16, HIGH(RAMEND)  ; Load high byte of RAMEND into R16
    OUT SPH, R16           ; Set the high byte of the stack pointer
    LDI R16, LOW(RAMEND)   ; Load low byte of RAMEND into R16
    OUT SPL, R16           ; Set the low byte of the stack pointer

    CALL PIN_SETUP         ; Call subroutine to set up pins

    LDI R16, (1<<TOIE0)    ; Enable Timer0 overflow interrupt
    STS TIMSK0, R16        ; Store in Timer Interrupt Mask Register
    SEI                    ; Enable global interrupts

    CALL TIMER0_SETUP      ; Call subroutine to set up Timer0
    LDI R21, 200           ; Load 200 into R21 (Counter for 1-second toggling)

LOOP:
    SBIC PIND, 4           ; Skip next instruction if bit 4 of PIND is clear (switch pressed)
    RJMP L_OFF             ; If switch is not pressed, jump to turn LED0 off
    RJMP L_ON              ; Otherwise, turn LED0 on

L_OFF:
    CBI PORTB, 0           ; Clear bit 0 of PORTB (Turn LED0 off)
    RJMP LOOP              ; Loop back

L_ON:
    SBI PORTB, 0           ; Set bit 0 of PORTB (Turn LED0 on)
    RJMP LOOP              ; Loop back

; Subroutine to configure I/O pins
PIN_SETUP:
    SBI DDRB, 0            ; Set PB0 as output (LED0)
    CBI PORTB, 0           ; Ensure LED0 is off initially
    SBI DDRB, 1            ; Set PB1 as output (LED1)
    CBI PORTB, 1           ; Ensure LED1 is off initially
    CBI DDRD, 4            ; Set PD4 as input (Switch)
    SBI PORTD, 4           ; Enable pull-up resistor on PD4
    RET                    ; Return from subroutine

; Subroutine to configure Timer0
TIMER0_SETUP:
    LDI R20, 0xB2          ; Load initial value for Timer0
    OUT TCNT0, R20         ; Set Timer0 initial value
    LDI R20, 0x00          ; Set normal mode (TCCR0A = 0)
    OUT TCCR0A, R20        ; Store in Timer Control Register A
    LDI R20, 0x05          ; Set pre-scaler to 1024 and start Timer0 (TCCR0B = 0x05)
    OUT TCCR0B, R20        ; Store in Timer Control Register B
    RET                    ; Return from subroutine

.ORG 0x200  ; Start of Timer0 Overflow Interrupt Service Routine
T0_OV_ISR:
    DEC R21               ; Decrement overflow counter
    BRNE HERE             ; If not zero, skip the toggling part
    LDI R21, 200          ; Reset counter to 200 (1-second cycle)
    IN R17, PORTB         ; Read current PORTB state
    LDI R18, (1<<1)       ; Load mask for PB1 (LED1)
    EOR R17, R18          ; Toggle PB1 state using XOR
    OUT PORTB, R17        ; Output new state to PORTB

HERE: 
    LDI R18, 0xB2         ; Reload initial Timer0 value
    OUT TCNT0, R18        ; Store in Timer0 counter register
    RETI                  ; Return from interrupt

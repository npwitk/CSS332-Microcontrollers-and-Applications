.ORG 0x0        ; Reset Vector
    JMP MAIN    ; Jump to main program

.ORG 0x04       ; External Interrupt 1 (INT1)
    JMP INT1_ISR

.ORG 0x0A       ; Pin Change Interrupt (PCINT21)
    JMP PCINT21_ISR

.ORG 0x20       ; Timer0 Overflow Interrupt
    JMP T0_OV_ISR

;------------------------------------------------------------
; MAIN PROGRAM
;------------------------------------------------------------
.ORG 0x100
MAIN:
    ; Set up stack pointer
    LDI R16, HIGH(RAMEND)
    OUT SPH, R16
    LDI R16, LOW(RAMEND)
    OUT SPL, R16

    CALL PIN_SETUP   ; Initialize I/O pins

    ; Task 2: Enable External Interrupt INT1 (falling-edge trigger)
    LDI R16, (1<<INT1)
    OUT EIMSK, R16         ; Enable INT1 interrupt
    LDI R16, (1<<ISC11)
    STS EICRA, R16         ; Set falling-edge trigger

    ; Task 3: Enable Pin Change Interrupt (PCINT21 for SW2 on PD5)
    LDI R16, (1<<PCIE2)
    STS PCICR, R16         ; Enable PCINT2 group
    LDI R16, 0x20          ; Enable PCINT21 (bit 5 of PORTD)
    STS PCMSK2, R16        ; Mask PCINT21
    LDI R22, 2             ; Set debounce counter

    ; Task 4: Enable Timer0 Overflow Interrupt
    LDI R16, (1<<TOIE0)
    STS TIMSK0, R16        ; Enable Timer0 overflow interrupt
    SEI                    ; Enable global interrupts
    CALL TIMER0_SETUP      ; Initialize Timer0
    LDI R21, 200           ; Load counter for 1s toggle interval
    SEI                    ; Enable global interrupts

;------------------------------------------------------------
; Task 1: Monitor SW0 and control LED0 in the main loop
;------------------------------------------------------------
LOOP:
    SBIC PIND, 4   ; Skip next instruction if SW0 is NOT pressed
    RJMP L_OFF     ; Jump to turn off LED0 if switch is not pressed
    RJMP L_ON      ; Otherwise, turn on LED0

L_OFF:
    CBI PORTB, 0   ; Clear LED0 (turn off)
    RJMP LOOP

L_ON:
    SBI PORTB, 0   ; Set LED0 (turn on)
    RJMP LOOP

;------------------------------------------------------------
; PIN SETUP
; Initialize input and output pins
;------------------------------------------------------------
PIN_SETUP:
    ; Configure LED pins as outputs (PORTB 0-3)
    SBI DDRB, 0  ; LED0
    CBI PORTB, 0
    SBI DDRB, 1  ; LED1
    CBI PORTB, 1
    SBI DDRB, 2  ; LED2
    CBI PORTB, 2
    SBI DDRB, 3  ; LED3
    CBI PORTB, 3

    ; Configure switch inputs (SW0, SW1, SW2)
    CBI DDRD, 3  ; SW1 (INT1)
    SBI PORTD, 3 ; Enable pull-up for SW1
    CBI DDRD, 4  ; SW0 (polled in loop)
    SBI PORTD, 4 ; Enable pull-up for SW0
    CBI DDRD, 5  ; SW2 (PCINT21)
    SBI PORTD, 5 ; Enable pull-up for SW2
    RET

;------------------------------------------------------------
; TIMER0 SETUP (For Task 4 - LED3 blinking every 1 sec)
;------------------------------------------------------------
TIMER0_SETUP:
    LDI R20, 0xB2          ; Load initial value for Timer0
    OUT TCNT0, R20         ; Set Timer0 initial value
    LDI R20, 0x00          ; Set normal mode (TCCR0A = 0)
    OUT TCCR0A, R20        ; Store in Timer Control Register A
    LDI R20, 0x05          ; Set pre-scaler to 1024 and start Timer0 (TCCR0B = 0x05)
    OUT TCCR0B, R20        ; Store in Timer Control Register B
    RET                    ; Return from subroutine

;------------------------------------------------------------
; INTERRUPT SERVICE ROUTINES
;------------------------------------------------------------

; Task 2: External Interrupt ISR (INT1 - toggles LED1)
.ORG 0x200
INT1_ISR:
    IN R17, PORTB        ; Read PORTB state
    LDI R18, (1<<1)      ; Load mask for LED1
    EOR R17, R18         ; Toggle LED1
    OUT PORTB, R17       ; Write back new state
    RETI                 ; Return from interrupt

; Task 3: Pin Change Interrupt ISR (PCINT21 - toggles LED2)
PCINT21_ISR:
    DEC R22              ; Decrement debounce counter
    BRNE HERE1           ; If not zero, skip toggle
    IN R17, PORTB        ; Read PORTB state
    LDI R18, (1<<2)      ; Load mask for LED2
    EOR R17, R18         ; Toggle LED2
    OUT PORTB, R17       ; Write back new state
    LDI R22, 2           ; Reset debounce counter
HERE1:
    RETI                 ; Return from interrupt

; Task 4: Timer0 Overflow ISR (toggles LED3 every 1 sec)
T0_OV_ISR:
    DEC R21              ; Decrement timer counter
    BRNE HERE2           ; If not zero, skip toggle
    LDI R21, 200         ; Reset counter for next cycle
    IN R17, PORTB        ; Read PORTB state
    LDI R18, (1<<3)      ; Load mask for LED3
    EOR R17, R18         ; Toggle LED3
    OUT PORTB, R17       ; Write back new state
HERE2:
    LDI R18, 0xB2        ; Reload Timer0 with initial value
    OUT TCNT0, R18
    RETI                 ; Return from interrupt

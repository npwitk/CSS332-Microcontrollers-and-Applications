; 16-bit Addition with Carry

.ORG 0x00                     ; Start at address 0x00

    ; Load first number (0x2AF7) into R23:R22
    LDI R22, 0xF7             ; Load low byte of first number
    LDI R23, 0x2A             ; Load high byte of first number
    
    ; Load second number (0x3E85) into R25:R24
    LDI R24, 0x85             ; Load low byte of second number
    LDI R25, 0x3E             ; Load high byte of second number
    
    ; Perform 16-bit addition
    ADD R22, R24              ; Add low bytes
    ADC R23, R25              ; Add high bytes with carry
    
    ; Store result in R27:R26
    MOV R26, R22              ; Move low byte of result to R26
    MOV R27, R23              ; Move high byte of result to R27
    
    ; At this point, R27:R26 = 0x697C (the sum of 0x2AF7 and 0x3E85)

HERE: RJMP HERE               ; Infinite loop to end program
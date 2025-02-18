START:  
    .ORG 0
	
    LDI R20, 1      ; Load first odd number (1) into R20  
    LDI R21, 9      ; Load the upper limit (9) into R21  
    LDI R22, 2      ; Load increment value (2) into R22  
    STS 0x02B5, R20

.ORG 80
LOOP:  
    CP R20, R21     ; Compare R20 with upper limit (9)  
    BREQ END        ; If equal, jump to END (infinite loop)  
    ADD R20, R22    ; Increment to the next odd number 
    STS 0x02B5, R20 ; Store the current odd number in memory address 0x02B5  
    
    CALL DELAY      ; Call 10 ms delay subroutine  
    JMP LOOP        ; Repeat loop  

.ORG 100
DELAY:  
    LDI R16, 128    ; Load outer loop counter  
AGAIN:  
    LDI R17, 161    ; Load inner loop counter  
HERE:  
    NOP             ; No operation (waste time)  
    NOP             ; No operation  
    DEC R17         ; Decrement inner loop counter  
    BRNE HERE       ; If R17 is not zero, repeat inner loop  
    DEC R16         ; Decrement outer loop counter  
    BRNE AGAIN      ; If R16 is not zero, repeat outer loop  
    RET             ; Return from subroutine  

END:  
    RJMP END        ; Infinite loop to stop execution

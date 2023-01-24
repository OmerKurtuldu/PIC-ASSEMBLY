    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec
    
    ; Reset vector
    org 0x00
    ; ---------- Initialization ---------------------------------
    BSF	STATUS, RP0	    ; select BANK1
    CLRF	TRISA	    ; Set all pins of PORTA as output
    CLRF	TRISD	    ; Set all pins of PORTD as output
    BCF	STATUS, RP0	    ; select Bank0
    CLRF	PORTD	    ; Turn off all LEDs connected to PORTD
    CLRF	PORTA	    ; Turn off all LEDs connected to PORTA
    

    ; ---------- Your code starts here --------------------------


NO_ITERATIONS	    EQU		0x20
digit0		    EQU		0x21
digit1		    EQU		0x22
I		    EQU		0x23
    CLRF digit0		    ;digit0 = 0
    CLRF digit1		    ;digit1 = 0
    
    MOVLW   d'90'
    MOVWF   NO_ITERATIONS

    
ENDLESS_WHILE_LOOP:
loop_begin:
   MOVF	NO_ITERATIONS, W	    ; WREG = NO_ITERATIONS
	SUBWF	I, W		    ; WREG = I - WREG
	BTFSC	STATUS, C	    ; If I<NO_ITERATIONS, then C must be NOT set
	GOTO loop_end

loop_body:
      
    ; for first digit
    BSF	    PORTA, 5	; Select second
    BCF	    PORTA, 4	; first SSD is not selected
    
    MOVFW   digit0	; WREG = digit0
    CALL    GetCode
    
    MOVWF   PORTD	; display the first digit
    CALL    Delay5ms	; delay function
    
    ; for second digit

    BSF	    PORTA, 4	; select first
    BCF	    PORTA, 5	; second SSD is not selected
    
    MOVFW   digit1	; WREG = digit1
    CALL    GetCode	; get the code for digit1
    
    MOVWF   PORTD	; display the second digit
    CALL    Delay5ms	; 5 millisecond delay
    INCF    I, F	; I++
    GOTO loop_begin


loop_end:
    
    CLRF    I
    INCF    digit0, F	; digit0++
    
    ; if (digit0 == 10)
    MOVLW   d'10'
    SUBWF   digit0, W	; WREG = digit0 - 10
    BTFSC   STATUS, Z	; skip next if digit0 - 10 != 0
    CALL    FIRST_IF_BLOCK
    
    ; if(digit1 == 2 and digit0 == 1)
    ; if(digit1 == 2)
    MOVLW   d'2'
    SUBWF   digit1, W	; WREG = digit1 - 2
    BTFSS   STATUS, Z	; skip digit1 != 2
    GOTO    ENDLESS_WHILE_LOOP	; short circuit evaluation
    
    ; if(digit0 == 1)
    MOVLW   d'1'
    SUBWF   digit0, W	; WREG = digit0- 1
    BTFSC   STATUS, Z	; skip  digit0  != 1
    CALL    SECOND_IF_BLOCK
    
    GOTO    ENDLESS_WHILE_LOOP

SECOND_IF_BLOCK:
    CLRF    digit0	; digit0 = 0
    CLRF    digit1	; digit1 = 0
    RETURN
      
FIRST_IF_BLOCK:
    CLRF    digit0	; digit0 = 0
    INCF    digit1, F	; digit1++
    RETURN
  
GetCode:
    ADDWF   PCL, F		; Jump to the correct number. PCL is the program counter register
    RETLW   B'00111111'		; 0
    RETLW   B'00000110'		; 1
    RETLW   B'01011011'		; 2
    RETLW   B'01001111'		; 3
    RETLW   B'01100110'		; 4
    RETLW   B'01101101'		; 5
    RETLW   B'01111101'		; 6
    RETLW   B'00000111'		; 7
    RETLW   B'01111111'		; 8
    RETLW   B'01101111'		; 9    
    

Delay5ms:
j	EQU	    0x70		    ; Use memory slot 0x70
k	EQU	    0x71		    ; Use memory slot 0x71
    MOVLW	    d'5'		    ; 
    MOVWF	    j			    ; j = 250
Delay5ms_OuterLoop
    MOVLW	    d'250'
    MOVWF	    k			    ; k = 250
Delay5ms_InnerLoop	
    NOP
    DECFSZ	    k, F		    ; k--
    GOTO	    Delay5ms_InnerLoop

    DECFSZ	    j, F		    ; j?
    GOTO	    Delay5ms_OuterLoop
    RETURN
    
    
    ; ---------- Your code ends here ----------------------------    

LOOP    GOTO $	; Infinite loop
     END  



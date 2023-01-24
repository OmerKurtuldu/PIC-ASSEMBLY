LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec
    
    org 0x00

    BSF     STATUS, RP0	; Select Bank1
    MOVLW   0XFF
    MOVWF   TRISB	; Set all pins of PORTB as input
    
    CLRF    TRISD	; Set all pins of PORTD as output
    CLRF    TRISA	; Set all pins of PORTA as output

    BCF     STATUS, RP0	; Select Bank0    
    CLRF    PORTA	; Turn off all LEDs connected to PORTA
    CLRF    PORTD	; Turn off all LEDs connected to PORTD
    BSF	    PORTA, 5	; Select the first SSD (DISP4)
    
COUNTER EQU 0X20
    CLRF    COUNTER

WHILE_BEGIN
    
    BTFSC   PORTB, 3
    GOTO    ELSEIF1
BTN3
    MOVLW   d'9'
    SUBWF   COUNTER, W
    BTFSS   STATUS, Z
    GOTO    BTN3_ELSE
    
    CLRF    COUNTER
    GOTO    CONTINUE

BTN3_ELSE
    INCF    COUNTER, F
    GOTO    CONTINUE
 
ELSEIF1
    BTFSC   PORTB, 4
    GOTO    ELSEIF2
BTN4
    MOVFW   COUNTER
    BTFSS   STATUS, Z
    GOTO    BTN4_ELSE
    
    MOVLW   d'9'
    MOVWF   COUNTER
    GOTO    CONTINUE

    
BTN4_ELSE
    DECF    COUNTER, F
    GOTO    CONTINUE
    
ELSEIF2
    BTFSC   PORTB, 5
    GOTO    CONTINUE
    
    BTN5
    CLRF    COUNTER
    
CONTINUE
    MOVFW   COUNTER	
    CALL    GetCode	
    MOVWF   PORTD
    CALL Delay100ms
    GOTO WHILE_BEGIN
    
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
    
    
Delay100ms:
i	EQU	    0x70		    ; Use memory slot 0x70
j	EQU	    0x71		    ; Use memory slot 0x71
	MOVLW	    d'100'		    ; 
	MOVWF	    i			    ; i = 100
Delay100ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    j			    ; j = 250
Delay100ms_InnerLoop	
	NOP
	DECFSZ	    j, F		    ; j--
	GOTO	    Delay100ms_InnerLoop

	DECFSZ	    i, F		    ; i?
	GOTO	    Delay100ms_OuterLoop    
	RETURN
    
END



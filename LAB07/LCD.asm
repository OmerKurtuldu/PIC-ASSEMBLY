    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec
    
    ; Reset vector
    org 0x00
    GOTO MAIN
    #include <Delay.inc>	; Delay library (Copy the contents here)
    #include <LcdLib.inc>	; LcdLib.inc (LCD) utility routines
    
    
    ; ---------- Your code starts here --------------------------
MAIN:
    
    BSF	STATUS, RP0	    ; select BANK1
    CLRF	TRISA	    ; Set all pins of PORTA as output
    CLRF	TRISD	    ; Set all pins of PORTD as output

    CLRF	TRISE	    ; Set all pins of PORTE as output


    
    MOVLW	0x03
    MOVWF	ADCON1
    
    BCF	STATUS, RP0	    ; select Bank0
    
    
    
    
    CALL    LCD_Initialize
    
    CLRF	PORTD	    ; Turn off all LEDs connected to PORTD
    CLRF	PORTA	    ; Turn off all LEDs connected to PORTA

NO_ITERATIONS	    EQU		0x20
digit0		    EQU		0x21
digit1		    EQU		0x22
I		    EQU		0x23
message		    EQU		0x24

    CLRF digit0		    ;digit0 = 0
    CLRF digit1		    ;digit1 = 0
    CLRF message	    ;message = 0

    
    MOVLW   d'90'
    MOVWF   NO_ITERATIONS

    
ENDLESS_WHILE_LOOP:
    BCF	    PORTA, 5	; 
    BCF	    PORTA, 4	;
    CALL    DisplayCounter1
    CALL    LCD_MoveCursor2SecondLine   ; Move the cursor to the start of the second line
    CALL    DisplayCounter2

    
loop_begin:
    
    

   MOVF	NO_ITERATIONS, W	    ; WREG = NO_ITERATIONS
	SUBWF	I, W		    ; WREG = I - WREG
	BTFSC	STATUS, C	    ; If I<NO_ITERATIONS, then C must be NOT set
	GOTO loop_end

loop_body:
      
    BSF	    PORTA, 5	
    BCF	    PORTA, 4	
    
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
    MOVLW   d'1'
    MOVWF   message
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
    
    
DisplayCounter1
	call	LCD_Clear		; Clear the LCD screen

	movlw	'C'	
	call	LCD_Send_Char
	movlw	'O'	
	call	LCD_Send_Char
	movlw	'U'	
	call	LCD_Send_Char
	movlw	'N'	
	call	LCD_Send_Char
	movlw	'T'	
	call	LCD_Send_Char
	movlw	'E'	
	call	LCD_Send_Char
	movlw	'R'	
	call	LCD_Send_Char
	movlw	' '	
	call	LCD_Send_Char
	movlw	'V'	
	call	LCD_Send_Char
	movlw	'A'	
	call	LCD_Send_Char
	movlw	'L'	
	call	LCD_Send_Char
	movlw	':'	
	call	LCD_Send_Char
	movlw	' '	
	call	LCD_Send_Char

	; Print digit2: MSB
	MOVF	digit1, W ; WREG <- digit
	ADDLW	'0'	    ; Add '0' to the digit 
	CALL	LCD_Send_Char
	
	; Print digit1: digits[2]
	MOVF	digit0, W ; WREG <- digit
	ADDLW	'0'	    ; Add '0' to the digit 
	CALL	LCD_Send_Char
	
		
	; The rest of the characters will get displayed on the second line
	
	
	
	RETURN
	
DisplayCounter2
	; The rest of the characters will get displayed on the second line
	MOVFW	message
	BTFSS	STATUS, Z
	GOTO	ROLLED0
	
	movlw	'C'	    
	call	LCD_Send_Char

	movlw	'O'	    
	call	LCD_Send_Char

	movlw	'U'	    
	call	LCD_Send_Char
	
	movlw	'N'	    
	call	LCD_Send_Char
	
	movlw	'T'	    
	call	LCD_Send_Char

	movlw	'I'	
	call	LCD_Send_Char

	movlw	'N'	
	call	LCD_Send_Char

	movlw	'G'	
	call	LCD_Send_Char
	
	movlw	' '	
	call	LCD_Send_Char

	movlw	'U'	
	call	LCD_Send_Char

	movlw	'P'	
	call	LCD_Send_Char

	movlw	'.'	
	call	LCD_Send_Char

	movlw	'.'	
	call	LCD_Send_Char
	
	movlw	'.'	
	call	LCD_Send_Char
	
	RETURN

	
ROLLED0
	movlw	'R'	    
	call	LCD_Send_Char

	movlw	'o'	    
	call	LCD_Send_Char

	movlw	'l'	    
	call	LCD_Send_Char
	
	movlw	'l'	    
	call	LCD_Send_Char
	
	movlw	'e'	    
	call	LCD_Send_Char
	
	movlw	'd'	    
	call	LCD_Send_Char

	movlw	' '	
	call	LCD_Send_Char

	movlw	'o'	
	call	LCD_Send_Char

	movlw	'v'	
	call	LCD_Send_Char
	
	movlw	'e'	
	call	LCD_Send_Char

	movlw	'r'	
	call	LCD_Send_Char

	movlw	' '	
	call	LCD_Send_Char

	movlw	't'	
	call	LCD_Send_Char

	movlw	'o'	
	call	LCD_Send_Char
	
	movlw	' '	
	call	LCD_Send_Char
	
	movlw	'0'	
	call	LCD_Send_Char
	
	CLRF	message;
	
	RETURN
    
    ; ---------- Your code ends here ----------------------------    

LOOP    GOTO $	; Infinite loop
     END  



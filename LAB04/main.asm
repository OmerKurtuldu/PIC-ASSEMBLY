    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec
    
    org 0x00

    BSF     STATUS, RP0	; Select Bank1
    BSF	    TRISB, 3
    CLRF    TRISD	; Set all pins of PORTD as output
    BCF     STATUS, RP0	; Select Bank0    
    CLRF    PORTB	; Turn off all LEDs connected to PORTB
    CLRF    PORTD	; Turn off all LEDs connected to PORTD
; Global variable declarations
X	EQU	0x20	; X
Y	EQU	0x21	; Y
N	EQU	0X22	
sum	EQU	0X23
A	EQU     0X24

	
 
    MOVLW   d'112'	; WREG = 7
    MOVWF   X		; X = WREG

    MOVLW   d'100'	; WREG = 11
    MOVWF   Y		; Y = WREG

    MOVLW   d'125'	; WREG = 23
    MOVWF   N		; N= WREG
    
    CALL    GenerateNumbers	; Compute R = X * Y
    CALL    AddNumbers
    CALL    DisplayNumbers
    
    GOTO    $		; Infinite loop

GenerateNumbers
COUNT2	EQU  0X73
TEMP	EQU  0X74

    CLRF COUNT2
    MOVLW A		; WREG = &A[0]
    MOVWF FSR		; FSR = &A[0]

    
GNLOOP_CHECK
    MOVF N, W
    SUBWF X, W	    ;W=X-N
    BTFSS STATUS, C
    GOTO  GNLOOP_INSIDE
    
    MOVF N, W
    SUBWF Y, W	    ;W=Y-N
    BTFSS STATUS, C
    GOTO  GNLOOP_INSIDE
    
    MOVF COUNT2, W
    RETURN
    
GNLOOP_INSIDE
    MOVF X, W
    ADDWF Y, W	    ;W=X+Y
    MOVWF TEMP
    RRF TEMP, W
    BTFSS STATUS, C
    GOTO GN_ELSE
GN_IF
    CALL Mult8x8 
    MOVWF INDF	    ;A[COUNT2]=Muly8x8(x, y)
    INCF FSR, F
    INCF COUNT2, F
    INCF X, F   
    GOTO GNLOOP_CHECK
    
    
    
GN_ELSE
    CALL Divide
    MOVF Q, W
    MOVWF INDF	    ;A[COUNT2]=TEMP/3
    INCF FSR, F
    INCF COUNT2, F
    MOVLW d'3'
    ADDWF Y, F	    ;Y=Y+3
    GOTO GNLOOP_CHECK

    

Mult8x8
COUNT	EQU	0x70	;
R_L	EQU	0x71	; Low byte of the result
R_H	EQU	0x72	; High byte of the result. R = X * Y
	
    CLRF    COUNT	; COUNT = 0
    BSF	    COUNT, 3	; COUNT = 8  
    CLRF    R_H		; R_H = 0
    MOVFW   Y		; WREG = Y (Multiplier)
    MOVWF   R_L		; R_L = WREG
    MOVFW   X		; WREG = X (Multiplicant)
    RRF	    R_L, F	; R_L = R_L >> 1
    
Mult8x8_Loop
    BTFSC   STATUS, C	; Is the least significant bit of Y equal to 1?
    ADDWF   R_H, F	; R_H = R_H + WREG
    RRF	    R_H, F	; R_H = R_H >> 1
    RRF	    R_L, F	; R_L = R_L >> 1
    
    DECFSZ  COUNT	; COUNT = COUNT-1       
    GOTO    Mult8x8_Loop
    MOVF    R_L, W
    ADDWF   R_L, W	;W=2*R_L
    ADDWF   R_H, W	;W=2*R_L+R_H
    RETURN		; DONE
 
    
    
Divide
Q	 EQU	    0x75	
TEMP_XY  EQU	    0X76
    
    MOVF    X, W
    ADDWF   Y, W
    MOVWF   TEMP_XY		;TEMP_XY=X+Y
    CLRF    Q			; Q = 0    
    
Divide_Loop
    MOVLW    d'3'		; WREG = 3
    SUBWF   TEMP_XY, W		; WREG = TEMP_XY - 3
    BTFSS   STATUS, C		; Was the result of the previous subtraction less than 0?	
    GOTO    Division_End	; If (TEMP_XY < 3) we are done.
    
    ; If we are here, it means that TEMP_X >= 3
    INCF    Q, F		; Q++
    MOVWF   TEMP_XY		; TEMP_XY = WREG
    GOTO    Divide_Loop
    
Division_End
    
    RETURN
    
    
AddNumbers
    
    
    CLRF    sum		;sum = 0
    MOVLW   A		;WREG = &A
    MOVWF   FSR		;FSR = &A
    
ANloop_begin
    
    MOVF    INDF,W	;WREG = FSR
    ADDWF   sum , F	;sum = sum +fsr
    
    INCF    FSR,F	;FSR = FSR+1
    DECFSZ  COUNT2,F	;count = count-1
    GOTO ANloop_begin
    RETURN

    
Delay250ms
j EQU 0x76		    ; Use memory slot 0x70
k EQU 0x77		    ; Use memory slot 0x71
    MOVLW	    d'250'		    ; 
    MOVWF	    j			    ; j = 250
Delay250ms_OuterLoop
    MOVLW	    d'250'
    MOVWF	    k			    ; k = 250
Delay250ms_InnerLoop	
    NOP
    DECFSZ	    k, F		    ; k--
    GOTO	    Delay250ms_InnerLoop

    DECFSZ	    j, F		    ; j?
    GOTO	    Delay250ms_OuterLoop
    RETURN

DisplayNumbers
i EQU 0X78    
    BSF	    STATUS, RP0	    ;BANK1
    BSF	    TRISB, 3	    ;ALL pins input 
    CLRF    TRISD	    ;all pins output
    BCF	    STATUS, RP0	    ;select bank 0
    CLRF    PORTD	    ;Turn off all LEDs connected to PORTD
    
    MOVLW   A		    ;WREG= &a
    MOVWF   FSR		    ;
    
    MOVFW   sum		    ;WREG = sum
    MOVWF   PORTD	    ;PORTD =sum
     
    CLRF    i		    ;i=0
    
DNloop_begin
    BTFSC   PORTB, RB3
    GOTO    DNloop_begin	
    MOVF    INDF,W	;WREG = A[i]
    MOVWF   PORTD	;PORTD =a[i]
    CALL    Delay250ms
    INCF    i,F		;i=+1;
    INCF    FSR,F	;FSR= FSR+1
    
    MOVLW   d'5'	;WREG = 5
    SUBWF   i,W		;wreg = i- 5
    BTFSS   STATUS,C	;if i<5 next
    GOTO    DNloop_begin
    
    END			; End of the program
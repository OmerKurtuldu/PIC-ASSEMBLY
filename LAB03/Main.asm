LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec

    ; Reset vector
    org 0x00
    ; ---------- Initialization ---------------------------------
    BSF     STATUS, RP0	; Select Bank1
    ;CLRF    TRISB	; Set all pins of PORTB as output
    BSF TRISB, 3
    CLRF    TRISD	; Set all pins of PORTD as output
    BCF     STATUS, RP0	; Select Bank0    
    CLRF    PORTB	; Turn off all LEDs connected to PORTB
    CLRF    PORTD	; Turn off all LEDs connected to PORTD
   
    
    ; ---------- Your code starts here --------------------------
    
;BANKSEL TRISB       ; Select the Bank where TRISB is located (Bank 1)
;TRISB = 0xFF            ; Make all pins of PORTB as input pins
;TRISD = 0x00           ; Make all pins of PORTD as output pins

;BANKSEL PORTD      ; Select the Bank where PORTB is located (Bank 0)
;CLRF        PORTD      ; Turn off all LEDs
;
 ;   uint8_t zib0 = 1;
  ;  uint8_t zib1 = 2;
   ; uint8_t zib;
    ;uint8_t i = 2;
    ;int N = 13;
    ;for (i = 2; i <= N; i++) {
     ;   zib = (zib1 & 0x3f) + (zib0 | 0x05);
     ;   zib0 = zib1;
     ;   zib1 = zib;

      ;  PORTD = zib;                           ; Display the current Zibonacci number on the LEDs
      ;  DelayMs(250)                         ; Wait for 250ms
       ; while (PORTB3 == 1) ;           ; Wait for Button3 (RB3) to be pressed
;} //end-for
;while (1);                                        ; Infinite loop

    
    zib0 EQU 0x20
    zib1 EQU 0x21
    zib  EQU 0x22
    N	 EQU 0x23
    i	 EQU 0x24
	 
	 
    MOVLW d'1'	    ;wreg = 1
    MOVWF zib0	    ;zib0 = 1
    
    MOVLW d'2'	    ;wreg = 2
    MOVWF zib1	    ;zib1 = 2
    
    MOVLW d'2'	    ;wreg = 2
    MOVWF i	    ;i = 2
    
    MOVLW d'13'	    ;wreg = 13
    MOVWF N	    ;N = 13
    
    
    loop_begin:
	MOVF i,W    ;wreg = i
	SUBWF N,W   ;wreg = n-i
	BTFSS	STATUS, C   ;If there is carry then i <= N 
			    ;so we continue executing the loop
	GOTO loop_end
    loop_body:
	
	MOVF	zib1, W	;WREG = ZIB1
	ANDLW	0x3f	;WREG = ZIB1 OR 0x3f
	MOVWF	zib	;zib=ZIB1 AND 0x3f
	
	MOVF    zib0, W	;WREG = ZIB0
	IORLW   0x05	;wreg = zib0 or 0x05
	ADDWF	zib,F	;zib=(ZIB0 OR Ox05) + (zib1 & 0x3f)
	
	MOVF	zib1,W	;WREG = zib1
	MOVWF	zib0	;ZIB0=ZIB1
	MOVF	zib, W	;WREG = ZIB
	MOVWF	zib1	;zib1=zib
	
	INCF	i,F	;i = i+1
	MOVWF	PORTD   ;PORTD=ZIB

	CALL Delay250ms	;wait(250ms)
    Check_RB3:
	BTFSC	PORTB, 3
	GOTO Check_RB3
	
	GOTO loop_begin
	
    Delay250ms:
	j	EQU	    0x70		    ; Use memory slot 0x70
	k	EQU	    0x71		    ; Use memory slot 0x71
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
	
    loop_end
 
	GOTO	$ 
	END
			    
                             

    
    



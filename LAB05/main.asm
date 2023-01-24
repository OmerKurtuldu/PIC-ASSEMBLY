    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec
    
    org 0x00

    BSF     STATUS, RP0	; Select Bank1
    CLRF    TRISB	; Set all pins of PORTB as output
    CLRF    TRISD	; Set all pins of PORTD as output
    BCF     STATUS, RP0	; Select Bank0    
    CLRF    PORTB	; Turn off all LEDs connected to PORTB
    CLRF    PORTD	; Turn off all LEDs connected to PORTD

MOVE_LEFT EQU 0X20
MOVE_RIGHT EQU 0X21
DIR EQU 0X23
VAL EQU 0X24
COUNT EQU 0X25
    
    MOVLW   0x1
    MOVWF   MOVE_RIGHT
    MOVWF   VAL
    CLRF    MOVE_LEFT
    CLRF    COUNT

    
MAIN_LOOP
    MOVF    VAL, W
    MOVWF   PORTD
    CALL    DELAY
    
    INCF    COUNT, F
    MOVF    COUNT, W
    SUBLW   d'15'
    BTFSS   STATUS, Z
    GOTO    NOT_A_TOUR
TOUR
    CLRF    PORTD
    CALL    DELAY
    COMF    PORTD, F
    CALL    DELAY
    CLRF    PORTD
    CALL    DELAY
    COMF    PORTD, F
    CALL    DELAY
    CLRF    PORTD
    CALL    DELAY
    MOVLW   0x1
    MOVWF   VAL
    CLRF    COUNT
    MOVF    MOVE_LEFT, W
    MOVWF   DIR
    GOTO    MAIN_LOOP
    
    
    
NOT_A_TOUR
    MOVLW   0x80
    SUBWF   VAL, W
    BTFSS   STATUS, Z
    GOTO    DONT_CHANGE_DIRECTION

CHANGE_DIRECTION
    MOVF    MOVE_RIGHT, W
    MOVWF   DIR
    
DONT_CHANGE_DIRECTION
    MOVF    MOVE_LEFT, W
    SUBWF   DIR, W
    BTFSS   STATUS, Z
    GOTO    MOVING_RIGHT
    
MOVING_LEFT
    CLRF    STATUS
    RLF	    VAL, F
    CLRF    STATUS
    GOTO    MAIN_LOOP
    
MOVING_RIGHT
    CLRF    STATUS
    RRF	    VAL, F
    CLRF    STATUS
    GOTO    MAIN_LOOP

    
DELAY:
    CALL    Delay250ms;
    ;CALL    Delay500ms;
    RETURN

Delay500ms:
i	EQU	    0x70
j	EQU	    0x71
k	EQU	    0x72
	MOVLW	    d'2'
	MOVWF	    i			    ; i = 2
Delay500ms_Loop1_Begin
	MOVLW	    d'250'
	MOVWF	    j			    ; j = 250
Delay500ms_Loop2_Begin	
	MOVLW	    d'250'
	MOVWF	    k			    ; k = 250
Delay500ms_Loop3_Begin	
	NOP				    ; Do nothing
	DECFSZ	    k, F		    ; k--
	GOTO	    Delay500ms_Loop3_Begin

	DECFSZ	    j, F		    ; j--
	GOTO	    Delay500ms_Loop2_Begin

	DECFSZ	    i, F		    ; i?
	GOTO	    Delay500ms_Loop1_Begin    
	RETURN
    
    

    
Delay250ms:
l EQU 0x76		    ; Use memory slot 0x70
m EQU 0x77		    ; Use memory slot 0x71
    MOVLW	    d'250'		    ; 
    MOVWF	    l			    ; l = 250
Delay250ms_OuterLoop
    MOVLW	    d'250'
    MOVWF	    m			    ; m = 250
Delay250ms_InnerLoop	
    NOP
    DECFSZ	    m, F		    ; m--
    GOTO	    Delay250ms_InnerLoop

    DECFSZ	    l, F		    ; l?
    GOTO	    Delay250ms_OuterLoop
    RETURN
    
    END



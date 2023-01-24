    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF
    radix	dec

    ; Reset vector
    org 0x00
    ; ---------- Initialization ---------------------------------
    BSF     STATUS, RP0	; Select Bank1
    CLRF    TRISB	; Set all pins of PORTB as output
    CLRF    TRISD	; Set all pins of PORTD as output
    BCF     STATUS, RP0	; Select Bank0    
    CLRF    PORTB	; Turn off all LEDs connected to PORTB
    CLRF    PORTD	; Turn off all LEDs connected to PORTD
    
    ; ---------- Your code starts here --------------------------
    
x EQU 0x20
y EQU 0x21
box EQU 0x22
 

    MOVLW d'10'	
    MOVWF x	
    
    
    MOVLW d'11'	
    MOVWF y	 
    
    ;if (x < 0 || x > 11 || y < 0 || y > 10) box = -1
    ;x<0
    BTFSS x, 7	;is negative?
    GOTO CHECK_IF_X_GT_11_LABEL

IF_LABEL1
    MOVLW -d'1'	
    MOVWF box		
    GOTO TERMINATE
    
    
CHECK_IF_X_GT_11_LABEL
    ;x>11
    MOVF x, W
    SUBLW d'11'	    ;W=11-X
    BTFSS STATUS, C
    GOTO IF_LABEL1
    
CHECK_IF_Y_NEGATIVE_LABEL
    ;y<0
    BTFSC y, 7
    GOTO IF_LABEL1
    
CHECK_IF_Y_GT_10_LABEL
    ;y>10
    MOVF y, W
    SUBLW d'10'	    ;W=10-Y
    BTFSS STATUS, C
    GOTO IF_LABEL1
    

    ;else if (x <= 3){
	;if (y <= 1)	    box = 3;
	;else if (y <= 4)    box = 2;
	;else		    box = 1;
    ;}
    
    ;x<=3
    MOVF x, W
    SUBLW d'3'	    ;W=3-x
    BTFSS STATUS, C
    GOTO ELSE_IF_X_LT_7_LABEL
    
    
    
Y_0_1
    ;if (y <= 1)
    MOVF y, W
    SUBLW d'1'	    ;W=1-y
    BTFSS STATUS, Z
    GOTO Y_1_4
    
    MOVLW d'3'
    MOVWF box
    GOTO TERMINATE
    
Y_1_4
    ;y<=4
    MOVF y, W
    SUBLW d'4'	    ;W=4-y
    BTFSS STATUS, C
    GOTO Y_4_10

    MOVLW d'2'
    MOVWF box
    GOTO TERMINATE

Y_4_10
    
    MOVLW d'1'
    MOVWF box
    GOTO TERMINATE   
    
    
ELSE_IF_X_LT_7_LABEL
    ;else if (x <= 7){
	;if (y <= 5)	box=5;
	;else		box=4;
    ;}
    
    ;x<=7
    MOVF x, W
    SUBLW d'7'	    ;W=7-x
    BTFSS STATUS, C
    GOTO ELSE_X_GT_7_LABEL
    
    
    ;y<=5
    MOVF y, W
    SUBLW d'5'	    ;W=5-y
    BTFSS STATUS, C
    GOTO BOX4_LABEL

    MOVLW d'5'
    MOVWF box
    GOTO TERMINATE
    

BOX4_LABEL
    
    MOVLW d'4'
    MOVWF box
    GOTO TERMINATE  
    
    
    
    ELSE_X_GT_7_LABEL
    ;else {
	;if (y<=2)	    box=9;
	;else if (y<=6)	    box=8;
	;else if (y<=8)	    box=7;
	;else		    box=6;
    ;}
    
    ;y<=2
    MOVF y, W
    SUBLW d'2'	    ;W=2-y
    BTFSS STATUS, C
    GOTO BOX8_LABEL

    MOVLW d'9'
    MOVWF box
    GOTO TERMINATE
    
BOX8_LABEL
    ;y<=6
    MOVF y, W
    SUBLW d'6'	    ;W=6-y
    BTFSS STATUS, C
    GOTO BOX7_LABEL

    MOVLW d'8'
    MOVWF box
    GOTO TERMINATE    
    
    
BOX7_LABEL
    ;y<=8
    MOVF y, W
    SUBLW d'8'	    ;W=8-y
    BTFSS STATUS, C
    GOTO BOX6_LABEL

    MOVLW d'7'
    MOVWF box
    GOTO TERMINATE
    
BOX6_LABEL
   
    MOVLW d'6'
    MOVWF box
    
    
TERMINATE    
    
    MOVF box, W
    MOVWF PORTD
    GOTO $
	
    END

    
    


    
    
    
    
    
    
    
    
    
    
    
    
    
TERMINATE
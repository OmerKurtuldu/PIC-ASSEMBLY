    ;ÖMER KURTULDU 152120191007
    ;YUSUF AKTA? 152120191032
    
    
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
z EQU 0x22
r1 EQU 0x23
r2 EQU 0x24
r3 EQU 0x25
r4 EQU 0x26
r EQU 0x27
g EQU 0x28

 

;x = 5;
;y = 6;
;z = 7;
;r1 = (5 * x - 2 * y + z - 3);17    
;r2 = (x + 5) * 4 - 3 * y + z;29
;r3 = x / 2 + y / 2 + z / 4;6
;r4 = (3 * x - y - 3 * z) * 2 - 30;-54
;r = 3 * r1 + 2 * r2 - r3 / 2 - r4;
    
    MOVLW d'5'	    ;W=5
    MOVWF x	    ;x=W=5

    MOVLW d'6' 
    MOVWF y	   

    MOVLW d'7' 
    MOVWF z
 
    ;r1 = (5 * x - 2 * y + z - 3);

    MOVF x, W
    MOVWF r1	    ;r1=x
 
    RLF r1, F	    ;r1=2x
    RLF r1, F	    ;r1=4x
    ADDWF r1, F	    ;r1=4x+x
    
    MOVF y, W	    ;W=y
    ADDWF y,W	    ;W=2y
    
    SUBWF r1, F	    ;r1=5x-2y
    
    MOVF z, W	    ;W=z
    ADDWF r1, F	    ;r1=5x-2y+z
    
    MOVLW d'3'
    SUBWF r1, F	    ;r1=5x-2y+z-3
    ;r1
    ;---------------------------------------------------------------------------
    ;r2 = (x + 5) * 4 - 3 * y + z;
    
    MOVF x, W	    ;W=x
    MOVWF r2	    ;r2=x
    
    MOVLW d'5'	    ;W=5
    ADDWF r2, F	    ;r2=x+5
    
    RLF r2, F	    ;r2=(x+5)*2
    RLF r2, F	    ;r2=(x+5)*4
    
    RLF y, W	    ;W=2y
    ADDWF y, W	    ;W=2y+y
    
    SUBWF r2, F	    ;r2=(x+5)*4-3y
    
    MOVF z, W	    ;W=z
    ADDWF r2, F	    ;r2=(x+5)*4-3y+z
    ;r2 end
    ;---------------------------------------------------------------------------
    ;r3 = x / 2 + y / 2 + z / 4;
    
    MOVF z , W	    ;W =z
    MOVWF r3	    ; r3 = z;    
    RRF r3 , F	    ; r3 = z/2
    CLRC	    ;clear carry bit
    RRF r3 , F	    ; r3 = z/4
    CLRC	    ;clear carry bit

    RRF y, W	    ;W=y/2
    CLRC
    ADDWF r3, F	    ;r3 = y/2 + z/4
    
    RRF x, W
    ADDWF r3, F	    ;r3 = x/2 + y/2 + z/4
    ; r3 end
    ;---------------------------------------------------------------------------
    ;r4 = (3 * x - y - 3 * z) * 2 - 30;
    
    RLF x , W	    ;W = 2x
    ADDWF x , W    ;r4 = 3X
    MOVWF r4
    
    RLF z , W	    ;W = 2z
    ADDWF z, W	    ; W = 3z
    SUBWF r4, F	    ;r4 = 3*x - 3*z
    
    MOVF y, W	    ;W = y  
    SUBWF r4 , F    ;W = (3*x-y-3z)
    
    CLRC
    RLF r4, F	    ;r4 = (3*x-y-3z)*2
    CLRC

    MOVLW d'30'	    ; W = 30
    SUBWF r4 ,F	    ;r4 = (3*x-y-3z)*2 - 30
    
    
    ;r4 end
    ;---------------------------------------------------------------------------
    ;r = 3 * r1 + 2 * r2 - r3 / 2 - r4;
    
    MOVF r1 , W	    ;W = r1
    ADDWF r1 ,W   ;r = 2*r1
    ADDWF r1 ,W	    ;r = 3*r1
    MOVWF r
    
    RLF r2 ,W	    ;W = r*2
    ADDWF r , F	    ;W =3*r1+2*r2
    
    RRF r3,W	    ;W = r3/2
    SUBWF r, F	    ;r = 3*r1 + 2*r2 - r3/2
    
    MOVF r4 ,W	    ;W=r4
    
    SUBWF r, F	    ;r = 3 * r1 + 2 * r2 - r3 / 2 - r4;
    
    MOVF r ,W
    MOVWF PORTD
    
   
    
LOOP    GOTO    $	; Infinite loop
    END
    
 
 
 











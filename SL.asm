;---------------------ENCABEZADO------------------------
          #INCLUDE<P16F84A.INC>
          __CONFIG _XT_OSC & _CP_OFF & _PWRTE_ON & _WDT_OFF

          CBLOCK 0CH
          aux1
          aux2
          aux3
          aux4
          aux5
          aux6
          aux7
          aux8
          aux9
          aux10
          aux11
          aux12
          aux13
          aux14
          aux15
	  AUX16
	  AUX17
          contador
	  MOV
          ENDC

          ORG    000H
                                 
;------------------CONFIGURACION-----------
INICIO:   BSF     STATUS,RP0
          MOVLW   b'01110000'
          MOVWF   TRISB
          CLRF    TRISA
          BCF     STATUS,RP0

          CLRF    PORTA
          CLRF    PORTB
        
;-----------------VALORES DE COMPARACION----
          MOVLW   .4
          MOVWF   contador

          MOVLW   b'00100000' ;ADELANTE
          MOVWF   aux5

          MOVLW   b'00010000' ;DERECHA
          MOVWF   aux6

          MOVLW   b'00110000' ;DERECHA
          MOVWF   aux7

          MOVLW   b'00000000' ;ATRAS
          MOVWF   aux8

          MOVLW   b'01000000' ;IZQ
          MOVWF   aux9

          MOVLW   b'01100000' ;IZQ
          MOVWF   aux10

;	==CASOS ESPECIALES==

          MOVLW   b'01010000' ;DER
          MOVWF   aux11

          MOVLW   b'01110000' ;IZQ
          MOVWF   aux12

;	==VALORES DE MOV==

          MOVLW   01H ;ULTIMO DERECHA
          MOVWF   AUX16

          MOVLW   02H ;ULTIMO IZQUIERDA
          MOVWF   AUX17

;----------------INICIO DE DECISIONES------------

CICLO:    MOVF    PORTB,0
          XORWF   aux5,0
          BTFSC   STATUS,2
          GOTO    ADELANTE

          MOVF   PORTB,0
          XORWF   aux6,0
          BTFSC   STATUS,2
          GOTO    DERECHA

          MOVF    PORTB,0
          XORWF   aux7,0
          BTFSC   STATUS,2
          GOTO    DERECHA

          MOVF    PORTB,0
          XORWF   aux8,0
          BTFSC   STATUS,2
          GOTO    ATRAS

          MOVF    PORTB,0
          XORWF   aux9,0
          BTFSC   STATUS,2
          GOTO    IZQUIERDA

          MOVF    PORTB,0
          XORWF   aux10,0
          BTFSC   STATUS,2
          GOTO    IZQUIERDA

          MOVF    PORTB,0
          XORWF   aux11,0
          BTFSC   STATUS,2
          GOTO    DERECHA

          MOVF    PORTB,0
          XORWF   aux12,0
          BTFSC   STATUS,2
          GOTO    IZQUIERDA	;Tomar en cuenta el giro en la pista.
          GOTO    CICLO

;-------------MOVIMIENTOS--------------------

DERECHA:    MOVLW   b'00000110'
            MOVWF   PORTA
            CALL    PAUSA
            MOVLW   00H
            MOVWF   PORTA
            CALL    PAUSA
            CLRF    MOV
            BSF	    MOV,0
            GOTO    CICLO

IZQUIERDA:  MOVLW   b'00001001'
            MOVWF   PORTA
            CALL    PAUSA
            MOVLW   00H
           	MOVWF   PORTA
	        CALL    PAUSA
            CLRF	MOV
            BSF		MOV,1
	        GOTO    CICLO

ADELANTE:   MOVLW   B'00000101'
            MOVWF   PORTA
            GOTO    CICLO

ATRAS:  MOVF	AUX16,0
    	XORWF	MOV,0
    	BTFSC	STATUS,2
    	GOTO	ATRI
    	MOVF	AUX17,0
    	XORWF	MOV,0
        BTFSC	STATUS,2
        GOTO	ATRD
        GOTO	CICLO

ATRD:	MOVLW   b'00001010'
        MOVWF   PORTA
        CALL    PAUSA
        ;MOVLW   b'00010001'
    	MOVLw	10H
        MOVWF   PORTA
        CALL    PAUSA
    	;CALL	DERECHA
        GOTO    CICLO

ATRI:	MOVLW   b'00001010'
        MOVWF   PORTA
    	CALL    PAUSA
        ;MOVLW   b'00010100'
        MOVLW   10H
        MOVWF   PORTA
        CALL    PAUSA
        ;CALL 	IZQUIERDA
        GOTO    CICLO


;----------DELAY-----------------------------------------------

PAUSA:      MOVLW   .1
            MOVWF   aux1
            MOVLW   .40
            MOVWF   aux2
            MOVLW   .40
            MOVWF   aux3
            DECFSZ  aux3,F
            GOTO    $-1
            DECFSZ  aux2,F
            GOTO    $-5
            DECFSZ  aux1,F
            GOTO    $-9
            RETURN

;---------------------FIN----------------

            END

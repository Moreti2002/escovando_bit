
; s1 --> pd3 0b00001000
; s2 --> pd4 0b00010000
; s3 --> pd5 0b00100000
; led1 --> pd6
; led2 --> pd7

ldi     r16, 0b11000111
out     ddrd, r16  

rjmp loop_principal

loop_principal:
	in r16,pind ; carregando valores dos pinos d

	; isoladores de posicoes de bits
	ldi r17, (1 << pd3) ; r17 --> pd3 = s1
	ldi r18, (1 << pd4) ; r18 --> pd4 = s2
	ldi r19, (1 << pd5) ; r18 --> pd4 = s2

	; isolando bits
	and r17, r16
	and r18, r16
	and r19, r16


	; start inverter s3
	com r19 ; invertendo todos os bits
	andi r19, 0b00100000 ; isolando bit pd5
	; end inverter s3


	; BEGIN logica led1
	rjmp logica_led_1
	; END logica led1


logica_led_1:
	lsl r17
	mov r20, r17 ; preservando valor de r17

	; begin negando r20
	com r20
	andi r20, 0b00010000
	; end negando r20

	; operacao OR
	or r20, r18
	
	; if r20=1 {rjmp ligar_led} else {rjmp logica_led_2}
	cpi r20, 0b00010000 
	breq ligar_led_1

	rjmp logica_led_2
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ligar_led_1:
	sbi portd, pd6
	cbi portd, pd6
	rjmp logica_led_2

logica_led_2:
	lsl r17
	lsl r18



	; BEGIN operacao NOR
	or r17, r18
	com r17
	andi r17, 0b00100000
	; END operacao NOR


	; operacao XOR
	eor r17, r19
	
	cpi r17, 0b00100000

	breq ligar_led_2
	rjmp loop_principal

ligar_led_2:
	sbi portd, pd7
	cbi portd, pd7
	rjmp loop_principal
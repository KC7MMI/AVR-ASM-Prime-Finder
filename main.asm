; ASM Prime Finder.asm
; Created: 2/6/2019 9:21:11 PM
; Author : KC7MMI
; Purpose: Test for Primes between 3 and 255
; Division inspired by https://sites.google.com/site/avrasmintro/

.cseg
.org 0
.def tmp = r16		;current number being tested
.def ans = r17		;working answer     
.def rem = r18		;remainder
.def div = r19		;divisor   
.def ctr = r20		;counter
	ldi tmp, $ff	;load tmp with all ones
	out DDRB, tmp	;all of port B set to output
	ldi tmp, 1		;start tmp with a 1
newprime:
	ldi div, 2		;starting place for divisor
	add tmp, div	;inc tmp by 2--div is convenient for this
	cpi tmp, 255	;testing value of dividend/number under test
	breq end		;if dividend is 255, goto end eternal loop
newdivisor:
	mov ans, tmp	;copy dividend to working answer register
	ldi ctr, 9		;initialize bit counter for 1 byte division
	sub rem, rem	;clear remainder and carry
divnloop:   
	rol ans			;shift answer left thru carry
	dec ctr			;decrement counter
	breq loopexit	;exit when ctr reaches zero
	rol rem			;left shift in remainder
	sub rem, div	;subtract divisor from remainder
	brpl ifplus		;if result positive skip next 3 instructions
	add rem, div	;else, undo subtraction
	clc				;clear carry flag to shift zero into ans
	rjmp divnloop	;next step in long division
ifplus:   
	sec				;set carry flag to shift into ans
	rjmp divnloop	;next step in long division
loopexit:
	clz				;clear zero flag for the next test
	cpi rem, 0		;test for prime
	breq newprime	;if no remainder (not prime) start over
	inc div			;inc divisor until...
	cp div, tmp		;divisor equals number under test
	brne newdivisor ;else, loop back and test with new divisor
	out PORTB, tmp	;if prime & at max divisor, output prime
	rjmp newprime	;do it all over again
end:
	rjmp end		;end forever
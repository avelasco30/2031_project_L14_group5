; An empty ASM program ...

ORG 0

load light1
out newleds
load light2
out newleds
load light3
out newleds
load light4
out newleds
load light5
out newleds
load light6
out newleds
load light7
out newleds
load light8
out newleds
load light9
out newleds

	JUMP 0
	
; IO address constants
light1: dw &b0000010000000001
light2: dw &b0000100000000010
light3: dw &b0001100000000100
light4: dw &b0010000000001000
light5: dw &b1111111000000000
light6: dw &b1111100100000000
light7: dw &b1111010010000000
light8: dw &b1000000001000000
light9: dw &b0111110000100000


Switches:  EQU 000
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
NewLEDs:   EQU 001

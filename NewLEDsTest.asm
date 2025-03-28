; An empty ASM program ...

ORG 0

load fkev;
out newleds
load fkev2
out newleds

	JUMP 0
	
; IO address constants
fkev: dw &b0000101111000000
fkev2: dw &b0111110000000111
Switches:  EQU 000
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
NewLEDs:   EQU 001

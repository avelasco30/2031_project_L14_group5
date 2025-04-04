Org 0


MainLoop:
load erase
out leds

load FullOn
shift 1
store FullOn
out leds


loadi 63
store count


DecreaseLoop:

load waittime
call wait


load count
shift 10
store countshifted
load changebit
or countshifted
out LEDs
load count
addi -1
store count
jpos DecreaseLoop

load changebit
shift 1
store changebit
sub changebitlimter
jneg MainLoop



endProgram:
jump endProgram




;Function to wait accumulator deciseconds
wait:
store WaitTime
out Timer

CheckTimer:
in Timer
sub WaitTime
jneg CheckTimer
return
WaitTime: DW 2

DisplayAC:; Assumes your accumulator has value and stores it


TempDisp: DW 0



;----------
Count: DW 0
Countshifted: DW 0

MaxInt: DW &b1111111111111111
FullOn: DW &b1111111111111111
MaxBrightness: DW &b1111110000000000
Erase: DW &b0000001111111111
changebit: DW &b0000000000000001
changebitlimter: DW &b0000010000000000

Switches:  EQU 000
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
LEDs:   EQU 001
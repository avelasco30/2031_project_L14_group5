Org 0

; clear stuff
loadi 0
store onLEDs
store SelectedLeds
store selectedBrightness


MainLoop:

call wait
call DisplayOnLEDs

in Switches
store switchState
and switchMask
store selectedLEDs
load switchState
and drawMask
jpos drawaction
load switchState
and eraseMask
jpos eraseAction

; Erase what's not selected or on
load selectedLEDs
or OnLEDs
xor minInt
shift 6
shift -6
out LEDs


load SelectedBrightness
add deltaBrightness
store SelectedBrightness
jzero brightnessZero
sub MaxBrightness
jzero brightnessMax


call DisplaySelectedLEDs
jump MainLoop



brightnessZero:
loadi 1
store deltaBrightness
jump MainLoop

brightnessMax:
loadi -1
store deltaBrightness
jump MainLoop



drawAction:
load onLeds
or selectedLeds
store onLeds
jump MainLoop

eraseAction:
load SelectedLeds
xor MinInt
and OnLEDs
store OnLEDs
jump MainLoop


; function to wait, change later to something better or change timer clock source
wait:
loadi 0
store countdown
waitingloop:
load countdown
addi 1
store countdown
jpos waitingloop
return
countdown: DW 0



DisplayOnLEDs:
load MaxBrightness
shift 10
or OnLEDs
out LEDs
return


DisplaySelectedLEDs:
load SelectedBrightness
shift 10
or selectedLEDs
out LEDs
return



;---------
OnLEDs: DW 0
SelectedLeds: DW 0
switchState: DW 0
selectedBrightness: DW 0
deltaBrightness: DW 1


Erase: DW &b0000001111111111
MaxInt: DW &b0111111111111111
MaxBrightness: DW 63
MinInt: DW &b1111111111111111
EraseMask: DW &b0000000100000000
DrawMask: DW &b0000001000000000
switchMask: DW &b0000000011111111




Switches:  EQU 000
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
LEDs:   EQU 001

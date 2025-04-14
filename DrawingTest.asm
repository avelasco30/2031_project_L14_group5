; 1 Dimensional Drawing Test
; 8 right LEDs for canvas
; leftmost switch to draw, second leftmost to erase
; 8 rightmost switches to select which pixel to draw to

Org 0

; clear screen and reset necessary mem values
loadi 0
store onLEDs
store SelectedLeds
store selectedBrightness


MainLoop:

call wait
call DisplayOnLEDs; Display LEDs that are turned on

in Switches
store switchState
and switchMask
store selectedLEDs; store high 8 rightmost switches as selected
load switchState
and drawMask
jpos drawaction; jump to draw action if draw switch is high
load switchState
and eraseMask
jpos eraseAction; jump to erase action if erase switch is high

; Erase what's not selected or on
call EraseNecessary


load SelectedBrightness
add deltaBrightness; increment or decrement brightness to get an oscillating brightness
store SelectedBrightness
jzero brightnessZero
sub MaxBrightness
jzero brightnessMax


call DisplaySelectedLEDs; display oscillating brightness on selected LEDs
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
xor minInt
and erase
out LEDs ; erase everything but on LEDs


jump MainLoop

; Functions
;-----------------------------------------
; function to wait, change later to something better or change timer clock source
wait:
loadi 0
store countdown
waitingloop:
load countdown
addi 2
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

EraseNecessary:
load selectedLEDs
or OnLEDs
xor minInt
and erase
out LEDs
return


;Constants and variables
;---------------
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

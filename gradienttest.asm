; Test program for final project LED peripheral
; On i, j-th iteration (j loop is nested within i loop), 
; Sets the lowest i LEDs to brightness j
; ex. first led 0 goes 0-63, then leds 0 and 1 go 0-63, and so on

LEDs: DW 002 ; Should probably change

; loop through incr. number of LEDs

; load number of LEDs to be active, if it's more than 10 bits high then we are done
LEDLoop:
LOAD LEDsActive
ADDI -1024
JPOS Done 


; Loop through brightness levels
; Need to reset brightness to 0
LOADI 0
STORE Brightness

; Initialize LEDs to all dark
LOADI 1023
OUT LEDs

; Per number of LEDs, loop through brightness values
BrightnessLoop:
LOAD Brightness
ADDI -64
JPOS BrightnessLoopOver

; Actually use peripheral to set brightness for active LEDs as desired
LOAD Brightness
SHIFT 10
ADD LEDsActive
OUT LEDs

; Loop back to next brightness value
LOAD Brightness
ADDI 1
STORE Brightness
JUMP BrightnessLoop

BrightnessLoopOver:

; Increment LED selector (add another LED)
LOAD LEDsActive
SHIFT 1
ADDI 1
STORE LEDsActive
JUMP LEDLoop


; Infinite loop as process is over
Done:
JUMP Done



LEDsActive: DW 1
Brightness: DW 0
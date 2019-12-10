.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ RED_LIGHT_PIN, 0		// wiringPi pin 0
.equ YLW_LIGHT_PIN, 1		// wiringPI pin 1
.equ GREEN_LIGHT_PIN, 2		// wiringPi pin 27

.equ GREEN_CRSS_PIN, 3		// wiringPi pin 22
.equ RED_CRSS_PIN, 4		// wiringPi pin 23

.equ CROSS_BTN_PIN, 24
.equ RED_LT_ST, 0
.equ YLW_LT_ST, 1
.equ GRN_LT_ST, 2

.equ RED_CRSS_ST, 3
.equ GREEN_CRSS_ST, 4

.text
.global main

main:
	push {lr}
	bl wiringPiSetup
	bl my_setup
start:

	mov r4, #GRN_LT_ST
	mov r0, #GREEN_LIGHT_PIN
	bl pinOn

	mov r4,#RED_CRSS_ST
	mov r0, #RED_CRSS_PIN
	bl pinOn

	mov r0, #RED_LIGHT_PIN
	bl pinOff

	bl readCrossButton

light_sqnc:

	ldr r0, =#2000 		// delay next sequence by 2 seconds
	bl delay

	mov r0, #GREEN_LIGHT_PIN
	bl pinOff

	mov r0, #YLW_LIGHT_PIN
	bl pinOn

	ldr r0, =#5000 		// delay yellow light for 4 seconds before turning red
	bl delay

	mov r0, #YLW_LIGHT_PIN
	bl pinOff

	mov r0, #RED_LIGHT_PIN
	bl pinOn

	ldr r0, =#4000 		// delay by 4 seconds before crossing
	bl delay

crossing_sqnc:

	mov r0, #GREEN_CRSS_PIN
	bl pinOn

	mov r0, #RED_CRSS_PIN
	bl pinOff

	ldr r0, =#15000 	// street crossing is timed for 15 seconds
	bl delay

blink_crossing:

	mov r0, #GREEN_CRSS_PIN
	bl pinOff

	mov r0, #RED_CRSS_PIN
	bl pinOn

	ldr r0, =#500
	bl delay

	mov r0, #RED_CRSS_PIN
	bl pinOff

	ldr r0, =#250
	bl delay

	mov r0, #RED_CRSS_PIN
	bl pinOn

	ldr r0, =#500
	bl delay

	mov r0, #RED_CRSS_PIN
	bl pinOff

	ldr r0, =#250
	bl delay

	mov r0, #RED_CRSS_PIN
	bl pinOn

	ldr r0, =#500
	bl delay

	mov r0, #RED_CRSS_PIN
	bl pinOff

	ldr r0, =#250
	bl delay

	mov r0, #RED_CRSS_PIN
	bl pinOn

	ldr r0, =#500
	bl delay

	mov r0, #RED_CRSS_PIN
	bl pinOff

	ldr r0, =#250
	bl delay

end_crossing:
	mov r0, #RED_LIGHT_PIN
	bl pinOff

	mov r0, #YLW_LIGHT_PIN
	bl pinOff

	mov r0, #GREEN_LIGHT_PIN
	bl pinOff

	mov r0, #GREEN_CRSS_PIN
	bl pinOff

	mov r0, #RED_CRSS_PIN
	bl pinOff

	mov r0, #0
	pop {pc}

readCrossButton:
	mov r0, #CROSS_BTN_PIN
	bl digitalRead
	cmp r0, #HIGH 		// If button is pressed, crossing fx runs
	beq light_sqnc

	cmp r0, #LOW		// If button is not pressed, keep inital
	beq start		// continue to run 'start' function

setPinInput:
	push {lr}
	mov r1, #INPUT
	bl pinMode
	pop {pc}

setPinOutput:
	push {lr}
	mov r1, #OUTPUT
	bl pinMode
	pop {pc}

pinOn:
	push {lr}
	mov r1, #HIGH
	bl digitalWrite
	pop {pc}

pinOff:
	push {lr}
	mov r1, #LOW
	bl digitalWrite
	pop {pc}

my_setup:
	push {lr}

	mov r0, #RED_LIGHT_PIN
	bl setPinOutput

	mov r0, #YLW_LIGHT_PIN
	bl setPinOutput

	mov r0, #GREEN_LIGHT_PIN
	bl setPinOutput

	mov r0, #GREEN_CRSS_PIN
	bl setPinOutput

	mov r0, #RED_CRSS_PIN
	bl setPinOutput

	pop {pc}

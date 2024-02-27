@ File: mcclureLab3.s 

@ Author: Colby McClure

@ Email: ctm0026@uah.edu

@ CS 413-01 Spring 2024

@ Purpose: implemented a simple four function integer calculator using Assembly

@ The comments below are to assemble, link, run, and debug the program
@ as -o mcclureLab3.o mcclureLab3.s
@ gcc -o mcclureLab3 mcclureLab3.o 
@ ./mcclureLab3
@ gdb --args ./mcclureLab3

.equ READERROR, 0
.global main 
.text

@ This label is for setting the register equal to the max amount of coffee allowed
@**********
waterLoad:
@**********

    mov r4, #48 @ Set r4 equal to max amount of coffee allowed
    mov r7, #0 @ Set r6 equal to amount of small cups used
    mov r8, #0 @ Set r7 equal to amount of medium cups used
    mov r9, #0 @ Set r8 equal to amount of large cups used

@ This label outputs the welcoming message along with the instructions
@**********
beginPrompt:
@**********

    ldr r0, =prompt1 @ Load the first prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =prompt2 @ Load the second prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =prompt3 @ Load the third prompt into r0
    bl printf @ Call printf to print the prompt

    b chooseSize @ Branch to the chooseSize label

@ This label is for outputting the optins for the cup size and allowing input from the user 
@**********
chooseSize:
@**********

    ldr r0, =prompt4 @ Load the fourth prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =prompt5 @ Load the fifth prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =chInputPattern @ Load the input pattern into r0
    ldr r1, =cupInput @ Load the cupInput into r1
    bl scanf @ Call scanf to get the input from the user

    ldr r1, =cupInput @ Load the cupInput into r1
    ldr r5, [r1] @ Load the value of cupInput into r5

    cmp r5, #33 @ Compare r5 with the secret character '!'
    bleq secretCode @ Branch to secretCode if r5 is less than or equal to 33

    cmp r5, #115 @ Compare r5 with the character 's'
    beq checkWater @ Branch to checkWater if r5 is equal to 's'

    cmp r5, #109 @ Compare r5 with the character 'm'
    beq checkWater @ Branch to checkWater if r5 is equal to 'm'

    cmp r5, #108 @ Compare r5 with the character 'l'
    beq checkWater @ Branch to checkWater if r5 is equal to 'l'

    cmp r5, #84 @ Compare r5 with the character 'T'
    beq exit @ Branch to exit if r5 is equal to 'T'

    b chooseSize @ Branch to chooseSize if secret character or any other character is entered

@ This label is for checking to make sure that the user input is valid
@**********
checkWater:
@**********

    cmp r5, #115 @ Compare r5 and 115
    moveq r6, #6 @ If r5 is equal to 1, move 6 into r5

    cmp r5, #115 @ Compare r5 and 115
    addeq r7, r7, #1 @ If r5 is equal to 1, add 1 to r7

    cmp r5, #109 @ Compare r5 and 109
    moveq r6, #8 @ If r5 is equal to 2, move 8 into r5

    cmp r5, #109 @ Compare r5 and 109
    addeq r8, r8, #1 @ If r5 is equal to 2, add 1 to r8

    cmp r5, #108 @ Compare r5 and 108
    moveq r6, #10 @ If r5 is equal to 3, move 10 into r5

    cmp r5, #108 @ Compare r5 and 108
    addeq r9, r9, #1 @ If r5 is equal to 3, add 1 to r9

    cmp r4, r6 @ Compare r4 and r6
    bge brewPrep @ Branch to brewCoffee if r4 is greater than or equal to r5

    ldr r0, =brewBad @ Load the brewBad prompt into r0
    bl printf @ Call printf to print the prompt

    b chooseSize @ Branch to chooseSize

@ This label is for brewing the coffee if there's enough water
@**********
brewPrep:
@**********

    ldr r0, =brewGood1 @ Load the brewGood1 prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =brewGood2 @ Load the brewGood2 prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =chInputPattern @ Load the character input pattern into r0
    ldr r1, =buttonInput @ Load the buttonInput into r1
    bl scanf @ Call scanf to get the input from the user

    ldr r1, =buttonInput @ Load the buttonInput into r1
    ldr r5, [r1] @ Load the value of buttonInput into r5

    cmp r5, #33 @ Compare r5 and character '!'
    bleq secretCode @ Branch to secretCode if r5 is less than or equal to 33

    cmp r5, #66 @ Compare r5 and character 'B'
    beq brewCoffee @ Branch to brewCoffee if r5 is equal to 'B'

    b brewPrep @ Branch to brewPrep if secret code or any other character is entered

@ This label is for brewing the coffee 
@**********
brewCoffee:
@**********

    subs r4, r4, r6 @ Subtract r6 from r4

    ldr r0, =brewSuccess @ Load the brewSuccess prompt into r0
    bl printf @ Call printf to print the prompt

    cmp r4, #6 @ Compare r4 and to the minimum amount of water
    bge beginPrompt @ Branch to beginPrompt if r4 is greater than or equal to 6

    ldr r0, =waterLow1 @ Load the waterLow1 prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =waterLow2 @ Load the waterLow2 prompt into r0
    bl printf @ Call printf to print the prompt

    b exit @ Branch to exit

@ This label ends the program 
@**********
exit:
@**********

	mov r7, #0x01 @ Set r7 equal to 0x01
	svc 0 @ Call svc 0 to exit the program

@ This label is for the secret code to display the water level and the amount of cups used
@**********
secretCode:
@**********

    ldr r0, waterLevel @ Load the waterLevel prompt into r0
    ldr r1, r4 @ Load the value of r4 into r1
    bl printf @ Call printf to print the prompt

    ldr r0, smallCups @ Load the smallCups prompt into r0
    ldr r1, r7 @ Load the value of r7 into r1
    bl printf @ Call printf to print the prompt

    ldr r0, mediumCups @ Load the mediumCups prompt into r0
    ldr r1, r8 @ Load the value of r8 into r1
    bl printf @ Call printf to print the prompt

    mov pc, lr @ Exit the subroutine 

.data 

.balign 4
prompt1: .asciz "Welcome to the Coffee Maker \n"

.balign 4
prompt2: .asciz "Insert K-cup and press B to begin making coffee \n"

.balign 4
prompt3: .asciz "Press T to turn off the machine \n"

.balign 4
prompt4: .asciz "Please select the size of the cup you would like to use \n"

.balign 4
prompt5: .asciz " [s] Small (6 oz) [m] Medium (8 oz) [l] Large (10 oz) \n"

.balign 4
brewGood1: .asciz "Ready to Brew \n" 

.balign 4
brewGood2: .asciz "Please place a cup in the tray and press [B] to begin brewing \n"

.balign 4
brewBad: .asciz "Not enough water to brew the coffee, please select a smaller cup size \n"

.balign 4
brewSuccess: .asciz "Coffee is ready! \n"

.balign 4
waterLow1: .asciz "The water level is low, please refill the reservoir \n"

.balign
waterLow2: .asciz "Powering down... \n"

.balign 4
waterLevel: .asciz "Water level: %d \n"

.balign 4
smallCups: .asciz "Small: %d \n"

.balign 4
mediumCups: .asciz "Medium: %d \n"

.balign 4
largeCups: .asciz "Large: %d \n"

.balign 4
cupInput: .word 0 

.balign 4 
numInputPattern: .asciz "%d"

.balign 4
buttonInput: .word 0

.balign 4
chInputPattern: .asciz " %c" 

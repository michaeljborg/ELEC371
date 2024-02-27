#-----------------------------------------------------------------------------
# This template source file for ELEC 371 Lab 2 experimentation with interrupts
# also serves as the template for all assembly-language-level coding for
# Nios II interrupt-based programs in this course. DO NOT USE the approach
# shown in the vendor documentation for the DE0 Basic (or Media) Computer.
# The approach illustrated in this template file is far simpler for learning.
#
# Dr. N. Manjikian, Dept. of Elec. and Comp. Eng., Queen's University
#-----------------------------------------------------------------------------

	.text		# start a code segment (and we will also have data in it)

	.global	_start	# export _start symbol for linker 

#-----------------------------------------------------------------------------
# Define symbols for memory-mapped I/O register addresses and use them in code
#-----------------------------------------------------------------------------

# mask/edge registers for pushbutton parallel port

	.equ	BUTTON_MASK, 0x10000058
	.equ	BUTTON_EDGE, 0x1000005C

	.equ	TIMER_STATUS, 0x10002000
	.equ	TIMER_CONTROL, 0x10002004
	.equ	TIMER_START_LOW, 0x10002008
	.equ	TIMER_START_HIGH, 0x1000200C

	

# pattern corresponding to the bit assigned to button1 in the registers above

	.equ	BUTTON1, 0x10000050 #MIGHT BE WRONG




# data register for LED parallel port

	.equ	LEDS, 0x10000010





# PRINT STRING INFO

	.equ 	JTAG_UART_BASE,		0x10001000
	.equ 	DATA_OFFSET, 		0
	.equ 	STATUES_OFFSET, 	4
	.equ 	WSPACE_MASK, 		0xFFFF


#UPDATE_HEX_ADDRESS_SPACE
	.equ 	HEXDISPLAYS,	 	0x10000020  


#-----------------------------------------------------------------------------
# Define two branch instructions in specific locations at the start of memory
#-----------------------------------------------------------------------------

	.org	0x0000	# this is the _reset_ address 
_start:
	br		main	# branch to actual start of main() routine 



	.org	0x0020	# this is the _exception/interrupt_ address
	br		isr	# branch to start of interrupt service routine 
			#   (rather than placing all of the service code here) 

#-----------------------------------------------------------------------------
# The actual program code (incl. service routine) can be placed immediately
# after the second branch above, or another .org directive could be used
# to place the program code at a desired address (e.g., 0x0080). It does not
# matter because the _start symbol defines where execution begins, and the
# branch at that location simply forces execution to continue where desired.
#-----------------------------------------------------------------------------

main:		
	movia 	sp, 0x0007FFFC 			# initialize stack pointer

	call 	Init 					# call hw/sw initialization subroutine
	
	# perform any local initialization of gen.-purpose regs.
	#   before entering main loop 

	ldw 	r3, COUNT(r0) 

	movia 	r2, String1			#this is a pure pointer - no need for (r0)
	call 	PrintString

	movia 	r3, HEXDISPLAYS
	movia 	r5, 0xFF000000


	stwio 	r5, 0(r3)


main_loop:

	# body of main loop (reflecting typical embedded
	#   software organization where execution does not
	#   terminate)
	# IDLE and adding to count
	addi 	r3, r3, 1
	stw 	r3, COUNT(r0)	

	br 		main_loop

#-----------------------------------------------------------------------------
# This subroutine should encompass preparation of I/O registers as well as
# special processor registers for recognition and processing of interrupt
# requests. Initialization of data variables in memory can also be done here.
#-----------------------------------------------------------------------------

Init:						# make it modular -- save/restore registers
	subi 	sp, sp, 8
	stw 	r3, 4(sp)
	stw 	r4, 0(sp)


	# write to the pushbutton port interrupt mask register
	movia 	r3, BUTTON_MASK
	movi 	r4, 6   #0b0110
	stwio 	r4, 0(r3)





	/*TIMER SETUP*/

	/*set the start value*/
	movia 	r3, TIMER_START_HIGH
	movia  	r4, 0x017D
	stwio 	r4, 0(r3)

	movia 	r3, TIMER_START_LOW
	movia  	r4, 0x7840
	stwio 	r4, 0(r3)

	movia 	r3, TIMER_CONTROL
	movi 	r4, 7  	/*0b0111 == 7. START=1, CONT=1, ITO=1*/
	stbio 	r4, 0(r3)


	
	#________________________________________

	# enable Nios II processor interrupts ___
	movi 	r4, 3 			#0b0011 --> pushbutton ienable is in position A1 and timer is in A0
	wrctl 	ienable, r4 	#registers in CPU

	movi 	r4, 1
	wrctl 	status, r4 		#registers in CPU, turn on NIOS 2 interrupt processing


	#________________________________________


	ldw 	r3, 4(sp)
	ldw 	r4, 0(sp)
	addi 	sp, sp, 8(sp)

	ret



#PART1-------------------------------

UpdateHexDisplay:
	subi	sp, sp, 20
	stw 	r3, 16(sp)		
	stw 	r4, 12(sp)		
	stw 	r5, 8(sp)		
	stw 	ra, 4(sp)		
	stw 	ra, 0(sp)




	movia 	r3, HEXDISPLAYS
	movia 	r5, 0x000000FF

	ldwio 	r4, 0(r3)


UHD_IF:
	beq 	r4, r5, WRAP_AROUND
UHD_THEN:
	srli 	r4, r4, 8 		/*shift 8 bits*/
	stwio 	r4, 0(r3)		#load from DEO hex data register
	br 	 	UHD_END_IF	


WRAP_AROUND:
	movia 	r4, 0xFF000000
	stwio 	r4, 0(r3)



UHD_END_IF:	

	ldw 	r3, 16(sp)		
	ldw 	r4, 12(sp)		
	ldw 	r5, 8(sp)		
	ldw 	ra, 4(sp)		
	ldw 	ra, 0(sp)		
	addi	sp, sp, 20

	ret







PrintString:
	subi	sp, sp, 20
	stw 	r3, 16(sp)		#storing original N value
	stw 	r4, 12(sp)		#using this for the current value of "String1"
	stw 	r5, 8(sp)		#SAVE r2 REGISTER
	stw 	ra, 4(sp)		#store return address, so we can get back to main
	stw 	r6, 0(sp)


#1. get value from string - list
#2. print the character
#3. increment through string
#4. decrement N
	movi 	r3, '\n'

psloop:
	ldb 	r4, 0(r2)		#get new character
	mov 	r5, r2			#saving r2
	mov 	r2, r4			#put new character in r2
	call 	PrintChar
	mov 	r6, r2 			#save current character for while loop
	mov 	r2, r5			#restoring r2


	addi 	r2, r2, 1		#increment through string -> string is byte addressable

	bne 	r3, r6, psloop


	ldw 	r3, 16(sp)		#storing original N value
	ldw 	r4, 12(sp)		#using this for the current value of "String1"
	ldw 	r5, 8(sp)		#SAVE r2 REGISTER
	ldw 	ra, 4(sp)		#store return address, so we can get back to main
	ldw 	r6, 0(sp)		
	addi	sp, sp, 20


	ret


PrintChar:
	subi	sp, sp, 8
	stw 	r3, 4(sp)
	stw 	r4, 0(sp)
	movia 	r3, JTAG_UART_BASE

pcloop:
	ldwio 	r4, STATUES_OFFSET(r3)
	andhi 	r4, r4, WSPACE_MASK
	beq	 	r4, r0, pcloop
	stwio 	r2, DATA_OFFSET(r3)

	ldw 	r3, 4(sp)
	ldw 	r4, 0(sp)
	addi 	sp, sp, 8

	ret
	


#-----------------------------------------------------------------------------
# The code for the interrupt service routine is below. Note that the branch
# instruction at 0x0020 is executed first upon recognition of interrupts,
# and that branch brings the flow of execution to the code below. Therefore,
# the actual code for this routine can be anywhere in memory for convenience.
# This template involves only hardware-generated interrupts. Therefore, the
# return-address adjustment on the ea register is performed unconditionally.
# Programs with software-generated interrupts must check for hardware sources
# to conditionally adjust the ea register (no adjustment for s/w interrupts).
#-----------------------------------------------------------------------------

isr:
	# save register values, except ea which
	#   must be modified for hardware interrupts
	subi 	sp, sp, 12
	stw 	r3, 8(sp)
	stw 	r4, 4(sp)
	stw 	ra, 0(sp)

	subi	ea, ea, 4	# ea adjustment required for h/w interrupts

										# 	body of interrupt service routine
										#   use the proper approach for checking
										#    the different interrupt sources
	rdctl 	r3, ipending
PUSHBUTTON_handle:
	andi 	r4, r3, 2 					#	PUSH BUTTON1 is in position A1
	beq 	r4, r0, TIMER_handle				# IF ipending AND 0010 is equal to zero, then push button was not triggered, check different interrupt
	call 	PUSHBUTTON_ISR
	br 		isr_end


TIMER_handle:
	andi 	r4, r3, 1
	beq 	r4, r0, Next_handle
	call 	TIMER_ISR
	br 		isr_end


Next_handle:



	#other 	interrupts we want to check, keep adding handles


	#[...]
	
	
isr_end:	
	# restore register values
	ldw 	r3, 8(sp)
	ldw 	r4, 4(sp)
	ldw 	ra, 0(sp)
	addi 	sp, sp, 12(sp)			
	
	
	eret							# interrupt service routines end _differently_
									#   than subroutines; execution must return to
									#   to point in main program where interrupt
									#   request invoked service routine
	

TIMER_ISR:
	subi 	sp, sp, 8 				/* reserve space on the stack */
	stw 	r10, 4(sp)
	stw 	ra, 0(sp)



	movia 	r10, TIMER_STATUS
	stwio 	r0, 0(r10) /*write one to start bit, to clear*/
	
	call 	UpdateHexDisplay


	

END_TIMER_ISR:
	ldw 	r10, 4(sp)
	ldw 	ra, 0(sp)
	addi 	sp, sp, 8
	ret







PUSHBUTTON_ISR:
	subi 	sp, sp, 24 				/* reserve space on the stack */
	stw 	ra, 0(sp)
	stw 	r10, 4(sp)
	stw 	r11, 8(sp)
	stw 	r12, 12(sp)
	stw 	r13, 16(sp)
	stw 	r14, 20(sp)


	movia 	r10, BUTTON_EDGE		/* base address of pushbutton KEY parallel port */
	ldwio 	r11, 0(r10) 			/* read edge capture register */
	# andi 	r14, r14, 2
	# wrctl 	ipending, r14
	movi 	r14, 0xFFFFFFFF			#mov all bits into a register, then write all bits to BUTTON_EDGE
	stwio	r14, 0(r10) 			/* clear the interrupt */



	movia 	r10, LEDS
	ldwio 	r11, 0(r10)
	xori 	r12, r11, 1
	stwio 	r12, 0(r10)



	END_PUSHBUTTON_ISR:
	ldw 	ra, 0(sp) 				/* Restore all used register to previous values */
	ldw 	r10, 4(sp)
	ldw 	r11, 8(sp)
	ldw 	r12, 12(sp)
	ldw 	r13, 16(sp)
	ldw 	r14, 20(sp)
	addi 	sp, sp, 24
	ret







#-----------------------------------------------------------------------------
# Definitions for program data, incl. anything shared between main/isr code
#-----------------------------------------------------------------------------

			.org	0x1000		# start should be fine for most small programs
				
COUNT:		.word 	0		# define/reserve storage for program data
String1:	.byte 	'E','L','E','C',' ','3','7','1',' ','L','a','b',' ','2',' ','b','y',' ','L','u','k','a',' ','R','o','d','r','i','g','u','e','s',' ','a','n','d',' ','M','i','c','h','a','e','l',' ','B','o','r','g','\n'



			.end


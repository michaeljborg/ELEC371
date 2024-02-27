#lab4_prelab.s


#Print_Hex_Word.s
.text 
.global 	_start
.org 		0x0000


.equ 	JTAG_UART_BASE,		    0x10001000
.equ 	DATA_OFFSET, 		    0
.equ 	STATUES_OFFSET, 	    4
.equ 	WSPACE_MASK, 		    0xFFFF



.equ    STATUES_OFFSET_INPUT,   0
.equ	RSPACE_MASK,		    0xFF





_start:
_main:
	movia 	sp, 0x7FFC


	movia 	r2, String1
	ldw 	r3, N_string(r0)
	call 	PrintString

    movi    r3, 'q'
main_loop:
    call    GetChar         #Changes the value of r2
    call    PrintChar       #Prints the value of r2
    bne     r2, r3, main_loop
_end:
	br		_end



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# no params, only returns new data in r2
GetChar:
    subi    sp, sp, 12
    stw     r3, 8(sp)
    stw 	r4, 4(sp)
    stw     r5, 0(sp)
	movia 	r3, JTAG_UART_BASE

GCloop:
	ldwio 	r4, STATUES_OFFSET_INPUT(r3)
    mov     r5, r4
	andi 	r4, r4, 0x8000 #checking if the status register is hi or lo
    beq     r4, r0, GCloop  

    andi    r2, r5, RSPACE_MASK #AND-ing the contents of r4 (the word) with 0xFF allows us to capture only the 8 bits

    #RESULT IS STORED IN R2

	ldw 	r3, 8(sp)
	ldw 	r4, 4(sp)
    ldw     r5, 0(sp)
	addi 	sp, sp, 12
    #INCREMNT SP

    ret 





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 	param takes (list, N) - r2, r3
DisplayByteList:
	subi 	sp, sp, 24
	stw 	r2, 20(sp) 	#Original List pointer
	stw 	r3, 16(sp) 	#FOR INCREMENT COUNTER
	stw 	r4, 12(sp) 	#Current List Value
	stw 	r5, 8(sp) 	#List Pointer SAVE
	stw 	r6, 4(sp) 	#the value of 128
	stw 	ra, 0(sp)	#NESTEED CALLING, SAVE HOME



	addi 	r6, r0, 128
	mov 	r5, r2



#-------------------
DBL_loop:
	ldw 	r4, 0(r5) 	#load current value of list into register 4 (varaible x in pseudo code)
	mov  	r2, r4		#mov the value of r4 into r2 so we can use the "PrintChar" subroutine


DBL_IF:
	
	bge 	r4, r6, DBL_ELSE

DBL_THEN:
	movi  	r2, '_'
	call 	PrintChar
	mov  	r2, r4		#mov the value of r4 into r2 so we can use the "PrintChar" subroutine
	call 	PrintHexByte
	movi  	r2, '_'
	call 	PrintChar
	br 		DBL_ENDIF
DBL_ELSE:
	movi  	r2, '['
	call 	PrintChar
	mov  	r2, r4		#mov the value of r4 into r2 so we can use the "PrintChar" subroutine
	call 	PrintHexByte
	movi  	r2, ']'
	call 	PrintChar

DBL_ENDIF:

	movi  	r2, ' '
	call 	PrintChar


	subi 	r3, r3, 1
	addi 	r5, r5, 4
	bgt		r3, r0, DBL_loop

DBL_ENDFOR:
#-------------------
	movi 	r2, '\n'
	call 	PrintChar

	ldw 	r2, 20(sp) 	#Original List pointer
	ldw 	r3, 16(sp) 	#FOR INCREMENT COUNTER
	ldw 	r4, 12(sp) 	#Current List Value
	ldw 	r5, 8(sp) 	#List Pointer SAVE
	ldw 	r6, 4(sp) 	#the value of 128
	ldw 	ra, 0(sp)	#NESTEED CALLING, SAVE HOME
	addi 	sp, sp, 24




	ret





#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PrintHexDigit:
	subi 	sp, sp, 12
	stw 	r2, 8(sp)
	stw 	r3, 4(sp)
	stw 	ra, 0(sp)

	movi 	r3, 10

#if(r2 < 10)
PHD_IF:

	bge 	r2, r3, PHD_ELSE

PHD_THEN:
	addi 	r2, r2, '0'
	br 		PHD_ENDIF
	


PHD_ELSE:
	subi  	r2, r2, 10
	addi 	r2, r2, 'A'



PHD_ENDIF:

	call 	PrintChar


	ldw 	r2, 8(sp)
	ldw 	r3, 4(sp)
	ldw 	ra, 0(sp)
	addi 	sp, sp, 12

	ret
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PrintHexByte:
	subi 	sp, sp, 12
	stw 	r2, 8(sp)
	stw 	r3, 4(sp)
	stw 	ra, 0(sp)
	

	mov 	r3, r2

	srli 	r2, r3, 4
	call 	PrintHexDigit

	andi	r2, r3, 0xF
	call 	PrintHexDigit

	ldw 	r2, 8(sp)
	ldw 	r3, 4(sp)
	ldw 	ra, 0(sp)
	addi 	sp, sp, 12
 	
	ret
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PrintHexWord:
	subi 	sp, sp, 12
	stw 	r2, 8(sp)
	stw 	r3, 4(sp)
	stw 	ra, 0(sp)

	mov 	r3, r2

	srli	r2, r3, 24
	call 	PrintHexByte


	srli 	r2, r3, 16
	andi 	r2, r3, 0xFF
	call 	PrintHexByte

	srli 	r2, r3, 8
	andi 	r2, r3, 0xFF
	call 	PrintHexByte	

	andi 	r2, r3, 0xFF
	call 	PrintHexByte	


	ldw 	r2, 8(sp)
	ldw 	r3, 4(sp)
	ldw 	ra, 0(sp)
	addi 	sp, sp, 12
 	
	ret

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TAKES TWO PARAM (STRING, N) - r2, r3
PrintString:
	subi	sp, sp, 16
	stw 	r3, 12(sp)		#storing original N value
	stw 	r4, 8(sp)		#using this for the current value of "String1"
	stw 	r5, 4(sp)		#SAVE r2 REGISTER
	stw 	ra, 0(sp)		#store return address, so we can get back to main


#1. get value from string - list
#2. print the character
#3. increment through string
#4. decrement N

psloop:
	ldw 	r4, 0(r2)		#get new character
	mov 	r5, r2			#saving r2
	mov 	r2, r4			#put new character in r2
	call 	PrintChar
	mov 	r2, r5			#restoring r2


	subi 	r3, r3, 1
	addi 	r2, r2, 4

	bgt 	r3, r0, psloop


	ldw 	r3, 12(sp)		#storing original N value
	ldw 	r4, 8(sp)		#using this for the current value of "String1"
	ldw 	r5, 4(sp)		#SAVE r2 REGISTER
	ldw 	ra, 0(sp)		#store return address, so we can get back to main
	addi	sp, sp, 16


	ret
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		.org	0x1000


N_list: 		.word 	4
LIST: 			.word 	0x3E, 0xF7, 0x2C, 0x9A

N_string: 		.word 	5
String1:		.word 	'L', 'a', 'b', '4', '\n'		


		.end










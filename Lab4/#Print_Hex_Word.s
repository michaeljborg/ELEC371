#Print_Hex_Word.s
.text 
.global 	_start
.org 		0x0000



.equ 	JTAG_UART_BASE,		0x10001000
.equ 	DATA_OFFSET, 		0
.equ 	STATUES_OFFSET, 	4
.equ 	WSPACE_MASK, 		0xFFFF




_start:
_main:
	movia 	sp, 0x7FFC

	movi 	r2, 0xFFFFFFFFF
	call	PrintHexWord

_end:
	br		_end



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PrintHexDigit:
	subi 	sp, sp, 12
	stw 	r2, 8(sp)
	stw 	r3, 4(sp)
	stw 	ra, 0(sp)

	movi 	r3, 10


PHD_IF:

	bge 	r2, r0, PHD_ELSE

THEN:
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
	

#---------------------------------------------------
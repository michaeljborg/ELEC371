#PrintChar.s


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

	movi 	r2, 'A'
	call 	PrintChar

_end:
	br		_end


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

		.org 0x1000
		.end	

















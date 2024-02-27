#include <stdio.h>
#ifndef _CHARIO_H_
#define _CHARIO_H_

/* place character-I/O function prototypes here */

#define JTAG_UART_BASE        ((volatile unsigned int *) 0x10001000)
#define JTAG_UART_STATUS      ((volatile unsigned int *) 0x10001004)
#define DATA_OFFSET           ((volatile unsigned int) 0x0)
#define STATUS_OFFSET         ((volatile unsigned int) 4)
#define STATUS_OFFSET_INPUT  ((volatile unsigned int) 0x0)
#define WSPACE_MASK           ((volatile unsigned int) 0xFFFF)
#define RSPACE_MASK           ((volatile unsigned int) 0xFF)

void PrintHexDigit(int c);
void PrintChar(char c);
void PrintString(char* string);
char getChar();


#endif /* _CHARIO_H_ */

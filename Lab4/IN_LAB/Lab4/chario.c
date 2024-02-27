/* for standalone testing of this file by itself using the simulator,
   keep the following line, but for in-lab activity with the Monitor Program
   to have a multi-file project, comment out the following line */

#include <stdio.h>
#include "chario.h"


#define TEST_CHARIO


/* no #include statements should be required, as the character I/O functions
   do not rely on any other code or definitions (the .h file for these
   functions would be included in _other_ .c files) */


/* because all character-I/O code is in this file, the #define statements
   for the JTAG UART pointers can be placed here; they should not be needed
   in any other file */



void PrintChar(char c){
   unsigned int JTAG_status;
   do{
      JTAG_status = *JTAG_UART_STATUS;
      JTAG_status = ((JTAG_status>>16) & WSPACE_MASK); //shift right 16 bits for an andhi operation
   }while(JTAG_status == 0);
   *JTAG_UART_BASE = c;
   return;
   
}
void PrintHexDigit(int c){
   if(c < 10){
      c += '0';
   }
   else{
      c -= 10;
      c += 'A';
   }

   PrintChar((char)c);

}

void PrintString(char* string){
   while(*string != '\0'){
      PrintChar(*string);
      string++;
   }

}
char getChar(){
   unsigned int JTAG_input_status;
   do{
      JTAG_input_status = *(JTAG_UART_BASE + STATUS_OFFSET_INPUT);
   }while((JTAG_input_status & 0x8000) == 0);
   JTAG_input_status = (JTAG_input_status & RSPACE_MASK);
   return JTAG_input_status;

}




/* place the full function definitions for the character-I/O routines here */





// #ifdef TEST_CHARIO

// /* this portion is conditionally compiled based on whether or not
//    the symbol exists; it is only for standalone testing of the routines
//    using the simulator; there is a main() routine in lab4.c, so
//    for the in-lab activity, the following code would conflict with it */

// int main (void)
// {

//   /* place calls here to the various character-I/O routines
//      to test their behavior, e.g., PrintString("hello\n");  */
//       PrintString("Printing Hex Digit:\n");
//       PrintHexDigit(0x5);
//       PrintString("\nGetting Char Until q is entered\n");

//       char c;
//       do{
//          c = getChar();
//          PrintChar(c);
//       }while(c != 'q');
//    return 0;
// } 

// #endif /* TEST_CHARIO */

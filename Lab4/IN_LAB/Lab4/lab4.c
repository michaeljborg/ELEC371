#include <stdio.h>

#include "nios2_control.h"
#include "chario.h"
#include "leds.h"
#include "timer1.h"
#include "timer2.h"

#include "hex.h"
#include "switches.h"


#include "adc.h"



/* place additional #define macros here */

/* define global program variables here */

/* place additional functions here */

unsigned int timer1_flag = 0;
unsigned int timer2_flag = 0;

unsigned int leftmost = 0;


int led_patterns[] = {0x201, 0x102, 0x084, 0x048, 0x030};
int current_leds = 0;
void timer1_isr(void){
	//clear interupt
	*TIMER1_STATUS = 0;
	if(current_leds >= 5){
		current_leds = 0;
	}
	*LEDS = led_patterns[current_leds];
	current_leds++;
	timer1_flag = 1;


}
void timer2_isr(void){
	//clear interupt
	*TIMER2_STATUS = 0;
	timer2_flag = 1;

}



/*-----------------------------------------------------------------*/

/* this routine is called from the_exception() in exception_handler.c */

void interrupt_handler(void)
{
	unsigned int ipending;

	/* read current value in ipending register */
	ipending = NIOS2_READ_IPENDING();
	if(ipending & TIMER1_TO_BIT){
		timer1_isr();
	}
	if(ipending & TIMER2_TO_BIT){
		timer2_isr();
	}

	/* read current value in ipending register */

	/* do one or more checks for different sources using ipending value */

	/* remember to clear interrupt sources */
}

/*-----------------------------------------------------------------*/

void Init (void)
{
	/* initialize software variables */
   unsigned int ienable = 0;

   int timer2_time = 0x017D7840; //0.5s
   int timer1_time = 0x00989680; //0.2s



	/* set up each hardware interface */
   *(TIMER1_START_LO) = (timer1_time & 0xFFFF);
   *(TIMER1_START_HI) = ((timer1_time >> 16) & 0xFFFF);//start_high
   *(TIMER1_CONTROL) =  (int)0x7; //start, cont, to

   *(TIMER2_START_LO) = (timer2_time & 0xFFFF);
   *(TIMER2_START_HI) = ((timer2_time >> 16) & 0xFFFF);//start_high
   *(TIMER2_CONTROL) =  (int)0x7; //start, cont, to




	/* set up ienable */

   ienable= (TIMER1_TO_BIT | TIMER2_TO_BIT) | ienable;
   //ienable = 0x1C000;
   NIOS2_WRITE_IENABLE( ienable ); /* set interrupt mask bits for levels 0 (interval timer)*/

   /* enable global recognition of interrupts in procr. status reg. */
   NIOS2_WRITE_STATUS( 1 );
   // asm ("mov	r2, 0x1");
   // asm ("wrctl	status, r2");
   // asm ("mov	r2, 0x1");
   // asm ("ldw	ienable, r2");
}

/*-----------------------------------------------------------------*/

int main (void)
{
	Init ();	/* perform software/hardware initialization */
	InitADC(2, 2); //0b10 0b10  
	PrintChar('\n'); //blank line
	PrintString("ELEC 371 lab4 by Luka Rodrigues and Michael Borg\n");
	PrintChar('\n'); //blank line
	PrintString("Please enter either l/L or anything else");
	char user_input = getChar();
	if(user_input == 'l' || user_input == 'L'){
		leftmost = 1;
	}

	PrintString("\n\nA/D result divided by 16: 0x?");


	while (1)
	{
		/* fill in body of infinite loop */
		


		//check for timer1_flag
		if(timer1_flag){
			timer1_flag = 0;
			unsigned int adc_result = (ADConvert())/16;
			PrintChar('\b');
			PrintHexDigit(adc_result); //this value must be between 0 and 15


		}

		if(timer2_flag){
			timer2_flag = 0;

			int switches_val = (*SWITCHES) & 0x07F;// make sure top three switches dont impact value

			if(leftmost){
				*HEXDISPLAY = (switches_val << 24);

			}else{
				*HEXDISPLAY = switches_val;

			}
		}

	}

	return 0;	/* never reached, but main() must return a value */
}

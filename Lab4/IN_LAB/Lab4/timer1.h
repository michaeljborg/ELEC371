#ifndef _TIMER1_H_
#define _TIMER1_H_


/* define pointer macros for accessing the timer interface registers */

#define TIMER1_STATUS	((volatile unsigned int *) 0x10004020)

#define TIMER1_CONTROL	((volatile unsigned int *) 0x10004024)

#define TIMER1_START_LO	((volatile unsigned int *) 0x10004028)

#define TIMER1_START_HI	((volatile unsigned int *) 0x1000402C)

#define TIMER1_SNAP_LO	((volatile unsigned int *) 0x10004030)

#define TIMER1_SNAP_HI	((volatile unsigned int *) 0x10004034)


/* define a bit pattern reflecting the position of the timeout (TO) bit
   in the timer status register */

#define TIMER1_TO_BIT 0x4000


#endif /* _TIMER1_H_ */
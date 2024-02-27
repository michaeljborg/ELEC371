#ifndef _TIMER2_H_
#define _TIMER2_H_


/* define pointer macros for accessing the timer interface registers */

#define TIMER2_STATUS	((volatile unsigned int *) 0x10004040)

#define TIMER2_CONTROL	((volatile unsigned int *) 0x10004044)

#define TIMER2_START_LO	((volatile unsigned int *) 0x10004048)

#define TIMER2_START_HI	((volatile unsigned int *) 0x1000404C)

#define TIMER2_SNAP_LO	((volatile unsigned int *) 0x10004050)

#define TIMER2_SNAP_HI	((volatile unsigned int *) 0x10004054)


/* define a bit pattern reflecting the position of the timeout (TO) bit
   in the timer status register */

#define TIMER2_TO_BIT 0x8000


#endif /* _TIMER2_H_ */
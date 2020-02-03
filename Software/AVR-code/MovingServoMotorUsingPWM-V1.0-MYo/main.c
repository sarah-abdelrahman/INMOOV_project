
/**************************/
/*	Author : Mina Yousry  */
/*	Version : 1.0         */
/*	Date : 3/2/2020	      */		
/**************************/


#include <avr/interrupt.h>
#include <util/delay.h>
#include <avr/io.h>
#include "STD_TYPES.h"

#define SET_BIT(VAR,BITNO) (VAR) |=  (1 << (BITNO))
#define CLR_BIT(VAR,BITNO) (VAR) &= ~(1 << (BITNO))
#define TOG_BIT(VAR,BITNO) (VAR) ^=  (1 << (BITNO))
#define GET_BIT(VAR,BITNO) (((VAR) >> (BITNO)) & 0x01)


void main (void)
{
	
	
	DDRD=255;

	/*set clock of TCCR1 /64 prescaling*/
	CLR_BIT(TCCR1B,2);
	
	SET_BIT(TCCR1B,0);
	
	SET_BIT(TCCR1B,1);

	/*TO SET TIMER on mode 2 PWM,Phase correct,9-bit*/
	
	SET_BIT(TCCR1A,1);
	
	CLR_BIT(TCCR1A,0);


	/*copmare output fast pwm Mode*/
	SET_BIT(TCCR1A,7);
	
	CLR_BIT(TCCR1A,6);

	/*total value of ticks we need in 16 bit for 20ms running freq 8000000 Mhz*/
	ICR1=(u16) 2500;


while(1)

				{
	/*set value for servo or compare value*/
	_delay_ms(500);
	
	OCR1A=(u16)30;
	
	_delay_ms(500);
	
	OCR1A=(u16)250;

}
	
}

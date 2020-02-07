#include <avr/interrupt.h>
#include <util/delay.h>
#include <avr/io.h>

#include "STD_TYPES.h"
#include "BIT_MATH.h"
#include "DIO_interface.h"

#define RIGHT		(u16)32
#define MIDDLE		(u16)47
#define LEFT		(u16)63

void main(void)
{

	/* Setting the direction of pin 5 on port D to output */
	setPinDir('D', 5, 1);

	/* Set clock of TCCR1 /64 prescaler */
	SET_BIT(TCCR1B, 2);
	CLR_BIT(TCCR1B, 0);
	CLR_BIT(TCCR1B, 1);

	/* Fast PWM mode 14 (using ICR1 as top value) */
	CLR_BIT(TCCR1A, 0);
	SET_BIT(TCCR1A, 1);

	SET_BIT(TCCR1B, 3);
	SET_BIT(TCCR1B, 4);

	/* Clear  on compare match when up-counting , Set on compare match when down-counting. */
	SET_BIT(TCCR1A, 7);
	CLR_BIT(TCCR1A, 6);

	/* Total value of ticks we need in 16 bit for 20ms running frequency 8 Mhz*/
	/* Setting the top value of the register to 2500 */
	ICR1 = (u16) 625;

	while (1)
	{
		_delay_ms(3000);
		/* 1.5ms high pulse -> 0 degrees (middle)*/
		OCR1A = MIDDLE;

		_delay_ms(3000);
		/* 1ms high pulse -> -90 degrees (Left) */
		OCR1A = LEFT;

		_delay_ms(3000);
		/* 2ms high pulse -> 90 degrees (Right) */
		OCR1A = RIGHT;
	}

}

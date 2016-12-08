//******************************************************************************
//
// main.c - Blinky program demonstration that the template works
//
//
//******************************************************************************
#include "TM4C123GH6PM.h"

void wait(uint32_t ulPeriod)
{
    for (uint32_t ulLoop = 0; ulLoop < ulPeriod; ulLoop++);
}

int main(void)
{
    uint32_t dummy;

    SYSCTL->RCGCGPIO |= (1UL << 5); // Provide clock to GPIOF
    dummy = SYSCTL->RCGCGPIO; // Dummy read after enabling peripheral
    GPIOF->DIR |= (1UL << 1); // Set GPIOF1 as output pin
    GPIOF->DR2R |= (1UL << 1); // Set GPIOF1 to 2mA drive strength
    GPIOF->PDR |= (1UL << 1); // Pull GPIOF1 output to ground
    GPIOF->DEN |= (1UL << 1); // Set GPIOF1 to be a digital pin

    while (1)
    {
        GPIOF->DATA |= (1UL << 1); // Turn on LED connected to GPIOF1

        wait(10000000); // Small delay

        GPIOF->DATA &= ~(1UL << 1); // Turn off LED connected to GPIOF1

        wait(10000000); // Small delay
    }
}


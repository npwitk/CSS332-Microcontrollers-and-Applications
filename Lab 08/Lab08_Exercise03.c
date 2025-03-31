#include <avr/io.h>
#include <avr/interrupt.h>
#define F_CPU 16000000UL
#include <util/delay.h>

unsigned char z = 200; // Counter variable

void PIN_SETUP() {
    DDRB |= (1<<0); // Set PB0 as an output -> LED0
    PORTB &= ~(1<<0); // Ensure PB0 starts LOW (LED0 OFF)
    DDRB |= (1<<1); // Set PB1 as an output -> LED1
    PORTB &= ~(1<<1); // Ensure PB1 starts LOW (LED1 OFF)
    DDRD &= ~(1<<4); // Set PD4 as an input -> SW
    PORTD |= (1<<4); // Enable internal pull-up resistor for PD4 (default HIGH)
}

void TIMER0_SETUP() {
    TCNT0 = 0xB2; // Load initial timer value to adjust timing
    TCCR0A = 0x00; // Normal mode operation
    TCCR0B = 0x05; // Prescaler = 1024, starts Timer0
}

int main() {
    PIN_SETUP(); // Configure input/output pins
    TIMER0_SETUP(); // Configure Timer0
    TIMSK0 = (1<<TOIE0); // Enable Timer0 overflow interrupt
    sei(); // Enable global interrupts
    
    while (1) {
        if (~PIND & (1<<4)) { // Check if switch (PD4) is pressed (active low)
            PORTB |= (1<<0); // Turn LED0 ON (PB0=1)
        } else {
            PORTB &= ~(1<<0); // Turn LED0 OFF (PB0=0)
        }
        _delay_ms(100); // Debounce delay for the switch
    }
    return 0;
}

ISR(TIMER0_OVF_vect) { // Timer0 overflow interrupt service routine
    z--; // Decrement counter variable
    if (z == 0) { // If counter reaches zero
        z = 200; // Reset counter for approximately 1-second delay
        PORTB ^= (1<<1); // Toggle LED1 (PB1) state
    }
    TCNT0 = 0xB2; // Reload timer count for next cycle
}

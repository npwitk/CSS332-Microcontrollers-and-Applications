#include <avr/io.h>
#include <avr/interrupt.h>

unsigned char z = 2;

void PIN_SETUP() {   // A function to set up the pin modes
    DDRB |= (1<<0);  // Set PB0 as an output -> LED0
    PORTB &= ~(1<<0); // Set PB0 = 0
    DDRB |= (1<<1);  // Set PB1 as an output -> LED1
    PORTB &= ~(1<<1); // Set PB1 = 0
    DDRD &= ~(1<<4);  // Set PD4 as an input -> SW
    PORTD |= (1<<4);  // Pull-up resistor for PD4
    PORTC |= (1<<0);  // Pull-up resistor for PC0 (Pin Change Interrupt)
}

int main() {
    PIN_SETUP();      // Call the PIN_SETUP function
    PCICR = 0x02;     // Enable the PORTC Pin Change Interrupt
    PCMSK1 = 0x01;    // Enable the interrupt from PC0
    sei();            // Enable the global interrupt

    while (1) {
        if (~PIND & (1<<4)) {  // Check PD4=0?
            PORTB |= (1<<0);   // Yes, PB0=1 -> LED0 on
        } else {
            PORTB &= ~(1<<0);  // No, PB0=0 -> LED0 off
        }
    }

    return 0;
}

ISR (PCINT1_vect) {  // ISR of INT0 interrupt
    z--;
    if (z == 0) {
        PORTB ^= (1<<1);  // and toggle PB1
        z = 2;
    }
}

#include <avr/io.h>
#include <avr/interrupt.h>

void PIN_SETUP() {
    DDRB |= (1<<0); // Set PB0 as an output -> LED0
    PORTB &= ~(1<<0); // Set PB0 = 0
    DDRB |= (1<<1); // Set PB1 as an output -> LED1
    PORTB &= ~(1<<1); // Set PB1 = 0
    DDRD &= ~(1<<4); // Set PD4 as an input -> SW
    PORTD |= (1<<4); // Pull-up resistor for PD4
    PORTD |= (1<<2); // Pull-up resistor for PD2(INT0)
}


int main() {
    PIN_SETUP();
    EIMSK = 0x01; // Enable the INT0 Interrupt
    EICRA = 0x02; // Set the falling-edge trigger
    sei(); // Enable the global interrypt
    while (1) {
        if(~PIND & (1<<4)) { // Check PD4 = 0
            PORTB |= (1<<0); // Yes, PB0=1 -> LED0 on
        } else {
            PORTB &= ~(1<<0); // No, PB0=0 -> LED0 off
        }
    }
    return (0);
}

ISR(INT0_vect) { // ISR of INT0 interrupt
    PORTB ^= (1<<1); // toggle PB1
}

#include <avr/io.h>
#include <avr/interrupt.h>
#define F_CPU 16000000UL
#include <util/delay.h>

unsigned char z = 200;

void PIN_SETUP() {
    DDRB |= (1<<0); // Set PB0 as an output -> LED0
    PORTB &= ~(1<<0); // Set PB0 = 0
    DDRB |= (1<<1); // Set PB1 as an output -> LED1
    PORTB &= ~(1<<1); // Set PB1 = 0
    DDRD &= ~(1<<4); // Set PD4 as an input -> SW
    PORTD |= (1<<4); // Pull-up resistor for PD4
}

void TIMER0_SETUP() {
    TCNT0 = 0xB2; // Set initial value of Timer0
    TCCR0A = 0x00; // Set the normal mode
    TCCR0B = 0x05; // Pre-scaling = 1024, start the timer
}

int main() {
    PIN_SETUP();
    TIMER0_SETUP();
    TIMSK0 = (1<<TOIE0); // Enable the Timer0 overflow interrupt
    sei(); // Enable the global interrypt
    while (1) {
        if(~PIND & (1<<4)) { // Check PD4 = 0
            PORTB |= (1<<0); // Yes, PB0=1 -> LED0 on
        } else {
            PORTB &= ~(1<<0); // No, PB0=0 -> LED0 off
        }
        _delay_ms(100);
    }
    return (0);
}

ISR(TIMER0_OVF_vect) { // ISR of Timer0 interrupt
    z--;
    if (z == 0) { // Check z = 0
        z = 200; // Yes, reset z = 200
        PORTB ^= (1<<1); // And toggle PB1
    }
    TCNT0 = 0xB2; // Set TCNT0 = 0xB2
}

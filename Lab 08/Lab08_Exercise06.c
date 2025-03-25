#include <avr/io.h>
#include <avr/interrupt.h>
#define F_CPU 16000000UL
#include <util/delay.h>

unsigned char y = 200;
unsigned char z = 2;

void PIN_SETUP() {   // A function to set up the pin modes
    DDRB |= (1<<0);  // Set PB0 as an output -> LED0
    PORTB &= ~(1<<0); // Set PB0 = 0
    DDRB |= (1<<1);  // Set PB1 as an output -> LED1
    PORTB &= ~(1<<1); // Set PB1 = 0
    DDRB |= (1<<2);  // Set PB2 as an output -> LED2
    PORTB &= ~(1<<2); // Set PB2 = 0
    DDRB |= (1<<3);  // Set PB3 as an output -> LED3
    PORTB &= ~(1<<3); // Set PB3 = 0
    DDRD &= ~(1<<4);  // Set PD4 as an input -> SW
    PORTD |= (1<<4);  // Pull-up resistor for PD4
    PORTD |= (1<<3);  // Pull-up resistor for PD3 (INT1)
    PORTD |= (1<<5);  // Pull-up resistor for PD5 (Pin Change)
}

void TIMER0_SETUP() {   // A function to set TIMER0
    TCNT0 = 0xB2;   // Set initial value of Timer0
    TCCR0A = 0x00;  // Set the normal mode
    TCCR0B = 0x05;  // Pre-scaling = 1024, start the timer
}

int main() {
    PIN_SETUP();      // Call the PIN_SETUP function
    TIMER0_SETUP();   // Call the TIMER0_SETUP function

    // INT0 Interrupt Setup
    EIMSK = 0x02;     // Enable the INT0 Interrupt
    EICRA = 0x08;     // Set the falling-edge trigger

    // PD5 Pin Change Interrupt
    PCICR = 0x04;     // Enable the PORTD Pin Change Interrupt
    PCMSK2 = 0x20;    // Enable the interrupt from PD5

    // Timer0 Overflow Interrupt
    TIMSK0 = (1<<TOIE0);  // Enable the Timer0 Overflow Interrupt

    sei();            // Enable the global interrupt

    while (1) {
        if (~PIND & (1<<4)) {  // Check PD4=0?
            PORTB |= (1<<0);   // Yes, PB0=1 -> LED0 on
        } else {
            PORTB &= ~(1<<0);  // No, PB0=0 -> LED0 off
        }
        _delay_ms(100); // Delay added between iterations
    }

    return 0;
}

// ISR for INT1 interrupt
ISR (INT1_vect) {
    PORTB ^= (1<<1); // Toggle PB1
}

// ISR for Pin Change Interrupt on PD5
ISR (PCINT2_vect) {
    z--;
    if (z == 0) {
        PORTB ^= (1<<2); // Toggle PB2
        z = 2;
    }
}

// ISR for Timer0 Overflow Interrupt
ISR (TIMER0_OVF_vect) {
    y--;
    if (y == 0) {
        y = 200;        // Reset y = 200
        PORTB ^= (1<<3); // Toggle PB3
    }
    TCNT0 = 0xB2;       // Reload Timer0
}

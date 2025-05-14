#include <avr/io.h>
#include <avr/interrupt.h>

unsigned char z = 8;

void PIN_SETUP() {
    DDRB |= (1<<0); // Set PB0 as output for LED0
    PORTB &= ~(1<<0); // Set PB0 initial state to low
    DDRB |= (1<<1); // Set PB1 as output for LED1
    PORTB &= ~(1<<1); // Set PB1 initial state to low
    DDRB |= (1<<2); // Set PB2 as output for LED2
    PORTB &= ~(1<<2); // Set PB2 initial state to low

    // Configure switch inputs with pull-up resistors
    DDRD &= ~(1<<4); // Set PD4 as input for SW0
    PORTD |= (1<<4); // Enable pull-up for PD4
    DDRD &= ~(1<<3); // Set PD3 as input for SW1 (INT1)
    PORTD |= (1<<3); // Enable pull-up for PD3
    DDRC &= ~(1<<2); // Set PC2 as input for SW2
    PORTC |= (1<<2); // Enable pull-up for PC2
}

int main() {
    PIN_SETUP();      // Call the PIN_SETUP function
    
    // Configure INT1 for rising edge trigger
    EIMSK = 0x10; // Enable INT1
    EICRA = 0x0C; // Set for rising edge
    
    PCICR = 0x02;     // Enable the PORTC Pin Change Interrupt
    PCMSK1 = 0x04;    // Enable the interrupt from PC2

    sei();            // Enable the global interrupt

    while (1) {
        if (~PIND & (1<<4)) {  // Check if SW0 is pressed
            PORTB |= (1<<0);   // Turn on LED0
        } else {
            PORTB &= ~(1<<0);  // Turn off LED0
        }
    }

    return 0;
}

// ISR for INT1 (Task 2)
ISR(INT1_vect) {
    PORTB ^= (1<<1); // Toggle LED1
}

// ISR for Pin Change Interrupt (Task 3)
ISR(PCINT1_vect) {  // ISR of INT0 interrupt
    z--;
    if (z == 0) {
        PORTB ^= (1<<2);  // Toggle LED2
        z = 8;            // Reset counter to initial value
    }
}

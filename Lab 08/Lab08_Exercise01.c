#include <avr/io.h>
#define F_CPU 16000000UL  // Define CPU clock speed as 16MHz
#include <util/delay.h>

void PIN_SETUP() {
    DDRB |= (1<<0);   // Set PB0 (digital pin 8 on Arduino UNO) as an output
    PORTB &= ~(1<<0); // Ensure PB0 is LOW initially (LED off)
}

int main() {
    PIN_SETUP(); // Call function to set up pin modes
    
    while (1) {  // Infinite loop to keep the program running
        PORTB |= (1<<0);  // Turn ON LED by setting PB0 HIGH
        _delay_ms(1000);  // Wait for 1000 milliseconds (1 second)
        PORTB &= ~(1<<0); // Turn OFF LED by setting PB0 LOW
        _delay_ms(1000);  // Wait for 1000 milliseconds (1 second)
    }
    return 0; // Program should never reach here
}

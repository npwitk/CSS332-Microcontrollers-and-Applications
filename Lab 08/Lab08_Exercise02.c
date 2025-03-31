#include <avr/io.h>

void PIN_SETUP() {
    DDRB |= (1<<0);   // Set PB0 (digital pin 8) as an output
    PORTB &= ~(1<<0); // Ensure PB0 is LOW initially (LED OFF)
    
    DDRD &= ~(1<<4);  // Set PD4 (digital pin 4) as an input
    PORTD |= (1<<4);  // Enable internal pull-up resistor on PD4 (default HIGH)
}

int main() {
    PIN_SETUP();
    
    while (1) {  // Infinite loop to continuously check button state
        if(~PIND & (1<<4)) { // Check if button (PD4) is pressed (logic LOW)
            PORTB |= (1<<0);  // Turn ON LED (set PB0 HIGH)
        } else { 
            PORTB &= ~(1<<0); // Turn OFF LED (set PB0 LOW)
        }
    }
    return (0); // Program should never reach here
}

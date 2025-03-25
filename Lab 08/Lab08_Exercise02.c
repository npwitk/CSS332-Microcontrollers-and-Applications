#include <avr/io.h>

void PIN_SETUP() {
    DDRB |= (1<<0);
    PORTB &= ~(1<<0);
    DDRD &= ~(1<<4);
    PORTD |= (1<<4);
}

int main() {
    PIN_SETUP();
    while (1) {
        if(~PIND & (1<<4)) {
            PORTB |= (1<<0);
        } else {
            PORTB &= ~(1<<0);
        }
    }
    return (0);
}

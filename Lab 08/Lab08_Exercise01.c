#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>

void PIN_SETUP() {
    DDRB |= (1<<0);
    PORTB &= ~(1<<0);
}

int main() {
    PIN_SETUP();
    while (1) {
        PORTB |= (1<<0);
        _delay_ms(1000);
        PORTB &= ~(1<<0);
        _delay_ms(1000);
    }
    return (0);
}

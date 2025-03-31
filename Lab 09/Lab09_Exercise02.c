#include <avr/io.h>

void usart_init(void) {
    UCSR0B = (1<<RXEN0);         // Enable USART receiver
    UCSR0C = (1<<UCSZ01)|(1<<UCSZ00);  // Async, 8 bits,
    UBRR0L = 103;                // Baud rate = 9600
}

void pin_setup(void) { // Set output pins
    DDRB = 0xFF;
    PORTB = 0x00;
    DDRD = 0xFF;
    PORTD = 0x00;
}

int main(void) {
    pin_setup();
    usart_init();
    while (1) {      // Receive the input and show it on output pins
        while (!(UCSR0A&(1<<RXC0))); // Wait until RXC0 flag = 1
        PORTB = (UDR0 & 0x3F);     // Show the input on pins PB0 - PB5
        PORTD = (UDR0 & 0xC0);     // Show the input on pins PD6 - PD7
    }
    return 0;
}

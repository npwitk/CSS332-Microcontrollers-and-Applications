#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>

void usart_init (void) {
    UCSR0B = (1<<TXEN0);         // Enable USART transmitter
    UCSR0C = (1<<UCSZ01)|(1<<UCSZ00); // Async, 8 bits,
    UBRR0L = 0x67;               // Baud rate = 9600
}

void pin_setup (void) { // Set input pins
    DDRB = 0x00;
    PORTB = 0xFF;
    DDRD = 0x00;
    PORTD = 0xFF;
}

int main(void) {
    usart_init();
    pin_setup();
    while (1) {
        while (!(UCSR0A&(1<<UDRE0)));    // Wait until UDRE0 flag = 1
        UDR0= (PIND & 0xC0) | (PINB & 0x3F);  // Store inputs in UDR0
        _delay_ms(5000);         // Wait for 5 seconds
    }
    return 0;
}

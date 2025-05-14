#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>

// Function to initialize UART
void usart_init(void) {
    UCSR0B = (1<<RXEN0); // Enable USART transmitter
    UCSR0C = (1<<UCSZ01)|(1<<UCSZ00); // Async, 8 bits
    UBRR0L = 103; // Baud rate = 9600
}

void pin_setup(void) {
    DDRB |= (1<<0); // Set PB0 as output (LED0)
    PORTB &= ~(1<<0); // Set LED0 initial state to OFF
    DDRB |= (1<<1); // Set PB1 as output (LED1)
    PORTB &= ~(1<<1); // Set LED1 initial state to OFF
}

// Function to send a character over UART
void usart_send(unsigned char data) {
    while (!(USCR0A&(1<<UDRE0))); // Wait until UDR0 is empty
    UDR0 = data; // Send data
}

int main(void) {
    unsigned char received_data;
    pin_setup();
    usart_init();

    while(1) {
        // Wait until data is received
        while (!(UCSR0A&(1<<RXC0))); // Check if data is available

        // Read the received data
        received_data = UDR0;

        // Process received commands
        if (received_data == '1') {
            PORTB ^= (1<<0);
        } else if (received_data == '2') {
            PORTB ^= (1<<1);
        }
    }
    return 0;
}
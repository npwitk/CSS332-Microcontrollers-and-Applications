#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>

// Function to initialize UART
void usart_init(void) {
    UCSR0B = (1<<TXEN0); // Enable USART transmitter
    UCSR0C = (1<<UCSZ01)|(1<<UCSZ00); // Async, 8 bits
    UBRR0L = 103; // Baud rate = 9600
}

void pin_setup(void) {
    DDRD &= ~(1<<2); // Set PD2 as input (Switch 0)
    PORTD |= (1<<2); // Enable pull-up for Switch 0
    DDRD &= ~(1<<3); // Set PD3 as input (Switch 1)
    PORTD |= (1<<3); // Enable pull-up for Switch 1
}

// Function to send a character over UART
void usart_send(unsigned char data) {
    while (!(USCR0A&(1<<UDRE0))); // Wait until UDR0 is empty
    UDR0 = data; // Send data
}

int main(void) {
    pin_setup();
    usart_init();

        while(1) {
        
            // Check if Switch 0 is pressed (PD2 is LOW)
        if (!(PIND&(1<<2))) {
            usart_send('1'); // Send command to toggle LED0
            _delay_ms(200);
        }
            
        // Check if Switch 1 is pressed (PD3 is LOW)
        if (!(PIND&(1<<3))) {
            usart_send('2'); // Send command to toggle LED1
            _delay_ms(200);
        }

        _delay_ms(50); // Small polling delay
     }

    return 0;
}
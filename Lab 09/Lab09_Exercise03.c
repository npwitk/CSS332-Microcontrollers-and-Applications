#include <avr/io.h>

int main(void) {
    unsigned char ch;
    
    UCSR0B=(1<<TXEN0)|(1<<RXEN0);  // USART setup
    UCSR0C=(1<<UCSZ01)|(1<<UCSZ00);
    UBRR0L=103;
    
    while (1) {
        while (!(UCSR0A&(1<<RXC0))); // Wait for the input from Terminal
        ch=UDR0;
        if (ch>='a'&& ch<='z') {
            ch+=('A'-'a'); // update what stored in ch to be its capital letter
            while (!(UCSR0A&(1<<UDRE0))); // Wait to send ch to Terminal
            UDR0=ch;
        }
    }
    return 0;
}

#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>

void pin_setup(void) { //Set the pin modes
    DDRC = 0x00;
    DDRB = 0xFF;
    DDRD = 0xFF;
    PORTB = 0x00;
    PORTD = 0x00;
}

void ADC_setup(void) {
    ADCSRA = 0x87;   // Enable the ADC and use CK/128
    ADMUX = 0x40;    // Vref = AVCC and use ADC0 pin, right-justified
}

int main(void) {
    pin_setup();
    ADC_setup();
    while (1) {
        ADCSRA |= (1<<ADSC);     // Start the ADC conversion
        while ((ADCSRA&(1<<ADIF)) == 0);  // Wait for the conversion
        PORTD = ADCL;  // Last 8 bits shown on pins D
        PORTB = ADCH;  // First 8 bits shown on pins B
        _delay_ms(100);
    }
    return 0;
}

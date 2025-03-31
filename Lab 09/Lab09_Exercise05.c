#include <avr/io.h>

void pin_setup(void) { // Set the pin modes
    DDRC = 0x00;
    DDRB = 0xFF;
    PORTB = 0x00;
}

void ADC_setup(void) {
    ADCSRA = 0x87;   // Enable the ADC and use CK/128
    ADMUX = 0x42;    // Vref = AVCC = 5V and use ADC2 pin, right-justified
}

int main(void) {
    pin_setup();
    ADC_setup();
    while (1) {
        ADCSRA |= (1<<ADSC);     // Start the ADC conversion
        while ((ADCSRA&(1<<ADIF)) == 0);  // Wait for the conversion
        if (ADC <= 308) { // If ADC < or = 1.5V
            PORTB = 0x01; // Set PB0=1
        } else if ((ADC > 308) && (ADC < 614)) { // If 1.5V < ADC < 3V
            PORTB = 0x02; // Set PB1=1
        } else { // If ADC > or = 3V
            PORTB = 0x04; // Set PB2=1
        }
    }
    return 0;
}

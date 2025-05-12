#include <avr/io.h>
#define F_CPU 16000000UL
#include <util/delay.h>

// Function to initialize pins
void pin_setup(void) {
    DDRC = 0x00;   // Set PORTC as input (ADC0 and ADC1)
    DDRB = 0x07;   // Set PB0, PB1, PB2 as outputs (LEDs)
    PORTB = 0x00;  // Initialize all LEDs as OFF
}

// Function to initialize ADC0
void ADC0_setup(void) {
    ADCSRA = 0x87;   // Enable ADC, set prescaler to 128
    ADMUX = 0x40;    // Vref = AVCC, select ADC0 channel, right-justified
}

// Function to initialize ADC1
void ADC1_setup(void) {
    ADCSRA = 0x87;   // Enable ADC, set prescaler to 128
    ADMUX = 0x41;    // Vref = AVCC, select ADC1 channel, right-justified
}

// Function to read from ADC
int read_ADC(void) {
    ADCSRA |= (1 << ADSC);
    while ((ADCSRA & (1 << ADIF)) == 0);
    return ADC;
}

int main(void) {
    int adc0_value, adc1_value;
    
    pin_setup();
    
    while (1) {
        ADC0_setup();
        adc0_value = read_ADC();
        
        ADC1_setup();
        adc1_value = read_ADC();
        
        PORTB = 0x00; // Turn off all LEDs
        
        if (adc0_value > adc1_value) {
            PORTB = 0x01;
        } else if (adc0_value < adc1_value) {
            PORTB = 0x02;
        } else {
            PORTB = 0x04;
        }
        
        _delay_ms(100);
    }
    
    return 0;
}
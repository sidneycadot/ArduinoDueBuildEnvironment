
#define ARDUINO_MAIN
#include "Arduino.h"

/*
 * \brief Main entry point of Arduino application
 */
int main(void)
{
    init();

    delay(1);

    const int led = 13;

    pinMode(led, OUTPUT);

    for (;;)
    {
        digitalWrite(led, HIGH);
        delay(MSEC_DELAY);
        digitalWrite(led, LOW);
        delay(MSEC_DELAY);
    }

    return 0;
}

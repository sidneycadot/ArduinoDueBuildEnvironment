
#include "Arduino.h"

void setup();
void loop();

int led = 13;

void setup()
{
    pinMode(led, OUTPUT);
}


void loop()
{
    digitalWrite(led, HIGH);
    delay(MSEC_DELAY);
    digitalWrite(led, LOW);
    delay(MSEC_DELAY);
}

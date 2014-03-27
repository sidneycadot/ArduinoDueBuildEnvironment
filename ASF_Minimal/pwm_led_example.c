
///////////////////////
// pwm_led_example.c //
///////////////////////

#include "asf.h"
#include "stdio_serial.h"
#include "conf_board.h"
#include "conf_clock.h"

// PWM frequency in Hz

#define PWM_FREQUENCY      4000

// Period value of PWM output waveform

#define PERIOD_VALUE       100

// Initial duty cycle value

#define INIT_DUTY_VALUE    0

// PWM channel instance for LEDs

pwm_channel_t g_pwm_channel_led;

// Interrupt handler for the PWM controller.

void PWM_Handler(void)
{
    static uint32_t ul_count = 0;               // PWM counter value
    static uint32_t ul_duty = INIT_DUTY_VALUE;  // PWM duty cycle rate
    static uint8_t fade_in = 1;                 // LED fade in flag

    uint32_t events = pwm_channel_get_interrupt_status(PWM);

    // Interrupt on PIN_PWM_LED0_CHANNEL

    if ((events & (1 << PIN_PWM_LED0_CHANNEL)) == (1 << PIN_PWM_LED0_CHANNEL))
    {
        ++ul_count;

        // Fade in/out

        if (ul_count == (PWM_FREQUENCY / (PERIOD_VALUE - INIT_DUTY_VALUE)))
        {
            if (fade_in)
            {
                // Fade in
                ul_duty++;
                if (ul_duty == PERIOD_VALUE)
                {
                    fade_in = 0;
                }
            }
            else
            {
                // Fade out
                ul_duty--;
                if (ul_duty == INIT_DUTY_VALUE)
                {
                    fade_in = 1;
                }
            }

            // Set new duty cycle
            ul_count = 0;
            g_pwm_channel_led.channel = PIN_PWM_LED0_CHANNEL;
            pwm_channel_update_duty(PWM, &g_pwm_channel_led, ul_duty);
            g_pwm_channel_led.channel = PIN_PWM_LED1_CHANNEL;
            pwm_channel_update_duty(PWM, &g_pwm_channel_led, ul_duty);
        }
    }
}

static void configure_console(void)
{
    const usart_serial_options_t uart_serial_options =
    {
        .baudrate = CONF_UART_BAUDRATE,
        .paritytype = CONF_UART_PARITY
    };

    // Configure console UART

    sysclk_enable_peripheral_clock(CONSOLE_UART_ID);
    stdio_serial_init(CONF_UART, &uart_serial_options);
}

int main(void)
{
    // Initialize the SAM system

    sysclk_init();
    board_init();

    // Configure the console uart for debug information

    configure_console();

    // Output example information

    puts("hello, world!\r\n");

    // Enable PWM peripheral clock

    pmc_enable_periph_clk(ID_PWM);

    // Disable PWM channels for LEDs

    pwm_channel_disable(PWM, PIN_PWM_LED0_CHANNEL);
    pwm_channel_disable(PWM, PIN_PWM_LED1_CHANNEL);

    // Set PWM clock A as PWM_FREQUENCY * PERIOD_VALUE (clock B is not used)

    pwm_clock_t clock_setting =
    {
        .ul_clka = PWM_FREQUENCY * PERIOD_VALUE,
        .ul_clkb = 0,
        .ul_mck = sysclk_get_cpu_hz()
    };
    pwm_init(PWM, &clock_setting);

    // Initialize PWM channel for LED0

    g_pwm_channel_led.alignment = PWM_ALIGN_LEFT;       // Period is left-aligned
    g_pwm_channel_led.polarity = PWM_LOW;               // Output waveform starts at a low level
    g_pwm_channel_led.ul_prescaler = PWM_CMR_CPRE_CLKA; // Use PWM clock A as source clock
    g_pwm_channel_led.ul_period = PERIOD_VALUE;         // Period value of output waveform
    g_pwm_channel_led.ul_duty = INIT_DUTY_VALUE;        // Duty cycle value of output waveform
    g_pwm_channel_led.channel = PIN_PWM_LED0_CHANNEL;
    pwm_channel_init(PWM, &g_pwm_channel_led);

    // Enable channel counter event interrupt

    pwm_channel_enable_interrupt(PWM, PIN_PWM_LED0_CHANNEL, 0);

    // Initialize PWM channel for LED1

    g_pwm_channel_led.alignment = PWM_ALIGN_CENTER;     // Period is center-aligned
    g_pwm_channel_led.polarity = PWM_HIGH;              // Output waveform starts at a high level
    g_pwm_channel_led.ul_prescaler = PWM_CMR_CPRE_CLKA; // Use PWM clock A as source clock
    g_pwm_channel_led.ul_period = PERIOD_VALUE;         // Period value of output waveform
    g_pwm_channel_led.ul_duty = INIT_DUTY_VALUE;        // Duty cycle value of output waveform
    g_pwm_channel_led.channel = PIN_PWM_LED1_CHANNEL;
    pwm_channel_init(PWM, &g_pwm_channel_led);

    // Disable channel counter event interrupt

    pwm_channel_disable_interrupt(PWM, PIN_PWM_LED1_CHANNEL, 0);

    // Configure interrupt and enable PWM interrupt

    NVIC_DisableIRQ(PWM_IRQn);
    NVIC_ClearPendingIRQ(PWM_IRQn);
    NVIC_SetPriority(PWM_IRQn, 0);
    NVIC_EnableIRQ(PWM_IRQn);

    // Enable PWM channels for LEDs

    pwm_channel_enable(PWM, PIN_PWM_LED0_CHANNEL);
    pwm_channel_enable(PWM, PIN_PWM_LED1_CHANNEL);

    // Infinite loop

    while (1) {
        puts("sidney\r\n");
    }
}

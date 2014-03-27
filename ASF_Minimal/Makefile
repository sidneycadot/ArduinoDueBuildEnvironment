
.PHONY : subdirs default all program clean

ASF_DIR = ../xdk-asf-3.15.0

CC = arm-none-eabi-gcc

CFLAGS = -O1 -mcpu=cortex-m3 -mthumb -D=__sam3x8e__ -g3 \
        -pipe \
        -Wall -Wstrict-prototypes -Wmissing-prototypes -Werror-implicit-function-declaration -Wpointer-arith \
        -std=gnu99 \
        -fno-strict-aliasing -ffunction-sections -fdata-sections \
        -Wchar-subscripts -Wcomment -Wformat=2 -Wimplicit-int -Wmain -Wparentheses -Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs \
        -Wunused -Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef -Wshadow -Wbad-function-cast -Wwrite-strings -Wsign-compare \
        -Waggregate-return -Wmissing-declarations -Wformat -Wmissing-format-attribute -Wno-deprecated-declarations -Wpacked -Wredundant-decls \
        -Wnested-externs -Winline -Wlong-long -Wunreachable-code -Wcast-align \
        --param max-inline-insns-single=500

CPPFLAGS = \
        -D ARM_MATH_CM3=true -D BOARD=ARDUINO_DUE_X -D __SAM3X8E__ -D printf=iprintf -D scanf=iscanf \
        -I$(ASF_DIR)/common/boards \
        -I$(ASF_DIR)/common/services/clock \
        -I$(ASF_DIR)/common/services/gpio \
        -I$(ASF_DIR)/common/services/ioport \
        -I$(ASF_DIR)/common/services/serial \
        -I$(ASF_DIR)/common/services/serial/sam_uart \
        -I$(ASF_DIR)/common/utils \
        -I$(ASF_DIR)/common/utils/stdio/stdio_serial \
        -I$(ASF_DIR)/sam/boards \
        -I$(ASF_DIR)/sam/boards/arduino_due_x \
        -I$(ASF_DIR)/sam/drivers/pio \
        -I$(ASF_DIR)/sam/drivers/pmc \
        -I$(ASF_DIR)/sam/drivers/pwm \
        -I. \
        -I$(ASF_DIR)/sam/drivers/uart \
        -I$(ASF_DIR)/sam/drivers/usart \
        -I$(ASF_DIR)/sam/utils \
        -I$(ASF_DIR)/sam/utils/cmsis/sam3x/include \
        -I$(ASF_DIR)/sam/utils/cmsis/sam3x/source/templates \
        -I$(ASF_DIR)/sam/utils/header_files \
        -I$(ASF_DIR)/sam/utils/preprocessor \
        -I$(ASF_DIR)/thirdparty/CMSIS/Include \
        -I$(ASF_DIR)/thirdparty/CMSIS/Lib/GCC \
        -I$(ASF_DIR)/sam/drivers/pwm/pwm_led_example/sam3x8e_arduino_due_x/gcc

OBJS = common/services/clock/sam3x/sysclk.o                       \
       common/services/serial/usart_serial.o                      \
       common/utils/interrupt/interrupt_sam_nvic.o                \
       common/utils/stdio/read.o                                  \
       common/utils/stdio/write.o                                 \
       sam/boards/arduino_due_x/init.o                            \
       sam/drivers/pio/pio.o                                      \
       sam/drivers/pio/pio_handler.o                              \
       sam/drivers/pmc/pmc.o sam/drivers/pmc/sleep.o              \
       sam/drivers/pwm/pwm.o pwm_led_example.o                    \
       sam/drivers/uart/uart.o sam/drivers/usart/usart.o          \
       sam/utils/cmsis/sam3x/source/templates/exceptions.o        \
       sam/utils/cmsis/sam3x/source/templates/gcc/startup_sam3x.o \
       sam/utils/cmsis/sam3x/source/templates/system_sam3x.o      \
       sam/utils/syscalls/gcc/syscalls.o

default : pwm_led_example_flash.bin pwm_led_example_sram.bin

	# show hashes
	md5sum $^

common/services/clock/sam3x/sysclk.o : $(ASF_DIR)/common/services/clock/sam3x/sysclk.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

common/services/serial/usart_serial.o : $(ASF_DIR)/common/services/serial/usart_serial.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

common/utils/interrupt/interrupt_sam_nvic.o : $(ASF_DIR)/common/utils/interrupt/interrupt_sam_nvic.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

common/utils/stdio/read.o : $(ASF_DIR)/common/utils/stdio/read.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

common/utils/stdio/write.o : $(ASF_DIR)/common/utils/stdio/write.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/boards/arduino_due_x/init.o : $(ASF_DIR)/sam/boards/arduino_due_x/init.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/drivers/pio/pio.o : $(ASF_DIR)/sam/drivers/pio/pio.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/drivers/pio/pio_handler.o : $(ASF_DIR)/sam/drivers/pio/pio_handler.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/drivers/pmc/pmc.o : $(ASF_DIR)/sam/drivers/pmc/pmc.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/drivers/pmc/sleep.o : $(ASF_DIR)/sam/drivers/pmc/sleep.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/drivers/pwm/pwm.o : $(ASF_DIR)/sam/drivers/pwm/pwm.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/drivers/uart/uart.o : $(ASF_DIR)/sam/drivers/uart/uart.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/drivers/usart/usart.o : $(ASF_DIR)/sam/drivers/usart/usart.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/utils/cmsis/sam3x/source/templates/exceptions.o : $(ASF_DIR)/sam/utils/cmsis/sam3x/source/templates/exceptions.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/utils/cmsis/sam3x/source/templates/gcc/startup_sam3x.o : $(ASF_DIR)/sam/utils/cmsis/sam3x/source/templates/gcc/startup_sam3x.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/utils/cmsis/sam3x/source/templates/system_sam3x.o : $(ASF_DIR)/sam/utils/cmsis/sam3x/source/templates/system_sam3x.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sam/utils/syscalls/gcc/syscalls.o : $(ASF_DIR)/sam/utils/syscalls/gcc/syscalls.c subdirs
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

# Main program

pwm_led_example.o : pwm_led_example.c

######################################################### make FLASH version

pwm_led_example_flash.elf : $(OBJS)

	arm-none-eabi-g++ -Wl,--entry=Reset_Handler -Wl,--cref -mcpu=cortex-m3 -mthumb -pipe -Wl,--gc-sections -Wl,-T $(ASF_DIR)/sam/utils/linker_scripts/sam3x/sam3x8/gcc/flash.ld -Wl,-Map=pwm_led_example_flash.map,--cref -L$(ASF_DIR)/thirdparty/CMSIS/Lib/GCC $(OBJS) -larm_cortexM3l_math -lm -o $@

# show info

#arm-none-eabi-size -Ax pwm_led_example_flash.elf
#arm-none-eabi-size -Bx pwm_led_example_flash.elf

pwm_led_example_flash.lss : pwm_led_example_flash.elf

	arm-none-eabi-objdump -h -S pwm_led_example_flash.elf > pwm_led_example_flash.lss

pwm_led_example_flash.sym : pwm_led_example_flash.elf

	arm-none-eabi-nm -n pwm_led_example_flash.elf > pwm_led_example_flash.sym

pwm_led_example_flash.hex : pwm_led_example_flash.elf

	arm-none-eabi-objcopy -O ihex   pwm_led_example_flash.elf pwm_led_example_flash.hex

pwm_led_example_flash.bin : pwm_led_example_flash.elf

	arm-none-eabi-objcopy -O binary pwm_led_example_flash.elf pwm_led_example_flash.bin

######################################################### make SRAM version

pwm_led_example_sram.elf : $(OBJS)

	arm-none-eabi-g++ -Wl,--entry=Reset_Handler -Wl,--cref -mcpu=cortex-m3 -mthumb -pipe -Wl,--gc-sections -Wl,-T $(ASF_DIR)/sam/utils/linker_scripts/sam3x/sam3x8/gcc/sram.ld -Wl,-Map=pwm_led_example_sram.map,--cref -L$(ASF_DIR)/thirdparty/CMSIS/Lib/GCC $(OBJS) -larm_cortexM3l_math -lm -o $@

# show info

#	arm-none-eabi-size -Ax pwm_led_example_sram.elf
#	arm-none-eabi-size -Bx pwm_led_example_sram.elf

pwm_led_example_sram.lss :

	arm-none-eabi-objdump -h -S pwm_led_example_sram.elf > pwm_led_example_sram.lss

pwm_led_example_sram.sym : pwm_led_example_sram.elf

	arm-none-eabi-nm -n pwm_led_example_sram.elf > pwm_led_example_sram.sym

pwm_led_example_sram.hex : pwm_led_example_sram.elf

	arm-none-eabi-objcopy -O ihex   pwm_led_example_sram.elf pwm_led_example_sram.hex

pwm_led_example_sram.bin : pwm_led_example_sram.elf

	arm-none-eabi-objcopy -O binary pwm_led_example_sram.elf pwm_led_example_sram.bin

subdirs :
	test -d common/services/clock/sam3x                || mkdir -p common/services/clock/sam3x
	test -d common/services/serial                     || mkdir -p common/services/serial
	test -d common/utils/interrupt                     || mkdir -p common/utils/interrupt
	test -d common/utils/stdio                         || mkdir -p common/utils/stdio
	test -d sam/boards/arduino_due_x                   || mkdir -p sam/boards/arduino_due_x
	test -d sam/drivers/pio                            || mkdir -p sam/drivers/pio
	test -d sam/drivers/pmc                            || mkdir -p sam/drivers/pmc
	test -d sam/drivers/pwm                            || mkdir -p sam/drivers/pwm
	test -d sam/drivers/uart                           || mkdir -p sam/drivers/uart
	test -d sam/drivers/usart                          || mkdir -p sam/drivers/usart
	test -d sam/utils/cmsis/sam3x/source/templates/gcc || mkdir -p sam/utils/cmsis/sam3x/source/templates/gcc
	test -d sam/utils/cmsis/sam3x/source/templates     || mkdir -p sam/utils/cmsis/sam3x/source/templates
	test -d sam/utils/syscalls/gcc                     || mkdir -p sam/utils/syscalls/gcc

program : pwm_led_example_flash.bin
	../bin/reset_due.py
	../bin/arduino-bossac -i --port=ttyACM0 -U false -e -w -v -b pwm_led_example_flash.bin -R

clean :
	$(RM) *.o
	$(RM) -r common
	$(RM) -r sam
	$(RM) pwm_led_example_flash.bin
	$(RM) pwm_led_example_flash.elf
	$(RM) pwm_led_example_flash.hex
	$(RM) pwm_led_example_flash.lss
	$(RM) pwm_led_example_flash.map
	$(RM) pwm_led_example_flash.sym
	$(RM) pwm_led_example_sram.bin
	$(RM) pwm_led_example_sram.elf
	$(RM) pwm_led_example_sram.hex
	$(RM) pwm_led_example_sram.lss
	$(RM) pwm_led_example_sram.map
	$(RM) pwm_led_example_sram.sym
	$(RM) pwm_led_example.d

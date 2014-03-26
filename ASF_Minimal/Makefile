
.PHONY : default subdirs program clean

ASF_DIR = ../xdk-asf-3.15.0

TOOLCHAIN_DIR = ../root/bin
TOOL_PREFIX = arm-none-eabi-

CC      = $(TOOLCHAIN_DIR)/$(TOOL_PREFIX)gcc
CXX     = $(TOOLCHAIN_DIR)/$(TOOL_PREFIX)g++
OBJDUMP = $(TOOLCHAIN_DIR)/$(TOOL_PREFIX)objdump
OBJCOPY = $(TOOLCHAIN_DIR)/$(TOOL_PREFIX)objcopy
NM      = $(TOOLCHAIN_DIR)/$(TOOL_PREFIX)nm
AR      = $(TOOLCHAIN_DIR)/$(TOOL_PREFIX)ar
RANLIB  = $(TOOLCHAIN_DIR)/$(TOOL_PREFIX)ranlib
SIZE    = $(TOOLCHAIN_DIR)/$(TOOL_PREFIX)size

CFLAGS = -std=gnu99 -O1 -mcpu=cortex-m3 -mthumb -g3 -pipe --param max-inline-insns-single=500 \
        -fno-strict-aliasing -ffunction-sections -fdata-sections \
        -Wall -Wstrict-prototypes -Wmissing-prototypes -Werror-implicit-function-declaration -Wpointer-arith \
        -Wchar-subscripts -Wcomment -Wformat=2 -Wimplicit-int -Wmain -Wparentheses -Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs \
        -Wunused -Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef -Wshadow -Wbad-function-cast -Wwrite-strings -Wsign-compare \
        -Waggregate-return -Wmissing-declarations -Wformat -Wmissing-format-attribute -Wno-deprecated-declarations -Wpacked -Wredundant-decls \
        -Wnested-externs -Winline -Wlong-long -Wunreachable-code -Wcast-align

CPPFLAGS = \
        -D=__sam3x8e__ \
        -D ARM_MATH_CM3=true \
        -D BOARD=ARDUINO_DUE_X \
        -D __SAM3X8E__ \
        -D printf=iprintf \
        -D scanf=iscanf \
        -I$(ASF_DIR)/common/boards                          \
        -I$(ASF_DIR)/common/services/clock                  \
        -I$(ASF_DIR)/common/services/gpio                   \
        -I$(ASF_DIR)/common/services/ioport                 \
        -I$(ASF_DIR)/common/services/serial                 \
        -I$(ASF_DIR)/common/services/serial/sam_uart        \
        -I$(ASF_DIR)/common/utils                           \
        -I$(ASF_DIR)/common/utils/stdio/stdio_serial        \
        -I$(ASF_DIR)/sam/boards                             \
        -I$(ASF_DIR)/sam/boards/arduino_due_x               \
        -I$(ASF_DIR)/sam/drivers/pio                        \
        -I$(ASF_DIR)/sam/drivers/pmc                        \
        -I$(ASF_DIR)/sam/drivers/pwm                        \
        -I$(ASF_DIR)/sam/drivers/uart                       \
        -I$(ASF_DIR)/sam/drivers/usart                      \
        -I$(ASF_DIR)/sam/utils                              \
        -I$(ASF_DIR)/sam/utils/cmsis/sam3x/include          \
        -I$(ASF_DIR)/sam/utils/cmsis/sam3x/source/templates \
        -I$(ASF_DIR)/sam/utils/header_files                 \
        -I$(ASF_DIR)/sam/utils/preprocessor                 \
        -I$(ASF_DIR)/thirdparty/CMSIS/Include               \
        -I$(ASF_DIR)/thirdparty/CMSIS/Lib/GCC               \
        -I.

LIBASF_OBJS = sysclk.o             \
              usart_serial.o       \
              interrupt_sam_nvic.o \
              read.o               \
              write.o              \
              init.o               \
              pio.o                \
              pio_handler.o        \
              pmc.o                \
              sleep.o              \
              pwm.o                \
              uart.o               \
              usart.o              \
              exceptions.o         \
              startup_sam3x.o      \
              system_sam3x.o       \
              syscalls.o

default : pwm_led_example_flash.bin pwm_led_example_sram.bin
	# Show hashes
	md5sum *.bin

############################################################ ASF

libasf.a : $(LIBASF_OBJS)
	$(AR) rcs $@ $^
	$(RANLIB) $@

sysclk.o : $(ASF_DIR)/common/services/clock/sam3x/sysclk.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

usart_serial.o : $(ASF_DIR)/common/services/serial/usart_serial.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

interrupt_sam_nvic.o : $(ASF_DIR)/common/utils/interrupt/interrupt_sam_nvic.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

read.o : $(ASF_DIR)/common/utils/stdio/read.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

write.o : $(ASF_DIR)/common/utils/stdio/write.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

init.o : $(ASF_DIR)/sam/boards/arduino_due_x/init.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

pio.o : $(ASF_DIR)/sam/drivers/pio/pio.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

pio_handler.o : $(ASF_DIR)/sam/drivers/pio/pio_handler.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

pmc.o : $(ASF_DIR)/sam/drivers/pmc/pmc.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

sleep.o : $(ASF_DIR)/sam/drivers/pmc/sleep.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

pwm.o : $(ASF_DIR)/sam/drivers/pwm/pwm.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

uart.o : $(ASF_DIR)/sam/drivers/uart/uart.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

usart.o : $(ASF_DIR)/sam/drivers/usart/usart.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

exceptions.o : $(ASF_DIR)/sam/utils/cmsis/sam3x/source/templates/exceptions.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

startup_sam3x.o : $(ASF_DIR)/sam/utils/cmsis/sam3x/source/templates/gcc/startup_sam3x.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

system_sam3x.o : $(ASF_DIR)/sam/utils/cmsis/sam3x/source/templates/system_sam3x.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

syscalls.o : $(ASF_DIR)/sam/utils/syscalls/gcc/syscalls.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

############################################################ Main program

pwm_led_example.o : pwm_led_example.c

############################################################ make FLASH version

pwm_led_example_flash.elf : pwm_led_example.o $(LIBASF_OBJS)

	$(CXX) -Wl,--entry=Reset_Handler \
	       -Wl,--cref \
	       -mcpu=cortex-m3 \
	       -mthumb \
	       -Wl,--gc-sections \
	       -Wl,-T $(ASF_DIR)/sam/utils/linker_scripts/sam3x/sam3x8/gcc/flash.ld \
	       -Wl,-Map=pwm_led_example_flash.map,--cref \
	       -L$(ASF_DIR)/thirdparty/CMSIS/Lib/GCC \
	       pwm_led_example.o -lasf -larm_cortexM3l_math -lm -o $@

	# show info
	#$(SIZE) -Ax pwm_led_example_flash.elf
	#$(SIZE) -Bx pwm_led_example_flash.elf

pwm_led_example_flash.lss : pwm_led_example_flash.elf

	$(OBJDUMP) -h -S $< > $@

pwm_led_example_flash.sym : pwm_led_example_flash.elf

	$(NM) -n $< > $@

pwm_led_example_flash.hex : pwm_led_example_flash.elf

	$(OBJCOPY) -O ihex $< $@

pwm_led_example_flash.bin : pwm_led_example_flash.elf

	$(OBJCOPY) -O binary $< $@

############################################################ make SRAM version

pwm_led_example_sram.elf : pwm_led_example.o $(LIBASF_OBJS)

	$(CXX) -Wl,--entry=Reset_Handler \
	       -Wl,--cref \
	       -mcpu=cortex-m3 \
	       -mthumb \
	       -Wl,--gc-sections \
	       -Wl,-T $(ASF_DIR)/sam/utils/linker_scripts/sam3x/sam3x8/gcc/sram.ld \
	       -Wl,-Map=pwm_led_example_sram.map,--cref \
	       -L$(ASF_DIR)/thirdparty/CMSIS/Lib/GCC \
	       pwm_led_example.o $(LIBASF_OBJS) -larm_cortexM3l_math -lm -o $@

	# show info
	#$(SIZE) -Ax pwm_led_example_sram.elf
	#$(SIZE) -Bx pwm_led_example_sram.elf

pwm_led_example_sram.lss : pwm_led_example_sram.elf

	$(OBJDUMP) -h -S $< > $@

pwm_led_example_sram.sym : pwm_led_example_sram.elf

	$(NM) -n $< > $@

pwm_led_example_sram.hex : pwm_led_example_sram.elf

	$(OBJCOPY) -O ihex $< $@

pwm_led_example_sram.bin : pwm_led_example_sram.elf

	$(OBJCOPY) -O binary $< $@

############################################################ programming

program : pwm_led_example_flash.bin
	../bin/reset_due.py
	../bin/arduino-bossac -i --port=ttyACM0 -U false -e -w -v -b pwm_led_example_flash.bin -R

clean :
	$(RM) $(LIBASF_OBJS) libasf.a pwm_led_example.o
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

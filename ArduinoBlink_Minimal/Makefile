
.PHONY : check program

#ARDUINO_DIR          = /home/sidney/Arduino/arduino-1.5.6-r2
#ARDUINO_HW_TOOLS_DIR = $(ARDUINO_DIR)/hardware/tools
#ARDUINO_SAM_DIR      = $(ARDUINO_DIR)/hardware/arduino/sam

#ARDUINO_SUPPORT_CODE_DIR = $(ARDUINO_SAM_DIR)/cores/arduino

ARM_COMPILER_DIR = ../root/bin

CC      = $(ARM_COMPILER_DIR)/arm-none-eabi-gcc
CXX     = $(ARM_COMPILER_DIR)/arm-none-eabi-g++
AR      = $(ARM_COMPILER_DIR)/arm-none-eabi-ar
OBJCOPY = $(ARM_COMPILER_DIR)/arm-none-eabi-objcopy
BOSSAC  = bin/bossac

CPPFLAGS = -DMSEC_DELAY=50 \
           -Dprintf=iprintf \
           -DF_CPU=84000000L -DARDUINO=156 -DARDUINO_SAM_DUE -DARDUINO_ARCH_SAM -D__SAM3X8E__ \
           -DUSB_VID=0x2341 -DUSB_PID=0x003e -DUSBCON -DUSB_MANUFACTURER="\"Unknown\"" -DUSB_PRODUCT="\"Arduino Due\"" \
           -I.

#          -I$(ARDUINO_SAM_DIR)/system/libsam
#          -I$(ARDUINO_SAM_DIR)/system/CMSIS/CMSIS/Include
#          -I$(ARDUINO_SAM_DIR)/system/CMSIS/Device/ATMEL

CFLAGS   = -g -Os -w -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -mcpu=cortex-m3 -mthumb
CXXFLAGS = -g -Os -w -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -mcpu=cortex-m3 -mthumb -fno-rtti -fno-exceptions

OBJS =                   \
       main.o            \
       Blink.o           \
       Reset.o           \
       wiring.o          \
       wiring_digital.o  \
       variant.o         \
       hooks.o           \
       syscalls_sam3.o   \
       iar_calls_sam3.o  \
       cortex_handlers.o \
       cxxabi-compat.o

check : Blink.bin
	md5sum Blink.bin

Blink.bin : Blink.elf
	$(OBJCOPY) -O binary Blink.elf Blink.bin

Blink.elf : $(OBJS)
	$(CXX) -Os -Wl,--gc-sections -mcpu=cortex-m3 -Tflash.ld -Wl,-Map,Blink.map -o Blink.elf \
	-lm -lgcc -mthumb \
	-Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--warn-unresolved-symbols \
	-Wl,--start-group $(OBJS) libsam_sam3x8e_gcc_rel.a -Wl,--end-group

main.o            : main.cpp
Blink.o           : Blink.cpp
Reset.o           : Reset.cpp
wiring.o          : wiring.c
wiring_digital.o  : wiring_digital.c
variant.o         : variant.cpp
hooks.o           : hooks.c
syscalls_sam3.o   : syscalls_sam3.c
iar_calls_sam3.o  : iar_calls_sam3.c
cortex_handlers.o : cortex_handlers.c
cxxabi-compat.o   : cxxabi-compat.cpp

program: Blink.bin
	./reset_due.py
	$(BOSSAC) -i --port=ttyACM0 -U false -e -w -v -b Blink.bin -R

clean :
	$(RM) $(OBJS) *~ Blink.elf Blink.bin Blink.map *.o

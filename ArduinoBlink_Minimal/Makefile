
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

CPPFLAGS = -DMSEC_DELAY=200 \
           -Dprintf=iprintf \
           -DF_CPU=84000000L -DARDUINO=156 -DARDUINO_SAM_DUE -DARDUINO_ARCH_SAM -D__SAM3X8E__ \
           -DUSB_VID=0x2341 -DUSB_PID=0x003e -DUSBCON -DUSB_MANUFACTURER="\"Unknown\"" -DUSB_PRODUCT="\"Arduino Due\"" \
           -I.

#          -I$(ARDUINO_SAM_DIR)/system/libsam
#          -I$(ARDUINO_SAM_DIR)/system/CMSIS/CMSIS/Include
#          -I$(ARDUINO_SAM_DIR)/system/CMSIS/Device/ATMEL

CFLAGS   = -g -Os -w -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -mcpu=cortex-m3 -mthumb
CXXFLAGS = -g -Os -w -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -mcpu=cortex-m3 -mthumb -fno-rtti -fno-exceptions

OBJS = Blink.o \
       itoa.o wiring_analog.o syscalls_sam3.o dtostrf.o wiring_shift.o iar_calls_sam3.o cortex_handlers.o wiring_digital.o hooks.o WInterrupts.o wiring.o \
       Reset.o Print.o RingBuffer.o CDC.o HID.o USBCore.o WString.o cxxabi-compat.o main.o UARTClass.o Stream.o IPAddress.o wiring_pulse.o WMath.o USARTClass.o \
       variant.o

check : Blink.bin
	md5sum Blink.bin

Blink.bin : Blink.elf
	$(OBJCOPY) -O binary Blink.elf Blink.bin

Blink.elf : $(OBJS)
	$(CXX) -Os -Wl,--gc-sections -mcpu=cortex-m3 -Tflash.ld -Wl,-Map,Blink.map -o Blink.elf \
	-lm -lgcc -mthumb \
	-Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--warn-unresolved-symbols \
	-Wl,--start-group $(OBJS) libsam_sam3x8e_gcc_rel.a -Wl,--end-group

%.o : %.cpp
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

%.o : %.c
	$(CC) -c  $(CPPFLAGS) $(CFLAGS) $< -o $@

Blink.o : Blink.cpp

itoa.o            : itoa.c
wiring_analog.o   : wiring_analog.c
syscalls_sam3.o   : syscalls_sam3.c
dtostrf.o         : dtostrf.c
wiring_shift.o    : wiring_shift.c
iar_calls_sam3.o  : iar_calls_sam3.c
cortex_handlers.o : cortex_handlers.c
wiring_digital.o  : wiring_digital.c
hooks.o           : hooks.c
WInterrupts.o     : WInterrupts.c
wiring.o          : wiring.c

Reset.o         : Reset.cpp
Print.o         : Print.cpp
RingBuffer.o    : RingBuffer.cpp
CDC.o           : CDC.cpp
HID.o           : HID.cpp
USBCore.o       : USBCore.cpp
WString.o       : WString.cpp
cxxabi-compat.o : cxxabi-compat.cpp
main.o          : main.cpp
UARTClass.o     : UARTClass.cpp
Stream.o        : Stream.cpp
IPAddress.o     : IPAddress.cpp
wiring_pulse.o  : wiring_pulse.cpp
WMath.o         : WMath.cpp
USARTClass.o    : USARTClass.cpp

variant.o       : variant.cpp

program: Blink.bin
	./reset_due.py
	$(BOSSAC) -i --port=ttyACM0 -U false -e -w -v -b Blink.bin -R

clean :
	$(RM) $(OBJS) *~ Blink.elf Blink.bin Blink.map

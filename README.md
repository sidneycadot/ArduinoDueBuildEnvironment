
Arduino Due and Atmel SAM4E XPLained Pro Build Environment
==========================================================

Introduction
------------

The Arduino Due is a small form-factor embedded computer built around the Atmel AT91SAM3X8E microcontroller,
which is an ARM Cortex-M3 class processor with associated peripherals. It is quite different from earlier
Arduino models that are based on an Atmel AVR microcontroller.

The Arduino IDE is simplified for casual tinkerers; its language is C++, but a custom preprocessor is used to
change the code before it is compiled to C++. To do proper C/C++ development, a classic build environment is
needed.

The Atmel SAM4E XPlained Pro is a development board built around the Atmel ATSAM4E16E microcontroller, which
is an ARM Cortex-M4 class processor with associated peripherals. The processor has a hardware Floating Point
Unit (FPU) that supports single-precision IEEE-754 floating point operations.

The goal of this project is to provide a script that builds a cross-compiler, C library, and associated tools
to do Linux-based development for the Arduino and XPlained Pro boards.

Goals
-----

We try to support the following features:

1. A working cross-compiler GCC build environment for ARM-based development.
2. A working newlib or other small C library
3. Support for the FPU in the Cortex M4 processor.
4. The appropriate CMSIS stuff for the ARM chip
5. A working FreeRTOS or other minimalistic OS.
6. Flash tool (BOSSA or OpenOCD)
7. Working C++, STL
8. Minix?

Software versions
-----------------

Current versions (30 April 2016):

| tool / library           | version   | project url                                          | status                                          |
|--------------------------|-----------|------------------------------------------------------|-------------------------------------------------|
| Binutils                 | 2.26      | http://www.gnu.org/software/binutils/                | ok                                              |
| GCC                      | 6.1.0     | http://gcc.gnu.org/                                  | ok                                              |
| GMP                      | 6.1.0     | https://gmplib.org/                                  | ok                                              |
| MPFR                     | 3.1.4     | http://www.mpfr.org/                                 | ok                                              |
| MPC                      | 1.0.3     | http://www.multiprecision.org/                       | ok                                              |
| ISL                      | 0.16.1    | http://isl.gforge.inria.fr/                          | ok                                              |
| CLoog                    | 0.18.4    | http://www.cloog.org/                                | (no longer needed)                              |
| newlib                   | 2.4.0     | http://sourceware.org/newlib/                        | ok                                              |
| Atmel Software Framework | 3.31.0    | http://www.atmel.com/tools/avrsoftwareframework.aspx | ok                                              |
| GDB                      | 7.11      | http://www.gnu.org/software/gdb/                     | ok                                              |

NOTE: To find the link to the "Atmel Software Framework" you need to register with atmel. You can also try looking at
      [this page](http://spaces.atmel.com/gf/project/asf/frs/?action=&br_pkgrlssort_by=release_name&br_pkgrlssort_order=asc)
      to find the version number of the most recent version, and change the download URL accordingly.

Stuff that isn't used/built yet:

| tool / library           | version   | project url                                          | status                                          |
|--------------------------|-----------|------------------------------------------------------|-------------------------------------------------|
| uClibc                   | 0.9.33.2  | http://www.uclibc.org/                               | Presumes Linux                                  |
| glibc                    | 2.23      | http://www.gnu.org/software/libc/libc.html           | Heavyweight                                     |
| Bossac                   | 1.2.1     | http://www.shumatech.com/web/products/bossa          | Not useful for XPlained Pro board               |
| FreeRTOS                 | 8.2.3     | http://www.freertos.org/                             |                                                 |
| Minix                    | 3.3.0     | http://www.minix3.org/                               |                                                 |
| CMSIS                    | 3.01      |                                                      |                                                 |
| OpenOCD                  | 0.9.0     | http://openocd.org/                                  |                                                 |

Interesting web pages
---------------------

* http://gcc.gnu.org/install/
* http://kunen.org/uC/gnu_tool.html
* https://github.com/ndim/arm-newlib-gcc-toolchain-builder/blob/master/README.md
* http://www.atmel.com/products/microcontrollers/arm/sam3x.aspx
* http://www.atmel.com/Images/asf-releasenotes-3.15.0.pdf
* http://www.ifp.illinois.edu/~nakazato/tips/xgcc.html
* https://github.com/rdiez/JtagDue/blob/master/Toolchain/Makefile
* http://eehusky.wordpress.com/2012/12/17/using-gcc-with-the-ti-stellaris-launchpad-newlib/
* http://wiki.osdev.org/Porting_Newlib

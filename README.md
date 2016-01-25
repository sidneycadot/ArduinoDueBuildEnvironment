
Arduino Due Build Environment
=============================

Introduction
------------

The Arduino Due is a small form-factor embedded computer built around the Atmel AT91SAM3X8E (ARM Cortex-M3) processor.
It is quite different from earlier Arduino models that are based on an Atmel AVR processor.

The Arduino IDE is simplified for casual tinkerers; its language is C++-like, but a custom preprocessor is used to
change the code before it is compiled to C++. To do proper C/C++ development, a classic build environment is
needed.

Goals
-----

1. A working cross-compiler GCC build environment for the ARM-based Arduino Due.
2. A working newlib, uclib, or other small C library
3. The appropriate CMSIS stuff for the ARM chip
4. A working FreeRTOS
5. Flash tool ("BOSSA")
6. Working C++, STL
7. Minix?

Versions
--------

Current versions (25 January 2016):

| tool / library           | version   | project url                                          | status                                          |
---------------------------|-----------|------------------------------------------------------|------------------------------------------------ |
| Binutils                 | 2.26      | http://www.gnu.org/software/binutils/                | downloaded and built.                           |
| GCC                      | 5.3.0     | http://gcc.gnu.org/                                  | downloaded and built.                           |
| GMP                      | 6.1.0     | https://gmplib.org/                                  | downloaded as GCC dependency, but not yet used. |
| MPFR                     | 3.1.3     | http://www.mpfr.org/                                 | downloaded as GCC dependency, but not yet used. |
| MPC                      | 1.0.3     | http://www.multiprecision.org/                       | downloaded as GCC dependency, but not yet used. |
| ISL                      | 0.16.1    | http://isl.gforge.inria.fr/                          | downloaded as GCC dependency, but not yet used. |
| CLoog                    | 0.18.4    | http://www.cloog.org/                                | downloaded as GCC dependency, but not yet used. |
| newlib                   | 2.2.0     | http://sourceware.org/newlib/                        | downloaded and built.                           |
| Atmel Software Framework | 3.29.0    | http://www.atmel.com/tools/avrsoftwareframework.aspx | downloaded.                                     |
| GDB                      | 7.10.1    | http://www.gnu.org/software/gdb/                     | downloaded and built.                           |

NOTE: To find the link to the "Atmel Software Framework" you need to register with atmel. You can also try looking at
      [this page](http://spaces.atmel.com/gf/project/asf/frs/?action=&br_pkgrlssort_by=release_name&br_pkgrlssort_order=asc)
      to find the version number of the most recent version, and change the download URL accordingly.

Stuff that isn't used/built yet:

| tool / library           | version   | project url                                          | status                                          |
---------------------------|-----------|------------------------------------------------------|------------------------------------------------ |
| uClibc                   | 0.9.33.2  | http://www.uclibc.org/                               | downloaded but not yet built.                   |
| glibc                    | 2.22      | http://www.gnu.org/software/libc/libc.html           |                                                 |
| Bossac                   | 1.2.1     | http://www.shumatech.com/web/products/bossa          | not downloaded.                                 |
| FreeRTOS                 | 8.2.2     | http://www.freertos.org/                             | downloaded, not currently used.                 |
| Minix                    | 3.3.0     | http://www.minix3.org/                               | planned for future.                             |

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

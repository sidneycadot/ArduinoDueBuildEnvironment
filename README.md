
GOALS
=====

The Arduino Due is a small form-factor embedded computer built around the Atmelk AT91SAM3X8E (ARM Cortex-M3) processor.

(1) A working cross-compiler GCC build environment for the ARM-based Arduino Due.
(2) A working newlib, uclib, or other small C library
(3) The appropriate CMSIS stuff for the ARM chip
(4) A working FreeRTOS
(5) Flash tool ("BOSSA")
(6) Working c++, STL

Versions
--------

Current versions (March 2014):

* Binutils ...................... 2.24       http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.bz2
* GCC ........................... 4.8.2      ftp://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2
* GMP ........................... 5.1.3      https://gmplib.org/download/gmp/gmp-5.1.3.tar.lz
* MPFR .......................... 3.1.2      http://www.mpfr.org/mpfr-current/mpfr-3.1.2.tar.xz
* MPC ........................... 1.0.2      ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.2.tar.gz
* ISL ........................... 0.12.2     ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.12.2.tar.bz2
* CLoog ......................... 0.18.1     ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz
* NewLib ........................ 2.1.0      ftp://sourceware.org/pub/newlib/newlib-2.1.0.tar.gz               http://sourceware.org/newlib/
* uClibc ........................ 0.9.33     http://www.uclibc.org/downloads/uClibc-0.9.33.tar.xz              http://www.uclibc.org/
* CMSIS .........................
* STL ...........................
* Atmel Software Framework ...... 3.15       http://www.atmel.com/images/asf-standalone-archive-3.15.0.87.zip
* GDB ........................... 7.7        http://ftp.gnu.org/gnu/gdb/gdb-7.7.tar.bz2
* FreeRTOS ...................... 8.0.0
* Bossac ........................            git clone git://git.code.sf.net/p/b-o-s-s-a/code b-o-s-s-a-code

NOTE: To find the link to the "Atmel Software Framework" you need to register with atmel.

Installing GCC
--------------

http://gcc.gnu.org/install/

Interesting web pages
---------------------

http://kunen.org/uC/gnu_tool.html
https://github.com/ndim/arm-newlib-gcc-toolchain-builder/blob/master/README.md

http://www.atmel.com/products/microcontrollers/arm/sam3x.aspx
http://www.atmel.com/Images/asf-releasenotes-3.15.0.pdf
http://www.ifp.illinois.edu/~nakazato/tips/xgcc.html
https://github.com/rdiez/JtagDue/blob/master/Toolchain/Makefile
http://eehusky.wordpress.com/2012/12/17/using-gcc-with-the-ti-stellaris-launchpad-newlib/
http://wiki.osdev.org/Porting_Newlib

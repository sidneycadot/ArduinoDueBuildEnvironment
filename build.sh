#! /bin/sh

set -e

HERE=$PWD

########################################

BINUTILS_VERSION=2.24
GCC_VERSION=4.8.2
NEWLIB_VERSION=2.1.0

########################################

DOWNLOADS_DIR=$HERE/downloads
ROOT_DIR=$HERE/root
UNPACKED_SRC_DIRS=$HERE/unpacked-src
BUILD_DIRS=$HERE/build

BINUTILS_SOURCE_DIR=$UNPACKED_SRC_DIRS/binutils-$BINUTILS_VERSION
BINUTILS_BUILD_DIR=$BUILD_DIRS/binutils-$BINUTILS_VERSION

GCC_SOURCE_DIR=$UNPACKED_SRC_DIRS/gcc-$GCC_VERSION

GCC_BOOTSTRAP_BUILD_DIR=$BUILD_DIRS/gcc-$GCC_VERSION-bootstrap
GCC_FULL_BUILD_DIR=$BUILD_DIRS/gcc-$GCC_VERSION-full

NEWLIB_SOURCE_DIR=$UNPACKED_SRC_DIRS/newlib-$NEWLIB_VERSION
NEWLIB_BUILD_DIR=$BUILD_DIRS/newlib-$NEWLIB_VERSION

TARGET=arm-none-eabi

PROGRAM_PREFIX=$TARGET-

MAKE_OPTS="-j8"

########################################

echo "@@@ [all] removing stale directories ..."

rm -rf $UNPACKED_SRC_DIRS
rm -rf $BUILD_DIRS
rm -rf $ROOT_DIR

########################################

echo "@@@ [all] setting up fresh directories ..."

mkdir $UNPACKED_SRC_DIRS
mkdir $BUILD_DIRS
mkdir $ROOT_DIR

if [ ! -d $DOWNLOADS_DIR ] ; then
    mkdir $DOWNLOADS_DIR
fi

########################################

echo "@@@ [all] fetching tarballs ..."

cd $DOWNLOADS_DIR

# Binutils

if [ ! -f binutils-$BINUTILS_VERSION.tar.bz2 ] ; then
    wget http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.bz2
fi

# GCC and its dependencies

if [ ! -f gcc-$GCC_VERSION.tar.bz2 ] ; then
    wget ftp://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2
fi

if [ ! -f gmp-5.1.3.tar.lz ] ; then
    wget https://gmplib.org/download/gmp/gmp-5.1.3.tar.lz
fi

if [ ! -f mpfr-3.1.2.tar.xz ] ; then
    wget http://www.mpfr.org/mpfr-current/mpfr-3.1.2.tar.xz
fi

if [ ! -f mpc-1.0.2.tar.gz ] ; then
    wget ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.2.tar.gz
fi

if [ ! -f isl-0.12.2.tar.bz2 ] ; then
    wget ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.12.2.tar.bz2
fi

if [ ! -f cloog-0.18.1.tar.gz ] ; then
    wget ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.1.tar.gz
fi

# GDB

if [ ! -f gdb-7.7.tar.bz2 ] ; then
    wget http://ftp.gnu.org/gnu/gdb/gdb-7.7.tar.bz2
fi

# C libraries

if [ ! -f newlib-$NEWLIB_VERSION.tar.gz ] ; then
    wget ftp://sourceware.org/pub/newlib/newlib-$NEWLIB_VERSION.tar.gz
fi

if [ ! -f uClibc-0.9.33.tar.xz ] ; then
    wget http://www.uclibc.org/downloads/uClibc-0.9.33.tar.xz
fi

# FreeRTOS

# Flash utility

# Show all downloaded files.

echo
md5sum *
echo

######################################## build binutils

echo "@@@ [binutils] unpacking ..."

cd $UNPACKED_SRC_DIRS

tar xf $DOWNLOADS_DIR/binutils-$BINUTILS_VERSION.tar.bz2

echo "@@@ [binutils] Emitting configure help ..."

$BINUTILS_SOURCE_DIR/configure --help > $HERE/ConfigureHelp_binutils.txt

echo "@@@ [binutils] Creating build directory ..."

mkdir $BINUTILS_BUILD_DIR

echo "@@@ [binutils] configuring ..."

cd $BINUTILS_BUILD_DIR
$BINUTILS_SOURCE_DIR/configure --prefix=$ROOT_DIR --program-prefix=$PROGRAM_PREFIX $CONFIG_OPTS_EXTRA --target=$TARGET

echo "@@@ [binutils] making ..."

make $MAKE_OPTS

echo "@@@ [binutils] installing ..."

make install

######################################## build gcc/bootstrap

# Note that building the toolchain depends on the availability of a toolchain.
# In essence, what we do is this:
#
# (1) Build the gcc compiler partially (good enough to be able to build newlib)
# (2) Build newlib using the cross compiler
# (3) Finish building GCC

echo "@@@ [gcc/bootstrap] unpacking GCC ..."

cd $UNPACKED_SRC_DIRS

tar xf $DOWNLOADS_DIR/gcc-$GCC_VERSION.tar.bz2

tar xf $DOWNLOADS_DIR/newlib-$NEWLIB_VERSION.tar.gz

echo "@@@ [gcc/bootstrap] emitting configure help ..."

$GCC_SOURCE_DIR/configure --help > $HERE/ConfigureHelp_gcc.txt

echo "@@@ [gcc/bootstrap] creating build directory ..."

mkdir $GCC_BOOTSTRAP_BUILD_DIR

echo "@@@ [gcc/bootstrap] configuring ..."

cd $GCC_BOOTSTRAP_BUILD_DIR
$GCC_SOURCE_DIR/configure  --target=$TARGET --prefix=$ROOT_DIR --program-prefix=$PROGRAM_PREFIX --enable-languages=c,c++ --without-headers --with-newlib --with-gnu-as --with-gnu-ld

echo "@@@ [gcc/bootstrap] making bootstrap compiler..."

make $MAKE_OPTS all-gcc

echo "@@@ [gcc/bootstrap] installing bootstrap compiler..."

make install-gcc

######################################## build newlib

echo "@@@ [newlib] unpacking NEWLIB ..."

cd $UNPACKED_SRC_DIRS

tar xf $DOWNLOADS_DIR/newlib-$NEWLIB_VERSION.tar.gz

echo "@@@ [newlib] Emitting configure help ..."

$NEWLIB_SOURCE_DIR/configure --help > $HERE/ConfigureHelp_newlib.txt

echo "@@@ [newlib] Creating build directory ..."

mkdir $NEWLIB_BUILD_DIR

echo "@@@ [newlib] configuring ..."

# Note that we add to PATH, to make sure that the configure scripts finds the just-installed GCC compiler.
export PATH=$ROOT_DIR/bin:$PATH

cd $NEWLIB_BUILD_DIR
$NEWLIB_SOURCE_DIR/configure --target=$TARGET --prefix=$ROOT_DIR

echo "@@@ [newlib] making ..."

make all $MAKE_OPTS

echo "@@@ [newlib] installing ..."

make install

######################################## build gcc/full

echo "@@@ [gcc/full] creating build directory ..."

mkdir $GCC_FULL_BUILD_DIR

echo "@@@ [gcc/full] configuring ..."

cd $GCC_FULL_BUILD_DIR
$GCC_SOURCE_DIR/configure --target=$TARGET --prefix=$ROOT_DIR --program-prefix=$PROGRAM_PREFIX --enable-languages=c,c++ --with-newlib --with-gnu-as --with-gnu-ld --disable-shared --disable-libssp

echo "@@@ [gcc/full] making full compiler..."

make $MAKE_OPTS all

echo "@@@ [gcc/full] installing full compiler..."

make install

echo
echo "ALL DONE!!!"

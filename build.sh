#! /bin/sh

set -e

HERE=$PWD

DOWNLOADS_DIR=$HERE/downloads
ROOT_DIR=$HERE/root
UNPACKED_SRC_DIRS=$HERE/unpacked-src
BUILD_DIRS=$HERE/build

BINUTILS_BUILD_DIR=$BUILD_DIRS/binutils-2.24
BINUTILS_SOURCE_DIR=$UNPACKED_SRC_DIRS/binutils-2.24

GCC_BUILD_DIR=$BUILD_DIRS/gcc-4.8.2
GCC_SOURCE_DIR=$UNPACKED_SRC_DIRS/gcc-4.8.2

TARGET=arm-none-eabi

PROGRAM_PREFIX=sidney-

#############################

echo "@@@ Removing stale directories ..."

rm -rf $UNPACKED_SRC_DIRS
rm -rf $BUILD_DIRS
rm -rf $ROOT_DIR

#############################

echo "@@@ Setting up fresh directories ..."

mkdir $UNPACKED_SRC_DIRS
mkdir $BUILD_DIRS
mkdir $ROOT_DIR

if [ ! -d $DOWNLOADS_DIR ] ; then
    mkdir $DOWNLOADS_DIR
fi

#############################

echo "@@@ Fetching tarballs ..."

cd $DOWNLOADS_DIR

# Binutils

if [ ! -f binutils-2.24.tar.bz2 ] ; then
    wget http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.bz2
fi

# GCC and its dependencies

if [ ! -f gcc-4.8.2.tar.bz2 ] ; then
    wget ftp://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2
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

# C libraries

if [ ! -f cloog-0.18.1.tar.gz ] ; then
    wget ftp://sourceware.org/pub/newlib/newlib-2.1.0.tar.gz
fi

if [ ! -f cloog-0.18.1.tar.gz ] ; then
    wget http://www.uclibc.org/downloads/uClibc-0.9.33.tar.xz
fi

# FreeRTOS


# Flash utility

# Show all downloaded files.

echo
md5sum *
echo

############################# Build binutils

echo "@@@ [binutils] unpacking ..."

cd $UNPACKED_SRC_DIRS

tar xf $DOWNLOADS_DIR/binutils-2.24.tar.bz2

echo "@@@ [binutils] Emitting configure help ..."

$BINUTILS_SOURCE_DIR/configure --help > ConfigureHelp_binutils.txt

echo "@@@ [binutils] Creating build directory ..."

mkdir $BINUTILS_BUILD_DIR
cd $BINUTILS_BUILD_DIR

echo "@@@ [binutils] configuring ..."

$BINUTILS_SOURCE_DIR/configure --prefix=$HERE/root --program-prefix=$PROGRAM_PREFIX --target=$TARGET

echo "@@@ [binutils] making ..."

make -j8

echo "@@@ [binutils] installing ..."

make install

############################# Build gcc

echo "@@@ [gcc] unpacking ..."

cd $UNPACKED_SRC_DIRS

tar xf $DOWNLOADS_DIR/gcc-4.8.2.tar.bz2

echo "@@@ [gcc] Emitting configure help ..."

$GCC_SOURCE_DIR/configure --help > ConfigureHelp_gcc.txt

echo "@@@ [gcc] Creating build directory ..."

mkdir $GCC_BUILD_DIR
cd $GCC_BUILD_DIR

echo "@@@ [gcc] configuring ..."

$GCC_SOURCE_DIR/configure --prefix=$HERE/root --program-prefix=$PROGRAM_PREFIX --enable-languages=c --target=$TARGET

echo "@@@ [gcc] making ..."

make -j8

echo "@@@ [gcc] installing ..."
make install

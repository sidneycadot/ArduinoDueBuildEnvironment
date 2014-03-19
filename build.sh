#! /bin/sh

set -e

# gmp
# mpfr
# mpc
# isl
# cloog

# TODO: add binutils

HERE=$PWD

DOWNLOADS_DIR=$HERE/downloads
ROOT_DIR=$HERE/root

BINUTILS_BUILD_DIR=$HERE/build-binutils
BINUTILS_SOURCE_DIR=$HERE/binutils-2.24

GCC_BUILD_DIR=$HERE/build-gcc
GCC_SOURCE_DIR=$HERE/gcc-4.8.2

TARGET=arm-none-eabi

rm -rf $BINUTILS_SOURCE_DIR $BINUTILS_BUILD_DIR
rm -rf $GCC_SOURCE_DIR      $GCC_BUILD_DIR
rm -rf $ROOT_DIR

#############################

if [ ! -d $DOWNLOADS_DIR ] ; then
    mkdir -p $DOWNLOADS_DIR
fi

cd $DOWNLOADS_DIR

if [ ! -f binutils-2.24.tar.bz2 ] ; then
    wget http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.bz2
fi

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

############################# Build binutils

cd $HERE

tar xf $DOWNLOADS_DIR/binutils-2.24.tar.bz2

mkdir $BINUTILS_BUILD_DIR
cd $BINUTILS_BUILD_DIR

$BINUTILS_SOURCE_DIR/configure --prefix=$HERE/root --program-prefix=sidney- --target=$TARGET

make -j8

make install

############################# Build gcc

cd $HERE

tar xf $DOWNLOADS_DIR/gcc-4.8.2.tar.bz2

mkdir $GCC_BUILD_DIR
cd $GCC_BUILD_DIR

$GCC_SOURCE_DIR/configure --prefix=$HERE/root --program-prefix=sidney- --enable-languages=c,c++ --target=$TARGET

make -j8

make install

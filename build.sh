#! /bin/sh

set -e

HERE=$PWD

######################################## set up basic variables

BINUTILS_VERSION=2.24
GCC_VERSION=4.8.2
NEWLIB_VERSION=2.1.0
GDB_VERSION=7.7

BINUTILS_DIRNAME=binutils-$BINUTILS_VERSION
GCC_DIRNAME=gcc-$GCC_VERSION
NEWLIB_DIRNAME=newlib-$NEWLIB_VERSION
GDB_DIRNAME=gdb-$GDB_VERSION

BINUTILS_TARBALL=$BINUTILS_DIRNAME.tar.bz2
GCC_TARBALL=$GCC_DIRNAME.tar.bz2
NEWLIB_TARBALL=$NEWLIB_DIRNAME.tar.gz
GDB_TARBALL=$GDB_DIRNAME.tar.bz2

BINUTILS_TARBALL_URL=ftp://ftp.gnu.org/gnu/binutils/$BINUTILS_TARBALL
GCC_TARBALL_URL=ftp://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/$GCC_TARBALL
GDB_TARBALL_URL=ftp://ftp.gnu.org/gnu/gdb/$GDB_TARBALL
NEWLIB_TARBALL_URL=ftp://sourceware.org/pub/newlib/$NEWLIB_TARBALL

######################################## set up directories

DOWNLOADS_DIR=$HERE/downloads
ROOT_DIR=$HERE/root

SOURCE_DIRS=$HERE/source

BINUTILS_SOURCE_DIR=$SOURCE_DIRS/$BINUTILS_DIRNAME
GCC_SOURCE_DIR=$SOURCE_DIRS/$GCC_DIRNAME
NEWLIB_SOURCE_DIR=$SOURCE_DIRS/$NEWLIB_DIRNAME
GDB_SOURCE_DIR=$SOURCE_DIRS/$GDB_DIRNAME

BUILD_DIRS=$HERE/build

BINUTILS_BUILD_DIR=$BUILD_DIRS/$BINUTILS_DIRNAME
GCC_BOOTSTRAP_BUILD_DIR=$BUILD_DIRS/$GCC_DIRNAME-bootstrap
NEWLIB_BUILD_DIR=$BUILD_DIRS/$NEWLIB_DIRNAME
GCC_FULL_BUILD_DIR=$BUILD_DIRS/$GCC_DIRNAME-full
GDB_BUILD_DIR=$BUILD_DIRS/$GDB_DIRNAME

######################################## set up option variables

TARGET=arm-none-eabi

PROGRAM_PREFIX=$TARGET-

MAKE_OPTS="-j8"

########################################

echo "@@@ [all] removing stale directories ..."

rm -rf $SOURCE_DIRS
rm -rf $BUILD_DIRS
rm -rf $ROOT_DIR

########################################

echo "@@@ [all] setting up fresh directories ..."

mkdir $SOURCE_DIRS
mkdir $BUILD_DIRS
mkdir $ROOT_DIR

if [ ! -d $DOWNLOADS_DIR ] ; then
    mkdir $DOWNLOADS_DIR
fi

########################################

echo "@@@ [all] fetching tarballs ..."

cd $DOWNLOADS_DIR

# Binutils

if [ ! -f $BINUTILS_TARBALL ] ; then
    wget $BINUTILS_TARBALL_URL
fi

# GCC and its dependencies

if [ ! -f $GCC_TARBALL ] ; then
    wget $GCC_TARBALL_URL
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

if [ ! -f $NEWLIB_TARBALL ] ; then
    wget $NEWLIB_TARBALL_URL
fi

if [ ! -f uClibc-0.9.33.tar.xz ] ; then
    wget http://www.uclibc.org/downloads/uClibc-0.9.33.tar.xz
fi

# GDB

if [ ! -f $GDB_TARBALL ] ; then
    wget $GDB_TARBALL_URL
fi

# ASF

# FreeRTOS

if [ ! -f FreeRTOSV8.0.0.zip ] ; then
    http://garr.dl.sourceforge.net/project/freertos/FreeRTOS/V8.0.0/FreeRTOSV8.0.0.zip
fi

# Flash utility: BOSSA

# Minix

# Show all downloaded files.

echo
md5sum *
echo

######################################## build binutils

echo "@@@ [binutils] unpacking source ..."

tar x -C $SOURCE_DIRS -f $DOWNLOADS_DIR/$BINUTILS_TARBALL

echo "@@@ [binutils] emitting configure help ..."

$BINUTILS_SOURCE_DIR/configure --help > $HERE/ConfigureHelp_binutils.txt

echo "@@@ [binutils] configuring in new build directory ..."

mkdir $BINUTILS_BUILD_DIR && cd $BINUTILS_BUILD_DIR

$BINUTILS_SOURCE_DIR/configure --prefix=$ROOT_DIR --program-prefix=$PROGRAM_PREFIX $CONFIG_OPTS_EXTRA --target=$TARGET

echo "@@@ [binutils] making ..."

make $MAKE_OPTS

echo "@@@ [binutils] installing ..."

make install

echo "@@@ [binutils] creating rootdir index ..."

find $ROOT_DIR -type f -print0 | xargs -0 md5sum > $HERE/md5_after_binutils

######################################## build gcc/bootstrap

# Note that building the toolchain depends on the availability of a C library
# To solve this, we perform these steps:
#
# (1) Build the gcc compiler partially (good enough to be able to build newlib) -- a "gcc bootstrap" build.
# (2) Build newlib using the bootstrap compiler.
# (3) Build a full gcc.

echo "@@@ [gcc/bootstrap] unpacking source ..."

tar x -C $SOURCE_DIRS -f $DOWNLOADS_DIR/$GCC_TARBALL

echo "@@@ [gcc/bootstrap] emitting configure help ..."

$GCC_SOURCE_DIR/configure --help > $HERE/ConfigureHelp_gcc.txt

echo "@@@ [gcc/bootstrap] configuring in new build directory ..."

mkdir $GCC_BOOTSTRAP_BUILD_DIR && cd $GCC_BOOTSTRAP_BUILD_DIR

$GCC_SOURCE_DIR/configure  --target=$TARGET --prefix=$ROOT_DIR --program-prefix=$PROGRAM_PREFIX --enable-languages=c,c++ --without-headers --with-newlib --with-gnu-as --with-gnu-ld

echo "@@@ [gcc/bootstrap] making ..."

make $MAKE_OPTS all-gcc

echo "@@@ [gcc/bootstrap] installing ..."

make install-gcc

echo "@@@ [gcc/bootstrap] creating rootdir index ..."

find $ROOT_DIR -type f -print0 | xargs -0 md5sum > $HERE/md5_after_gcc_bootstrap

######################################## build newlib

echo "@@@ [newlib] unpacking source ..."

tar x -C $SOURCE_DIRS -f $DOWNLOADS_DIR/$NEWLIB_TARBALL

echo "@@@ [newlib] emitting configure help ..."

$NEWLIB_SOURCE_DIR/configure --help > $HERE/ConfigureHelp_newlib.txt

echo "@@@ [newlib] configuring in new build directory ..."

# Note that newlib expects the toolchain commands to be named arm-eabi-name-<toolname>, and there is
# no easy way to override this.
#
# We use the "--disable-newlib-supplied-syscalls" to omit the 17 stub 'syscalls' provided by newlib.
# Better alternatives are provided by the Atmel Software Framework (ASF).

# We add to PATH, to make sure that the newlib configure script finds the just-installed GCC bootstrap compiler.
export PATH=$ROOT_DIR/bin:$PATH

mkdir $NEWLIB_BUILD_DIR && cd $NEWLIB_BUILD_DIR

$NEWLIB_SOURCE_DIR/configure --target=$TARGET --prefix=$ROOT_DIR --disable-newlib-supplied-syscalls

echo "@@@ [newlib] making ..."

make all $MAKE_OPTS

echo "@@@ [newlib] installing ..."

make install

echo "@@@ [newlib] creating rootdir index ..."

find $ROOT_DIR -type f -print0 | xargs -0 md5sum > $HERE/md5_after_newlib

######################################## build gcc/full

echo "@@@ [gcc/full] configuring in new build directory ..."

mkdir $GCC_FULL_BUILD_DIR && cd $GCC_FULL_BUILD_DIR

$GCC_SOURCE_DIR/configure --target=$TARGET --prefix=$ROOT_DIR --program-prefix=$PROGRAM_PREFIX --enable-languages=c,c++ --with-newlib --with-gnu-as --with-gnu-ld --disable-shared --disable-libssp

echo "@@@ [gcc/full] making ..."

make $MAKE_OPTS all

echo "@@@ [gcc/full] installing ..."

make install

echo "@@@ [gcc/full] creating rootdir index ..."

find $ROOT_DIR -type f -print0 | xargs -0 md5sum > $HERE/md5_after_gcc_full

######################################## build gdb

echo "@@@ [gdb] unpacking source ..."

tar x -C $SOURCE_DIRS -f $DOWNLOADS_DIR/$GDB_TARBALL

echo "@@@ [gdb] emitting configure help ..."

$NEWLIB_SOURCE_DIR/configure --help > $HERE/ConfigureHelp_gdb.txt

echo "@@@ [gdb] configuring in new build directory ..."

mkdir $GDB_BUILD_DIR && cd $GDB_BUILD_DIR

$GDB_SOURCE_DIR/configure --target=$TARGET --prefix=$ROOT_DIR --program-prefix=$PROGRAM_PREFIX

echo "@@@ [gdb] making ..."

make $MAKE_OPTS all

echo "@@@ [gdb] installing ..."

make install

echo "@@@ [gdb] creating rootdir index ..."

find $ROOT_DIR -type f -print0 | xargs -0 md5sum > $HERE/md5_after_gdb

######################################## all done

echo
echo "@@@ all done!"

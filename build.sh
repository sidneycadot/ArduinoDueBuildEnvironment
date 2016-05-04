#! /bin/sh

set -e

HERE=$PWD

######################################## set up basic variables

# CMSIS:
#
#     https://silver.arm.com/download/Development_Tools/Keil/Keil:_generic/CMSIS-SP-00300-r3p1-00rel0/CMSIS-SP-00300-r3p1-00rel0.zip
#
# NOTE: gcc6 does not requite "CLOOOG" anymore.

BINUTILS_VERSION=2.26
GCC_VERSION=6.1.0
GMP_VERSION=6.1.0
MPFR_VERSION=3.1.4
MPC_VERSION=1.0.3
ISL_VERSION=0.16.1
NEWLIB_VERSION=2.4.0
GDB_VERSION=7.11
ASF_VERSION=3.31.0.46
#UCLIBC_VERSION=0.9.33.2
#GLIBC_VERSION=2.22
#FREERTOS_VERSION=8.2.2

# Note: ISL version 0.15 doesn't currently seem to be compatible with GCC!
# ISL versions supposedly supported by GCC: 0.12.2, 0.13, 0.14, 0.15

BINUTILS_DIRNAME=binutils-${BINUTILS_VERSION}
GCC_DIRNAME=gcc-${GCC_VERSION}
GMP_DIRNAME=gmp-${GMP_VERSION}
MPFR_DIRNAME=mpfr-${MPFR_VERSION}
MPC_DIRNAME=mpc-${MPC_VERSION}
ISL_DIRNAME=isl-${ISL_VERSION}
NEWLIB_DIRNAME=newlib-${NEWLIB_VERSION}
GDB_DIRNAME=gdb-${GDB_VERSION}
#UCLIBC_DIRNAME=uClibc-${UCLIBC_VERSION}
#GLIBC_DIRNAME=glibc-${GLIBC_VERSION}
#FREERTOS_DIRNAME=FreeRTOSv${FREERTOS_VERSION}

# NOTE: we don't define ASF_DIRNAME.
# ASF_ZIPFILE unpacks to a directory called "xdk-asf-${ASF_VERSION}".

BINUTILS_TARBALL=${BINUTILS_DIRNAME}.tar.bz2
GCC_TARBALL=${GCC_DIRNAME}.tar.bz2
GMP_TARBALL=${GMP_DIRNAME}.tar.lz
MPFR_TARBALL=${MPFR_DIRNAME}.tar.xz
MPC_TARBALL=${MPC_DIRNAME}.tar.gz
ISL_TARBALL=${ISL_DIRNAME}.tar.xz
NEWLIB_TARBALL=${NEWLIB_DIRNAME}.tar.gz
GDB_TARBALL=${GDB_DIRNAME}.tar.xz
ASF_ZIPFILE=asf-standalone-archive-${ASF_VERSION}.zip
#UCLIBC_TARBALL=${UCLIBC_DIRNAME}.tar.xz
#GLIBC_TARBALL=${GLIBC_DIRNAME}.tar.xz
#FREERTOS_ZIPFILE=${FREERTOS_DIRNAME}.zip

BINUTILS_TARBALL_URL=ftp://ftp.gnu.org/gnu/binutils/${BINUTILS_TARBALL}
GCC_TARBALL_URL=ftp://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/${GCC_TARBALL}
GMP_TARBALL_URL=https://gmplib.org/download/gmp/${GMP_TARBALL}
MPFR_TARBALL_URL=http://www.mpfr.org/mpfr-current/${MPFR_TARBALL}
MPC_TARBALL_URL=ftp://ftp.gnu.org/gnu/mpc/${MPC_TARBALL}
ISL_TARBALL_URL=http://isl.gforge.inria.fr/${ISL_TARBALL}
NEWLIB_TARBALL_URL=ftp://sourceware.org/pub/newlib/${NEWLIB_TARBALL}
GDB_TARBALL_URL=ftp://ftp.gnu.org/gnu/gdb/${GDB_TARBALL}
ASF_ZIPFILE_URL=http://www.atmel.com/images/${ASF_ZIPFILE}
#UCLIBC_TARBALL_URL=http://www.uclibc.org/downloads/${UCLIBC_TARBALL}
#GLIBC_TARBALL_URL=ftp://ftp.gnu.org/gnu/glibc/${GLIBC_TARBALL}
#FREERTOS_ZIPFILE_URL=http://freefr.dl.sourceforge.net/project/freertos/FreeRTOS/V${FREERTOS_VERSION}/${FREERTOS_ZIPFILE}

######################################## set up directory environment variables

DOWNLOADS_DIR=${HERE}/downloads
ROOT_DIR=${HERE}/root

SOURCE_DIR=${HERE}/source

BINUTILS_SOURCE_DIR=${SOURCE_DIR}/${BINUTILS_DIRNAME}
GCC_SOURCE_DIR=${SOURCE_DIR}/${GCC_DIRNAME}
GMP_SOURCE_DIR=${SOURCE_DIR}/${GMP_DIRNAME}
MPFR_SOURCE_DIR=${SOURCE_DIR}/${MPFR_DIRNAME}
MPC_SOURCE_DIR=${SOURCE_DIR}/${MPC_DIRNAME}
ISL_SOURCE_DIR=${SOURCE_DIR}/${ISL_DIRNAME}
NEWLIB_SOURCE_DIR=${SOURCE_DIR}/${NEWLIB_DIRNAME}
GDB_SOURCE_DIR=${SOURCE_DIR}/${GDB_DIRNAME}

BUILD_DIR=$HERE/build

BINUTILS_BUILD_DIR=${BUILD_DIR}/${BINUTILS_DIRNAME}
GCC_BOOTSTRAP_BUILD_DIR=${BUILD_DIR}/${GCC_DIRNAME}-bootstrap
NEWLIB_BUILD_DIR=${BUILD_DIR}/${NEWLIB_DIRNAME}
GCC_FULL_BUILD_DIR=${BUILD_DIR}/${GCC_DIRNAME}-full
GDB_BUILD_DIR=${BUILD_DIR}/${GDB_DIRNAME}

######################################## set up option variables

TARGET=arm-none-eabi

PROGRAM_PREFIX=$TARGET-

MAKE_OPTS="-j8"

########################################

echo "@@@ [all] removing stale directories ..."

rm -rf ${SOURCE_DIR}
rm -rf ${BUILD_DIR}
rm -rf ${ROOT_DIR}

########################################

echo "@@@ [all] setting up fresh directories ..."

mkdir ${SOURCE_DIR}
mkdir ${BUILD_DIR}
mkdir ${ROOT_DIR}

if [ ! -d ${DOWNLOADS_DIR} ] ; then
    mkdir ${DOWNLOADS_DIR}
fi

########################################

echo "@@@ [all] fetching tarballs ..."

cd ${DOWNLOADS_DIR}

# Binutils

if [ ! -f ${BINUTILS_TARBALL} ] ; then
    wget ${BINUTILS_TARBALL_URL}
fi

# GCC and its dependencies

if [ ! -f ${GCC_TARBALL} ] ; then
    wget ${GCC_TARBALL_URL}
fi

# Dependencies of GCC

if [ ! -f ${GMP_TARBALL} ] ; then
    wget ${GMP_TARBALL_URL}
fi

if [ ! -f ${MPFR_TARBALL} ] ; then
    wget ${MPFR_TARBALL_URL}
fi

if [ ! -f ${MPC_TARBALL} ] ; then
    wget ${MPC_TARBALL_URL}
fi

if [ ! -f ${ISL_TARBALL} ] ; then
    wget ${ISL_TARBALL_URL}
fi

# C libraries

if [ ! -f ${NEWLIB_TARBALL} ] ; then
    wget ${NEWLIB_TARBALL_URL}
fi

#if [ ! -f ${UCLIBC_TARBALL} ] ; then
#    wget ${UCLIBC_TARBALL_URL}
#fi

#if [ ! -f ${GLIBC_TARBALL} ] ; then
#    wget ${GLIBC_TARBALL_URL}
#fi

# GDB

if [ ! -f ${GDB_TARBALL} ] ; then
    wget ${GDB_TARBALL_URL}
fi

# Atmel Software Framework (ASF)

if [ ! -f ${ASF_ZIPFILE} ] ; then
    wget ${ASF_ZIPFILE_URL}
fi

# FreeRTOS

#if [ ! -f ${FREERTOS_ZIPFILE} ] ; then
#    wget ${FREERTOS_ZIPFILE_URL}
#fi

# Flash utility: bossa, OpenOCD

# Minix

# Show MD5 hashes of all downloaded files.

echo
md5sum *
echo

# Return to toplevel directory.

cd ${HERE}

######################################## build binutils

echo "@@@ [binutils] unpacking source ..."

tar x -C ${SOURCE_DIR} -f ${DOWNLOADS_DIR}/${BINUTILS_TARBALL}

echo "@@@ [binutils] emitting configure help ..."

${BINUTILS_SOURCE_DIR}/configure --help > ${BUILD_DIR}/ConfigureHelp_binutils.txt

echo "@@@ [binutils] configuring in new build directory ..."

mkdir ${BINUTILS_BUILD_DIR} && cd ${BINUTILS_BUILD_DIR}

${BINUTILS_SOURCE_DIR}/configure --prefix=${ROOT_DIR} --program-prefix=${PROGRAM_PREFIX} --target=${TARGET}

echo "@@@ [binutils] making ..."

make ${MAKE_OPTS}

echo "@@@ [binutils] installing ..."

make install

echo "@@@ [binutils] creating rootdir index ..."

find ${ROOT_DIR} -type f -print0 | xargs -0 md5sum > ${BUILD_DIR}/md5_after_binutils

######################################## build gcc/bootstrap

# Note that building the toolchain depends on the availability of a C library; but the C library must be built with a compiler.
# To solve this, we perform these steps:
#
# (1) Build the gcc compiler partially (good enough to be able to build newlib) -- a "gcc bootstrap" build.
# (2) Build newlib using the bootstrap compiler.
# (3) Build a full gcc.

echo "@@@ [gcc/bootstrap] unpacking source ..."

tar x -C ${SOURCE_DIR} -f ${DOWNLOADS_DIR}/${GCC_TARBALL}

echo "@@@ [gcc/bootstrap] unpacking source of GCC dependencies ..."

tar x -C ${SOURCE_DIR} -f ${DOWNLOADS_DIR}/${GMP_TARBALL}
tar x -C ${SOURCE_DIR} -f ${DOWNLOADS_DIR}/${MPFR_TARBALL}
tar x -C ${SOURCE_DIR} -f ${DOWNLOADS_DIR}/${MPC_TARBALL}
tar x -C ${SOURCE_DIR} -f ${DOWNLOADS_DIR}/${ISL_TARBALL}

echo "@@@ [gcc/bootstrap] linking GCC dependencies into GCC source directory ..."

# Linking these into the GCC directory with the names given will instruct GCC to use them for its own build.
# See http://gcc.gnu.org/install/prerequisites.html

ln -s ${GMP_SOURCE_DIR}   ${GCC_SOURCE_DIR}/gmp
ln -s ${MPFR_SOURCE_DIR}  ${GCC_SOURCE_DIR}/mpfr
ln -s ${MPC_SOURCE_DIR}   ${GCC_SOURCE_DIR}/mpc
ln -s ${ISL_SOURCE_DIR}   ${GCC_SOURCE_DIR}/isl

echo "@@@ [gcc/bootstrap] emitting configure help ..."

${GCC_SOURCE_DIR}/configure --help > ${BUILD_DIR}/ConfigureHelp_gcc.txt

echo "@@@ [gcc/bootstrap] configuring in new build directory ..."

mkdir ${GCC_BOOTSTRAP_BUILD_DIR} && cd ${GCC_BOOTSTRAP_BUILD_DIR}

${GCC_SOURCE_DIR}/configure --target=${TARGET} --prefix=${ROOT_DIR} --program-prefix=${PROGRAM_PREFIX} --enable-languages=c,c++ --without-headers --with-newlib --with-gnu-as --with-gnu-ld

echo "@@@ [gcc/bootstrap] making ..."

make ${MAKE_OPTS} all-gcc

echo "@@@ [gcc/bootstrap] installing ..."

make install-gcc

echo "@@@ [gcc/bootstrap] creating rootdir index ..."

find ${ROOT_DIR} -type f -print0 | xargs -0 md5sum > ${BUILD_DIR}/md5_after_gcc_bootstrap

######################################## build newlib using the bootstrap GCC

echo "@@@ [newlib] unpacking source ..."

tar x -C $SOURCE_DIR -f $DOWNLOADS_DIR/$NEWLIB_TARBALL

echo "@@@ [newlib] emitting configure help ..."

$NEWLIB_SOURCE_DIR/configure --help > $BUILD_DIR/ConfigureHelp_newlib.txt

echo "@@@ [newlib] configuring in new build directory ..."

# Note that newlib expects the toolchain commands to be named arm-eabi-name-<toolname>, and there is
# no easy way to override this.
#
# We use the "--disable-newlib-supplied-syscalls" to omit the 17 stub 'syscalls' provided by newlib.
# Better(?) alternatives are provided by the Atmel Software Framework (ASF).

# We add to PATH, to make sure that the newlib configure script finds the just-installed GCC bootstrap compiler.
export PATH=$ROOT_DIR/bin:$PATH

mkdir $NEWLIB_BUILD_DIR && cd $NEWLIB_BUILD_DIR

$NEWLIB_SOURCE_DIR/configure --target=$TARGET --prefix=$ROOT_DIR --disable-newlib-supplied-syscalls

echo "@@@ [newlib] making ..."

make all $MAKE_OPTS

echo "@@@ [newlib] installing ..."

make install

echo "@@@ [newlib] creating rootdir index ..."

find $ROOT_DIR -type f -print0 | xargs -0 md5sum > $BUILD_DIR/md5_after_newlib

######################################## build gcc/full

echo "@@@ [gcc/full] configuring in new build directory ..."

mkdir $GCC_FULL_BUILD_DIR && cd $GCC_FULL_BUILD_DIR

$GCC_SOURCE_DIR/configure --target=$TARGET --prefix=$ROOT_DIR --program-prefix=$PROGRAM_PREFIX --enable-languages=c,c++ --with-newlib --with-gnu-as --with-gnu-ld --disable-shared --disable-libssp

echo "@@@ [gcc/full] making ..."

make $MAKE_OPTS all

echo "@@@ [gcc/full] installing ..."

make install

echo "@@@ [gcc/full] creating rootdir index ..."

find $ROOT_DIR -type f -print0 | xargs -0 md5sum > $BUILD_DIR/md5_after_gcc_full

######################################## build gdb

echo "@@@ [gdb] unpacking source ..."

tar x -C $SOURCE_DIR -f $DOWNLOADS_DIR/$GDB_TARBALL

echo "@@@ [gdb] emitting configure help ..."

$NEWLIB_SOURCE_DIR/configure --help > $BUILD_DIR/ConfigureHelp_gdb.txt

echo "@@@ [gdb] configuring in new build directory ..."

mkdir $GDB_BUILD_DIR && cd $GDB_BUILD_DIR

$GDB_SOURCE_DIR/configure --target=$TARGET --prefix=$ROOT_DIR --program-prefix=$PROGRAM_PREFIX

echo "@@@ [gdb] making ..."

make $MAKE_OPTS all

echo "@@@ [gdb] installing ..."

make install

echo "@@@ [gdb] creating rootdir index ..."

find $ROOT_DIR -type f -print0 | xargs -0 md5sum > $BUILD_DIR/md5_after_gdb

######################################## all done

echo
echo "@@@ all done!"

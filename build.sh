#! /bin/sh

set -e

# gmp
# mpfr
# mpc
# isl
# cloog

HERE=$PWD

rm -rf $HERE/gcc-4.8.2
rm -rf $HERE/build
rm -rf $HERE/root

if [ ! -f gcc-4.8.2.tar.bz2 ] ; then
    wget ftp://ftp.gnu.org/gnu/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2
fi

tar xf gcc-4.8.2.tar.bz2

find $HERE/gcc-4.8.2 gcc-4.8.2 -type f -print0 | xargs -0 md5sum > $HERE/Stage-1

mkdir build
cd build

# Add --target=xxx later

$HERE/gcc-4.8.2/configure --prefix=$HERE/root --program-prefix=sidney --enable-languages=c,c++

find $HERE/gcc-4.8.2 gcc-4.8.2 -type f -print0 | xargs -0 md5sum > $HERE/Stage-2

make

find $HERE/gcc-4.8.2 gcc-4.8.2 -type f -print0 | xargs -0 md5sum > $HERE/Stage-3

make install

find $HERE/gcc-4.8.2 gcc-4.8.2 -type f -print0 | xargs -0 md5sum > $HERE/Stage-4

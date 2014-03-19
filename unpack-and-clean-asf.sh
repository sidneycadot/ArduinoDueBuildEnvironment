#! /bin/sh

rm -rf xdk-asf-3.15.0

unzip asf-standalone-archive-3.15.0.87.zip

cd xdk-asf-3.15.0

rm -rf avr32 mega xmega

rm -rf `find -type d -name "iar"`

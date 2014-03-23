#! /usr/bin/env python

# Touching the Due at 1200 baud resets it.
# TODO: investigate what is meant by "touching"
# TODO: implement a C version.

import serial, sys

if len(sys.argv) > 1:
    device = sys.argv[1]
else:
    device = "/dev/ttyACM0"

ser = serial.Serial(device, baudrate = 1200)
ser.close()

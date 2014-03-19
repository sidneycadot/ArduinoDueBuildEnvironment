#! /bin/sh

# See http://www.atmel.com/products/microcontrollers/arm/sam3x.aspx?tab=documents

if [ ! -f doc11057.pdf ] ; then
    wget http://www.atmel.com/Images/doc11057.pdf
fi

ln -sf doc11057.pdf SAM3X_SAM3A_Series_Complete.pdf

if [ ! -f doc11057s.pdf ] ; then
    wget http://www.atmel.com/Images/doc11057s.pdf
fi

ln -sf doc11057s.pdf SAM3X_SAM3A_Series_Summary.pdf

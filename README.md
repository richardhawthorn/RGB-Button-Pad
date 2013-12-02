Sparkfun rgb button pad
============

Code to get the sparkfun spi rgb button pad work on the electric imp

Sparkfun button pad:
https://www.sparkfun.com/products/retired/9840

I took Arduino code for this device, and re-wrote it to work on the electric imp.  It's a work in progress, and needs some work to make it stable, possibly due to the timings.

The serial protocol is not standard spi, and involves bit-banging the device.

It is the first version of the code, and needs mor work to make it functional.

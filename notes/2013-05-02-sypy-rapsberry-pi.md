
# Python on the Raspberry-Pi

David Lyon - [hackerpads.com/clixx.io](http://hackerpads.com/clixx.io)

RPi was originall designed as a dedicated Python computer (the "Pi" was
originally spelled "Py"). Designed at Cambridge. Phone SOC and supporting
peripherals; operating system "optimised" for the environment.

Has a few features that desktop computers lack:

- Low power consumption: 0.7 A at 3.3 V
- I2C, SPI and digital I/O pins make it easy to connect devices.

"Device drivers in Python, interactively. Very strange definition of device
"driver, but still awesome. Some cool example projects using SimpleCV
"(monitoring fish in aquaponics), clustering, etc.

GPIO access using WiringPi2 (a port of the Wiring interface to Python on RPi)
instead of RPIO.

Use `motion` (Debian package of same name) and use 

    glob.glob("/tmp/motion/*.jpg")

to detect respond to motion in Python.

# serial_com_m
Matlab package for serial communication  
Written by Dan Oates (WPI Class of 2020)

### Description
This package contains serial communication functions and classes targeted
towards embedded systems. The files in this package are described below:

- make_serial : Function to make and open serial port
- make_bluetooth : Function to make and open Bluetooth object
- SerialServer : Class for exchanging asynchronous serial messages
- SerialStruct : Class for exchanging C data types over serial
- Struct : Class for interpreting byte arrays as C data types
- sizeof : Matlab implementation of C sizeof function
- hc06_config : Function for programming HC06 Bluetooth modules

### Cloning and Submodules
Clone this repo as '+serial_com' and add the containing dir to the Matlab path.
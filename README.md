# UART-Transciever

Aim of this project is to creat an UART transceiver: to be implemented on two **_Terasic DE10-Nano_** FPGA Development Kits. This project was done in partial fulfilment of the _EN2111 Electronic Circuits Design_ of University of Moratuwa, Sri Lanka.
The UART transciever has a 115000 MHz of a baud rate

![Block Diagram of the UART Transciever](/Photos/img1.jpg)

This repository contains following files:
- `baudTick.v`  Baudrate generator to downscale the internal clock of 50MHz
- `uartRx.v`    UART receiver
- `uartTx.v`    UART transmitter
- `uart.v`      Integration of UART recevier, transmitter, and the baudrate generator
- `testbench.v` Testbench to simulate the transciever

> [!NOTE]
> Parts of design taken from https://medium.com/@chandulanethmal/uart-communication-link-implementation-with-verilog-hdl-on-fpga-b6e405c5cbd8

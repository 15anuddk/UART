# UART communication protocol is not like SPI or I2C its a hardware circuit.

## The simple_uart: objective: understanding the design and functionality of UART protocol.
Designed receiver and transmitter modules.
✅ Full-duplex communication support

✅ FSM-based TX and RX design

✅ Parity bit support

✅ Configurable timing via clk_per_bit

## UART: Dividing the project into different modules:
Full Duplex UART
### Baud Rate Generator : 
    system clk : 10Mhz
    baud rate : 115200
    clk per bit : ~87
### Parity Bit Unit:
    Supports  3 parity types: No parity, ODD parity, Even Parity

### PISO unit

PISO unit
SIPO Unit 
Depframe Unit
Error Check Unit

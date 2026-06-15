# APB Timer

A simple APB-based countdown timer designed in Verilog.

## Features
- APB read and write operations
- Programmable countdown timer
- Timer completion indication (`timer_done`)
- Parameterizable counter width

## Register Map

| Address | Function |
|-----------|----------|
| 0x00 | Load Register |
| 0x04 | Control Register |
| 0x08 | Counter Value Register |
| 0x0C | Status Register |

## Files

- `apb_timer.v` : RTL design
- `apb_timer_tb.v` : Testbench

## Simulation

1. Reset the timer.
2. Write the countdown value to address `0x00`.
3. Start the timer by writing `1` to address `0x04`.
4. Wait until `timer_done` becomes high.
5. Read registers to verify the operation.

## Tool Used

- Verilog HDL
- Vivado Simulator

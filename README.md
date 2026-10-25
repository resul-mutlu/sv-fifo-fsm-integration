# SystemVerilog FSM and Synchronous FIFO Integration

## Overview
This repository includes a basic SystemVerilog project that shows the design, integration and verification of a finite state machine and a FIFO.
The main aim of the project is to learn about digital logic design and waveform-based debugging.

## Architecture
There are two main hardware blocks in the system integrated within a top-level module:
* **Synchronous FIFO (`sync_fifo.sv`):** A circular buffer that has the First-Word-Fall-Through logic. It manages a read pointer and a write pointer and calculates "full" and "empty" flags to prevent data loss.
* **FSM Controller (`fifo_controller.sv`):** A 3-block moore machine that acts as the brain of the system. When it receives a "start" signal, it changes its state to drive "wr_en" and "wr_data" signals to push a sequence of data in.

## Development Process & Methodology
This project has been developed as a learning environment for Design Verification (DV) practices:
* **LLM Assistance:** AI tools were used to create testbench skeletons and discuss best architectural practices (e.g. dividing FSM logic into three blocks to avoid latches).
* **Manual Debugging & Verification:** Integration, pointer bit-width corrections and race condition resolutions were managed manually. To verify accurate state transitions and exact-clock-cycle data propagation waveform analysis was heavily utilized.

## Toolchain
* Language: SystemVerilog (IEEE 1800-2012)
* Environment: Windows Subsystem for Linux (WSL - Ubuntu)
* Compiler/Simulator: Icarus Verilog (`iverilog`)
* Waveform Viewer: GTKWave

## How to Run the Simulation
To compile and run the top-level integration test on a Linux/WSL terminal, one can write the following commands:

```bash
iverilog -g2012 -o sim_top tb/tb_top_system.sv rtl/top_system.sv rtl/fifo_controller.sv rtl/sync_fifo.sv
./sim_top
gtkwave top_dump.vcd &

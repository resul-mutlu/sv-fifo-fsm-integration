# SystemVerilog FSM and Synchronous FIFO Integration

## Overview
A small SystemVerilog learning project: a synchronous FIFO and a Moore FSM, integrated in a top-level module and tested in simulation. The goal was to practice RTL design, integration, and waveform-based debugging.

## Architecture
* **`sync_fifo.sv`**: A parameterized circular-buffer FIFO (default 8-bit x 16). The pointers have one extra MSB to tell full from empty. The read is first-word-fall-through: `rd_data` shows the oldest entry combinationally, without waiting for `rd_en`.
* **`fifo_controller.sv`**: A Moore FSM written in three blocks (state register, next-state logic, output logic). On `start` it pushes three fixed bytes (`AA`, `BB`, `CC`) and returns to `IDLE`. It does not check `full`; if the FIFO is already full, the FIFO's own `!full` guard drops the extra writes.
* **`top_system.sv`**: Connects the FSM's write interface to the FIFO.

## Verification status
Each block has a directed testbench:

* `tb_sync_fifo.sv`: fills the FIFO, keeps writing while full (overflow), then drains it.
* `tb_fifo_controller.sv`: triggers one `start` pulse and observes the FSM sequence.
* `tb_top_system.sv`: triggers the FSM, then reads the three bytes back.

Results were checked manually in GTKWave. **The testbenches are not self-checking**: they print "finished", not "passed". A self-checking approach is the next step, developed in my async-fifo project.

## Use of AI tools
AI tools (LLMs) were used to create testbench skeletons and to discuss design practices (e.g. splitting the FSM into three blocks to avoid latches). Integration, pointer bit-width fixes, and race-condition fixes were done manually with waveform analysis.

## Toolchain
* SystemVerilog (IEEE 1800-2012)
* Icarus Verilog (`iverilog`) on WSL (Ubuntu)
* GTKWave

## How to run
```bash
iverilog -g2012 -o sim_top tb/tb_top_system.sv rtl/top_system.sv rtl/fifo_controller.sv rtl/sync_fifo.sv
./sim_top
gtkwave top_dump.vcd &
```

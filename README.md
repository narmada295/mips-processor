# MIPS Processor (Gate-Level Verilog Implementation)

## Overview

This project implements a **subset of the 32-bit MIPS processor** using **gate-level modeling in Verilog**. It simulates a **single-cycle datapath** capable of executing a selected set of MIPS instructions including arithmetic, memory, and control flow operations.

The entire processor is built **modularly**, with custom implementations for instruction memory, data memory, ALU, control logic, program counter, register file, and multiplexers. No behavioral-level constructs were used in datapath components.

## Supported Instructions

### Memory Access
- `lw` – Load Word  
- `sw` – Store Word

### Arithmetic/Logic Operations
- `add`, `sub`, `and`, `or`, `slt`, `nor`

### Control Flow
- `beq` – Branch on Equal  
- `j` – Unconditional Jump  
- `jal` – Jump and Link

## Features

- **Gate-level ALU** supporting addition, subtraction, AND, OR, SLT, and NOR using full-adder chains and logic gates  
- **32 general-purpose registers** in the register file (register 0 hardwired to 0)  
- **Instruction fetch and decode** with a modular program counter and instruction memory  
- **Control unit** decoding opcodes and generating all required control signals  
- **ALU Control** logic decoding function fields for R-type instructions  
- **Branching and Jumping** support including PC update logic, immediate shift, and JAL address construction  
- **Separate instruction and data memory** (ROM/RAM) with load/store support  
- **Modular design**, each datapath component implemented in a separate Verilog module  

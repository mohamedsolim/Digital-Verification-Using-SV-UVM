# Class-Based Verification for a Synchronous FIFO:

SystemVerilog - class based verification of a parameterized Synchronous FIFO with code coverage, functional coverage, and assertions.

## Project Overview

A Synchronous FIFO (First In, First Out) is a memory queue where data enters from one side (the write interface) and exits from the other side (the read interface) in the same order it was written. Both the write and read operations are synchronized to a common clock. This type of FIFO is widely used in digital systems for buffering data between different parts of a system operating at the same clock frequency.

## Parameters
• FIFO_WIDTH: DATA in/out and memory word width (default: 16)

• FIFO_DEPTH: Memory depth (default: 8)

## Ports 


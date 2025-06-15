### Matrix Multiplication Using Systolic Arrays - Hardware Accelerator

## Overview
This project implements a hardware accelerator for matrix multiplication using systolic array architecture in SystemVerilog. It features a modular, scalable design optimized for AI/ML workloads. The accelerator interfaces with software via an APB slave interface, enabling seamless communication and control from Python or other host programs.
The goal is to demonstrate hardware-software co-design by offloading matrix multiplication to a custom accelerator and comparing its performance with standard CPU-based libraries like NumPy.

## Features
Parameterizable matrix size (e.g., 32x32)
Systolic array design for efficient parallel multiply-accumulate operations
APB slave interface for communication with host software
Fully verified using Cocotb testbench framework
Performance benchmarking against NumPy matrix multiplication
Comprehensive documentation and waveform captures included

## Repository Structure

/Design                 # SystemVerilog RTL source files


/Hardware               # Hardware for MMU 
   /syn                 # Synthesis-related files and data
   
       /scripts         # Synthesis scripts (e.g., DC Shell scripts)
       
       /reports         # Synthesis reports (area, timing, power)
       
       /outputs         # Synthesis output files (netlists, logs)

   /apr                 # Automatic Place and Route files and data
   
       /scripts         # APR scripts (for place and route tools)
       
       /reports         # APR reports (congestion, timing, utilization)
       
       /outputs         # APR output files (route_db, spef, logs)

/README.md              # This file — project overview and instructions

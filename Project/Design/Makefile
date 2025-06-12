export PYTHONPATH := /u/routh/HW_AI_ML/Project/Design:$(PYTHONPATH)

TOPLEVEL_LANG = verilog
SIM = questa

# Verilog/SystemVerilog sources
VERILOG_SOURCES = $(shell pwd)/apb_if.sv \
                  $(shell pwd)/MAC.sv \
                  $(shell pwd)/MMU.sv \
                  $(shell pwd)/matmul_top.sv

# Top-level module name
TOPLEVEL = matmul_top

# Python testbench file (test_matmul_apb.py with @cocotb.test)
MODULE = Apb_master

# Extra compile arguments (SystemVerilog support)
COMPILE_ARGS += -sv
# QuestaSim Simulation Arguments
VSIM_ARGS += -voptargs=+acc


# Optional: dump waveform
WAVES = 1
GUI = 0

# Simulation build output directory
BUILD_DIR = sim_build

# Include Cocotb makefile
include $(shell cocotb-config --makefiles)/Makefile.sim


vlog MAC.sv
vlog TPU.sv
vlog MMU.sv
vlog test_TPU.sv





# Load simulation
vsim work.test_TPU

vsim -voptargs=+acc work.test_TPU

# Optional: Open waveform viewer
 add wave -r /*

run 5000ns

# Run simulation
run -all



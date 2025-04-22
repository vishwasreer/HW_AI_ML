# Compile the design files
vlog fully_connected_network.v
vlog spi_master.v
vlog top_level.v
vlog tb_top_level.v

# Create the work library
vlib work
vmap work ./work

# Run the simulation
vsim tb_top_level

# Set simulation options
add wave -position end sim:/tb_top_level/*

# Run the simulation
run -all


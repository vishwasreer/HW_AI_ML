#####################################################
# Main Code
####################################################
source ../../${top_design}.design_config.tcl

set designs [get_db designs * ]
if { $designs != "" } {
  delete_obj $designs
}


source ../scripts/innovus-get-timlibslefs.tcl
source ../../constraints/${top_design}.mmmc.sdc

set_db init_design_netlist_type Verilog
set_db init_netlist_files ../../syn/outputs/${top_design}.genus.vg
set_db init_power_nets VDD
set_db init_ground_nets VSS

read_mmmc mmmc.tcl

read_physical -lef "$tech_lef [glob saed*.lef]"
read_netlist "../../syn/outputs/${top_design}.genus.vg" -top "$top_design"
init_design


source ../../${top_design}.design_options.tcl

source ../scripts/floorplan-innovus-cui.tcl


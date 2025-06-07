set top_design MMU
source -echo -verbose ../$top_design.design_config.tcl

set rtl_list [list ../rtl/MMU.sv ../rtl/TPU.sv ../rtl/MAC.sv]

# List all current designs
#set this_design [ list_designs ]

source ../dc-get-timlibs.tcl

# Analyzing the files for the design
analyze $rtl_list -autoread -define SYNTHESIS
#analyze MAC.sv -autoread -define SYNTHESIS
#analyze TPU.sv -autoread -define SYNTHESIS
#analyze MMU.sv -autoread -define SYNTHESIS
#set top_design MMU

# Elaborate the FIFO design
elaborate ${top_design} 
#elaborate MAC.sv
#elaborate TPU.sv
#elaborate MMU.sv
#set top_design MMU


change_names -rules verilog -hierarchy

# Load the timing and design constraints
source -echo -verbose ../${top_design}.sdc

# any additional non-design specific constraints
set_max_transition 0.5 [current_design ]

# Duplicate any non-unique modules so details can be different inside for synthesis
set_dont_use [get_lib_cells */DELLN* ]

uniquify

#compile with ultra features and with scan FFs
compile_ultra  -scan  -no_autoungroup
change_names -rules verilog -hierarchy

# output reports
set stage dc
report_qor > ../reports/${top_design}.$stage.qor.rpt
report_constraint -all_viol > ../reports/${top_design}.$stage.constraint.rpt
report_timing -delay max -input -tran -cross -sig 4 -derate -net -cap  -max_path 10000 -slack_less 0 > ../reports/${top_design}.$stage.timing.max.rpt
check_timing  > ../reports/${top_design}.$stage.check_timing.rpt
check_design > ../reports/${top_design}.$stage.check_design.rpt
check_mv_design  > ../reports/${top_design}.$stage.mvrc.rpt

# output netlist
write -hier -format verilog -output ../outputs/${top_design}.$stage.vg
write -hier -format ddc -output ../outputs/${top_design}.$stage.ddc
save_upf ../outputs/${top_design}.$stage.upf


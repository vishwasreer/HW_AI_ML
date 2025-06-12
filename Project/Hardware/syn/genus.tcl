history keep 100
set_db timing_report_fields "delay arrival transition fanout load cell timing_point"

source -echo -verbose ../$top_design.design_config.tcl


source ../genus-get-timlibslefs.tcl

set_db init_lib_search_path $search_path

set_db library $link_library

set_db dft_opcg_domain_blocking true

set_db auto_ungroup none

# Analyzing the current FIFO design
read_hdl -language sv ../rtl/${top_design}.sv

elaborate $top_design

#return -level 9 

# This needs to be after add_ios
update_names -map { {"." "_" }} -inst -force
update_names -map {{"[" "_"} {"]" "_"}} -inst -force
update_names -map {{"[" "_"} {"]" "_"}} -port_bus
update_names -map {{"[" "_"} {"]" "_"}} -hport_bus
update_names -inst -hnet -restricted {[} -convert_string "_"
update_names -inst -hnet -restricted {]} -convert_string "_"


# Load the timing and design constraints
source -echo -verbose ../${top_design}.sdc

set_dont_use [get_lib_cells */DELLN* ]

syn_gen
# any additional non-design specific constraints
#set_max_transition 0.5 [current_design ]

# Duplicate any non-unique modules so details can be different inside for synthesis
uniquify $top_design


#compile with ultra features and with scan FFs
syn_map


syn_opt

# output reports
set stage genus
report_qor > ${top_design}.$stage.qor.rpt
#report_constraint -all_viol > ../reports/${top_design}.$stage.constraint.rpt
report_timing -max_path 1000 > ${top_design}.$stage.timing.max.rpt
#check_timing_intent -verbose  > ../reports/${top_design}.$stage.check_timing.rpt
#check_design  > ../reports/${top_design}.$stage.check_design.rpt
#check_mv_design  > ../reports/${top_design}.$stage.mvrc.rpt

# output netlist
write_hdl $top_design > outputs/${top_design}.$stage.vg

write_db -all_root_attributes -verbose outputs/${top_design}.$stage.db


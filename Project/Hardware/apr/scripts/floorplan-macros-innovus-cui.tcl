source ../../$top_design.design_config.tcl

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


set_interactive_constraint_modes [all_constraint_modes -active]


if { $pad_design } {
    # subtract off the IO width if this is a pad design.  The floorplan statement automatically includes the IO border
    set margin [expr $design_io_border - 300 ]
} else {
    set margin $design_io_border
}

create_floorplan -core_size [lindex $design_size 0 ] [lindex $design_size 1 ] $margin $margin $margin $margin -flip s -core_margins_by io

#create_row -area "0.0000 0.0000 [lindex $design_size 0 ] [ lindex $design_size 1 ]" -site unitdouble

#placeInstance fifomem/genblk1_0__U 500 500 W -fixed

if { $add_ios } {
    source ../scripts/floorplan-ios-innovus.tcl
    read_io_file ${top_design}.io
}

source ../../${top_design}.design_options.tcl

if { $innovus_enable_manual_macro_placement == 0} {
    # Running automatic macro placement.
    place_area_ios  
} elseif { $innovus_enable_manual_macro_placement == 1} {
    # Placing IOs and running macro placement scripts. 
    place_area_ios -only_area_ios 
    source ../../${top_design}.macro_placement_innovus.tcl
}
#defOut -noStdCells -noTracks -noSpecialNet -noTracks  "../outputs/${top_design}.floorplan.innovus.macros.def"

gui_deselect -all
select_obj [ get_ports * ]
select_obj [ get_db ports * ]
select_obj [ get_db insts -if ".is_black_box==true" ]
select_obj [ get_db insts -if ".is_pad==true" ]
set_db [get_db selected ] .place_status fixed

write_def -selected "../outputs/${top_design}.floorplan.innovus.macros.def"



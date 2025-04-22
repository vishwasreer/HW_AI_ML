set lib_dir /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib
set hack_lef_dir /u/bcruik2/hacked_lefs

# Decoder ring for the libraries
# You will need to follow another example or look in the library directories to understand.

# lib_types is used for the dc/dct linking variables and ICC2 NDM lcoations.
# /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm
# /          $lib_dir                   /lib/ $lib_type /db_nldm

# link_library, Target_library use the sub_lib_types and corner variables. 
# For sub_lib_types and corner:
# Example:
#     saed32hvt_ss0p75v125c.db
#     |sub_lib  corner    .db
# The current flow tries to find all sub_lib and all corners in all the search paths.  Any match will be put in the library list.
# Wild cards can be used, but be careful.  Multiple matches can occur in ways you don't want.

# For the target library, the same method is used as the link library except only HVT and RVT lib_types are used.

# ICC2 NDM choosing also uses the sub_lib_types so that only the required libraries and extras are not loaded.

# fifo1
#set top_design fifo1
set add_ios 0
set pad_design 0
set design_size { 580 580  } 
set design_io_border 310
set dc_floorplanning 1
set enable_dft 0
set innovus_enable_manual_macro_placement 0

#set rtl_list [list ../rtl/$top_design.sv ]

#set rtl_list [list \
    ../rtl/MultiNeuron_Network.sv \
    ../rtl/NeuronNetworkSystem.sv \
    ../rtl/RegisterFile.sv \
    ../rtl/SPI_Slave.sv \
    ../rtl/leaky_integrate_fire_neuron.sv \
    ../rtl/two_layer_neural_network.sv \
#]

set rtl_list {}

lappend rtl_list ../rtl/MultiNeuron_Network.sv
lappend rtl_list ../rtl/NeuronNetworkSystem.sv
lappend rtl_list ../rtl/RegisterFile.sv
lappend rtl_list ../rtl/SPI_Slave.sv
lappend rtl_list ../rtl/leaky_integrate_fire_neuron.sv
lappend rtl_list ../rtl/two_layer_neural_network.sv



set slow_corner "ss0p95v125c_2p25v ss0p95v125c"
set fast_corner "ff0p95vn40c ff1p16vn40c_2p75v ff1p16vn40c"
set synth_corners $slow_corner
set synth_corners_target "ss0p95v125c" 
#set synth_corners_target "ss0p95v125c" 
set synth_corners_slow $slow_corner
set synth_corners_fast $fast_corner
set slow_metal Cmax_125
set fast_metal Cmax_125
set lib_types "$lib_dir/stdcell_rvt/db_nldm $lib_dir/stdcell_hvt/db_nldm $lib_dir/io_std/db_nldm $lib_dir/sram/db_nldm $lib_dir/pll/db_nldm"
set ndm_types "$lib_dir/stdcell_rvt/ndm $lib_dir/stdcell_hvt/ndm $lib_dir/sram/ndm $lib_dir/io_std/ndm  $lib_dir/pll/ndm"
set lib_types_target "$lib_dir/stdcell_rvt/db_nldm"
# Get just the main standard cells, srams and IOs
set sub_lib_type "saed32?vt_ saed32sram_ saed32io_wb_ saed32pll_"
set sub_lib_type_target "saed32rvt_"
set tech_lef ${hack_lef_dir}/tech.lef 
# set tech_lef ../../cadence_cap_tech/tech.lef

set lef_types [list $hack_lef_dir  \
$lib_dir/sram/lef/ \
$lib_dir/io_std/lef \
$lib_dir/pll/lef \
]
#set lef_types [list $lib_dir/stdcell_hvt/lef  $lib_dir/stdcell_rvt/lef $lib_dir/stdcell_lvt/lef $lib_dir/sram/lef $lib_dir/io_std/lef $lib_dir/pll/lef ]


set sub_lef_type "saed32nm_?vt_*.lef saed32sram.lef saed32_io_wb_all.lef saed32_PLL.lef"
set mwlib_types [list $lib_dir/stdcell_hvt/milkyway \
$lib_dir/stdcell_rvt/milkyway \
$lib_dir/stdcell_lvt/milkyway  \
$lib_dir/io_std/milkyway \
$lib_dir/sram/milkyway $lib_dir/pll/milkyway \
 ]
set sub_mwlib_type "saed32nm_?vt_* SRAM32NM saed32io_wb_* SAED32_PLL_FR*"

#set topdir /u/$env(USER)/PSU_RTL2GDS
set topdir [ lindex [ regexp -inline "(.*)\(syn\|pt\|apr\)" [pwd] ] 1 ]
set FCL 0
set split_constraints 0



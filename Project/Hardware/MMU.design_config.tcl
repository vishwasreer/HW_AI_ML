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


# ORCA
# The RTL version does not currently have macros
# The one pulled from a lab does have macros, but no RTL.  Similar to the version with RTL.
# Below is an effort to get the design pulled from a lap working for ICC2
# Original lab had sram_lp memories, but the NDMs don't seem to be build correctly for the current libraries.  Converted code to regular SRAMs.
#set top_design ORCA_TOP
set FCL 0
set add_ios 0
set pad_design 0
set design_size {950 620}
set design_io_border 10
set dc_floorplanning 1
set enable_dft  1
set innovus_enable_manual_macro_placement 1
set split_constraints 0

# This is the raw RTL without SRAMS
#set rtl_list [list [glob /pkgs/synopsys/32_28nm/SAED_EDK32.28nm_REF_v_15032018/SAED32_EDK/references/orca/dc/rtl/*.vhd ] ../rtl/MUX21X2.sv ]
# This is hacked P&R netlist with SRAMs and test and level shifters removed.
set rtl_list [list ../rtl/$top_design.sv ]

set slow_corner "ss0p75vn40c ss0p75vn40c_i0p95v ss0p75vn40c_i0p75v ss0p95vn40c ss0p95vn40c_i0p75v"
set fast_corner "ff0p95vn40c ff0p95vn40c_i1p16v ff0p95vn40c_i0p95v ff1p16vn40c ff1p16vn40c_i1p16v ff1p16vn40c_i0p95v"
set synth_corners_slow $slow_corner
set synth_corners_fast $fast_corner
set slow_metal Cmax.tlup_-40
set fast_metal Cmin.tlup_-40

set lib_types "$lib_dir/stdcell_rvt/db_nldm $lib_dir/stdcell_lvt/db_nldm $lib_dir/stdcell_hvt/db_nldm $lib_dir/io_std/db_nldm $lib_dir/sram/db_nldm $lib_dir/pll/db_nldm"
set ndm_types "$lib_dir/stdcell_rvt/ndm $lib_dir/stdcell_lvt/ndm $lib_dir/stdcell_hvt/ndm $lib_dir/sram/ndm $lib_dir/io_std/ndm  $lib_dir/pll/ndm"
set lib_types_target "$lib_dir/stdcell_rvt/db_nldm"
set sub_lib_type "saed32?vt_ saed32sram_ saed32io_wb_ saed32pll_ saed32?vt_ulvl_ saed32?vt_dlvl_"
set sub_lib_type_target "saed32rvt_"
set synth_corners_target "ss0p95vn40c ss0p75vn40c" 
#set synth_corners_target "ss0p95v125c" 
set tech_lef ${hack_lef_dir}/tech.lef 
# set tech_lef ../../cadence_cap_tech/tech.lef

set lef_types [list $hack_lef_dir  \
$lib_dir/sram/lef/ \
$lib_dir/io_std/lef \
$lib_dir/pll/lef \
]
#set lef_types [list $lib_dir/stdcell_hvt/lef  $lib_dir/stdcell_rvt/lef $lib_dir/stdcell_lvt/lef $lib_dir/sram/lef $lib_dir/io_std/lef $lib_dir/pll/lef ]

set sub_lef_type "saed32nm_?vt_*.lef saed32sram.lef saed32io_std_wb saed32_PLL.lef"

set synth_corners $slow_corner
set synth_corners_slow $slow_corner
set synth_corners_fast $fast_corner
set mwlib_types [list $lib_dir/stdcell_hvt/milkyway \
$lib_dir/stdcell_rvt/milkyway \
$lib_dir/stdcell_lvt/milkyway  \
$lib_dir/io_std/milkyway \
$lib_dir/sram/milkyway $lib_dir/pll/milkyway \
 ]
set sub_mwlib_type "saed32nm_?vt_* SRAM32NM saed32io_wb_* SAED32_PLL_FR*"

#set lib_types "stdcell_hvt stdcell_rvt stdcell_lvt sram"
# Get just the main standard cells, srams
#set sub_lib_type "saed32?vt_ saed32sram_ saed32?vt_ulvl_ saed32?vt_dlvl_ "

# Full MCMM Corners
if { 0 } {
    set corners ""
    #Add Worst corners
    set corners "$corners ss0p75vn40c ss0p75vn40c_i0p95v ss0p75vn40c_i0p75v ss0p95vn40c ss0p95vn40c_i0p75v"
    #Add Best corners
    set corners "$corners ff0p95vn40c ff0p95vn40c_i1p16v ff0p95vn40c_i0p95v ff1p16vn40c ff1p16vn40c_i1p16v ff1p16vn40c_i0p95v"
    #Add Leakage corners
    set corners "$corners ff0p95v125c f0p95v125c_i1p16v ff0p95v125c_i0p95v ff1p16v125c ff1p16v125c_i1p16v ff1p16v125c ff1p16v125c_i0p95v"
    set lib_types "stdcell_hvt stdcell_rvt stdcell_lvt sram_lp"
    # Get the main standard cells, and also the level shifters.  Plus srams.
    set sub_lib_type "saed32?vt_ saed32?vt_ulvl_ saed32?vt_dlvl_ saed32sram_"
}

#set topdir /u/$env(USER)/PSU_RTL2GDS
set topdir [ lindex [ regexp -inline "(.*)\(syn\|pt\|apr\)" [pwd] ] 1 ]

#declaring sub blocks
set sub_block {SDRAM_TOP 
				BLENDER_0 
				PCI_TOP 
				CONTEXT_MEM 
				RISC_CORE 
				CLOCKING 
				BLENDER_1 
				PARSER 
				}
				
set sub_block_I {I_SDRAM_TOP I_BLENDER_1  I_BLENDER_0 I_RISC_CORE I_CONTEXT_MEM I_PCI_TOP I_PARSER I_CLOCKING}
				
set macro_block {I_SDRAM_TOP I_PCI_TOP I_RISC_CORE I_CONTEXT_MEM}


if {[info exists synopsys_program_name]} {
        if { $synopsys_program_name == "dc_shell" } {
           set_host_options -max_cores 4
        } 
        if { ( $synopsys_program_name == "icc2_shell" ) || ($synopsys_program_name == "fc_shell" ) } {
           set_host_options -max_cores 4
        }
} elseif {[get_db root: .program_short_name] == "innovus"} {
        if [is_common_ui_mode ] {set_multi_cpu_usage -local_cpu 8  
        } else { setMultiCpuUsage -localCpu 8 }
} elseif {[get_db root: .program_short_name] == "genus"} {
  set_db / .max_cpus_per_server 8 
}

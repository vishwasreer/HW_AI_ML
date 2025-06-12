if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name libs_min\
   -timing\
    [list ${::IMEX::libVar}/mmmc/saed32rvt_ff0p95vn40c.lib\
    ${::IMEX::libVar}/mmmc/saed32rvt_ff1p16vn40c.lib\
    ${::IMEX::libVar}/mmmc/saed32hvt_ff0p95vn40c.lib\
    ${::IMEX::libVar}/mmmc/saed32hvt_ff1p16vn40c.lib\
    ${::IMEX::libVar}/mmmc/saed32io_wb_ff1p16vn40c_2p75v.lib\
    ${::IMEX::libVar}/mmmc/saed32sram_ff1p16vn40c.lib\
    ${::IMEX::libVar}/mmmc/saed32pll_ff1p16vn40c_2p75v.lib]
create_library_set -name libs_max\
   -timing\
    [list ${::IMEX::libVar}/mmmc/saed32rvt_ss0p95v125c.lib\
    ${::IMEX::libVar}/mmmc/saed32hvt_ss0p95v125c.lib\
    ${::IMEX::libVar}/mmmc/saed32io_wb_ss0p95v125c_2p25v.lib\
    ${::IMEX::libVar}/mmmc/saed32sram_ss0p95v125c.lib\
    ${::IMEX::libVar}/mmmc/saed32pll_ss0p95v125c_2p25v.lib]
create_rc_corner -name cmin\
   -cap_table ${::IMEX::libVar}/mmmc/saed32nm_1p9m_Cmin.cap\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T -40
create_rc_corner -name cmax\
   -cap_table ${::IMEX::libVar}/mmmc/saed32nm_1p9m_Cmax.cap\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T -40
create_delay_corner -name min_corner\
   -library_set libs_min\
   -rc_corner cmin
create_delay_corner -name max_corner\
   -library_set libs_max\
   -rc_corner cmax
create_constraint_mode -name func_min_sdc\
   -sdc_files\
    [list /dev/null]
create_constraint_mode -name func_max_sdc\
   -sdc_files\
    [list /dev/null]
create_analysis_view -name func_max_scenario -constraint_mode func_max_sdc -delay_corner max_corner
create_analysis_view -name func_min_scenario -constraint_mode func_min_sdc -delay_corner min_corner
set_analysis_view -setup [list func_max_scenario] -hold [list func_min_scenario]
catch {set_interactive_constraint_mode [list func_min_sdc func_max_sdc] } 

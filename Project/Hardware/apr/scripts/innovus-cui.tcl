
######
## WARNING!!!
## you must start innovus from the INNOVUS area and not the GENUS area
## /pkgs/cadence/2019-03/INNOVUS171/bin/innovus
## not /pkgs/cadence/2019-03/GENUS171/bin/innovus
##
## You need this as well in your .profile to get your libraries loaded correctly
## LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/pkgs/cadence/2019-03/SSV171/tools.lnx86/lib/64bit/"
## You might see this error otherwise.
## **ERROR: (IMPCCOPT-3092):	Couldn't load external LP solver library. Error returned:

proc innovus_reporting { stage postcts postroute } {
global top_design
   if { !$postcts && !$postroute } {
     redirect -tee ../reports/$top_design.innovus.$stage.congestion.2d.rpt { report_congestion -hotSpot -overflow -include_blockage }
     redirect -tee ../reports/$top_design.innovus.$stage.congestion.3d.rpt { report_congestion -hotSpot -overflow -include_blockage -3d }
    time_design -pre_cts -report_prefix $stage -report_dir ../reports/${top_design}.innovus -expanded_views
   }
   if { $postcts } {
     report_skew_groups -summary -out_file ../reports/$top_design.innovus.$stage.ccopt_skew_groups.rpt
     report_clock_trees -summary -out_file ../reports/$top_design.innovus.$stage.ccopt_clock_trees.rpt
     if { ! $postroute } {
        time_design -post_cts -report_prefix $stage -report_dir ../reports/${top_design}.innovus -expanded_views
        time_design -post_cts -hold -report_prefix $stage -report_dir ../reports/${top_design}.innovus -expanded_views
     }
   }
   if { $postroute } {
     check_drc -limit 100000 -out_file ../reports/$top_design.innovus.$stage.drc.all.rpt
     check_drc -limit 100000 -check_only regular -out_file ../reports/$top_design.innovus.$stage.drc.regular.rpt
     check_connectivity -error 100000 -ignore_dangling_wires -out_file ../reports/$top_design.innovus.$stage.connectivity.rpt 
     time_design -post_route -report_prefix $stage -report_dir ../reports/${top_design}.innovus -expanded_views
     time_design -post_route -si -report_prefix ${stage}_si -report_dir ../reports/${top_design}.innovus -expanded_views
     time_design -post_route -hold -report_prefix $stage -report_dir ../reports/${top_design}.innovus -expanded_views
     time_design -post_route -hold -si -report_prefix ${stage}_si -report_dir ../reports/${top_design}.innovus -expanded_views
     #report_power > ../reports/${top_design}.ROUTE_power_from_innovus_tcl.rpt
     #report_area > ../reports/${top_design}.ROUTE_area_from_innovus_tcl.rpt
     report_power > ../reports/${top_design}.innovus.${stage}.power.rpt
   }
   redirect -tee ../reports/${top_design}.innovus.$stage.density.rpt { report_density_map }
   report_summary -no_html -out_file ../reports/${top_design}.innovus.$stage.summary.rpt
}

source ../../$top_design.design_config.tcl

set designs [get_db designs * ]
if { $designs != "" } {
  delete_obj $designs
}

if { ! [ info exists flow ] } { set flow "fpcr" }

####### STARTING INITIALIZE and FLOORPLAN #################
if { [regexp -nocase "f" $flow ] } {
    puts "######## STARTING INITIALIZE and FLOORPLAN #################"
    # MANUALLY TRANSLATE (WARN-2): Command 'set_global' is obsolete in common UI and is removed. 
#     set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
    source ../scripts/innovus-get-timlibslefs.tcl
    source ../../constraints/${top_design}.mmmc.sdc
    set init_design_netlist_type Verilog
    set init_netlist_files ../../syn/outputs/${top_design}.genus_phys.vg
#     set init_top_cell $top_design
    set_db init_power_nets VDD
    set_db init_ground_nets VSS
    read_mmmc mmmc.tcl
    read_physical -lef $init_lef_file
    read_netlist $init_netlist_files 
    init_design
   if { [file exists ../scripts/${top_design}.pre.floorplan.tcl ] } { source ../scripts/${top_design}.pre.floorplan.tcl }
    read_def "../outputs/${top_design}.floorplan.innovus.def" 
    #defIn "../outputs/${top_design}.floorplan.innovus.macros.def" 
    add_tracks -honor_pitch
   if { [file exists ../scripts/${top_design}.post.floorplan.tcl ] } { source ../scripts/${top_design}.post.floorplan.tcl }
    if { $enable_dft == 1} {
    	echo READING SCANDEF
   	 #defIn ../../syn/outputs/${top_design}.dct.scan.def
    	read_def ../../syn/outputs/${top_design}.genus.scan.def
    	echo FINISHED READING SCANDEF
       # Source SDC file with DFT constraints. 
       #source ../../syn/outputs/${top_design}.genus.sdc
    }
    source ../../${top_design}.design_options.tcl
    # Add dcap boundary cells on the left and right side of design and macros
    #set_boundary_cell_rules -left_boundary_cell [get_lib_cell */DCAP_HVT]
    #set_boundary_cell_rules -right_boundary_cell [get_lib_cell */DCAP_HVT]
    # Tap Cells are usually needed, but they are not in this library. create_tap_cells
    #compile_boundary_cells
    #loadDefFile ../../apr/outputs/${top_design}.floorplan.def
    # Setting the interactive_constrint mode overwrites constraints applied 
    # for each scenario. 
    set_interactive_constraint_modes [all_constraint_modes -active]
    source ../../constraints/$top_design.sdc
    set_opt_dont_use *DELLN* true
    create_basic_path_groups -expanded
    write_db ${top_design}_floorplan.innovus.cui
    #report_power > ../reports/${top_design}.FLRPLN_power_from_innovus_tcl.rpt
    #report_area > ../reports/${top_design}.FLRPLN_area_from_innovus_tcl.rpt
    puts "######## FINISHED INTIIALIZE and FLOORPLAN #################"
}

######## PLACE #################
if { [regexp -nocase "p" $flow ] } {
    if { ![regexp -nocase "f" $flow ] } {
       read_db ${top_design}_floorplan.innovus }
    puts "######## STARTING PLACE #################"
set_db opt_useful_skew false
set_db opt_useful_skew_ccopt none
set_db opt_useful_skew_post_route false
set_db opt_useful_skew_pre_cts false
   if { [file exists ../scripts/${top_design}.pre.place.tcl ] } { source ../scripts/${top_design}.pre.place.tcl }
    place_opt_design
   if { [file exists ../scripts/${top_design}.post.place.tcl ] } { source ../scripts/${top_design}.post.place.tcl }
    set stage place.cui
    innovus_reporting $stage 0 0    
    write_db ${top_design}_place.innovus.cui
    #report_power > ../reports/${top_design}.$stage.PLACE_power_from_innovus_tcl.rpt
    #report_area > ../reports/${top_design}.$stage.PLACE_area_from_innovus_tcl.rpt
    puts "######## FINISHED PLACE #################"
}

######## STARTING CLOCK_OPT #################
if { [regexp -nocase "c" $flow ] } {
    if { ![regexp -nocase "f" $flow ] && ![regexp -nocase "p" $flow ]  } {
       read_db ${top_design}_place.innovus } elseif { [regexp -nocase "f" $flow ] && ![regexp -nocase "p" $flow ] } {
       puts "FLOW ERROR: You are trying to run route and skipping some but not all earlier stages"
       return -level 1 
    }
set_db design_process_node 28
set_db opt_useful_skew false
set_db opt_useful_skew_ccopt none
set_db opt_useful_skew_post_route false
set_db opt_useful_skew_pre_cts false
set_db cts_update_clock_latency false

# /pkgs/cadence/2020-11/INNOVUS191/doc/innovusUG/CCOpt_Properties.html
# https://support.cadence.com/apex/techpubDocViewerPage?path=innovusUG/innovusUG21.13/CCOpt_Properties.html
# /pkgs/cadence/2020-11/INNOVUS191/doc/innovusUG/Clock_Tree_Synthesis.html
#set_ccopt_property target_skew 0.1 
#set_ccopt_property use_inverters true
#set_ccopt_property inverter_cells {}
#set_ccopt_property buffer_cells { }
#set ccopt_property clock_gating_cells { }
#set_ccopt_property target_max_trans 0.1
#set_ccopt_property insertion_delay 0.5
#set_ccopt_property max_fanout 50
#set_ccopt_property target_max_capacitance 0.1
# set_ccopt_property routing_top_min_fanout 10000
#add_ndr -name CTS_RULE -spacing {M1 0.1 M2:M8 0.112 }
create_route_rule -name CTS_RULE -spacing  {M1 0.1 M2:M8 0.112 } -width_multiplier {M3:M8 2 } -generate_via
# Main power grid is currently on M7/M8
create_route_type -name top_type -route_rule CTS_RULE -top_preferred_layer M8 -bottom_preferred_layer M7
# set_ccopt_property -net_type top route_type top_type
create_route_type -name trunk_type -route_rule CTS_RULE -top_preferred_layer M6 -bottom_preferred_layer M5
# set_ccopt_property -net_type trunk route_type trunk_type
#create_route_type -name leaf_type -non_default_rule CTS_RULE -top_preferred_layer M7 -bottom_preferred_layer M6
#set_ccopt_property -net_type leaf route_type leaf_type
set_db route_design_detail_post_route_spread_wire false
   if { [file exists ../scripts/${top_design}.pre.cts.tcl ] } { source ../scripts/${top_design}.pre.cts.tcl }
    ccopt_design
   if { [file exists ../scripts/${top_design}.post.cts.tcl ] } { source ../scripts/${top_design}.post.cts.tcl }
    set_db timing_analysis_type ocv
    set_db timing_analysis_cppr both
# IO clock latencies are not adjusted as desired.
#update_io_latency
#May have to change earlier command to ccopt_design -cts
# Or reset to ideal mode first, then update_io_latency, then set_propagated_clock again.
# https://support.cadence.com/apex/ArticleAttachmentPortal?id=a1O0V000007MokSUAS&pageName=ArticleContent
# Or fix the problem with set_ccopt_propert update_io_latency true
   if { [file exists ../scripts/${top_design}.pre.opt.tcl ] } { source ../scripts/${top_design}.pre.opt.tcl }
    opt_design -post_cts -hold
   if { [file exists ../scripts/${top_design}.post.opt.tcl ] } { source ../scripts/${top_design}.post.opt.tcl }
    #opt_design -post_cts -hold
    set stage postcts.cui
    innovus_reporting $stage 1 0    
    write_db ${top_design}_postcts.innovus.cui
    #report_power > ../reports/${top_design}.$stage.CLOCK_power_from_innovus_tcl.rpt
    #report_area > ../reports/${top_design}.$stage.CLOCK_area_from_innovus_tcl.rpt
    puts "######## FINISHING CLOCK_OPT #################"

}

######## ROUTE_OPT #################
if { [regexp -nocase "r" $flow ] } {
    if { ![regexp -nocase "f" $flow ] && ![regexp -nocase "p" $flow ] && ![regexp -nocase "c" $flow ] } {
       read_db ${top_design}_postcts.innovus } elseif { ([regexp -nocase "f" $flow ] && ! [regexp -nocase "p" $flow ] ) ||
               ([regexp -nocase "f" $flow ] && ! [regexp -nocase "c" $flow ] ) ||
               ([regexp -nocase "p" $flow ] && ! [regexp -nocase "c" $flow ] )  } {
       puts "FLOW ERROR: You are trying to run route and skipping some but not all earlier stages"
       return -level 1 
    }
    puts "######## ROUTE_OPT #################"
set_db opt_useful_skew false
set_db opt_useful_skew_ccopt none
set_db opt_useful_skew_post_route false
set_db opt_useful_skew_pre_cts false
set_db route_design_detail_post_route_spread_wire false
#setNanoRouteMode -routeTopRoutingLayer 7
#setNanoRouteMode -routeBottomRoutingLayer 2
   if { [file exists ../scripts/${top_design}.pre.route.tcl ] } { source ../scripts/${top_design}.pre.route.tcl }
    route_design
   if { [file exists ../scripts/${top_design}.post.route.tcl ] } { source ../scripts/${top_design}.post.route.tcl }
    #route_design
# Should add tie hi/lo
#setTieHiLoMode -maxFanout 20 -maxDistance 50 -cell {TIEH_RVT TIEL_RVT}
#addTieHiLo
    opt_design -post_route -setup -hold
   connect_global_net VDD -type pg_pin -pin_base_name VDD 
   connect_global_net VSS -type pg_pin -pin_base_name VSS 
   # Should add other power nets if multivoltage
    write_db ${top_design}_route.innovus.cui
    ######## FINAL REPORTS/OUTPUTS  #################
    puts "######## FINAL REPORTS/OUTPUTS  #################"
    # output reports
    set stage route.cui
    innovus_reporting $stage 1  1   
    #report_power > ../reports/${top_design}.ROUTE_power_from_innovus_tcl.rpt
    #report_area > ../reports/${top_design}.ROUTE_area_from_innovus_tcl.rpt
    report_power > ../reports/${top_design}.innvous.${stage}.power.rpt
    # output netlist.  Look in the Saved Design Directory for the netlist
    #write_hdl $top_design > ../outputs/${top_design}.$stage.vg
    write_netlist ../outputs/${top_design}.$stage.innovus.vg 
    # there is not a command to just write the spef with a specific name, so use the Innovus command, then copy the file.
    write_model -spef -dir ${top_design}_route_spef
    foreach i [glob ../outputs/${top_design}*innovus*.spef.gz] { file delete $i  }
    foreach i [glob ${top_design}_route_spef/*.spef.gz] { 
       set newfile [regsub ${top_design}_ [file tail $i] ${top_design}.route.innovus. ]
       file copy $i  ../outputs/$newfile 
    }
    puts "######## FINISHED ROUTE_OPT + FINAL REPORTS/OUTPUTS #################"
}


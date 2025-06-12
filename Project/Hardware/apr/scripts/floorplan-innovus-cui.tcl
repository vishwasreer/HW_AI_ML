# if no IOs
#floorPlan -s [lindex $design_size 0 ] [lindex $design_size 1 ] $design_io_border $design_io_border $design_io_border $design_io_border -flip s -coreMarginsBy die
# If IOs
#floorPlan -s [lindex $design_size 0 ] [lindex $design_size 1 ] 10 10 10 10 -flip s -coreMarginsBy io

read_def "../outputs/${top_design}.floorplan.innovus.macros.def" 

add_tracks -honor_pitch

#loadFPlan
delete_global_net_connections
connect_global_net VDD -type pg_pin -pin_base_name VDD 
connect_global_net VSS -type pg_pin -pin_base_name VSS 

check_legacy_design -power_ground -no_html -out_file pg.rpt

#######
# Make sure you place the macros before starting the power mesh.  Or maybe remove the -onlyAIO option of the placeAIO -onlyAIO
######

# Power Grid here.  This is ICC2 version:
# M7/8 Mesh
#create_pg_mesh_pattern mesh_pat -layers {  {{vertical_layer: M8} {width: 4} {spacing: interleaving} {pitch: 16}}   \
#    {{horizontal_layer: M7} {width: 2}        {spacing: interleaving} {pitch: 8}}  }
#M2 Lower Mesh
# Orca does 0.350 width VSS two stripes, then 0.7u VDD stripe.  Repeating 16u. for now, do something simpler 
#create_pg_mesh_pattern lmesh_pat -layers {  {{vertical_layer: M2} {width: 0.7} {spacing: interleaving} {pitch: 16}}  } 
#M1 Std Cell grid
#create_pg_std_cell_conn_pattern rail_pat -layers {M1} -rail_width {0.06 0.06}
#   -via_rule {       {{layers: M6} {layers: M7} {via_master: default}}        {{layers: M8} {layers: M7} {via_master: VIA78_3x3}}}
#set_pg_strategy mesh_strat -core -extension {{stop:outermost_ring}} -pattern {{pattern:mesh_pat } { nets:{VDD VSS} } } 
#set_pg_strategy rail_strat -core -pattern {{pattern:rail_pat } { nets:{VDD VSS} } } 
#set_pg_strategy lmesh_strat -core -pattern {{pattern:lmesh_pat } { nets:{VDD VSS} } } 
#compile_pg -strategies {mesh_strat rail_strat lmesh_strat}

# Core power ring
add_rings -type core_rings -nets {VDD VSS} -layer {top M8 bottom M8 left M7 right M7} -offset 1 -width 4 -spacing 1.0
# Add Meshes
#addStripe -nets {VDD VSS} -direction vertical   -layer M2 -width 0.060 -set_to_set_distance 20 -spacing 10
#addStripe -nets {VDD VSS} -direction horizontal   -layer M3 -width 0.060 -set_to_set_distance 20 -spacing 10
add_stripes -nets {VDD VSS} -direction vertical   -layer M4 -width 0.060 -set_to_set_distance 20 -spacing 10
add_stripes -nets {VDD VSS} -direction horizontal   -layer M5 -width 0.120 -set_to_set_distance 20 -spacing 10
add_stripes -nets {VDD VSS} -direction vertical   -layer M6 -width 0.120 -set_to_set_distance 20 -spacing 10
add_stripes -nets {VDD VSS} -direction horizontal   -layer M7 -width 2 -set_to_set_distance 40 -spacing 20
add_stripes -nets {VDD VSS} -direction vertical   -layer M8 -width 4 -set_to_set_distance 80 -spacing 40

# Connect full grid and add M1 VDD/VSS rails. 
route_special -connect {core_pin pad_pin} -crossover_via_layer_range {1 4}

# Placing pins and spreading pins out. 
#editPin -edge 3 -pin [get_attribute [get_ports *] full_name] -layer 4 -spreadDirection clockwise -spreadType RANGE -offsetStart 100 -fixedPin 1 -fixOverlap 1 

if { [get_db sites unitdouble ] != "" } {
   create_row -area "0.0000 0.0000 [lindex $design_size 0 ] [ lindex $design_size 1 ]" -site unitdouble
}

delete_inst -inst [get_db [ get_db insts -if ".base_cell.name==*_?VT" ] .name ]
#source -echo -verbose ../../${top_design}.macro_placement_innovus.tcl
write_def -no_std_cells "../outputs/${top_design}.floorplan.innovus.def"


#defOut -noStdCells -noTracks -noSpecialNet -noTracks  "../outputs/${top_design}.floorplan.innovus.macros.def"

gui_deselect -all
select_obj [ get_ports * ]
select_obj [ get_db insts -if ".is_black_box==true" ]
select_obj [ get_db insts -if ".is_pad==true" ]
#defOut -selected "../outputs/${top_design}.floorplan.innovus.macros.def"



puts "Logfile message: writing def file completed ..."



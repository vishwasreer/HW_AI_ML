set search_path ""



# Set up the search path to the libraries
# One of the typical lines of the resultant search path is:
# /pkgs/synopsys/2020/saed14nm/stdcell_rvt/db_nldm
foreach i $lib_types {
   lappend search_path $i
}
# Indicate where the foundation synthesis library is
# using the absolute path.
set synthetic_library /pkgs/synopsys/2020/design_compiler/syn/Q-2019.12-SP3/libraries/syn/dw_foundation.sldb

# Smartly find all the libraries you need
# Will end up with sometihng like this: 
# saed32hvt_ss0p75v125c.db saed32hvt_ss0p95v125c.db saed32rvt_ss0p75v125c.db saed32rvt_ss0p95v125c.db saed32lvt_ss0p75v125c.db saed32lvt_ss0p95v125c.db saed32sram_ss0p95v125c.db dw_foundation.sldb *
# This contains all the VTs you want, all the corners you want, and designate any library subtypes like level shifters you might want
# The variables are defined in the design_config.tcl
# Example:
#     saed32hvt_ss0p75v125c.db
#     |sub_lib  corner    .db
set link_library ""
foreach i $search_path {
  foreach k $synth_corners {
      foreach m $sub_lib_type {
        foreach j [glob -nocomplain $i/$m$k.db ] {
          lappend link_library $j
        }
      }
  }
}
lappend link_library $synthetic_library
lappend link_library *

# Add the local directory "." to the search path after we have used it in the above loop.  If you add . before hand, it will cause some problems.
lappend search_path .

set search_path_target ""
foreach i $lib_types_target {
     lappend search_path_target $i
}
# Smartly find all the target libraries you need in a similar method as the link libraries
# Will end up with sometihng like this: 
# saed32hvt_ss0p75v125c.db saed32hvt_ss0p95v125c.db saed32lvt_ss0p75v125c.db saed32lvt_ss0p95v125c.db
# This contains all the VTs you want, all the corners you want, and designate any library subtypes like level shifters you might want.
# The variables are defined in the design_config.tcl
set target_library ""
foreach i $search_path_target {
  foreach k $synth_corners_target {
    foreach m $sub_lib_type_target {
      foreach j [glob -nocomplain $i/$m$k*.db ] {
         lappend target_library $j 
         lappend link_library  $j 
       }
     }
   }
 }



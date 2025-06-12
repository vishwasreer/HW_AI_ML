


# Set up the search path to the librariesi
# One of the typical lines of the resultant search path is:
# /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib/stdcell_hvt/db_nldm
# /          $lib_dir                   /lib/ $lib_type /db_nldm
# The variables are defined in design_config.tcl
set search_path ""
foreach i $lib_types { lappend search_path $i }

# Smartly find all the libraries you need
# Will end up with sometihng like this: 
# saed32hvt_ss0p75v125c.db saed32hvt_ss0p95v125c.db saed32rvt_ss0p75v125c.db saed32rvt_ss0p95v125c.db saed32lvt_ss0p75v125c.db saed32lvt_ss0p95v125c.db saed32sram_ss0p95v125c.db dw_foundation.sldb *
# This contains all the VTs you want, all the corners you want, and designate any library subtypes like level shifters you might want
# The variables are defined in the design_config.tcl
# Example:
#     saed32hvt_ss0p75v125c.db
#     |sub_lib  corner    .db
set link_library_worst ""
foreach i $search_path {
  foreach k $synth_corners_slow {
      foreach m $sub_lib_type {
        foreach j [glob -nocomplain $i/$m$k.lib ] {
          lappend link_library_worst $j 
        }
      }
  }
}

set link_library_best ""
foreach i $search_path {
  foreach k $synth_corners_fast {
      foreach m $sub_lib_type {
        foreach j [glob -nocomplain $i/$m$k.lib ] {
          lappend link_library_best $j 
        }
      }
  }
}
#lappend link_library *

set lef_path ""
foreach k $lef_types {
  foreach m $sub_lef_type {
    foreach j [glob -nocomplain $k/$m ] {
      lappend lef_path  $j 
    }
  }
}


# Add the local directory "." to the search path after we have used it in the above loop.  If you add . before hand, it will cause some problems.
lappend search_path .

# Currently copy all the lef files from original locations and delete the BUSBITCHARS lines.  The "_" of  "_<>" is a problem.
foreach i [glob -nocomplain saed*.lef ] { file delete $i }
foreach i $lef_path {
   # Double check the lef file has .lef extension.  add it if needed.  Some 14nm lefs do not have lef extension.
   set destfile [file tail $i ]
   if { ![ regexp ".*\.lef" $destfile ]  } {
      set destfile ${destfile}.lef
   }
   exec grep -v BUSBITCHARS $i > $destfile
}
set init_lef_file "$tech_lef [glob saed*.lef]"


